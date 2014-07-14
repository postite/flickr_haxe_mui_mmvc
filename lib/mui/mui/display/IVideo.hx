package mui.display;

import haxe.Timer;
import msignal.Signal;
import mui.core.Node;

/**
	The core video interface, defining required properties and methods of a 
	video display.

	Defines the properties and methods required by the framework to interact 
	with a video stream, including state, errors and behavior.
**/
interface IVideo extends Changeable
{
	/**
		The state of the playback.
	**/
	var playbackState(default, null):VideoPlaybackState;

	/**
		The state of the buffer.
	**/
	var bufferState(default, null):VideoBufferState;

	/**
		The amount of buffer currently loaded.
	**/
	var bufferProgress(default, null):Float;

	/**
		The amount of time a video has been playing for.
	**/
	var currentTime(default, null):Float;

	/**
		The duration of the video, in seconds.
	**/
	var duration(default, null):Float;

	/**
		The width of the video.
	**/
	var videoWidth(default, null):Int;

	/**
		The height of the video.
	**/
	var videoHeight(default, null):Int;

	/**
		Indicates whether or not metadata is attached to the video.
	**/
	var metadataLoaded(default, null):Bool;

	/**
		A url representing the path to the video.
	**/
	var source(default, set_source):String;

	/**
		The seeking state of the video stream.
	**/
	var seeking(default, set_seeking):Bool;

	/**
		Indicates whether to initially auto play the video.
	**/
	var autoPlay(default, set_autoPlay):Bool;

	/**
		Indicates whether to loop the video once finished.
	**/
	var loop(default, set_loop):Bool;

	/**
		The current playback rate, used for fast/slow play forward/back.
	**/
	var playbackRate(default, set_playbackRate):Int;

	/**
		The current volume of the video's audio.
	**/
	var volume(default, set_volume):Float;

	/**
		The muted state of the video's audio.
	**/
	var muted(default, set_muted):Bool;

	/**
		Toggles fullscreen playback
	**/
	var fullScreen(default, set_fullScreen):Null<Bool>;

	/**
		The type of stream to play.
	**/
	var connection(default, set_connection):VideoConnectionType;

	/**
		The rate at which to poll the stream for it's state.
	**/
	var refreshRate(default, set_refreshRate):Int;
	
	/**
		Signifies the state of the video has changed.
	**/
	var stateChanged(default, null):Signal1<VideoStateChange>;

	/**
		Signifies the video has errored.
	**/
	var failed(default, null):Signal1<VideoError>;
	
	/**
		Resumes playback of the video.
	**/
	function play():Void;

	/**
		Pauses playback of the video.
	**/
	function pause():Void;

	/**
		Stops playback of the video.
	**/
	function stop():Void;

	/**
		Seeks to the provided time in the video stream.

		If this method is called without manually setting seeking = true then 
		responsibility remains with the Video class to dispatch SEEKING_STARTED 
		and SEEKING_COMPLETED events.
		
		If seeking = true is set externally before this method is called then 
		it is assumed seeking state is being controlled manually and so no 
		SEEKING_COMPLETED event will be fired until seeking = false is set by 
		the controlling class.
		
		Manual control over seeking state is needed for situations like when a 
		user is dragging the playhead around for an indeterminate amount of 
		time, which may include holding in one spot for a period of time.
	**/
	function seek(time:Float):Void;
}

/**
	Enumerated values of `IVideo.stateChanged`.
**/
enum VideoStateChange
{
	// only broadcast when in PLAYING playbackState and buffer is full
	PLAYBACK_STARTED;
	PLAYBACK_STOPPED;
	PLAYBACK_PAUSED;
	PLAYBACK_COMPLETED;
	BUFFER_EMPTY;
	BUFFER_FULL;
	SEEKING_STARTED;
	SEEKING_STOPPED;
	VOLUME_CHANGED;
	MUTE_ON;
	MUTE_OFF;
	METADATA_LOADED;
	FULLSCREEN_ENTERED;
	FULLSCREEN_EXITED;
}

/**
	Enumerated values of `IVideo.failed`.
**/
enum VideoError
{
	UNSUPPORTED_FORMAT(?info:String);
	PLAYBACK_ABORTED(?info:String);
	NETWORK_ERROR(?info:String);
	DECODE_ERROR(?info:String);
	UNKNOWN_ERROR(info:String);
}

/**
	Enumerated values of `IVideo.playbackState`.
**/
enum VideoPlaybackState
{
	PLAYING;
	PAUSED;
	STOPPED;
}

/**
	Enumerated values of `IVideo.connection`.
**/
enum VideoConnectionType
{
	PROGRESSIVE;
	STREAMING;
}

/**
	Enumerated values of `IVideo.bufferState`.
**/
enum VideoBufferState
{
	FULL;
	EMPTY;
}
