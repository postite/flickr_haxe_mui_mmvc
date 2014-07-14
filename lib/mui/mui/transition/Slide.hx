package mui.transition;

import mui.layout.Direction;
import msignal.Signal;
import mui.display.Display;
import mui.transition.Animation;


class Slide extends TAnimation<Slide>
{
	public var targetX(get_targetX, set_targetX):Null<Int>;
	function get_targetX() { return properties.x; }
	function set_targetX(x:Null<Int>) { return properties.x = x; }

	public var targetY(get_targetY, set_targetY):Null<Int>;
	function get_targetY() { return properties.y; }
	function set_targetY(y:Null<Int>) { return properties.y = y; }

	public static function to(x:Int, y:Int, ?settings:AnimationSettings)
	{
		return new Slide(x, y, settings);
	}
	
	public static inline function x(x:Int, ?settings:AnimationSettings)
	{
		return new Slide(x, null, settings);
	}

	public static inline function y(y:Int, ?settings:AnimationSettings)
	{
		return new Slide(null, y, settings);
	}

	public static function on(direction:Direction, ?settings:AnimationSettings)
	{
		var slide = new Slide(null, null, settings);
		slide.pre = function(view:Display)
		{
			var parent = view.parent;
			if (view.centerX != null)
			{
				if (parent != null) 
					slide.targetX = Math.round((parent.width - view.width) * view.centerX);
			}
			else if (view.left != null)
			{
				slide.targetX = view.left;
			}
			else if (view.right != null && parent != null)
			{
				slide.targetX = parent.width - (view.width + view.right);
			}
			else
			{
				slide.targetX = view.x;
			}

			if (view.centerY != null)
			{
				if (parent != null)
					slide.targetY = Math.round((parent.height - view.height) * view.centerY);
			}
			else if (view.top != null)
			{
				slide.targetY = view.top;
			}
			else if (view.bottom != null && parent != null) 
			{
				slide.targetY = parent.height - (view.height + view.bottom);
			}
			else
			{
				slide.targetY = view.y;
			}
		
			switch (direction)
			{
				case left, previous:
					view.x = (parent != null) ? parent.width : view.width;
					view.y = slide.targetY;
				case right, next:
					view.x = -view.width;
					view.y = slide.targetY;
				case up:
					view.x = slide.targetX;
					view.y = (parent != null) ? parent.height : view.height;
				case down:
					view.x = slide.targetX;
					view.y = -view.height;
			}
		}
		return slide;
	}

	public static function off(direction:Direction, ?settings:AnimationSettings)
	{
		var slide = new Slide(null, null, settings);
		slide.pre = function(view:Display)
		{
			var parent = view.parent;
			switch (direction)
			{
				case left, next: 
					slide.targetX = -view.width;
					slide.targetY = view.y;
				case right, previous: 
					slide.targetX = (parent != null) ? parent.width : view.width;
					slide.targetY = view.y;
				case up:
					slide.targetX = view.x;
					slide.targetY = -view.height;
				case down:
					slide.targetX = view.x;
					slide.targetY = (parent != null) ? parent.height : view.height;
			}
		}
		return slide;
	}

	private function new(x:Null<Int>, y:Null<Int>, settings:AnimationSettings)
	{
		super({x:x, y:y}, settings);
	}
	
	public function from(x:Null<Int>, y:Null<Int>):Slide
	{
		#if debug
		if (pre != null)
			Console.warn("Overwriting an existing pre Slide function");
		#end
		
		pre = function(view:Display)
		{
			if (x != null) view.x = x;
			if (y != null) view.y = y;
		}
		return this;
	}
	
	public function position(x:Null<Int>, y:Null<Int>):Slide
	{
		this.targetX = x;
		this.targetY = y;
		return this;
	}

	override function createCopy():Slide
	{
		return Slide.to(properties.x, properties.y);
	}
}
