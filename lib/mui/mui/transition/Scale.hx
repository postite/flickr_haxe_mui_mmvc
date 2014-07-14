package mui.transition;

import msignal.Signal;
import mui.display.Display;
import mui.transition.Animation;

class Scale extends TAnimation<Scale>
{
	public static inline function to(xScale:Float, yScale:Float, ?settings:AnimationSettings):Scale
	{
		return new Scale(xScale, yScale, settings);
	}

	public static inline function x(xScale:Float, ?settings:AnimationSettings)
	{
		return new Scale(xScale, null, settings);
	}

	public static inline function y(yScale:Float, ?settings:AnimationSettings)
	{
		return new Scale(null, yScale, settings);
	}

	private function new(xScale:Null<Float>, yScale:Null<Float>, settings:AnimationSettings)
	{
		super({scaleX:xScale, scaleY:yScale}, settings);
	}
	
	public function from(xScale:Null<Float>, yScale:Null<Float>):Scale
	{
		pre = function(view:Display)
		{
			if (xScale != null) view.scaleX = xScale;
			if (yScale != null) view.scaleY = yScale;
		}
		return this;
	}

	override function createCopy():Scale
	{
		return Scale.to(properties.scaleX, properties.scaleY);
	}
}
