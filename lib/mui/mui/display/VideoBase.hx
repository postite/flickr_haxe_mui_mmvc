package mui.display;

import msignal.Signal;
import mui.display.IVideo;
import haxe.Timer;

/**
	The VideoBase class is the base class for the Video object.
**/
class VideoBase extends Rectangle implements IVideo
{
	public var stateChanged(default, null):Signal1<VideoStateChange>;
	public var failed(default, null):Signal1<VideoError>;
	public var playbackState(default, null):VideoPlaybackState;
	public var bufferState(default, null):VideoBufferState;
	public var duration(default, null):Float;
	public var currentTime(default, null):Float;
	public var videoWidth(default, null):Int;
	public var videoHeight(default, null):Int;
	public var bufferProgress(default, null):Float;
	public var metadataLoaded(default, null):Bool;

	/**
		The maximum amount of time the video can run for.
	**/
	public var maxSeekTime(get_maxSeekTime, null):Float;
	function get_maxSeekTime():Float
	{
		return (connection == PROGRESSIVE) ? bufferProgress * duration : duration;
	}

	public var source(default, set_source):String;
	function set_source(value:String):String
	{
		return source = changeValue("source", value);
	}

	public var autoPlay(default, set_autoPlay):Bool;
	function set_autoPlay(value:Bool):Bool
	{
		return autoPlay = changeValue("autoPlay", value);
	}

	public var loop(default, set_loop):Bool;
	function set_loop(value:Bool):Bool
	{
		return loop = changeValue("loop", value);
	}

	public var playbackRate(default, set_playbackRate):Int;
	function set_playbackRate(value:Int):Int
	{
		if (value != playbackRate)
		{
			seeking = (value != 1); // enable manual seeking while scrubbing to avoid seek>play loop
			playbackRate = changeValue("playbackRate", value);
			processPlaybackRate(); // ensure to process at least one update in case invalidation prevents it
		}
		return playbackRate;
	}

	public var muted(default, set_muted):Bool;
	function set_muted(value:Bool):Bool
	{
		return muted = changeValue("muted", value);
	}

	public var volume(default, set_volume):Float;
	function set_volume(value:Float):Float
	{
		return volume = changeValue("volume", Math.max(0, Math.min(1, value)));
	}

	public var fullScreen(default, set_fullScreen):Null<Bool>;
	function set_fullScreen(value:Null<Bool>):Null<Bool>
	{
		if (value != null && fullScreen != value)
			fullScreen = changeValue("fullScreen", requestFullScreen(value));
		
		return fullScreen;
	}

	public var seeking(default, set_seeking):Bool;
	function set_seeking(value:Bool):Bool
	{
		if (value != seeking)
		{
			if (value && seekType == None)
				seekType = Manual;
			else if (!value && (seekType == Manual || seekType == Automatic))
				seekType = None;

			seeking = changeValue("seeking", value);
		}
		return seeking;
	}

	public var connection(default, set_connection):VideoConnectionType;
	function set_connection(value:VideoConnectionType):VideoConnectionType
	{
		return connection = changeValue("connection", value);
	}

	public var refreshRate(default, set_refreshRate):Int;
	function set_refreshRate(value:Int):Int
	{
		refreshRate = value;

		if (playbackState == PLAYING)
		{
			updateTimer.stop();
			startMonitor();
		}

		return refreshRate;
	}

	var restartVideo(default, set_restartVideo):Bool;
	function set_restartVideo(value:Bool):Bool
	{
		return restartVideo = changeValue("restartVideo", value);
	}

	// The duration minus this value is what marks the end of the video.
	// This is needed as duration that comes back in metadata can be a little off.
	static var END_TIME_TOLERANCE_SECS = 1;

	public var updateTimer:Timer;
	var supportsNativeFFRWD:Bool;
	var seekType:SeekType;
	var lastVolumeLevel:Float;
	var pendingSeekTime:Float; // waiting for duration info before seeking
	var lastPlaybackRateUpdateTime:Float;
	var playbackRateTimer:Timer;
	var seekToEndForcesCompleteEvent:Bool;

	function new()
	{
		super();

		stateChanged = new Signal1<VideoStateChange>(VideoStateChange);
		failed = new Signal1<VideoError>(VideoError);
		seekType = None;

		// state
		reset();

		// control
		source = null;
		seeking = false;
		loop = false;
		playbackRate = 1;
		muted = false;
		fullScreen = null;
		volume = 1.0;
		pendingSeekTime = -1.0;
		lastVolumeLevel = volume;
		autoPlay = false;
		connection = PROGRESSIVE;
		refreshRate = 100;
		lastPlaybackRateUpdateTime = 0;
		seekToEndForcesCompleteEvent = true;
		supportsNativeFFRWD = false;
	}

	function reset()
	{
		bufferState = changeValue("bufferState", EMPTY);
		duration = changeValue("duration", 0.0);
		videoWidth = changeValue("videoWidth", 0);
		videoHeight = changeValue("videoHeight", 0);
		bufferProgress = changeValue("bufferProgress", 0.0);
		metadataLoaded = changeValue("metadataLoaded", false);
		currentTime = changeValue("currentTime", 0.0);
		playbackState = changeValue("playbackState", STOPPED);
		validate();
	}

	public function play()
	{
		if (!hasSource())
			return;

		playbackRate = 1;

		if (playbackState == STOPPED)
		{
			restartVideo = true; // need to invalidate this incase source has been set in same frame
		}
		else
		{
			// if we're at the end of the video then rewind to start and play from there
			if (duration > 0 && Math.ceil(currentTime) >= duration - END_TIME_TOLERANCE_SECS)
				replayVideo();
			else
				playVideo();
		}

		playbackState = changeValue("playbackState", PLAYING);
	}

	function startVideo()
	{
		// abstract
	}

	function replayVideo()
	{
		seek(0);
		playVideo();
	}

	function playVideo()
	{
		// abstract
	}

	public function pause()
	{
		playbackRate = 1;

		if (playbackState == PAUSED)
			return;

		pauseVideo();
		playbackState = changeValue("playbackState", PAUSED);
	}

	function pauseVideo()
	{
		// abstract
	}

	public function stop()
	{
		if (playbackState == STOPPED)
			return;

		stopVideo();
		metadataLoaded = changeValue("metadataLoaded", false);
		playbackState = changeValue("playbackState", STOPPED);
		currentTime = changeValue("currentTime", 0);
		playbackRate = 1;
		stopMonitor();
	}

	function stopVideo()
	{
		// abstract
	}

	public function seek(timeSecs:Float)
	{
		if (Math.isNaN(timeSecs))
			return;

		if (!metadataLoaded) // waiting for metadata to load with duration info
		{
			pendingSeekTime = timeSecs;
			return;
		}

		pendingSeekTime = -1.0;
		timeSecs = normalizeSeekTime(timeSecs);

		if (timeSecs == Math.round(currentTime))
			return;

		if (timeSecs == 0 && playbackRate < 1)
			playbackRate = 1;

		if (seekType == None)
			seekType = Automatic;

		seeking = true;
		updateSeekingPlaybackState();
		seekVideo(timeSecs);
	}
	
	// Some players need to be paused to seek, others need to be playing.
	function updateSeekingPlaybackState()
	{
		// recommended to pause during seeking to avoid audio blips
		// call pause directly so as not to change playbackState
		seeking ? pauseVideo() : playVideo();
	}

	function normalizeSeekTime(timeSecs:Float):Float
	{
		var timeSecs = Math.max(0, Math.min(maxSeekTime, timeSecs));
		timeSecs = Math.floor(timeSecs);
		return timeSecs;
	}

	function seekVideo(timeSecs:Float)
	{
		// abstract
	}

	function updateVolume(level:Float)
	{
		// abstract
	}

	function updateMuted(muted:Bool)
	{
		volume = muted ? 0 : lastVolumeLevel;
	}

	/**
		Called immedately to avoid sandbox restrictions (triggered by user input) 
		@returns true if successful
	**/
	function requestFullScreen(fullScreen:Bool):Bool
	{
		return false;
	}

	/**
		Called during validation to update internal fullscreen state
	**/
	function updateFullScreen(fullScreen:Bool)
	{
		// abstract		
	}

	function updateBufferProgress()
	{
	}
	
	function updateStreamingBufferProgress()
	{
		bufferProgress = changeValue("bufferProgress", 1);
	}

	override function change(flag:Dynamic)
	{
		super.change(flag);

		if (flag.source || (flag.restartVideo && restartVideo))
		{
			if (hasSource())
			{
				metadataLoaded = changeValue("metadataLoaded", false);
				startMonitor();
				startVideo();
				(autoPlay || playbackState == PLAYING) ? play() : pause();
				restartVideo = changeValue("restartVideo", false);
			}
			else
			{
				stop();
			}
		}

		if (flag.bufferState)
		{
			var value = (bufferState == EMPTY) ? BUFFER_EMPTY : BUFFER_FULL;
			stateChange(value);

			if (bufferState == FULL && playbackState == PLAYING)
				stateChange(PLAYBACK_STARTED);
		}

		if (flag.seeking)
		{
			stateChange(seeking ? SEEKING_STARTED : SEEKING_STOPPED);

			if (playbackState == PLAYING)
			{
				updateSeekingPlaybackState();
			}

			// This was causing a double PLAYBACK_COMPLETE event when seeking to the end
			// of a video on Samsung. Leaving here in case it's needed for other targets.
			// If that is the case we'll need an option to disable it in concrete video classes.
			if (seekToEndForcesCompleteEvent && !seeking && duration > 0 && currentTime >= (duration - END_TIME_TOLERANCE_SECS))
			{
				playbackComplete();
			}
		}

		if (flag.metadataLoaded && metadataLoaded)
		{
			stateChange(METADATA_LOADED);

			if (pendingSeekTime > 0)
			{
				seek(pendingSeekTime);
			}
		}

		if (flag.playbackState)
		{
			var value = switch (playbackState)
			{
				case PLAYING:
					if (bufferState == FULL) PLAYBACK_STARTED;
					else null;
				case PAUSED: PLAYBACK_PAUSED;
				case STOPPED: PLAYBACK_STOPPED;
			}
			if (value != null)
				stateChange(value);
		}

		if (flag.playbackRate && !supportsNativeFFRWD)
		{
			if (playbackRate == 1)
			{
				if (playbackRateTimer != null)
				{
					playbackRateTimer.stop();
					playbackRateTimer = null;
				}
			}
			else if (playbackRateTimer == null)
			{
				// Note that we run the update every 1/2 second. This helps
				// to keep playhead moving reasonably quickly while scrubbing
				playbackRateTimer = new Timer(500);
				playbackRateTimer.run = processPlaybackRate;
			}
		}

		if (flag.currentTime)
		{
			if (playbackRate > 1)
				checkPlaybackComplete(currentTime);
		}

		if (flag.volume)
		{
			if (volume != 0)
			{
				lastVolumeLevel = volume;

				if (muted)
					muted = false;
			}
			else if (!muted)
			{
				muted = true;
			}

			updateVolume(volume);
			stateChange(VOLUME_CHANGED);
		}

		if (flag.muted)
		{
			updateMuted(muted);
			stateChange(muted ? MUTE_ON : MUTE_OFF);
		}

		if (flag.fullScreen)
		{
			updateFullScreen(fullScreen);
			stateChange(fullScreen ? FULLSCREEN_ENTERED : FULLSCREEN_EXITED);
		}
	}

	function startMonitor()
	{
		if (refreshRate > 0 && refreshRate < 100) refreshRate = 100;

		updateTimer = new Timer(refreshRate);
		updateTimer.run = updateState;
		
		// If refresh rate is set to zero, no function is assigned to run as on 
		// ios devices, this causes a js execution timeout.
		if (refreshRate == 0) updateTimer.stop();
	}

	function updateState()
	{
		if (bufferProgress < 1)
		{
			if (connection == PROGRESSIVE)
				updateBufferProgress();
			else if (connection == STREAMING)
				updateStreamingBufferProgress();
		}

		if (seeking && seekType == Automatic)
			seeking = false;
	}

	function processPlaybackRate()
	{
		// This updates every 1/2 second so we should really add 
		// (playbackRate/2) but adding the full playbackRate feels more 
		// accurate when used.
		seek(currentTime + playbackRate);
	}

	function stopMonitor()
	{
		updateTimer.stop();
	}
	
	function checkPlaybackComplete(time:Float)
	{	
		if (duration > 0 && time >= duration - END_TIME_TOLERANCE_SECS)
		{
			playbackComplete();
		}
	}

	function playbackComplete()
	{
		// only ignore if seeking and it's not due to scrubbing, this is because
		// the user may be dragging the playhead around and may drag it to the end
		// of the video and then back in. If we didn't ignore this then
		// side effects like showing post roll ads could be triggered.
		if ((seeking && playbackRate == 1))
			return;

		playbackRate = 1;
		stateChange(PLAYBACK_COMPLETED);

		if (duration > 0)
			currentTime = changeValue("currentTime", duration);

		loop ? play() : pause();
	}

	function stateChange(state:VideoStateChange)
	{
		stateChanged.dispatch(state);
	}

	function failure(error:VideoError)
	{
		failed.dispatch(error);
		stopMonitor();
	}

	function hasSource():Bool
	{
		return source != null && source != "";
	}
}

/**
	The type of seek behavior to use.
**/
enum SeekType
{
	/**
		Start/end of seek controlled internally.
	**/
	Automatic;

	/**
		Start/end of seek controlled externally.
	**/
	Manual;

	/**
		Default value.
	**/
	None;
}
