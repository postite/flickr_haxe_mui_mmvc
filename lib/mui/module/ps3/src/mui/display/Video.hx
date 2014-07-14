package mui.display;

import haxe.Timer;
import js.Lib;
import mui.module.ps3.WebMAF;
import mui.display.IVideo;

/**
	WebMAF video implementation.
**/
class Video extends VideoBase
{
	public var licenseUri:String;
	public var licenseData:String;

	var webMAFTimer:Timer;

	public function new()
	{		
		super(); 

		WebMAF.setVideoPortalSize(-1.0,1.0,1.0,-1.0);

		WebMAF.contentAvailable.add(onContentAvailable);
		WebMAF.playbackTimeChanged.add(onPlaybackTimeChanged);
		WebMAF.playerStatusChanged.add(onPlayerStatusChanged);
	}

	override public function destroy()
	{
		stopVideo();
		if (webMAFTimer != null) webMAFTimer.stop();
		WebMAF.contentAvailable.remove(onContentAvailable);
		WebMAF.playbackTimeChanged.remove(onPlaybackTimeChanged);
		WebMAF.playerStatusChanged.remove(onPlayerStatusChanged);
		super.destroy();
	}

	override function startVideo()
	{
		WebMAF.load(source, licenseUri, licenseData);
	}

	override function playVideo()
	{
		WebMAF.play();
		if (webMAFTimer != null)
			webMAFTimer.stop();

		webMAFTimer = new Timer(1000);
		webMAFTimer.run = function() { WebMAF.getPlaybackTime(); }
	}

	override function pauseVideo()
	{
		WebMAF.pause();
		if (webMAFTimer != null)
			webMAFTimer.stop();
	}

	override function stopVideo()
	{
		WebMAF.stop();
		if (webMAFTimer != null)
			webMAFTimer.stop();
	}

	override function seekVideo(time:Float)
	{
		// disabled for now.
		// WebMAF.setPlayTime(time);
	}

	override function change(flag:Dynamic)
	{
		super.change(flag);

		if (flag.width || flag.height || flag.videoWidth || flag.videoHeight)
		{
			trace("WARNING: WebMAF video resize not implemented in ps3 module");
		}
	}

	function onContentAvailable(dur:Int)
	{
		duration = changeValue("duration", dur);
	}

	function onPlaybackTimeChanged(current:Int, dur:Int)
	{
		currentTime = changeValue("currentTime", current);
		duration = changeValue("duration", dur);

		// no buffer info comes back
		bufferProgress = changeValue("bufferProgress", currentTime/duration);
		
	}

	function onPlayerStatusChanged(status:String,playerState:String)
	{
		trace(status + ":" + playerState);
		switch(playerState)
		{
			case WebMAF.PLAYER_STATE_BUFFERING :
				bufferState = changeValue("bufferState", EMPTY);
			case WebMAF.PLAYER_STATE_END_OF_STREAM :
					playbackComplete();
			case WebMAF.PLAYER_STATE_NOT_READY :
			case WebMAF.PLAYER_STATE_OPENING :
				bufferState = changeValue("bufferState", FULL);
			case WebMAF.PLAYER_STATE_PAUSED :
				playbackState = changeValue("playbackState", PAUSED);
			case WebMAF.PLAYER_STATE_PLAYING :
				playbackState = changeValue("playbackState", PLAYING);
			case WebMAF.PLAYER_STATE_STOPPED :
				playbackState = changeValue("playbackState", STOPPED);
			case WebMAF.PLAYER_STATE_UNKNOWN :
			default :
		}
	}

	override function updateState()
	{
		super.updateState();
	}

	override function updateVolume(level:Float)
	{
		// not handled by PS3
	}
}
