package mui.display;

import haxe.Timer;
import mui.display.IVideo;

/**
Notes:

- NetCast Platform does not support Mute , Unmute or any volume control on an individual 
video object. These are all handled through the TV native system.

- NetCast metadata object doesn't contain encoded dimensions of video file so width and height
must be set manually when video object is created.

- Seeking is only possible when streaming over MMSH and the bool "isScannable" returns true

- If either dimension is set to maximum available dimension for the screen (width = 1280 or 
height = 720 ) then the other dimension will be forced to the maximum also event when set to a 
smaller number.
*/
class VideoNetcast20 extends VideoBase
{
	static public inline var LG_VIDEO = "lgvideo";
	static public inline var RECHECK_TIMEOUT = 250;
	
	var video:Dynamic;
	var videoReady:Bool;
	var storedTime:Float;
	var committingSeek:Bool;
	var isScannable:Bool;
	var endReached:Bool;
	
	public function new() 
	{
		super();
		
		videoReady = false;
		autoPlay = false;
		storedTime = -1.0;
		committingSeek = false;
		isScannable = false;
		createVideo();
	}
	
	override public function destroy()
	{
		stopVideo();
		element.removeChild(video);
		video = null;
	}
	
	function createVideo()
	{
		video = js.Browser.document.getElementById(LG_VIDEO);
		
		if (video != null)
		{ 
			element.removeChild(video);
		}
		
		video = js.Browser.document.createElement("object");	
		video.type="application/x-netcast-av";
		video.width=width;
		video.height=height;
		video.autoStart = false;
		video.wmode='transparent';
		video.preBufferingTime = 10;
		video.controller = false;
		video.downloadable = false;
		
		element.appendChild(video);
		
		video.onError = errorHandler;
		video.onPlayStateChange = playStateChangeHandler;
		video.onReadyStateChange = readyStateChangeHandler;
		video.onBuffering = bufferingHandler;

		//Check the reference to "video" actually referes to the browsers video 
		// player not just the object created above, otherwise methods such as 
		// "play" will not exist when first called.
		checkVideoReady();
	}

	function checkVideoReady()
	{
		if (video.play == null)
		{
			Timer.delay(checkVideoReady, RECHECK_TIMEOUT);
		}
		else
		{
			videoReady = true;
			
			isScannable = video.isScannable;
			
			// No way to retrieve encoded width and height from metadata so 
			// videoWidth and videoHeight are set to the width and height of 
			// the video object which are set in createVideo() 
			videoWidth = video.width;
			videoHeight = video.height;
			
			getDuration();
			
			bufferProgress = changeValue('bufferProgress', 1);
			
			switch(playbackState)
			{
				case VideoPlaybackState.PAUSED : pauseVideo();
				case VideoPlaybackState.PLAYING : playVideo();
				case VideoPlaybackState.STOPPED : stopVideo();
			}
			
			if (currentTime > -1)
				commitSeek();
		}
	}
	
	/**
	Ready state events that are supposed to return when metadata is ready are unreliable*
	o duration is retrieved manually.
	*/ 
	function getDuration()
	{
		var mediaInfoDuration = video.mediaPlayInfo().duration;
		if (mediaInfoDuration > 0)
		{
			duration = changeValue('duration', mediaInfoDuration / 1000);
			metadataLoaded = changeValue('metadataLoaded', true);
		}
		else
		{
			Timer.delay(getDuration, RECHECK_TIMEOUT);
		}
	}
	
	override function startVideo()
	{
		video.data = source;
	}
	
	override function playVideo() 
	{
		if (endReached)
		{
			video.stop();
			endReached = false;
		}

		if(videoReady)
			video.play(1);
	}
	
	override function pauseVideo()
	{
		if(videoReady)
			video.play(0);
	}
	
	override function stopVideo()
	{
		if (videoReady)
		{
			video.stop();
			video.data = "";
		}
	}
	
	override public function seek(timeSecs:Float)
	{
		if (!isScannable) return;
		
		super.seek(timeSecs);
	}
	
	override function seekVideo(timeSecs:Float)
	{
		if (storedTime == -1.0)
            storedTime = currentTime;
			
		currentTime = changeValue("currentTime", timeSecs);
	}

	function commitSeek()
	{
		if (!videoReady) return;
		
		// will jump to closest keyframe to currentTime.
		var offset = (storedTime - currentTime);
		
		if (offset < 0)
			video.seek(Math.abs(offset));
		else
			video.seek(offset);
			
		storedTime = -1.0;
		committingSeek = true;
	}
	
	override function updateState()
	{
		super.updateState();
	
		if(videoReady)
		{
			currentTime = changeValue("currentTime", video.playPosition / 1000);
			
			if (duration > 0 && currentTime >= duration - .01 && !endReached)
			{
				endReached = true;
				playbackComplete();
			}	
		}
	}
		
	override function updateVolume(level:Float)
	{
		// NetCast video / audio objects have no volume 
	}
	
	override function change(flag:Dynamic)
	{
		super.change(flag);
		
		if (flag.seeking && !seeking)
			commitSeek();
		
		if (flag.playbackState)
			video.style.display = (playbackState == STOPPED) ? "hidden" : "block";
			
		if (flag.width || flag.height || flag.videoWidth || flag.videoHeight) 
		{ 
			var vw:Float = width;
			var vh:Float = height;

			if (videoWidth > 0 && videoHeight > 0) 
			{
				vw = videoWidth;
				vh = videoHeight;
			}

			var sw = width / vw;
			var sh = height / vh;
			var s = (sw < sh ? sw : sh);

			vw *= s;
			vh *= s;
			
			var x = Std.int((width - vw) * 0.5);
			var y = Std.int((height - vh) * 0.5);

			video.style.left = x;
			video.style.top = y;
			video.width = Math.round(vw);
			video.height = Math.round(vh);
		}
		
		if (flag.source)
			checkProtocol(source);
	}
	
	function checkProtocol(source:String):Void 
	{
		if (source.indexOf('mms:') == 0 || source.indexOf('mmsh:') == 0)
		{
			connection = changeValue('connection', STREAMING);
			bufferProgress = changeValue('bufferProgress', 1);
		}
		else
		{
			connection = changeValue('connection', PROGRESSIVE);
			bufferProgress = changeValue('bufferProgress', 0);
		}
	}

	public function errorHandler(e):Void 
	{
		// Error codes from : LG Smart TV SDK V1.3.1 Release Notes.pdf
		var error : VideoError = switch(e)
		{
			case 0 : 
				VideoError.UNSUPPORTED_FORMAT('A/V format not supported');
			case 1 : 
				VideoError.NETWORK_ERROR('Cannot connect to server or connection lost');
			case 2 : 
				VideoError.UNKNOWN_ERROR('Unidentified error');
			case 1000 : 
				VideoError.NETWORK_ERROR('File is not found');
			case 1001 : 
				VideoError.NETWORK_ERROR('Invalid protocol');
			case 1003 : 
				VideoError.UNKNOWN_ERROR('Play list is empty');
			case 1004 : 
				VideoError.UNSUPPORTED_FORMAT('Unrecognized play list');
			case 1005 : 
				VideoError.UNSUPPORTED_FORMAT('Invalid ASX format');
			case 1006 : 
				VideoError.NETWORK_ERROR('Error in downloading play list');
			case 1007 : 
				VideoError.DECODE_ERROR('Out of memory');
			case 1008 : 
				VideoError.UNSUPPORTED_FORMAT('Invalid URL list format');
			case 1009 : 
				VideoError.UNSUPPORTED_FORMAT('Not playable in play list');
			case 1101 : 
				VideoError.PLAYBACK_ABORTED('Incorrect license in local license store');
			case 1102 : 
				VideoError.PLAYBACK_ABORTED('Fail in receiving correct license from server');
			case 1103 : 
				VideoError.PLAYBACK_ABORTED('Stored license is expired');
			default : 
				VideoError.UNKNOWN_ERROR(Std.string(e));
		}
		failure(error);
	}
	
	
	function bufferingHandler(isBufferEmpty):Void 
	{
		bufferState = changeValue("bufferState", isBufferEmpty ? EMPTY : FULL);
	}
	
	function playStateChangeHandler(e):Void 
	{
		//too unreliable to be of any use
	}
	
	function readyStateChangeHandler(e):Void 
	{
		//too unreliable to be of any use
	}
}

class Buffering 
{
	static public inline var BUFFER_EMPTY:Bool = true;
	static public inline var BUFFER_FULL:Bool = false;
}

// May be of use if 'onReadyStateChange' is improved 
// private class ReadyState
// {
// 	public static inline var FILE_NOT_SET:Int = 0;
// 	public static inline var FILE_LOADING:Int = 1;
// 	public static inline var UNKNOWN_READY_STATE:Int = 2;
// 	public static inline var FILE_PARTIALLY_LOADED:Int = 3;
// 	public static inline var FILE_LOADED:Int = 4; 
// }

// // May be of use if 'onPlayStateChange' is improved 
// private class PlayState
// {
// 	public static inline var STOPPED:Int = 0;
// 	public static inline var PLAYING:Int = 1;
// 	public static inline var PAUSED:Int = 2;
// 	public static inline var CONNECTING:Int = 3;
// 	public static inline var BUFFERING:Int = 4;
// 	public static inline var FINISHED:Int = 5;
// 	public static inline var ERROR:Int = 6;
// }
