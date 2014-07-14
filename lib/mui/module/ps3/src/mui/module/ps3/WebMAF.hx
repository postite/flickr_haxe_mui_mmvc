package mui.module.ps3;

import haxe.ds.StringMap;
import msignal.Signal;

class WebMAF
{
	// callback status
	inline public static var STATUS_OK = "ok";
	inline public static var STATUS_FAIL = "fail";

	// player states
	inline public static var PLAYER_STATE_BUFFERING = "buffering";
	inline public static var PLAYER_STATE_END_OF_STREAM = "endOfStream";
	inline public static var PLAYER_STATE_NOT_READY = "notReady";
	inline public static var PLAYER_STATE_OPENING = "opening";
	inline public static var PLAYER_STATE_PAUSED = "paused";
	inline public static var PLAYER_STATE_PLAYING = "playing";
	inline public static var PLAYER_STATE_STOPPED = "stopped";
	inline public static var PLAYER_STATE_UNKNOWN = "unknown";
	
	// player events
	public static var playbackTimeChanged = new Signal2<Int, Int>();
	public static var playerStatusChanged = new Signal2<String, String>();
	public static var contentAvailable = new Signal1<Int>();
	public static var streamingError = new Signal2<Int, String>();
	public static var networkStatusChange = new Signal2<String, String>();

	//-------------------------------------------------------------------------- psn

	/**
		Returns the current network time, preventing issues for users who have 
		not set the clock on their PS3TM.
	**/
	public static function getNpTime(?handler:{time:String} -> Void):Void
	{
		callCommand("getNpTime", null, handler);
	}

	/**
		Sets the PSN presence information.

		Please note that the presence information is in UTF8 but is limited to 
		128 bytes.
	**/
	public static function setPsnPresenceInfo(info:String):Void
	{
		callCommand("setPsnPresenceInfo", {presenceInfo:info});
	}

	/**
		Checks if the PSN is connected.
	**/
	public static function isPsnConnected(?handler:{connected:Bool} -> Void):Void
	{
		callCommand("isPsnConnected", null, handler);
	}

	/**
		Checks if the PSN account connected is a PSN Plus account.
	**/
	public static function isPsnPlusAccount(?handler:{plus:Bool} -> Void):Void
	{
		callCommand("isPsnPlusAccount", null, handler);
	}

	/**
		Returns the age of the currently logged in PSN user.
	**/
	public static function getPsnUserAge(?handler:{userAge:Int, isRestricted:Bool, result:String} -> Void):Void
	{
		callCommand("getPsnUserAge", null, handler);
	}

	/**
		Returns the online id of the currently logged in PSN user.
	**/
	public static function getPsnOnlineId(?handler:{onlineId:String, result:String} -> Void):Void
	{
		callCommand("getPsnOnlineId", null, handler);
	}

	/**
		Returns the ticket of the currently logged in PSN user. It can be 
		used with the TCM service.
	**/
	public static function getPsnTicket(?handler:{ticket:String} -> Void):Void
	{
		callCommand("getPsnTicket", null, handler);
	}

	/**
		Post an in-game user feed.
	**/
	public static function postPsnActivityFeed(activity:PSNActivity, ?handler:Dynamic -> Void):Void
	{
		callCommand("postPsnActivityFeed", activity, handler);
	}

	/**
		Initiates a request for PSN activity feeds based on user onlineId 
		or titleId.

		It will notify the application returning an array of feeds with 
		psnActivityFeedResponse.
	**/
	public static function getPsnActivityFeed(type:String, onlineId:String, newsfeed:String, blockIdx:String, ?handler:Dynamic -> Void):Void
	{
		callCommand("getPsnActivityFeed", {type:type, onlineId:onlineId, newsfeed:newsfeed, blockIdx:blockIdx}, handler);
	}

	//-------------------------------------------------------------------------- cdn

	/**
		Aborts the CDN performance test.
	**/
	public static function abortCdnPerformance()
	{
		callCommand("abortCdnPerformance");
	}

	/**
		The application will try downloading from the CDN using the URI 
		provided as parameter, and return the download speed once the test is 
		complete.
	**/
	public static function getCdnPerformance(uri:String, ?handler:{bitsPerSecond:Int} -> Void):Void
	{
		callCommand("getCdnPerformance", {uri:uri}, handler);
	}

	//-------------------------------------------------------------------------- other

	/**
		Command to be used by the web application to ping the PS3TM application.
	**/
	public static function ping(?handler:{message:String} -> Void):Void
	{
		callCommand("ping", null, handler);
	}

	/**
		Command to log a message on the TTY output for debugging purposes. This 
		command is only available in the development package and cannot be used 
		in production.
	**/
	public static function logTTY(msg:Dynamic):Void
	{
		callCommand("logTTY", {msg:msg});
	}

	/**
		Command to be used by the web application to get the PS3TM application 
		version number in the format MM.mm where MM is the major version and 
		mm the minor version.
	**/
	public static function appversion(?handler:{version:String} -> Void):Void
	{
		callCommand("appversion", null, handler);
	}

	/**
		Command to be used by the web application to get the PS3TM hardware id 
		as a hexadecimal string composed of 32 digits.

		The hardware id is a unique value per console.
	**/
	public static function hwid(?handler:{hwid:String} -> Void):Void
	{
		callCommand("hwid", null, handler);
	}

	/**
		Command to be used by the web application to get the PS3TM assignment 
		of the Enter button. It returns the value of the Enter button as a 
		string and a numeric value as used by the key event system.
	**/
	public static function enterbutton(?handler:{button:String, value:Int} -> Void):Void
	{
		callCommand("enterbutton", null, handler);
	}

	//-------------------------------------------------------------------------- video player
	
	/**
		Return a list of all the audio tracks detected in the content currently 
		playing.
	**/
	public static function getAudioTracks(?handler:{audioTracks:String, currentAudioTrack:String} -> Void):Void
	{
		callCommand("getAudioTracks", null, handler);
	}

	/**
		Return a list of the all the subtitle tracks detected in the content 
		currently playing.
	**/
	public static function getSubtitleTracks(?handler:{subtitleTracks:String, currentSubtitleTrack:String} -> Void):Void
	{
		callCommand("getSubtitleTracks", null, handler);
	}

	/**
		Requests playback time information.
	**/
	public static function getPlaybackTime(?handler:{totalTime:Float, elapsedTime:Float, cacheOccupancy:Float, cacheSize:Float} -> Void):Void
	{
		callCommand("getPlaybackTime", null, handler);
	}

	/**
		Gets the video playback speed.
	**/
	public static function getPlaySpeed(?handler:{playSpeed:Float} -> Void):Void
	{
		callCommand("getPlaySpeed", null, handler);
	}

	/**
		Requests the current video resolution.
	**/
	public static function getVideoResolution(?handler:{width:Int, height:Int} -> Void):Void
	{
		callCommand("getVideoResolution", null, handler);	
	}

	/**
		Load a video URI with optional DRM license URI and 
	*/
	public static function load(contentUri:String, ?licenseUri:String, ?customData:String):Void
	{
		var params:Dynamic = {contentUri:contentUri};

		if (licenseUri != null) params.licenseUri = licenseUri;
		if (customData != null) params.customData = customData;

		callCommand("load", params);
	}

	/**
		Pauses the video. Call `play` to resume the video.
	**/
	public static function pause():Void
	{
		callCommand("pause");		
	}

	/**
		Sets the video to play mode.
	**/
	public static function play():Void
	{
		callCommand("play");
	}

	/**
		Change the audio track from the content currently played.
	**/
	public static function setAudioTrack(audioTrack:String):Void
	{
		callCommand("setAudioTrack", {audioTrack:audioTrack});	
	}

	/**
		Jumps the video to a specified time.
	**/
	public static function setPlayTime(playTime:Float):Void
	{
		callCommand("setPlayTime", {playTime:playTime/1000});	

	}

	/**
		Set the subtitle track to the identifier passed to this function. If no 
		subtitles have been selected prior to this call, the subtitle will be 
		activated. To deactivate the subtitles, the identifier shall be an 
		empty string.

		If the RenderSubtitle keyword is set to true, the video player is in 
		charge to display the subtitles after calling this function. If not, a 
		collection of notifications playerSubtitle is sent with the subtitle 
		information.
	**/
	public static function setSubtitleTrack(subtitleTrack:String):Void
	{
		callCommand("setSubtitleTrack", {subtitleTrack:subtitleTrack});	
	}

	/**
		This function is used to show the video playback window on the screen 
		according to the coordinates provided.
	**/
	public static function setVideoPortalSize(ltx:Float, lty:Float, rpx:Float, rpy:Float):Void
	{
		callCommand("setVideoPortalSize", {ltx:ltx, lty:lty, rbx:rpx, rby:rpy});
	}

	/**
		Stops the video.
	**/
	public static function stop():Void
	{
		callCommand("stop");
	}

	//-------------------------------------------------------------------------- graphics

	/**
		Enables the Share button functionality on the controller so the user 
		can take a screenshot of the screen for upload to the Internet. Can be 
		set dynamically at any point during application execution
	**/
	public static function enableScreenshot(enable:Bool):Void
	{
		callCommand("enableScreenshot", {enable:enable});
	}

	/**
		Requests some device information.
	**/
	public static function getDeviceInfo(?handler:{portType:String} -> Void):Void
	{
		callCommand("getDeviceInfo", null, handler);
	}

	/**
		Requests the screen resolution.
	**/
	public static function getScreenResolution(?handler:{width:Int, height:Int, aspect:String} -> Void):Void
	{
		callCommand("getScreenResolution", null, handler);
	}

	/**
		Set the background color.
	**/
	public static function setBackgroundColor(color:Int):Void
	{
		callCommand("setBackgroundColour", {colour:StringTools.hex(color, 6)});
	}

	/**
		Enables or disables the CGMS-A protection.
		Please note that by default CGMS-A is enabled in WebMAF
	**/
	public static function setCgms(enable:Bool):Void
	{
		callCommand("setCgms", {enable:enable});
	}

	/**
		Dismisses the splash screen.
	**/
	public static function dismissSplash():Void
	{
		callCommand("dismissSplash");
	}

	//-------------------------------------------------------------------------- parameters

	/**
		Gets authentication parameters.
	**/
	public static function getAuthParameters(?handler:{consumerSecret:String, tokenSecret:String} -> Void):Void
	{
		callCommand("getAuthParameters", null, handler);
	}

	/**
		This command does a secure https “get request”, using the client 
		certificate of the application.
		
		This request is done using the http POST method, but this can be 
		changed by modifying the “ContentMethod” setting in the user data file, 
		setting it to “GET”.
	**/
	public static function getContentParameters(url:String, ?handler:{contentDocument:String} -> Void):Void
	{
		callCommand("getContentParameters", {parameterUrl:url}, handler);
	}

	/**
		Gets a user parameter.

		Please note that these values are in addition to the parameters saved 
		using “setUserParameter” or by adding values to the webmaf_settings.ini 
		configuration file.
	**/
	public static function getUserParameter(name:String, ?handler:{name:String, value:String} -> Void):Void
	{
		callCommand("getUserParameter", {name:name}, handler);
	}

	/**
		Saves a user parameter locally.

		- the user parameters are stored locally only for the current session 
		  and do not persist across other sessions. In the case the user 
		  parameter shall persist across sessions, it is advised to use a 
		  cookie.
		- the user shall be connected to the PlayStation®Network to 
		  successfully save the parameter.
	**/
	public static function setUserParameter(name:String, value:String):Void
	{
		callCommand("setUserParameter", {name:name, value:value});
	}

	//-------------------------------------------------------------------------- helpers

	static var inited = init();
	static var commandHandlers = new StringMap<Array<Dynamic -> Void>>();

	static function init()
	{
		#if !browser
		untyped window.accessfunction = mui.module.ps3.WebMAF.nativeCallback;
		#end
		return true;
	}

	static function callCommand(command:String, ?parameters:Dynamic, ?handler:Dynamic):Void
	{	
		if (parameters == null) parameters = {};
		parameters.command = command;

		if (handler != null)
		{
			if (!commandHandlers.exists(command)) commandHandlers.set(command, []);
			commandHandlers.get(command).push(handler);
		}

		var jsString = haxe.Json.stringify(parameters);			

		#if !browser
		untyped if (window.external && window.external.user)
		{
			window.external.user(jsString);
		}
		#end
	}

	static function nativeCallback(json:Dynamic):Void
	{
		trace("WebMAF: " + json);

		var result:Dynamic = null;
		try
		{
			result = untyped __js__("JSON.parse(json)");
		}
		catch (e:Dynamic)
		{
			trace("Failed to parse JSON: \n" + json);
			return;
		}

		if (result.status != STATUS_OK)
		{
			trace("Command failed: " + json);
			return;
		}

		var command:String = result.command;
		
		if (commandHandlers.exists(command))
		{
			var handlers = commandHandlers.get(command);
			for (handler in handlers) handler(result);
			commandHandlers.remove(command);
		}

		switch (command)
		{
			case "networkStatusChange":
				networkStatusChange.dispatch(result.previousState, result.newState);

			case "contentAvailable":
				contentAvailable.dispatch(result.totalLength);

			case "playerStatusChange":
				playerStatusChanged.dispatch(result.status, result.playerState);

			case "getPlaybackTime":
				playbackTimeChanged.dispatch(result.elapsedTime, result.totalTime);

			case "playerStreamingError":
				trace ("Player streaming error reported");
				streamingError.dispatch(result.status_code, result.error);

			case "shutdownNotification":
				trace("Received Shutdown Notification - stopping current video");
				stop();

			default:
		}
	}
}

typedef PSNActivity = {
	caption:String, 
	condensedCaption:String, 
	storyComment:String, 
	source:String, 
	smallImageUrl:String, 
	smallImageAspectRatio:String, 
	largeImageUrl:String, 
	videoUrl:String, 
	webUrl:String, 
	serviceLabel:String, 
	productCategoryLabel:String, 
	buttonCaption:String, 
	buttonImage:String
}
