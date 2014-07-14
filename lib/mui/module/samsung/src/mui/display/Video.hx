package mui.display;

import js.Lib;
import mui.display.IVideo;
import mui.display.VideoBase;
import mui.module.samsung.Device;
import mui.module.samsung.Player;
import mui.module.samsung.Audio;

/**
	Notes:

	- Seeking using the native video api (JumpBack/Forward or SetPlaybackSpeed) 
	causes a lot of processing which drains performance for ui controls. In 
	order to keep the ui responsive, seeking updates currentTime until seeking 
	ends, at which point the native seek is performed. While this means video 
	frames are not updated during seeking the performance benefits appear 
	worth it.

	- Previously the above applied to fast forward and rewind too, but this now 
	uses the native video's SetPlaybackSpeed api.
**/
class Video extends VideoBase
{
	/**
		Set to true to enable DRM. Default is false. Note only WMDRM is 
		supported currently. Must set this before setting the source of your 
		video. Currently this is Samsung specific so you'll need to use 
		"samsung" compiler conditionals around its use.
	**/
	public var drm:Bool;

	/**
		Before we can seek or pause or the video we must wait for 3 
		onCurrentTimeUpdate events. On the thrid one we are then able to 
		control the video.
		See bug https://jira.massiveinteractive.com/browse/MUI-600
	**/
	static var REQUIRED_STARTUP_TICKS:Int = 4;

	static inline var NO_STORED_TIME = -1.0;

	// Hack to get scoping correct in event handlers
	static var videos:Dynamic = {};
	static var guid:Int = 0;

	var id:String;
	var video:Player;
	var audio:Audio;
	var storedTime:Float;
	var committingSeek:Bool;
	var startingUp:Bool;
	var startupTickCount:Int;
	var committingSeekCheckCount:Int;
	var audioEnabled:Bool;

	public function new()
	{
		super();

		id = "video" + (guid++);
		Reflect.setField(videos, id, this);
		storedTime = -1.0;
		startupTickCount = 0;
		committingSeekCheckCount = 0;
		committingSeek = false;
		audioEnabled = false;
		drm = false;
		seekToEndForcesCompleteEvent = false;
		
		// progressive not supported by looks of it so set to streaming
		// i.e. you can seek anywhere.
		connection = STREAMING;

		// mark buffer as full so can seek anywhere (no progressive in samsung).
		bufferProgress = changeValue("bufferProgress", 1);
		video = Device.getPlayer();
		
		var qualifiedPath = 'mui.display.Video.videos.' + id + '.';

		// State handlers
		video.OnStreamInfoReady = qualifiedPath + 'onMetadata';
		video.OnBufferingStart = qualifiedPath + 'onBufferEmpty';
		//video.OnBufferingProgress = ;
		video.OnBufferingComplete = qualifiedPath + 'onBufferFull';
		video.OnCurrentPlayTime = qualifiedPath + 'onCurrentTimeUpdate';
		video.OnRenderingComplete = qualifiedPath + 'onPlaybackComplete';

		// Error handlers
		video.OnNetworkDisconnected = qualifiedPath + 'onNetworkDiconnected';
		video.OnStreamNotFound = qualifiedPath + 'onStreamNotFound';
		video.OnConnectionFailed = qualifiedPath + 'onConnectionFailed';
		video.OnRenderError = qualifiedPath + 'onRenderError';
		video.OnAuthenticationFailed = qualifiedPath + 'onAuthenticationFailed';
	}

	public function enableAudio()
	{
		if (audioEnabled) return;
		audio = Device.getAudio();
		volume = audio.GetVolume() / 100;
		muted = (audio.GetUserMute() != 0);
		audioEnabled = true;
	}

	public static function destroyInstances()
	{
		for (videoId in Reflect.fields(videos))
		{
			var video = Reflect.field(videos, videoId);
			video.destroy();
		}
	}

	override public function destroy()
	{
		Reflect.deleteField(videos, id);
		video.style.display = "none";
		stopVideo();
		video = null;
		audio = null;
	}

	override function startVideo()
	{
		startingUp = true;
		startupTickCount = 0;

		if (drm)
		{
			video.InitPlayer(source + "|COMPONENT=WMDRM");
			configureDRM(video);
			updateBounds(true);

			if (pendingSeekTime > 0)
			{
				// undocumented, but can seem to pass through resume point
				video.StartPlayback(pendingSeekTime);
				resetPendingSeekTime();
			}
			else
			{
				video.StartPlayback();
			}
		}
		else
		{
			if (pendingSeekTime > 0)
			{
				video.ResumePlay(source, pendingSeekTime);
				resetPendingSeekTime();
			}
			else
			{
				video.Play(source);
			}
		}
	}

	/**
		Called when DRM is enabled just after the video is initialised, but 
		before it is started. Should be used to set cookies or license server.

		For example:
		
		nativeVideo.SetPlayerProperty(1, cookie, cookie.length);
		nativeVideo.SetPlayerProperty(4, licenseServerURI, licenseServerURI.length);
	**/
	public dynamic function configureDRM(nativeVideo:Dynamic) {}

	function resetPendingSeekTime()
	{
		currentTime = changeValue("currentTime", pendingSeekTime);
		seekType = SeekType.Automatic;
		seeking = true;
		committingSeek = true;
		pendingSeekTime = NO_STORED_TIME;
	}

	override function playVideo()
	{
		// calling resume while seeking can cause JumpForward/Back to not work 
		// so we call this again after seeking
		if (!seeking) video.Resume();
	}

	override function pauseVideo()
	{
		video.Pause();
	}

	override function stopVideo()
	{
		storedTime = NO_STORED_TIME;
		video.Stop();
	}

	override function seekVideo(timeSecs:Float)
	{
		// Seek just updates current time until seeking ends. At that point 
		// commitSeek() is called. See class prologue for details.
		if (storedTime == NO_STORED_TIME)
			storedTime = currentTime;

		currentTime = changeValue("currentTime", timeSecs);
	}

	function commitSeek()
	{
		// will jump to closest keyframe to currentTime.
		var offset = (storedTime - currentTime);

		if (offset < 0) video.JumpForward(Math.abs(offset));
		else if (offset > 0) video.JumpBackward(offset);

		storedTime = NO_STORED_TIME;

		if (offset != 0) committingSeek = true;
	}

	override function updateVolume(level:Float)
	{
		if (!audioEnabled) return;

		// update volume to 0 when muted but no point setting device volume
		// (plus it's slow)
		if (!muted) 
		{
			var targetVolume = Math.min(100, Math.round(level * 100));
			var key = targetVolume < audio.GetVolume() ? 1 : 0;
			var count = 100; // safeguard

			while (audio.GetVolume() != targetVolume && count-- > 0)
				audio.SetVolumeWithKey(key);
		}
	}

	override function updateMuted(muted:Bool)
	{
		if (!audioEnabled) return;
		super.updateMuted(muted);
		audio.SetUserMute(muted);
	}

	override function change(flag:Dynamic)
	{
		super.change(flag);

		if (flag.seeking && !seeking && !startingUp)
			commitSeek();

		if (flag.playbackState && video != null)
			video.style.display = (playbackState == STOPPED) ? "hidden" : "block";

		if (flag.x || flag.y || flag.width || flag.height || flag.videoWidth || flag.videoHeight)
			updateBounds();
	}

	function updateBounds(?force:Bool = false)
	{
		// we can't set the size of the video until after we've called 
		// InitPlayer and we only use InitPlayer when DRM is enabled as we have 
		// to call SetPlayerProperty which can only be used with InitPlayer
		if (drm && !force) return;

		// Our native video object sits outside of our display list behind 
		// everything. This mui Video display object encapsulates it, so when 
		// the mui video size or position is changed we update the native video 
		// to reflect this (i.e. it always sits directly under this video 
		// display object).
		video.SetDisplayArea(rootX, rootY, width, height);
	}

	// Event handlers

	function onMetadata()
	{
		duration = changeValue("duration", video.GetDuration() / 1000);
		videoWidth = changeValue("videoWidth", video.GetVideoWidth());
		videoHeight = changeValue("videoHeight", video.GetVideoHeight());
		metadataLoaded = changeValue("metadataLoaded", true);
	}

	function onBufferEmpty()
	{
		bufferState = changeValue("bufferState", EMPTY);
		// when buffer is empty and have seeked then assume new seek point is 
		// now buffering
		committingSeek = false;
		committingSeekCheckCount = 0;
	}

	function onBufferFull()
	{
		bufferState = changeValue("bufferState", FULL);

		// ensure playback state is committed again when buffer is full as 
		// changes can be ignored by samsung player unless buffer is full.
		commitPlaybackState();
	}

	function commitPlaybackState()
	{
		switch (playbackState)
		{
			case PLAYING: playVideo();
			case PAUSED: pauseVideo();
			case STOPPED: stopVideo();
		}
	}

	function onCurrentTimeUpdate(time:Int)
	{
		// still get one tick after we call video.Stop(), but of course!
		if (playbackState == STOPPED) return;

		// until we've had 4 ticks the player won't respond to commands
		if (startingUp && (++startupTickCount >= REQUIRED_STARTUP_TICKS))
			onPlayerReady();

		// On the rare occasion that seek occurs with no buffer empty->full 
		// events then check time update and after two ticks set it back to 
		// false and assume seek has been committed.
		if (committingSeek && committingSeekCheckCount++ > 2)
		{
			committingSeek = false;
			committingSeekCheckCount = 0;
		}

		if (!seeking && !startingUp && !committingSeek && bufferState == FULL && !(playbackState == PAUSED && currentTime == duration))
		{
			if (storedTime != NO_STORED_TIME)
				storedTime = time / 1000;
			else
				currentTime = changeValue("currentTime", time / 1000);

			committingSeekCheckCount = 0;
		}
	}

	function onPlayerReady()
	{
		startupTickCount = 0;
		startingUp = false;

		commitPlaybackState();

		if (storedTime != NO_STORED_TIME)
			commitSeek();
	}

	function onPlaybackComplete()
	{
		if (storedTime != NO_STORED_TIME)
			commitSeek();

		playbackComplete();
	}

	function onRenderError(type:Int)
	{
		var error = null;
		if (type == 1) error = UNSUPPORTED_FORMAT("Unsupported container");
		else if (type == 2) error = UNSUPPORTED_FORMAT("Unsupported video codec");
		else if (type == 3) error = UNSUPPORTED_FORMAT("Unsupported audio codec");
		else if (type == 4) error = UNSUPPORTED_FORMAT("Unsupported video resolution");
		
		failure(error);
	}

	function onNetworkDiconnected()
	{
		onNetworkError("Network disconnected");
	}

	function onStreamNotFound()
	{
		onNetworkError("Stream not found");
	}

	function onConnectionFailed()
	{
		onNetworkError("Could not connect to server");
	}

	function onAuthenticationFailed()
	{
		onNetworkError("Could not authenticate with license server");
	}

	function onNetworkError(type:String)
	{
		stop();
		failure(NETWORK_ERROR(type));
	}

	override function set_playbackRate(value:Int):Int
	{
		if (value != playbackRate && playbackState != STOPPED)
		{
			if (value == 0 || value == 1)
			{
				value = 1;
				video.SetPlaybackSpeed(1);

				if (playbackState == PAUSED)
					pauseVideo();
				else
					playVideo();

				stateChanged.dispatch(SEEKING_STOPPED);
			}
			else
			{
				// TODO(mike): for now we don't set seeking = true as has side 
				// effects we don't want. Look at fixing this.
				if (playbackRate == 1) stateChanged.dispatch(SEEKING_STARTED);

				// Samsung require that we be playing video before we can 
				// adjust the speed
				if (playbackState == PAUSED) playVideo();

				// has to be a multiple of 2
				while (value % 2 != 0) value > 0 ? value++ : value--;

				video.SetPlaybackSpeed(value);
			}
			playbackRate = changeValue("playbackRate", value);
		}
		return playbackRate;
	}

	override function processPlaybackRate() {}
}
