package mui.input;

import mui.display.Rectangle;
import mui.display.Color;
import mui.display.Text;
import mui.display.Gradient;
import mui.display.GradientColor;
import mui.core.Component;
import mui.behavior.DragBehavior;
import mui.core.Skin;

class RangeInputSkin extends ThemeSkin<RangeInput>
{
	var track:Rectangle;
	var amount:Rectangle;
	var thumb:Rectangle;
	var dragBehavior:DragBehavior;
	var value:Text;

	public function new(theme:Theme)
	{
		super(theme);
		
		defaultWidth = 150;
		defaultHeight = 21;
		minHeight = maxHeight = 21;
		
		track = new Rectangle();
		addChild(track);
		
		track.left = track.right = 0;
		track.radius = 9;
		track.height = 9;
		track.fill = new Gradient([new GradientColor(0xdedede, 1, 0.1),
									new GradientColor(0xffffff, 1, 0.14),
									new GradientColor(0xe7e7e7, 1, 0.41),
									new GradientColor(0xbababa, 1, 0.83),
									new GradientColor(0x909090, 1, 0.85)],
									-90);
		track.strokeThickness = 1;
		track.stroke = new Gradient([new GradientColor(0xb0b0b0, 1, 0),
									new GradientColor(0x808080, 1, 1)],
									-90);
		track.centerY = 0.5;
		
		amount = new Rectangle();
		addChild(amount);
		
		amount.radiusTopLeft = amount.radiusBottomLeft = 9;
		amount.height = 9;
		amount.width = 20;
		amount.centerY = 0.5;
		amount.strokeThickness = 1;
		amount.stroke = new Gradient([new GradientColor(0x4e8ad5, 1, 0),
									new GradientColor(0x0a3987, 1, 1)],
									-90);
		amount.fill = new Gradient([new GradientColor(0x77adf6, 1, 0.0),
									new GradientColor(0x2f64b7, 1, 0.85),
									new GradientColor(0x0d48a8, 1, 0.92)],
									-90);
		
		thumb = new Rectangle();
		addChild(thumb);
		
		thumb.fill = new Gradient([new GradientColor(0xa6a6a6, 1, 0), new GradientColor(0xfafafa, 1, 1)], 90);
		thumb.strokeThickness = 1;
		thumb.stroke = new Color(0x9d9d9d);
		thumb.width = thumb.height = 21;
		thumb.centerY = 0.5;
		thumb.radius = 21;
		
		value = new Text();
		thumb.addChild(value);
		
		value.autoSize = false;
		value.width = thumb.width;
		value.height = 14;
		value.y = 6;
		value.size = 8;
		value.align = "center";

		dragBehavior = new DragBehavior();
		dragBehavior.target = thumb;
		dragBehavior.dragStarted.add(dragStarted);
		dragBehavior.dragUpdated.add(dragUpdated);
		dragBehavior.dragStopped.add(dragStopped);
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
			if (!Math.isNaN(ratio)) amount.width = Math.round((target.width - thumb.width) * ratio) + 10;

			value.value = Std.string(Std.int(target.data * 10) / 10);
		}
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
		var value = Math.isNaN(target.data) ? 0 : target.data;
		var ratio = (value - target.minimum) / (target.maximum - target.minimum);
		thumb.x = Math.round((target.width - thumb.width) * ratio);
	}
	
	function updateValue():Void
	{
		var ratio = thumb.x / (target.width - thumb.width);
		var range = target.maximum - target.minimum;
		target.data = target.minimum + range * ratio;
	}
}
