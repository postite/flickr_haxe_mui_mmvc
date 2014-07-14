package mui.module.widevine;

import flash.errors.Error;
import flash.events.TimerEvent;
import flash.external.ExternalInterface;
import flash.Lib;
import flash.net.NetStream;
import flash.net.Responder;
import flash.utils.Timer;
import mui.module.widevine.WvChapter;
import mui.module.widevine.WvChapterConnection;
import mui.module.widevine.WvNetConnection;

class WvNetStream
{
	@:isVar
	public var ns(get, null):NetStream;
	function get_ns():NetStream
	{
		return ns;
	}
	
	public var duration:Float;
	
	// maximun trick play speed to allow
	public static var MAX_SCALE:Int	= 256;
	
	// start trick play at this speed.  
	public static var MIN_SCALE:Int = 4;
	
	// do not allow seeks more than 1 per second
	public static var SEEK_INTERVAL:Int = 100;
	
	private static var SEEK_PAUSE_INTERVAL:Int = 100;
	
	// automatically switch to normal speed on seeks.
	public static var EXIT_TRICKPLAY_ON_SEEK:Bool = true;
	
	var myMovie:String;
	var myErrorText:String;
	var myCurrentMediaTime:Float;
	var myPreviousMediaTime:Float;
	var myWvMediaTime:Float;
	var myPlayScale:Int;
	var myPlayStatus:Bool;
	var myPrevTimeGetMediaTimeCalled:Float;
	var myIsBypassMode:Bool;
	var myConnection:WvNetConnection;
	var myTimer:Timer;
	var myResponder:Responder;
	var myBitrates:Array<Int>;
	var myCurrentBitrate:Int;
	var myMaxQualityLevel:Int;
	var myCurrentQualityLevel:Int;
	var myMaxScale:Int;
	var myAllowChapters:Bool;
	var myTickCounter:Int;
	var myScaleChangedTime:Int;
	var mySelectedTrack:Int;
	var myIsLiveStream:Bool;
	
	// chapter support
	var myChapterConnection:WvChapterConnection;
	
	public function new(connection:WvNetConnection)
	{
		ns = new NetStream(connection.nc);
		duration = 0;
		
		myCurrentMediaTime 	= 0;
		myPreviousMediaTime	= 0;
		myPrevTimeGetMediaTimeCalled = 0;
		myCurrentQualityLevel = 0;
		myMaxQualityLevel 	= 0;
		myPlayScale	 		= 1;
		myIsBypassMode 		= false;
		myConnection 		= connection;
		myPlayStatus		= false;
		myWvMediaTime		= 0;
		myAllowChapters		= true;
		myChapterConnection	= new WvChapterConnection();
		myTickCounter		= 0;
		myScaleChangedTime  = 0;
		mySelectedTrack 	= 0;
		myIsLiveStream		= false;
		
		// Create a timer to keep current media time correct due to trickplay
		myTimer				= new Timer(100, 0);
		myTimer.addEventListener (TimerEvent.TIMER, tick);
		
		// Create a responder object for NetConnnection.call()
		myResponder = new Responder(onResponderResult, onResponderFault);
	}
	
	public function play(file:String)
	{
		doPlay(file);
	}
	
	public function pause()
	{
		if (IsBypassMode()) {
			ns.pause();
			return;
		}
		
		if (myPlayScale != 1) {
			var mediaTime = getCurrentMediaTime();
			try {
				myConnection.nc.call("WidevineMediaTransformer.setPlayScale", myResponder, 1);
				haxe.Timer.delay(ns.seek.bind(mediaTime), SEEK_PAUSE_INTERVAL);
				myScaleChangedTime = Lib.getTimer();
			}
			catch (errObject:Error) {
				myErrorText = errObject.message;
				trace(myErrorText);
			}
		}
		
		myPlayStatus = false;
		myPlayScale	= 1;
		ns.pause();
	}
	
	public function resume()
	{
		if (IsBypassMode()) {
			ns.resume();
			return;
		}
		var mediaTime = getCurrentMediaTime();
		resumeAt(mediaTime);
	}
	
	public function resumeAt(offset:Float)
	{
		if ((myPlayScale != 1) && (EXIT_TRICKPLAY_ON_SEEK)){
			try {
				if (duration > 0 && offset >= duration)
				{
					myPlayScale = 1;
				}
				myConnection.nc.call("WidevineMediaTransformer.setPlayScale", myResponder, 1);
				haxe.Timer.delay(ns.seek.bind(offset), SEEK_PAUSE_INTERVAL);
				myScaleChangedTime = Lib.getTimer();
			}
			catch (errObject:Error) {
				trace("Exception calling WidevineMediaTransformer.setPlayScale:" + errObject.message);
				myErrorText = errObject.message;
			}
		}
		myPlayStatus = true;
		
		// don't call resume if we are switching from trick-play to normal play.
		// The seek from above will resume playback.
		if (myPlayScale == 1) {
			try {
				myConnection.nc.call("WidevineMediaTransformer.setPlayScale", myResponder, 1);
			}
			catch (errObject:Error) {
				trace("Exception calling WidevineMediaTransformer.setPlayScale:" + errObject.message);
				myErrorText = errObject.message;
			}
			
			ns.resume();
		}
		
		myPlayScale = 1;
	}
	
	public function seek(offset:Float) 
	{
		if (myPlayScale != 1) {
			resumeAt(offset);
		}
		else {
			ns.seek(offset);
		}
	}
	
	function doPlay(movie:String):Int
	{
		myMovie = movie;
		
		myIsLiveStream = isLiveStream();
		
		if (IsBypassMode()) {
			if (myConnection.IsPdl()) {
				var theURL:String = myConnection.getNewURL();
				myMovie = theURL.substr(theURL.lastIndexOf("/")+1);
				ns.play(theURL);
			}
			else {
				ns.play(myMovie);
			}
		}
		else {
			ns.play(myMovie);
		}
		myPlayStatus = true;
		
		return 0;
	}
	
	public function close()
	{
		myTimer.stop();
		myTimer.removeEventListener (TimerEvent.TIMER, tick);
		myChapterConnection.closeSocket();
		ns.close();
	}
	
	public function playForward()  
	{
		if (IsBypassMode()) {
			return;
		}
		//trace("## PLAY FORWARD");
		var mediaTime:Float 	= myCurrentMediaTime;
		var newScale:Int 		= myPlayScale;
		//trace("MEDIA TIME: " + mediaTime);
		//trace("newScale: " + newScale);
		//trace("playStatus: " + myPlayStatus);
		// If we're paused, resume
		if (myPlayStatus == false) {
			//trace(".. WAS PAUSED - RESUME");
			myPlayStatus = true;
			ns.resume();
		}
		
		if (newScale <= 1) {
			//trace("set to MIN SCALE: " + MIN_SCALE);
			newScale = MIN_SCALE;			// start with min scale
		}
		else {	// increase fast forward speed
			//trace("INCREASE FF SPEED: " + (newScale * 2));
			newScale = newScale * 2;	
			if (newScale > MAX_SCALE) {		// limit max scale and wrap around
				//trace("FF SPEED MAXED OUT: set to Min Scale again: " + MIN_SCALE);
				newScale = MIN_SCALE;	
			}
		}

		try {
			myScaleChangedTime = Lib.getTimer();
			myPlayScale = newScale;
			
			myConnection.nc.call("WidevineMediaTransformer.setPlayScale", myResponder, newScale);
			haxe.Timer.delay(ns.seek.bind(getCurrentMediaTime()), SEEK_PAUSE_INTERVAL);
		}
		catch (errObject:Error) {
			myErrorText = "WVSetPlayScale failed: " + errObject.message;
		}
	}
	
	public function playRewind()
	{		
		if (IsBypassMode()) {
			return;
		}
		
		var mediaTime:Float 	= getCurrentMediaTime();
		var newScale:Int 		= myPlayScale;

		// If we're paused, resume
		if (myPlayStatus == false) {
			myPlayStatus = true;
			ns.resume();
		}
		
		if (newScale >= 1) {
			newScale = MIN_SCALE * -1;		// start with min scale
		}
		else {
			newScale = newScale * 2;		// increase fast rewind speed
			if (Math.abs(newScale) > MAX_SCALE) {
				newScale = MIN_SCALE * -1;	// limit max scale and warp around
			}
		}	
		
		try {
			//trace("Rewind - new scale:" + newScale + ", seeking to:" + mediaTime);
			myScaleChangedTime = Lib.getTimer();
			myPlayScale = newScale;
			
			myConnection.nc.call("WidevineMediaTransformer.setPlayScale", myResponder, newScale);
			haxe.Timer.delay(ns.seek.bind(mediaTime), SEEK_PAUSE_INTERVAL);
			
		}
		catch (errObject:Error) {
			myErrorText = "WVSetPlayScale failed: " + errObject.message;
		}
		return;
	}
	
	public function getCurrentMediaTime():Float
	{
		if (!myTimer.running) {
			myTimer.start();
		}
		
		if (IsBypassMode()) {
			return ns.time;
		}
		return myCurrentMediaTime;
	}
	
	public function getWvMediaTime():Float
	{
		return myWvMediaTime;
	}
	///////////////////////////////////////////////////////////////////////////
	public function getErrorText():String
	{
		return myErrorText;
	}
	///////////////////////////////////////////////////////////////////////////
	public function getPlayStatus():Bool
	{
		return myPlayStatus;
	}
	///////////////////////////////////////////////////////////////////////////
	public function getPlayScale():Int
	{
		return myPlayScale;
	}
	///////////////////////////////////////////////////////////////////////////
	public function setBypassMode(bypass:Bool)
	{
		if (myConnection != null) {
			myConnection.setBypassMode(bypass);
		}
		myIsBypassMode = bypass;
	}
	///////////////////////////////////////////////////////////////////////////
	public function IsBypassMode():Bool
	{
		return myIsBypassMode;
	}	
	///////////////////////////////////////////////////////////////////////////
	public function isLiveStream():Bool
	{
		if (myMovie.indexOf(".m3u8") != -1) {
			return true;
		}
		return false;
	}
	///////////////////////////////////////////////////////////////////////////
	public function sendTransitionEvent()
	{
		myConnection.nc.call("WidevineMediaTransformer.sendTransitionEvent", myResponder);
	}
	
	///////////////////////////////////////////////////////////////////////////
	// Selecting a track puts the adaptive streaming in manual mode.
	// Selecting the already selected track will put the adaptive streaming 
	// back into auto mode.
	public function selectTrack(track:Int)
	{
		// check is caller wants to go back to auto adaptive streaming.
		if (mySelectedTrack == track) {
			myCurrentQualityLevel = 0;
			track = 0;
		}
		mySelectedTrack = track;
		myConnection.nc.call("WidevineMediaTransformer.selectTrack", myResponder, mySelectedTrack);
	}
	///////////////////////////////////////////////////////////////////////////
	public function getSelectedTrack():Int
	{ 
		return mySelectedTrack;
	}

	///////////////////////////////////////////////////////////////////////////
	public function getCurrentBitrate():Int
	{
		return myCurrentBitrate;
	}
	///////////////////////////////////////////////////////////////////////////
	public function getBitrates():Array<Int>
	{
		return myBitrates;
	}
	///////////////////////////////////////////////////////////////////////////
	public function getCurrentQualityLevel():Int
	{
		return myCurrentQualityLevel;
	}
	///////////////////////////////////////////////////////////////////////////
	public function getMaxQualityLevel():Int
	{
		return myMaxQualityLevel;
	}
	///////////////////////////////////////////////////////////////////////////
	public function getNumChapters():Int
	{
		if (!myAllowChapters) {
			return 0;
		}
		return myChapterConnection.getNumChapters();
	}
	///////////////////////////////////////////////////////////////////////////
	public function getChapter(chapterNum:Int):WvChapter
	{
		if (!myAllowChapters) {
			return null;
		}
		return myChapterConnection.getChapter(chapterNum);
	}
	///////////////////////////////////////////////////////////////////////////
	public function isChaptersReady():Bool
	{
		if (getNumChapters() != -1){
			// trace ("getNumChapters() returned: " + getNumChapters());
			return myChapterConnection.isChaptersLoaded();
		}
		return false;
	}
	///////////////////////////////////////////////////////////////////////////
	public function parseTransitionMsg(fullMessage:String) 
	{			
		if (fullMessage.length == 0) {
			return;
		}
			
		var msg:Array<String> = fullMessage.split(":");
		if (msg.length < 2) {
			return;
		}

		var currentQualityLevel:Int = 0;
		var currentBitrate:Int = 0;
		
		myBitrates = null;
		
		var bitrates:Array<String> = msg[0].split(";");
		myBitrates = new Array<Int>();
		
		// unsorted bitrates 
		for(j in 0...bitrates.length) {
			myBitrates[j] = Std.parseInt(bitrates[j]);
		}

		if (msg.length > 1) {
			// get the quality level
			var qualityLevel = Std.parseInt(msg[1]);
			currentBitrate = Std.parseInt(bitrates[qualityLevel]);
		}
		var j:Int;
		// order the bitrates from lowest to highest.
		var done:Bool = false;
		while (!done) {
			done = true;
			for(i in 0...myBitrates.length-1) {
				if (myBitrates[i+1] < myBitrates[i]) {	// bubble up 
					j = myBitrates[i];
					myBitrates[i] = myBitrates[i+1];
					myBitrates[i+1] = j;
					done = false;
				}
			}
		}
		
		if (msg.length > 1) {
			// set the quality level
			currentQualityLevel = 0;
			
			for(i in 0...myBitrates.length) {
				if (myBitrates[i] == currentBitrate) {
					currentQualityLevel = i+1;
					break;
				}
			}
			// convert from bytes to bits
			myCurrentBitrate 		= Math.round((currentBitrate * 8)/1000);
			myCurrentQualityLevel 	= currentQualityLevel;
			myMaxQualityLevel 		= bitrates.length;
		}
	}
	///////////////////////////////////////////////////////////////////////////
	// Create an onResult( ) method to handle results from the call to the remote method
	public function onResponderResult (result:Dynamic) 
	{
	}
	///////////////////////////////////////////////////////////////////////////
	public function onResponderFault(fault:Dynamic) 
	{
		myErrorText = "responder fault: " + fault;
	}
	///////////////////////////////////////////////////////////////////////////
	private function loadChapters()
	{
		if (!myAllowChapters) {
			return;
		}
		// check is chapters are already loaded
		if (isChaptersReady()) {
			return;
		}
		
		var commURL:String;
		try {
			commURL = Std.string(ExternalInterface.call("WVGetCommURL", ns.time));
			//trace("commURL:" + commURL);
		}
		catch (e:Error) {
			//trace("Error: exception from WVGetCommURL():" + e.message);
			return;
		}
		if (commURL == "error") {
			//trace("Error: WVGetCommURL() returned error");
			return;
		}
		if (commURL == "") {
			//trace("Error: WVGetCommURL() returned empty string");
			return;
		}
		
		var port:Int = 0;
		var host:String;
		
		var i = commURL.indexOf("://");
		if (i == 0) {
			//trace("Error parsing start of host from:" + commURL);
			return;
		}
		var j = commURL.indexOf(":", i+3);
		if (j == 0) {
			//trace("Error parsing end of host from:" + commURL);
			return;
		}
		i += 3;
		j += 1;
		host = commURL.substr(i, (j-i-1));
		//trace("host:" + host);
		
		i = commURL.indexOf("/", j);
		i += 1;
		
		port = Std.parseInt(commURL.substr(j, (i-j-1)));
		//trace("port:" + commURL.substr(j, i-j-1));
																	
		if (port == 0) {
			//trace("Error parsing port from:" + commURL);
			return;
		}
		//trace("Initializeing chapter connection...");
		myChapterConnection.init(host, port);
	}

	///////////////////////////////////////////////////////////////////////////
	private function tick(event:TimerEvent)
	{
		if (IsBypassMode()) {
			return;
		}
		
		// check chapters approx 2 second interval 
		if (++myTickCounter > 20) {
			myTickCounter = 0;
			loadChapters();
		}
		
		var now = Lib.getTimer();
				
		if ((myPlayScale == 1) && (!myIsLiveStream)) {
			// don't use flash's netstream time too soon after exiting trickplay
			if ((myScaleChangedTime + 1000) < now) {
				myPreviousMediaTime = myCurrentMediaTime;
				myCurrentMediaTime 	= ns.time;
				return;
			}
		}
		
		// avoid calling WVGetMediaTime too much
		if ((myPrevTimeGetMediaTimeCalled + (1000/myPlayScale)) < now) {
			// bug: for some reason, getting time right after changing rewind speed returns
			// the flash current time instead of the adjusted time.
			if  ((myScaleChangedTime + 1000) < now)  {
				myPreviousMediaTime = myCurrentMediaTime;
				var mediaTime:String = ExternalInterface.call("WVGetMediaTime", ns.time);
				if (mediaTime == "ERROR") {
					trace("WVGetMediaTime returned ERROR. Waiting for a seek to occur?");
				}
				else {
					myWvMediaTime 	= Std.parseFloat(mediaTime);
					myCurrentMediaTime 	= myWvMediaTime;
					myPrevTimeGetMediaTimeCalled = now;
				}
			}
		}
		return;
	}
}
