package mui.behavior;

import mui.core.Behavior;
import mui.core.Container;
import mui.event.Touch;
import mui.event.Input;
import mui.layout.Direction;

/**
	Scrolls the content of a `Container` in response to changes in its 
	selectedIndex.
	
	`ScrollSelectionBehavior` scrolls the content of a `Container` subclass in 
	response to changes in its selected index by calling `setTarget` on its 
	`scroller`. It also detects basic touch gestures (swipe left/right/up/down) 
	and moves selection in the gestured direction if `gesture` is `true`.
**/
class ScrollSelectionBehavior extends Behavior<Container>
{
	public var gesture:Bool;
	
	public function new(?target:Container)
	{
		super(target);
		gesture = true;
	}
	
	#if touch
	override function add()
	{
		target.touchStarted.add(touchStart);
		update({target:true});
	}
	
	override function remove()
	{
		Input.modeChanged.remove(inputModeChange);
		target.touchStarted.remove(touchStart);
	}
	
	function inputModeChange()
	{
		if (Input.mode == TOUCH)
		{
			enabled = false;
		}
		else
		{
			enabled = true;
			
			if (target.selectedComponent != null)
			{
				target.scroller.setTarget(target.selectedComponent);
			}
		}
	}
	
	function touchStart(touch:Touch)
	{
		touch.completed.addOnce(touchComplete);
	}
	
	function touchComplete(touch:Touch)
	{
		if (!enabled) return;
		if (!gesture) return;
		
		var travelX = Math.abs(touch.totalChangeX);
		var travelY = Math.abs(touch.totalChangeY);
		
		var velocityX = touch.changeX;
		var velocityY = touch.changeY;

		var next = target.selectedComponent;

		if(travelX < 5 && travelY < 5) return;

		if (travelY > travelX)
		{
			if (velocityY < 0)
			{
				next = target.navigator.next(next, Direction.down);
			}
			else if (velocityY > 0)
			{
				next = target.navigator.next(next, Direction.up);
			}
		}
		else
		{
			if (velocityX < 0)
			{
				next = target.navigator.next(next, Direction.right);
			}
			else if (velocityX > 0)
			{
				next = target.navigator.next(next, Direction.left);
			}
		}
		
		if (next != null)
		{
			target.selectedComponent = next;
			target.scroller.setTarget(target.selectedComponent);
		}
	}
	#end

	override function update(flag:Dynamic)
	{
		if (target.selectedComponent == null) return;

		if (flag.target || flag.layout || flag.components || flag.selectedIndex || flag.width || flag.height)
		{
			var child = target.selectedComponent;

			if (child != null)
			{
				var animate = !(flag.children || flag.target || flag.layout || flag.data);
				target.scroller.setTarget(child, animate);
			}
		}
	}
}
