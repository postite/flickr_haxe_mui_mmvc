package mui.event;

import msignal.Signal;
import mui.event.Input;

class Touch extends Input
{
	public static var started = new Signal1<Touch>(Touch);
	
	public static function start(touch:Touch)
	{
		Input.setMode(TOUCH);
		started.dispatch(touch);
		
		#if touch
		var display =  mui.Lib.display.getDisplayUnder(touch.currentX, touch.currentY);
		
		if (display != null)
		{
			touch.target = display;
			display.touchStart(touch);
		}
		#end
		mui.core.Node.validator.validate();
	}
	
	public var startX:Int;
	public var startY:Int;
	
	public var currentX:Int;
	public var currentY:Int;
	
	public var previousX:Int;
	public var previousY:Int;
	
	public function new(x:Int, y:Int)
	{
		super();
		
		startX = previousX = currentX = x;
		startY = previousY = currentY = y;
	}
	
	public function updatePosition(x:Int, y:Int)
	{
		previousX = currentX;
		previousY = currentY;
		
		currentX = x;
		currentY = y;
		
		update();
	}

	override public function complete()
	{
		#if touch
		target.touchEnd(this);
		#end
		super.complete();
		mui.core.Node.validator.validate();		
	}
	
	public var changeX(get_changeX, null):Int;
	function get_changeX():Int { return currentX - previousX; }
	
	public var changeY(get_changeY, null):Int;
	function get_changeY():Int { return currentY - previousY; }
	
	public var totalChangeX(get_totalChangeX, null):Int;
	function get_totalChangeX():Int { return currentX - startX; }
	
	public var totalChangeY(get_totalChangeY, null):Int;
	function get_totalChangeY():Int { return currentY - startY; }
}
