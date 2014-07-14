package mui.behavior;

import mui.core.Behavior;
import mui.core.Component;
import mui.event.Input;
import mui.core.Skin;
import msignal.Signal;

#if key
import mui.event.Key;
#end

#if touch
import mui.event.Touch;
#end

/**
	Gives a `Component` button like behavior.

	Adds `Key` and `Touch` events based on the current compilation target so 
	that the `Component` will respond to user input like a `Button`. Allows 
	composition of `Button` behavior without needing to subclass it.
**/
class ButtonBehavior extends Behavior<Component>
{
	/**
		Determines whether the `target` should gain focus when a touch begins.
	**/
	public var focusOnPress:Bool;

	/**
		Determines whether the `target` should gain focus when a touch ends.
	**/
	public var focusOnRelease:Bool;

	var externalAction:Void -> Void;

	/**
		Creates a new ButtonBehavior for the provided `target`

		@param target The target to apply the behavior to
		@param externamAction An optional callback to invoke when the `target` 
			is actioned by the user.
	**/
	public function new(target:Component, ?externalAction:Void->Void)
	{
		super(target);

		this.externalAction = externalAction;

		focusOnPress = true;
		focusOnRelease = false;
	}

	override function add()
	{
		#if key
		target.keyPressed.add(keyPress);
		target.keyReleased.add(keyRelease);
		#end

		#if touch
		target.touchStarted.add(touchStart);
		#end
	}

	override function remove()
	{
		#if key
		target.keyPressed.remove(keyPress);
		target.keyReleased.remove(keyRelease);
		#end

		#if touch
		target.touchStarted.remove(touchStart);
		#end
	}

	function press()
	{
		if (!target.enabled) return;
		if (focusOnPress && !target.focused) target.focus();
		target.pressed = true;

		if (Input.mode == KEY) actionTarget();
	}
	
	function release()
	{
		if (!target.enabled) return;
		if (focusOnRelease && !target.focused) target.focus();
		target.pressed = false;

		if (Input.mode == TOUCH) actionTarget();
	}

	function actionTarget()
	{
		if(externalAction != null) externalAction();
		else target.action();
	}
	
	#if touch
	override function change(flag:Dynamic)
	{
		super.change(flag);
		if (flag.enabled) target.useHandCursor = enabled;
	}
	#end

	#if key
	function keyPress(key:Key)
	{
		if (key.action == OK)
		{
			if (key.pressCount == 1) press();
			key.capture();
		}
	}
	
	function keyRelease(key:Key)
	{
		if (key.action == OK)
		{
			release();
			key.capture();
		}
	}
	#end

	#if touch
	function touchStart(touch:Touch)
	{
		press();
		
		touch.completed.add(inputCompleted);
		touch.captured.add(inputCancelled);
	}
	
	function inputCompleted(touch:Touch)
	{
		release();
	}
	
	function inputCancelled(touch:Touch)
	{
		touch.completed.remove(inputCompleted);
		target.pressed = false;
	}
	#end
}
