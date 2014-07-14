package mui.control;

import msignal.Signal;
import mui.event.Input;
import mui.core.Component;
import mui.core.Skin;

#if key
import mui.event.Key;
#end

#if touch
import mui.event.Touch;
#end

typedef Button = DataButton<Dynamic>;

/**
	A specialized `Component` representing a Button.

	A Button presents a visible selectable area. On selection a BUTTON_ACTIONED 
	event is dispatched, allowing an application to respond appropriately.
**/
class DataButton<TData> extends DataComponent<TData>
{
	public var focusOnPress:Bool;
	public var focusOnRelease:Bool;
	public var actioned:Signal0;

	override public function new(?skin:Skin<Dynamic>):Void
	{
		super(skin);
		
		useHandCursor = true;
		focusOnPress = true;
		focusOnRelease = false;
		actioned = new Signal0();
	}

	public function press()
	{
		if (!enabled) return;
		if (focusOnPress && !focused) focus();
		
		pressed = true;
		#if uiml
		setState("pressed");
		#end

		if (Input.mode == KEY)
			action();
	}
	
	public function release()
	{
		if (!enabled) return;
		if (focusOnRelease && !focused) focus();
		pressed = false;
		#if uiml
		setState("released");
		#end

		if (Input.mode == TOUCH)
			action();
	}
	
	override public function action():Void
	{
		super.action();
		
		pressed = false;
		actioned.dispatch();
		#if uiml
		setState("actioned");
		#end
		bubble(BUTTON_ACTIONED);
	}
	
	#if touch
	override function change(flag:Dynamic)
	{
		super.change(flag);
		
		if (flag.enabled)
			useHandCursor = enabled;
	}
	#end

	#if key
	override public function keyPress(key:Key)
	{
		if (key.action == OK)
		{
			key.capture();
			if (key.pressCount == 1) press();
		}
		else
			super.keyPress(key);
	}
	
	override public function keyRelease(key:Key)
	{
		if (key.action == OK)
		{
			key.capture();
			release();
		}
		else
			super.keyRelease(key);
	}
	#end

	#if touch
	
	var initialX:Int;
	var initialY:Int;
	
	override public function touchStart(touch:Touch)
	{
		super.touchStart(touch);
		
		press();
		pressed = true;
		
		initialX = touch.currentX - rootX;
		initialY = touch.currentY - rootY;
		
		touch.updated.add(touchMoved);
		touch.completed.add(inputCompleted);
		touch.captured.add(inputCancelled);
	}
	
	function touchMoved(touch:Touch)
	{
		var currentX = initialX + touch.totalChangeX;
		var currentY = initialY + touch.totalChangeY;
		pressed = (currentX >= 0 && currentX <= width && currentY >= 0 && currentY <= height);
	}
	
	function inputCompleted(touch:Touch)
	{
		if (pressed) release();
	}
	
	function inputCancelled(touch:Touch)
	{
		touch.updated.remove(touchMoved);
		touch.completed.remove(inputCompleted);
		pressed = false;
	}
	#end
}

enum ButtonEvent
{
	BUTTON_ACTIONED;
}
