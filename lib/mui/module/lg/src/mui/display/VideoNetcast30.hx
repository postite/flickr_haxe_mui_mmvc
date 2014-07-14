package mui.display;

import mui.display.IVideo;

/**
A `Video` implementation for LG 2012 NetCast 3.0 devices.
*/
class VideoNetcast30 extends VideoBase
{
	var player:MediaPlayer;

	public function new()
	{
		super();

		player = cast js.Browser.document.createElement('object');
		element.appendChild(untyped player);

		player.type = MediaPlayerType.NETCAST_AV;
		player.width = 1280;
		player.height = 720;
		
		player.onBuffering = onBuffering;
		player.onError = onError;
		player.onPlayStateChange = onPlayStateChange;
	}

	override function change(flag:Dynamic)
	{
		super.change(flag);

		if (flag.width || flag.height)
		{
			player.width = width;
			player.height = height;
		}
	}

	//-------------------------------------------------------------------------- player listeners

	function onBuffering(isStarted:Bool):Void
	{
		bufferState = changeValue('bufferState', isStarted ? VideoBufferState.EMPTY : VideoBufferState.FULL);
	}

	function onError():Void 
	{
		var error = switch (player.error)
		{
			case 0:     UNSUPPORTED_FORMAT('A/V format not supported');
			case 1:     NETWORK_ERROR('Cannot connect to server or connection lost');
			case 2:     UNKNOWN_ERROR('Unidentified error');
			case 1000:	NETWORK_ERROR('File is not found');
			case 1001:	NETWORK_ERROR('Invalid protocol');
			case 1003:  UNKNOWN_ERROR('Play list is empty');
			case 1004:  UNSUPPORTED_FORMAT('Unrecognized play list');
			case 1005:  UNSUPPORTED_FORMAT('Invalid ASX format');
			case 1006:  NETWORK_ERROR('Error in downloading play list');
			case 1007:  DECODE_ERROR('Out of memory');
			case 1008:  UNSUPPORTED_FORMAT('Invalid URL list format');
			case 1009:  UNSUPPORTED_FORMAT('Not playable in play list');
			case 1101:  PLAYBACK_ABORTED('Incorrect license in local license store');
			case 1102:  PLAYBACK_ABORTED('Fail in receiving correct license from server');
			case 1103:  PLAYBACK_ABORTED('Stored license is expired');
			default:    UNKNOWN_ERROR(Std.string(player.error));
		}

		failure(error);
	}

	function onPlayStateChange():Void 
	{
		switch (player.playState)
		{
			case 0: trace('stopped');
			case 1:
				if (!metadataLoaded) 
					metadataAvailable();
				trace('playing');
			case 2: trace('paused');
			case 3: trace('connecting');
			case 4: trace('buffering');
			case 5:
				playbackComplete();
				trace('finished');
			case 6: trace('error');
		}
	}

	//-------------------------------------------------------------------------- API implementation

	override function startVideo()
	{
//		source = "http://d26xz6ai9viud1.cloudfront.net/big_buck_bunny-1280x720-h264.mp4";
		player.data = source;
		player.play(1.0);
	}

	override function playVideo()
	{
		player.play(1.0);
	}

	override function pauseVideo()
	{
		player.play(0.0);
	}

	override function stopVideo()
	{
		player.stop();
		player.data = null;
	}

	override function seekVideo(timeSec:Float)
	{
		var timeMsec = Math.round(timeSec * 1000);
		// Tried checking player.isScannable first but it appears not to always be set
		player.seek(timeMsec);
	}

	override function updateBufferProgress()
	{
		bufferProgress = changeValue('bufferProgress', player.bufferingProgress);
	}

	function metadataAvailable()
	{
		duration = changeValue('duration', player.playTime / 1000);
		metadataLoaded = changeValue('metadataLoaded', true);
	}

	override function updateState()
	{
		super.updateState();
		currentTime = changeValue('currentTime', player.playPosition / 1000);
	}

	// NOTE(mike): This logic should work fine (does on Samsung for example) but on LG
	//             it seems that setting playback speed is not stable, especially when streaming (HLS, Smooth Streaming).
	//             The result is freezing of the app for a number of seconds or more.
	override function set_playbackRate(value:Int):Int
	{
		if (value != playbackRate && playbackState != STOPPED)
		{
			if (value == 0 || value == 1)
			{
				value = 1;
				player.play(1);

				if (playbackState == PAUSED)
					pauseVideo();
				else
					playVideo();

				stateChanged.dispatch(SEEKING_STOPPED);
			}
			else
			{
				// TODO(mike): for now we don't set seeking = true as has side effects we don't want. Look at fixing this.
				if (playbackRate == 1)
					stateChanged.dispatch(SEEKING_STARTED);
				
				player.play(value);
			}
			playbackRate = changeValue("playbackRate", value);
		}
		return playbackRate;
	}

	override function processPlaybackRate()
	{}
}

private extern class MediaPlayerType
{
	inline public static var WINDOWS_MEDIA_VIDEO = 'video/x-ms-wmv';
	inline public static var WINDOWS_MEDIA_AUDIO = 'video/x-ms-wma';
	inline public static var NETCAST_AV = 'application/x-netcast-av';
}

typedef MediaPlayer =
{
	var error(default, null):Int;
	var playState(default, null):Int;
	var playPosition(default, null):Int;
	var playTime(default, null):Int;
	var isScannable(default, null):Bool;
	var speed(default, null):Float;
	var bufferingProgress(default, null):Float;

	var version:String;
	var type:String;
	var width:Int;
	var height:Int;
	var data:String;
	var autoStart:Bool;
	var subtitleOn:Bool;
	var subtitle:String;
	var mode3D:String;
	var audioLanguage:String;

	function play(speed:Float):Void;
	function stop():Void;
	function next():Void;
	function previous():Void;
	function seek(position:Int):Void;
	function mediaPlayInfo():MediaPlayInfo;

	dynamic function onPlayStateChange():Void;
	dynamic function onBuffering(isStarted:Bool):Void;
	dynamic function onError():Void;
}

typedef MediaPlayInfo =
{
	var duration:Int;
	var currentPosition:Int;
	var bufRemain:Int;
	var bitrateInstant:Int;
	var bitrateTarget:Int;
}
