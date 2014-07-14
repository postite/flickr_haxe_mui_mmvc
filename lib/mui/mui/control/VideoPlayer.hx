package mui.control;

import mui.core.Container;
import mui.display.IVideo;
import mui.display.Video;
import mui.display.Color;
import mui.core.Skin;
import mui.event.Key;
import mui.event.KeyMap;

/**
	A video player widget with video display and controller.
**/
class VideoPlayer extends Container
{
	// TODO: flash seeks to closet keyframe so if they're far apart seek won't move anywhere
	//       look to see if we can monitor this in flash Video class to ensure seeking always progresses.
	//       ms 30.9.11
	static inline var SKIP_RATE:Int = #if flash 12 #else 4 #end;
	static inline var X2_PRESS_COUNT:Int = 8;

	public var video(default, null):Video;
	public var controls(default, null):VideoController;

	public function new(?skin:Skin<Dynamic>)
	{
		super(skin);

		// samsung is like stage video so sits behind everything
		// TODO: Look at abstracting this, perhaps into video capabilities.
		//       e.g. if (video.capabilities.nativeVideo)...
		//       ms 29.9.11
		#if (!samsung && !ps3)
		fill = new Color(0x000000);
		#end

		addChild(cast createVideo());

//      if (!(video.nativeControlsSupported && video.nativeControlsEnabled))
//      {
			controls = new VideoController();
			addComponent(controls);

			#if !touch
			controls.enabled = false;
			#end

			controls.bottom = 30;
			controls.centerX = 0.5;
			controls.video = video;
//      }
		
		scroller.enabled = false;
	}

	function createVideo()
	{
		video = new Video();
		video.all = 0;
		return video;
	}

	#if key
	override public function keyPress(key:Key)
	{
		var keyCaptured = true;

		switch (key.action)
		{
			#if tv
			case OK:
				(video.playbackState == PLAYING) ? video.pause() : video.play();
			#end
			case PLAY:
				video.play();
			case PAUSE:
				video.pause();
			case STOP:
				video.stop();
			#if pc
			case SPACE:
				(video.playbackState == PLAYING) ? video.pause() : video.play();
			case LEFT:
				var playbackRate = (key.pressCount < X2_PRESS_COUNT) ? -SKIP_RATE : -SKIP_RATE * 2;
				video.playbackRate = playbackRate;
			case RIGHT:
				var playbackRate = (key.pressCount < X2_PRESS_COUNT) ? SKIP_RATE : SKIP_RATE * 2;
				video.playbackRate = playbackRate;
			#end
			case FAST_FORWARD:
				var rate:Int = cast Math.max(1, video.playbackRate);
				video.playbackRate = rate * 2;
			case FAST_BACKWARD:
				var rate:Int = cast Math.min(1, video.playbackRate);
				video.playbackRate = cast -Math.abs(rate * 2);
			case VOLUME_UP:
				video.volume += 0.02;
			case VOLUME_DOWN:
				video.volume -= 0.02;
			case VOLUME_MUTE:
				video.muted = !video.muted;
			default:
				keyCaptured = false;
		}

		if (controls != null && controls.hidden)
			controls.show();

		if (keyCaptured)
			key.capture();
		else
			super.keyPress(key);
	}

	override public function keyRelease(key:Key)
	{
		switch (key.action)
		{
			#if pc
			case LEFT, RIGHT:
				video.playbackRate = 1;
			#end
			default:
				null;
		}

		super.keyRelease(key);
	}
	#end
}
