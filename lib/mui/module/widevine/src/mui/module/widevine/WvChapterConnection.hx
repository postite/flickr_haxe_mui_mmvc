package mui.module.widevine;

import flash.errors.ArgumentError;
import flash.errors.Error;
import flash.errors.SecurityError;
import flash.net.Socket;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.utils.ByteArray;

import flash.system.Security;
import flash.events.*;

import mui.module.widevine.WvSocket;
import mui.module.widevine.WvChapter;

class WvChapterConnection
{
	// various chapter states
	public static inline var CHAPTER_IDLE:Int					= 0;
	public static inline var CHAPTER_CONNECTING:Int 			= 1;
	public static inline var CHAPTER_CONNECTED:Int 			= 2;
	public static inline var CHAPTER_QUERY_LOADED_STATUS_LOADING:Int = 3;
	public static inline var CHAPTER_QUERY_LOADED_STATUS_LOADED:Int = 4;
	public static inline var CHAPTER_NUM_CHAPTERS_LOADING:Int 	= 5;
	public static inline var CHAPTER_NUM_CHAPTERS_LOADED:Int 	= 6;
	public static inline var CHAPTER_DATA_LOADING:Int 			= 7;
	public static inline var CHAPTER_DATA_LOADED:Int 			= 8;	
	public static inline var CHAPTER_IMAGE_LOADING:Int 		= 9;
	public static inline var CHAPTER_IMAGE_LOADED:Int 			= 10;		
	public static inline var MAX_RETRIES_ALLOWED:Int 			= 11;
	
	var myNumChapters:Int;
	var myIsChaptersLoaded:Bool;
	var myChapterImagesLoaded:Bool;
	var myPluginSocket:WvSocket;
	var myChapterState:Int;
	var myPort:Int;
	var myHost:String;
	var myNumConnects:Int;
	var myNumRetries:Int;
	var myFullMsg:String;
	var myDataIndex:Int;
	var myGotHTTPHeader:Bool;
	var myContentLength:Int;
	var myContentType:String;
	var myCurrLoadingChapter:Int;
	var myChapters:Array<WvChapter>;
	var myCurrentChapter:WvChapter;
		
	public function new()
	{
		myIsChaptersLoaded 	= false;
		myChapterImagesLoaded = false;
		myNumChapters 		= -1;
		myChapterState		= CHAPTER_IDLE;
		myPort				= 0;
		myNumConnects		= 0;
		myNumRetries		= 0;
		myCurrLoadingChapter= 0;
		myGotHTTPHeader		= false;
		myHost 				= "";

		myPluginSocket 		= new WvSocket();
		myChapters = new Array<WvChapter>();
					
		myPluginSocket.addEventListener(Event.CONNECT, connectHandler);
		myPluginSocket.addEventListener(Event.CLOSE, closeHandler);
		myPluginSocket.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
		myPluginSocket.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		myPluginSocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
	}
	
	///////////////////////////////////////////////////////////////////////////
	public function init(host:String, port:Int):Void
	{
		myHost = host;
		myPort = port;
		
		//trace("ChapterConnection::init():" + myChapterState);
		
		if (myChapterState == CHAPTER_IDLE) {
			startLoading();
		}
	}
	
	///////////////////////////////////////////////////////////////////////////
	public function startLoading():Void
	{
		if (myPort == 0) {
			return;
		}
		
		// if we have all the data already, no need to re-connect
		if (myIsChaptersLoaded &&  myChapterImagesLoaded) {
			// trace(">>>>>>>>>>  Reconnecting to plugin, but already have all data.");
			return;
		}
		// we switch from binary to ascii on the same connnect.  The binary handler
		// is used for chapter images, ascii for all other responses.
		myPluginSocket.removeEventListener(ProgressEvent.SOCKET_DATA, socketBinaryDataHandler);
		myPluginSocket.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
			
		myChapterState = CHAPTER_CONNECTING;
		try {
			//trace("Connecting to " + myHost + ":" + myPort);
			myPluginSocket.connect(myHost, myPort);
		}
		catch (e:SecurityError) {
			//dispatchEvent(new WvEvent("Wv.Chapter.Security", "", e.message));
		}
		catch (e:Error) {
			//dispatchEvent(new WvEvent("Wv.Chapter.Error", "", e.message));;
		}
		return;
	}
	///////////////////////////////////////////////////////////////////////////
	public function closeSocket():Void
	{
		//trace("WvChapterConnection::closeSocket()"); // FIXME: should this constantly poll?
		
		if (myChapters != null)
		{
			var i:Int = 0;
			for(chapter in myChapters) {
				chapter.close();
				myChapters.remove(chapter);
			}
		}
		myChapters = null;
		try {
			if (myPluginSocket.connected) {
				myPluginSocket.close();
			}
		}
		catch (e:Error) {
			trace("Caught exception closing myPluginSocket:" + e.message);
		}
		myChapterState = CHAPTER_IDLE;
	}
	///////////////////////////////////////////////////////////////////////////
	public function connectHandler(e:Event):Void
	{
		myNumConnects++;
		//trace("chapter connection extablished:" + e + ", num connects:" + myNumConnects);	
		myChapterState = CHAPTER_CONNECTED;

		// first connection is for the policy file
		if (myNumConnects == 1) {
			myPluginSocket.close();
			myChapterState = CHAPTER_IDLE;
			startLoading();
			return;
		}
		//sendLoadNumChapters();
		sendQueryChaptersLoaded();
	}
	///////////////////////////////////////////////////////////////////////////		
	private function sendQueryChaptersLoaded():Void 
	{
		try {
			myFullMsg = "";
			myPluginSocket.flush();
			myPluginSocket.sendRequest("GET /cgi-bin/QueryChaptersLoaded HTTP/1.1");
			myChapterState = CHAPTER_QUERY_LOADED_STATUS_LOADING;
		}
		catch (errObject:Error) {
		}
	}
	///////////////////////////////////////////////////////////////////////////
	private function readQueryChaptersLoadedFromSocket():Void 
	{			
		var ready:Bool = false;
		if (myFullMsg.substr(myDataIndex, 4) == "true") {
			ready = true;
		}
		//trace("QueryStatus:" + myFullMsg.substr(myDataIndex));
		myPluginSocket.flush();
		
		myChapters = new Array();
		myChapterState = CHAPTER_QUERY_LOADED_STATUS_LOADED;

		if (ready) {
			sendLoadNumChapters();
		} 
		else {
			// close socket and try later
			closeSocket();
		}
	}
	///////////////////////////////////////////////////////////////////////////				
	private function closeHandler(e:Event):Void{
		myChapterState = CHAPTER_IDLE;
		//trace("chapter connection closed:" + e);
		
		// re-connect
		startLoading();
	}
	///////////////////////////////////////////////////////////////////////////				
	private function securityErrorHandler(e:Event):Void{
		myChapterState = CHAPTER_IDLE;
		//trace("WcChapterConnection() - Security error:" + e.toString());
		//dispatchEvent(new WvEvent("Wv.Chapter.Security", "", e.toString());
		startLoading();
	}
	///////////////////////////////////////////////////////////////////////////				
	private function errorHandler(e:Event):Void{
		myChapterState = CHAPTER_IDLE;
		//trace("WvChapterConnection() - Error:" + e.toString());
		//dispatchEvent(new WvEvent("Wv.Chapter.Error", "", e.toString()));
		// re-connect
		// startLoading();
	}
	///////////////////////////////////////////////////////////////////////////
	public function sendLoadNumChapters():Void 
	{
		try {
			myFullMsg = "";
			myPluginSocket.flush();
			myPluginSocket.sendRequest("GET /cgi-bin/GetNumChapters HTTP/1.1");
			myChapterState = CHAPTER_NUM_CHAPTERS_LOADING;
		}
		catch (errObject:Error) {
		}
	}
	///////////////////////////////////////////////////////////////////////////
	private function readNumChaptersFromSocket():Void 
	{			
		myNumChapters = HTTPParserGetDataAsInt(myFullMsg.substr(myDataIndex), myContentLength);
		myPluginSocket.flush();
		
		myChapterState = CHAPTER_NUM_CHAPTERS_LOADED;
		//trace("NumChapters:" + myNumChapters);
		
		// If this asset contain chapters, start loading them.
		if (myNumChapters > 0) {
			loadChapterData();
		}
	}		
	///////////////////////////////////////////////////////////////////////////
	private function sendLoadChapterData(chapterNum:Int):Void 
	{
		myCurrLoadingChapter = chapterNum;
		try {
			myFullMsg = "";
			myPluginSocket.flush();
			myChapterState = CHAPTER_DATA_LOADING;
			myPluginSocket.sendRequest("GET /cgi-bin/GetChapterData?chapter="+chapterNum + " HTTP/1.1");
		}
		catch (errObject:Error) {
		}
	}

	///////////////////////////////////////////////////////////////////////////		
	/*
	private function URLCompleteHandler(e:Event):Void{
		//trace("chapter request complete");
	}
	private function URLOpenHandler(e:Event):Void{
		//trace("chapter request open:" + e);
	}
	private function URLHTTPStatusHandler(e:Event):Void{
		//trace("chapter request HTTP status:" + e);
	}
	private function URLProgressHandler(e:ProgressEvent):Void{
		//trace("chapter request progress:" + e.bytesLoaded + " total:" + e.bytesTotal);
	}
	private function URLIOErrorHandler(e:Event):Void{
		//trace("chapter request i/o error:" + e);
	}
	*/
	///////////////////////////////////////////////////////////////////////////
	private function configureListeners(dispatcher:IEventDispatcher):Void {
		/*
		dispatcher.addEventListener(Event.COMPLETE, 				URLCompleteHandler);
		dispatcher.addEventListener(Event.OPEN, 					URLOpenHandler);
		dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, 	URLHTTPStatusHandler);
		dispatcher.addEventListener(ProgressEvent.PROGRESS,	 		URLProgressHandler);
		dispatcher.addEventListener(IOErrorEvent.IO_ERROR,	 		URLIOErrorHandler);
		*/
	}
	///////////////////////////////////////////////////////////////////////////
	private function sendLoadChapterImage_URL(chapterNum:Int):Void 
	{
		myCurrLoadingChapter = chapterNum;
		try {
			myFullMsg = "";
			//trace("Closing socket");
			myPluginSocket.close();
			myChapterState = CHAPTER_IMAGE_LOADING;
			var loader:URLLoader = new URLLoader();
			configureListeners(loader);
			var request:URLRequest = new URLRequest("http://localhost:20001:/cgi-bin/GetChapterJpg?chapter="+chapterNum);
			try {
				//trace("Sending URL request");
				loader.load(request);
			}
			catch (error:Error) {
				//trace("Unable to load chapter image: " + chapterNum);
			}
			//myPluginSocket.sendRequest("GET /cgi-bin/GetChapterJpg?chapter="+chapterNum + " HTTP/1.1");
		}
		catch (errObject:Error) {
		}
	}
		///////////////////////////////////////////////////////////////////////////
	private function sendLoadChapterImage(chapterNum:Int):Void 
	{
		myCurrLoadingChapter = chapterNum;
		myCurrentChapter = myChapters[myCurrLoadingChapter];
		if (myCurrentChapter == null) {
			//dispatchEvent(new WvEvent("Wv.Chapter.Error", "", "Unable to load chapter image for chapter:" + chapterNum));
			//trace("Unable to send loadChapterImage request. Chapter " + myCurrLoadingChapter + " is null");
			return;
		}
		try {
			myFullMsg = "";
			myChapterState = CHAPTER_IMAGE_LOADING;
			myPluginSocket.removeEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
			myPluginSocket.addEventListener(ProgressEvent.SOCKET_DATA, socketBinaryDataHandler);
			myPluginSocket.sendRequest("GET /cgi-bin/GetChapterJpg?chapter="+chapterNum + " HTTP/1.1");
			myPluginSocket.flush();
		}
		catch (errObject:Error) {
		}
	}
	//////////////////
	/////////////////////////////////////////////////////////
	private function readChapterDataFromSocket():Void 
	{
		var timeIndex:String;
		var chapterName:String;
		var done:Bool = false;

		// check if called too soon
		if (myContentLength == 0) {
			if (myNumRetries++ < MAX_RETRIES_ALLOWED) {
				//trace("Resending the request for chapter data");
				sendLoadChapterData(myCurrLoadingChapter);
			}
			return;
		}

		myCurrentChapter = new WvChapter(myCurrLoadingChapter);
		myCurrentChapter.loadData(myFullMsg.substr(myDataIndex));
		myPluginSocket.flush();

		myChapters[myCurrLoadingChapter] = myCurrentChapter;
		myChapterState = CHAPTER_DATA_LOADED;
					
		// Is there more chapters?
		if (myCurrLoadingChapter < myNumChapters-1) {
			sendLoadChapterData(++myCurrLoadingChapter);
		}
		else {
			// start loading the images
			//trace("Start loading images...");
			myCurrLoadingChapter = 0;
			sendLoadChapterImage(myCurrLoadingChapter++);
		}
	}

	///////////////////////////////////////////////////////////////////////////
	private function readChapterImageFromSocket():Void 
	{
		var timeIndex:String;
		var chapterName:String;
		var done:Bool = false;

		//trace("Loading image for chapter:" + myCurrLoadingChapter);
		if (myCurrentChapter == null) {
			//trace("Chapter " + myCurrLoadingChapter + " is null");
		}
		else {
			myCurrentChapter.loadImage();
		}
		myPluginSocket.flush();
		myFullMsg = "";
		
		myChapterState = CHAPTER_IMAGE_LOADED;
					
		//dispatchEvent(new WvEvent("Wv.Chapter.Loading", String(myCurrLoadingChapter), String(myNumChapters)));
		
		//trace("currLoadingChapter:" + myCurrLoadingChapter + ", myNumChapterS:" + myNumChapters);
		// Is there more chapters?
		if (myCurrLoadingChapter < (myNumChapters-1)) {
			sendLoadChapterImage(++myCurrLoadingChapter);
		}
		else {
			// make sure we loaded all images.
			myIsChaptersLoaded = true;
			// all done
			myCurrLoadingChapter = 0;
			//dispatchEvent(new WvEvent("Wv.Chapter.Complete", "", String(myNumChapters)));
		}
	}
	///////////////////////////////////////////////////////////////////////////
	public function socketDataHandler(e:ProgressEvent):Void
	{
		//var str:String;
		//trace("socketDataHandler - [State:" + myChapterState + "] socketDataHandler: " + e);
		
		if (myFullMsg.length == 0) {
			myContentLength = 0;
		}
		myFullMsg += myPluginSocket.readUTFBytes(myPluginSocket.bytesAvailable);

		if (myContentLength == 0) {
			myDataIndex = 0;
			myContentLength = HTTPParserGetContentLength(myFullMsg);
		}
		// trace(">>>>>>>\n" + myFullMsg + "\n<<<<<<<<");

		if ((myFullMsg.length - myDataIndex) < myContentLength) 
		{
			//trace ("Got only " + (myFullMsg.length - myDataIndex) + " of " + myContentLength + " data bytes");
			return;
		}
		//trace ("Got " + (myFullMsg.length - myDataIndex) + " of " + myContentLength + " data bytes");
		myGotHTTPHeader = false;
		
		switch (myChapterState) 
		{
			case CHAPTER_QUERY_LOADED_STATUS_LOADING:
				readQueryChaptersLoadedFromSocket();
				//break;
			
			case CHAPTER_NUM_CHAPTERS_LOADING:
				readNumChaptersFromSocket();
				//break;
				
			case CHAPTER_DATA_LOADING:
				readChapterDataFromSocket();
				//break;
				
			case CHAPTER_IMAGE_LOADING:
				readChapterImageFromSocket();
				//break;
				
			default:
				//trace("unhandled chapter state: " + myChapterState);
				//break;
		}
	}
	
	///////////////////////////////////////////////////////////////////////////
	public function socketBinaryDataHandler(e:ProgressEvent):Void
	{
		//var str:String;
		//trace("socketBinaryDataHandler - [State:" + myChapterState + "] socketBinaryDataHandler: " + e);
		
		if (myFullMsg.length == 0) {
			myContentLength = 0;
		}

		if (myChapterState != CHAPTER_IMAGE_LOADING) {
			trace(">>>>>>>  Unexpected binary data.  ChapterState:" + myChapterState);
			myPluginSocket.flush();
			myFullMsg = "";
			return;
		}
		if (!myGotHTTPHeader) {
			var done:Bool = false;
			var loc:Int;
			while ((myPluginSocket.bytesAvailable > 0) && (!done)) {
				myFullMsg += myPluginSocket.readUTFBytes(1);
				loc = myFullMsg.indexOf("Cache-Control:");
				if (loc != -1) {
					if (myFullMsg.indexOf("\n", loc) != -1) {
						myFullMsg += myPluginSocket.readUTFBytes(1);
						done = true;
						myGotHTTPHeader = true;
						myContentLength = HTTPParserGetContentLength(myFullMsg);
						//trace("=========\n" + myFullMsg + "\n======== bytes left:" 
						//  				+ myPluginSocket.bytesAvailable);
					}
				}
			}
		}
		// read in remaining bytes
		myPluginSocket.readBytes(myCurrentChapter.myByteArray, 
								 myCurrentChapter.myByteArray.length, 
								 myPluginSocket.bytesAvailable);
		
		var byteArrayLength:Int = myCurrentChapter.myByteArray.length;
		if (byteArrayLength < myContentLength)
		{
			trace ("Got only " + myCurrentChapter.myByteArray.length + " of " + myContentLength + " data bytes");
			return;
		}
		//trace ("Got " + myCurrentChapter.myByteArray.length + " of " + myContentLength + " data bytes");
		myGotHTTPHeader = false;
		readChapterImageFromSocket();
	}
	///////////////////////////////////////////////////////////////////////////
	// Returns all information for the specified chapter
	// Parameters:
	//		[in]	chapter to return
	//		[out]	chapter name
	//		[out]	chapter start time index 
	//		[out]	chapter image as bute array
	// returns:
	//		void
	//
	public function GetChapterData(chapter:Int, chapterName:String, timeIndex:Float, image:ByteArray):Void
	{
		if (chapter > myChapters.length) {
			throw new ArgumentError("chapter requested exceeds number of chapters " + myChapters.length);
		}
		chapterName = myChapters[chapter].getName();
		timeIndex 	= myChapters[chapter].getIndex();
		image		= myChapters[chapter].myByteArray;
	}
	///////////////////////////////////////////////////////////////////////////
	// Returns the number of chapters
	public function getNumChapters():Int
	{
		//trace("returning numChapters:"+ myNumChapters);
		return myNumChapters;
	}
	///////////////////////////////////////////////////////////////////////////
	// Returns the chapter
	public function getChapter(chapterNum:Int):WvChapter
	{
		if (chapterNum > myNumChapters) {
			return null;
		}
		return myChapters[chapterNum];
	}
	///////////////////////////////////////////////////////////////////////////
	public function loadChapterData():Void
	{
		myChapterState = CHAPTER_DATA_LOADING;
		sendLoadChapterData(0);
	}
	///////////////////////////////////////////////////////////////////////////
	public function isChaptersLoaded():Bool
	{
		// if ((myIsChaptersLoaded) && (!myChapterImagesLoaded)) {
		if (myIsChaptersLoaded) {
			for(chapter in myChapters) {
				if (!chapter.hasBitmap()) {
					trace(">>>>>>>>>> Still waiting for chapter:"+chapter.getNumber());
					return false;
				}
				else {
					// trace ("chapter:" + chapter.getNumber() + " is loaded:");
				}
			}
			//trace("================ ALL CHAPTERS DATA LOADED ===================");
			myChapterImagesLoaded = true;
		}
		return myChapterImagesLoaded;
	}
	///////////////////////////////////////////////////////////////////////////
	// return the content-length.
	// return index to the data portion of the message
	public function HTTPParserGetContentLength(fullMsg:String):Int
	{
		var contentLength = "Content-Length: ";
		var loc1:Int 				= fullMsg.indexOf(contentLength);
		
		if (loc1 == -1) {
			//trace("Did not find \"" + contentLength + "\" in:" + fullMsg);
			return 0;
		}
		loc1 += contentLength.length;
		// find the <CR> 
		var loc2:Int = fullMsg.indexOf("\n", loc1);
		// end of actual length

		var len = Std.parseInt(fullMsg.substr(loc1, loc2-loc1));
		
		loc1 = fullMsg.indexOf("Content-Type:");
		myContentType = "";
		if (loc1 != -1) {
			loc2 = fullMsg.indexOf("\n", loc1);
			myContentType = fullMsg.substr(loc1 + 13, loc2);
		}
		loc1 = fullMsg.indexOf("Cache-Control:");
		myDataIndex = fullMsg.indexOf("\n", loc1) + 2;
		//trace("content length:" + len + ", dataIndex:" + myDataIndex);
		
		//ExternalInterface.call("alert", String(fullMsg.substr(loc1, loc2-loc1) + ", " + loc1  + ", " + loc2 + ", " + len));
		return len;
	}
		

	///////////////////////////////////////////////////////////////////////////
	public function HTTPParserGetDataAsInt(dataMsg:String, len:Int):Int
	{
		var intData:Int = Std.parseInt(dataMsg.substr(0,len));
		//trace("data:" + dataMsg.substr(0, len) + ", intData:" + intData);
		return intData;
	}
	///////////////////////////////////////////////////////////////////////////
	public function checkChapters():Void 
	{
		//trace(">>>> Checking chapters >>>>>>>>>>>>>>>>>>>>>>");
		//for each (var chapter:WvChapter in myChapters) {
		for(chapter in myChapters) {
			if (!chapter.hasBitmap()) {
				sendLoadChapterImage(chapter.getNumber());
			}
		}
	}
}



