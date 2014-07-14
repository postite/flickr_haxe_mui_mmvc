package mui.control;

import haxe.Timer;
import msignal.Signal;
import mui.util.Dispatcher;
import mui.transition.Tween;
import mui.control.Button;
import mui.core.Component;
import mui.core.Skin;
import mui.core.Container;
import mui.display.Rectangle;
import mui.display.Color;
import mui.display.GradientColor;
import mui.display.Gradient;
import mui.display.Shape;
import mui.display.IVideo;
import mui.input.RangeInput;
import mui.input.RangeInputSkin;
import mui.behavior.DragBehavior;
import mui.event.Touch;

/**
	A video controller widget with progress bar and control buttons.
**/
class VideoController extends Container
{
	public static inline var HIDE_DELAY_MSECS:Int = 2000;

	public var hidden(default, set_hidden):Bool;
	function set_hidden(value:Bool):Bool { return hidden = changeValue("hidden", value); }

	var playButton:Button;
	var pauseButton:Button;
	var progressBar:VideoProgressBar;
	var volumeBar:RangeInput;
	var hideTimer:Timer;

	public function new()
	{
		super();

		radius = 8;
		height = 50;
		fill = new Gradient([new GradientColor(0x52504f, 1, 0.01), new GradientColor(0x2b2b2b, 1, 0.02), new GradientColor(0x0d0b0a, 1, 0.49)], 90);

		#if (iphone || iphone4)
		left = 20;
		right = 20;
		width = 240;
		#else
		width = 500;
		#end

		#if js
		// fix for bug: https://jira.massiveinteractive.com/browse/MUI-562
		components.element.style.zIndex = "0";
		#end

		playButton = new Button();
		addComponent(playButton);

		playButton.skin = new VideoControllerButtonSkin();
		playButton.data = {icon:"play"};

		playButton.width = 30;
		playButton.height = 30;
		playButton.left = 18;
		playButton.centerY = 0.55;
		playButton.actioned.add(playActioned);

		pauseButton = new Button();
		addComponent(pauseButton);

		pauseButton.skin = new VideoControllerButtonSkin();
		pauseButton.data = {icon:"pause"};

		pauseButton.width = 30;
		pauseButton.height = 30;
		pauseButton.left = 18;
		pauseButton.centerY = 0.55;
		pauseButton.visible = false;
		pauseButton.actioned.add(pauseActioned);

		progressBar = new VideoProgressBar();
		addComponent(progressBar);

		progressBar.left = 65;
		progressBar.right = 100;
		progressBar.centerY = 0.55;
		progressBar.height = 10;

		volumeBar = new RangeInput(new VolumeBarSkin());
		addComponent(volumeBar);

		volumeBar.right = 22;
		volumeBar.centerY = 0.55;
		volumeBar.height = 10;
		volumeBar.width = 60;
		volumeBar.minimum = 0;
		volumeBar.maximum = 1;
		
		scroller.enabled = false;
	}

	public var video(default, set_video):IVideo;
	function set_video(value:IVideo):IVideo
	{
		if (video != null)
		{
			#if touch
			mui.Lib.mouseMoved.remove(onShow);
			#end
			video.stateChanged.remove(videoStateChanged);
			video.changed.remove(videoChange);
			progressBar.changed.remove(progressChange);
			volumeBar.changed.remove(volumeChange);
		}

		video = value;

		if (video != null)
		{
			#if touch
			mui.Lib.mouseMoved.add(onShow);
			#end
			video.stateChanged.add(videoStateChanged);
			video.changed.add(videoChange);
			progressBar.changed.add(progressChange);
			volumeBar.changed.add(volumeChange);
			volumeBar.data = video.volume;

			if (video.connection == STREAMING)
				progressBar.sliderRangeEnabled = false; // can seek anywhere

			updateState();
		}

		return video;
	}

	function onShow()
	{
		if (hidden)
			show();
	}

	public function show(?autoHide:Bool = true)
	{
		hidden = false;
		visible = true;
		new Tween(this, {alpha:1}, {frames:1});

		if (autoHide)
			hideTimer = Timer.delay(hide, HIDE_DELAY_MSECS);
		else if (hideTimer != null)
			hideTimer.stop();
	}
	
	function hideComplete()
	{
		visible = false;
	}

	public function hide()
	{
		var hide = true;

		#if touch
		// only hide if cursor is not over controls
		hide = (!(mouseX >= 0 && mouseX <= width && mouseY >= 0 && mouseY <= height));
		#end

		hide = hide && video.bufferState == FULL;

		if (hide)
		{
			hidden = true;
			new Tween(this, {alpha:0}, {onComplete:hideComplete});
		}
		else
		{
			show(video.playbackState != PLAYING);
		}
	}

	function playActioned()
	{
		video.play();
	}

	function pauseActioned()
	{
		video.pause();
	}

	function videoChange(flag:Dynamic)
	{
		if (flag.playbackState)
		{
			updateState();
		}

		if (flag.duration)
		{
			progressBar.maximum = video.duration;
		}

		if (flag.bufferProgress || flag.duration)
		{
			progressBar.maximumSliderPosition = video.bufferProgress * video.duration;
		}

		if (flag.currentTime && !progressBar.sliderDown)
		{
			progressBar.data = video.currentTime;
		}

		if(flag.volume)
		{
			volumeBar.data = video.volume;
		}
	}

	function videoStateChanged(event:VideoStateChange)
	{
		if (event == BUFFER_EMPTY || event == BUFFER_FULL || event == METADATA_LOADED)
			return;

		var autoHide = switch(event)
		{
			case PLAYBACK_COMPLETED, SEEKING_STARTED, PLAYBACK_STOPPED, PLAYBACK_PAUSED:
				false;
			default:
				video.playbackState == PLAYING;
		}

		show(autoHide);
	}

	function updateState()
	{
		switch (video.playbackState)
		{
			case PLAYING:
				playButton.visible = false;
				pauseButton.visible = true;
			case PAUSED, STOPPED:
				playButton.visible = true;
				pauseButton.visible = false;
		}
	}

	function volumeChange(flag:Dynamic)
	{
		if (flag.data && video != null)
		{
			video.volume = volumeBar.data;
		}
	}

	function progressChange(flag:Dynamic)
	{
		if (flag.sliderDown)
		{
			video.seeking = progressBar.sliderDown; // prolonged seeking so set state ourselves
		}

		if (flag.data && Math.round(progressBar.data) != Math.round(video.currentTime))
		{
			video.seek(Math.round(progressBar.data));
		}
	}
}

class VideoControllerButtonSkin extends Skin<Component>
{
	var background:Rectangle;
	var icon:Shape;

	public function new()
	{
		super();

		defaultWidth = 30;
		defaultHeight = 30;

		background = new Rectangle();
		addChild(background);

		background.fill = new Color(0x3e3a3a, 1);
		background.all = 0;
		background.alpha = 0;

		icon = new Shape();
		addChild(icon);
		icon.all = 0;
	}

	override function update(flag:Dynamic)
	{
		super.update(flag);

		if (flag.data)
		{
			icon.commands = drawIconShape(target.data.icon);
		} 

		if (flag.focused || flag.selected || flag.disabled || flag.pressed)
		{
			if (target.pressed)
			{
				//background.alpha = 0.5;
			}
			else if (!target.enabled)
			{
				target.alpha = 0.5;
				background.alpha = 0;
			}
			else
			{
				background.alpha = 0;
			}
		}
	}

	private function drawIconShape(id:String):String
	{
		var c:String = "BF 0xFFFFFF 1 ";
		var border:Int = 4;
		var w:Float = target.width - (border * 2);
		var h:Float = target.height - (border * 2);
		switch(id)
		{
			case "play":
				c += 	"M " + border + " " + border + " L " + (w + border) + " " + (target.height / 2) + " L " + border + " " + (h + border) + " L " + border + " " + border + " EF";
			case "pause":
				var barW:Int = Math.round(w / 3);
				c += 	"M " + border + " " + border + " " +
						"L " + (border + barW) + " " + border + " " +
						"L " + (border + barW) + " " + (border + h) + " " +
						"L " + border + " " + (border + h) + " " +
						"L " + border + " " + border + " " +

						"M " + (border + (barW * 2)) + " " + border + " " +
						"L " + (border + (barW * 3)) + " " + border + " " +
						"L " + (border + (barW * 3)) + " " + (border + h) + " " +
						"L " + (border + (barW * 2)) + " " + (border + h) + " " +
						"L " + (border + (barW * 2)) + " " + border + " " +
						"EF";
		}

		return c;
	}
}

class VideoProgressBar extends RangeInput
{
	public var trackClicked:Signal0;

	public function new(?skin:Skin<Dynamic>)
	{
		if (skin == null)
			skin = new VideoProgressBarSkin();
		
		super(cast skin);

		trackClicked = new Signal0();
		minimumSliderPosition = 0;
		maximumSliderPosition = 0;
		sliderRangeEnabled = true;
		maximum = 1000000; // need large value in case seek is made before duration is set, otherwise seek point may be limited
	}

	override function set_data(value:Float):Float
	{
		if (sliderRangeEnabled)
			return this.data = changeValue("data", Math.min(maximumSliderPosition, Math.max(minimumSliderPosition, value)));

		return super.set_data(value);
	}

	public var sliderRangeEnabled(default, set_sliderRangeEnabled):Bool;
	function set_sliderRangeEnabled(value:Bool):Bool
	{
		return sliderRangeEnabled = changeValue("sliderRangeEnabled", value);
	}

	public var minimumSliderPosition(default, set_minimumSliderPosition):Float;
	function set_minimumSliderPosition(value:Float):Float
	{
		if (!sliderRangeEnabled)
			value = minimum;
		else if (value < minimum)
			value = minimum;

		minimumSliderPosition = changeValue("minimumSliderPosition", value);

		if (maximumSliderPosition < minimumSliderPosition)
		{
			maximumSliderPosition = changeValue("maximumSliderPosition", minimumSliderPosition);
		}

		if (this.data < minimumSliderPosition)
		{
			this.data = changeValue("data", minimumSliderPosition);
		}

		return minimumSliderPosition;
	}

	public var maximumSliderPosition(default, set_maximumSliderPosition):Float;
	function set_maximumSliderPosition(value:Float):Float
	{
		if (!sliderRangeEnabled)
			value = maximum;
		else if (value > maximum)
			value = maximum;

		maximumSliderPosition = changeValue("maximumSliderPosition", value);

		if (minimumSliderPosition > maximumSliderPosition)
		{
			minimumSliderPosition = changeValue("minimumSliderPosition", maximumSliderPosition);
		}

		if (this.data > maximumSliderPosition)
		{
			this.data = changeValue("data", maximumSliderPosition);
		}

		return maximumSliderPosition;
	}

	override function change(flag:Dynamic)
	{
		super.change(flag);

		if (flag.sliderRangeEnabled || flag.maximum || flag.minimum)
		{
			if (!sliderRangeEnabled)
			{
				minimumSliderPosition = minimum;
				maximumSliderPosition = maximum;
			}
		}
	}
}


class VideoProgressBarSkin extends Skin<VideoProgressBar>
{
	var track:Rectangle;
	var buffer:Rectangle;
	var amount:Rectangle;
	var thumb:Rectangle;
	var dragBehavior:DragBehavior;

	public function new():Void
	{
		super();

		var size:Int = 6;
		defaultWidth = 150;
		defaultHeight = (size * 2) + 3;

		properties.fill = new Color(0x000000);

		buffer = new Rectangle();
		addChild(buffer);

		buffer.radius = size;
		buffer.height = size;
		buffer.width = size;
		buffer.centerY = 0.5;
		buffer.fill = new Color(0xd21b02);

		buffer.fill = new Gradient([new GradientColor(0x454545, 1, 0.14),
									new GradientColor(0x767575, 1, 0.85),
									new GradientColor(0xa7a6a6, 1, 0.95)],
									90);

		track = new Rectangle();
		addChild(track);

		track.left = track.right = 0;
		track.radius = size;
		track.height = size;
		track.strokeThickness = 1;
		track.stroke = new Gradient([new GradientColor(0x444444, 0.5, 0),
									new GradientColor(0x626161, 1, 1)],
									90);

		track.centerY = 0.5;

		amount = new Rectangle();
		addChild(amount);

		amount.radiusTopLeft = amount.radiusBottomLeft = size;
		amount.height = size;
		amount.width = size;
		amount.centerY = 0.5;
		//amount.strokeThickness = 1;
		//amount.stroke = new Gradient([new GradientColor(0x4e8ad5, 1, 0),
									//new GradientColor(0x0a3987, 1, 1)],
									//-90);
		amount.fill = new Gradient([new GradientColor(0x77adf6, 1, 0.0),
									new GradientColor(0x2f64b7, 1, 0.85),
									new GradientColor(0x0d48a8, 1, 0.92)],
									-90);

		thumb = new Rectangle();
		addChild(thumb);

		thumb.fill = new Gradient([new GradientColor(0xa6a6a6, 1, 0), new GradientColor(0xfafafa, 1, 1)], 90);
		thumb.strokeThickness = 1;
		thumb.stroke = new Color(0x9d9d9d);
		thumb.width = thumb.height = size * 2;
		thumb.centerY = 0.5;
		thumb.radius = thumb.height;
		//thumb.alpha = 0.4;

		dragBehavior = new DragBehavior();
		dragBehavior.target = thumb;
		dragBehavior.dragStarted.add(dragStarted);
		dragBehavior.dragUpdated.add(dragUpdated);
		dragBehavior.dragStopped.add(dragStopped);

		#if flash amount.sprite.mouseEnabled = false; #end
	}
	#if touch
	function trackClickHandler(touch:Touch)
	{

		var x = target.mouseX - (thumb.width / 2);
		if (x < 0)
			x = 0;
		else if (x > dragBehavior.maximumX)
			x = dragBehavior.maximumX;

		thumb.x = Math.round(x);
		updateValue();

		target.trackClicked.dispatch();
	}
	#end

	override function add()
	{
		super.add();
		#if touch
		target.touchEnded.add(trackClickHandler);
		#end
		target.sliderRangeEnabled = true; // this skin cares about buffer range
	}

	override function remove()
	{
		#if touch
		target.touchEnded.remove(trackClickHandler);
		#end
		target.sliderRangeEnabled = false; // reset as later skin may not care about buffer range
		super.remove();
	}

	override function update(flag:Dynamic)
	{
		super.update(flag);

		if (flag.width || flag.height)
		{
			dragBehavior.minimumX = 0;
			updateMaxPlayheadPosition();
		}

		if (flag.maximumSliderPosition || flag.width)
		{
			buffer.width = Math.round(target.width * (target.maximumSliderPosition / target.maximum));
			updateMaxPlayheadPosition();
		}

		if (flag.data || flag.width || flag.height || flag.minimum || flag.maximum)
		{
			if (!target.sliderDown)
			{
				updatePosition();
			}

			amount.width = Math.round(thumb.x + 4);
		}

		if (flag.focused)
		{
			//if (target.focused) thumb.fill = new Gradient([new GradientColor(0xEEEEFF, 1, 0), new GradientColor(0x1111FF, 1, 1)]);
			//else thumb.fill = new Gradient([new GradientColor(0xEEEEEE, 1, 0), new GradientColor(0x333333, 1, 1)]);
		}
	}

	function updateMaxPlayheadPosition()
	{
		var maxX = buffer.width - thumb.width;
		if (maxX < 0)
			maxX = 0;
		dragBehavior.maximumX = maxX;
	}

	function dragStarted():Void
	{
		// set this here as thumb.y may not be set earlier as not validated
		dragBehavior.minimumY = dragBehavior.maximumY = thumb.y;
		target.sliderDown = true;
		target.focus();
	}

	function dragUpdated():Void
	{
		if (target.tracking)
			updateValue();
	}

	function dragStopped():Void
	{
		updateValue();
		target.sliderDown = false;
	}

	function updatePosition():Void
	{
		var ratio = (target.data - target.minimum) / (target.maximum - target.minimum);
		var targetX = (target.width - thumb.width) * ratio;

		if (targetX > dragBehavior.maximumX)
			targetX = dragBehavior.maximumX;

		thumb.x = Math.round(targetX);
	}

	function updateValue():Void
	{
		var ratio:Float = thumb.x / (target.width - thumb.width);
		var range:Float = target.maximum - target.minimum;
		var pos:Float = target.minimum + range * ratio;

		target.data = pos;
	}
}

class VolumeBarSkin extends Skin<RangeInput>
{
	var track:Rectangle;
	var amount:Rectangle;
	var thumb:Rectangle;
	var dragBehavior:DragBehavior;

	public function new()
	{
		super();

		var size:Int = 6;
		defaultWidth = 80;
		defaultHeight = Math.round(size * 1.4);

		amount = new Rectangle();
		addChild(amount);

		properties.fill = new Color(0x000000);

		amount.radiusTopLeft = amount.radiusBottomLeft = size;
		amount.height = size;
		amount.width = size;
		amount.centerY = 0.5;

		amount.fill = new Gradient([new GradientColor(0x322e2e, 1, 0.0),
									new GradientColor(0x2c2a2a, 1, 0.85),
									new GradientColor(0x000000, 1, 0.92)],
									90);

		track = new Rectangle();
		addChild(track);

		track.left = track.right = 0;
		track.radius = size;
		track.height = size;
		track.strokeThickness = 1;
		track.stroke = new Gradient([new GradientColor(0x444444, 0.5, 0),
									 new GradientColor(0x626161, 1, 1)],
									 90);

		track.centerY = 0.5;

		thumb = new Rectangle();
		addChild(thumb);

		thumb.fill = new Gradient([new GradientColor(0xa6a6a6, 1, 0),
								   new GradientColor(0xfafafa, 1, 1)],
								   90);
		thumb.strokeThickness = 1;
		thumb.stroke = new Color(0x9d9d9d);
		thumb.width = thumb.height = Math.round(size * 1.5);
		thumb.centerY = 0.4;
		thumb.radius = thumb.height;


		dragBehavior = new DragBehavior();
		dragBehavior.target = thumb;
		dragBehavior.dragStarted.add(dragStarted);
		dragBehavior.dragUpdated.add(dragUpdated);
		dragBehavior.dragStopped.add(dragStopped);

		#if flash amount.sprite.mouseEnabled = false; #end
	}

	#if touch
	function trackClickHandler(touch:Touch)
	{
		thumb.x = Math.round(target.mouseX - (thumb.width / 2));
		updateValue();
	}
	#end

	override function add()
	{
		super.add();
		#if touch
		target.touchEnded.add(trackClickHandler);
		#end
	}

	override function update(flag:Dynamic)
	{
		super.update(flag);

		if (flag.width || flag.height)
		{
			dragBehavior.minimumX = 0;
			dragBehavior.maximumX = target.width - thumb.width;
			dragBehavior.minimumY = dragBehavior.maximumY = thumb.y;
		}

		if (flag.data || flag.width || flag.height)
		{
			if (!target.sliderDown)
			{
				updatePosition();
			}

			var ratio = (target.data - target.minimum) / (target.maximum - target.minimum);
			if (!Math.isNaN(ratio))
				amount.width = Math.round((target.width - thumb.width) * ratio);
		}

		if (flag.focused)
		{
			//if (target.focused) thumb.fill = new Gradient([new GradientColor(0xEEEEFF, 1, 0), new GradientColor(0x1111FF, 1, 1)]);
			//else thumb.fill = new Gradient([new GradientColor(0xEEEEEE, 1, 0), new GradientColor(0x333333, 1, 1)]);
		}
	}

	override function remove()
	{
		#if touch
		target.touchEnded.remove(trackClickHandler);
		#end
		super.remove();
	}

	function dragStarted():Void
	{
		// set this here as thumb.y may not be set earlier as not validated
		dragBehavior.minimumY = dragBehavior.maximumY = thumb.y;
		target.sliderDown = true;
		target.focus();
	}

	function dragUpdated():Void
	{
		if (target.tracking) updateValue();
	}

	function dragStopped():Void
	{
		target.sliderDown = false;
		updateValue();
	}

	function updatePosition():Void
	{
		var ratio = (target.data - target.minimum) / (target.maximum - target.minimum);
		thumb.x = Math.round((target.width - thumb.width) * ratio);
	}

	function updateValue():Void
	{
		var ratio:Float = thumb.x / (target.width - thumb.width);
		var range:Float = target.maximum - target.minimum;
		target.data = target.minimum + range * ratio;
	}
}
