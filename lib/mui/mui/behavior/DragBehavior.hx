package mui.behavior;

import msignal.Signal;
import mui.core.Behavior;
import mui.display.Display;

#if touch
import mui.event.Touch;
#end

/**
	Adds touch or mouse based drag functionality to subclasses of `Display`.

	The drag operation is initiated when a `Touch` event is initiated on the 
	target. As the `Touch` event updates, the position of the target is updated 
	based on its initial position, the distance the touch has moved and the 
	minimum/maximum constraints defined on the behavior. When the touch event 
	completes the position of the target is finalised and the behavior resets 
	to its initial waiting state.

	An example usage of `DragBehavior` is the sliding interaction with the 
	thumb of a `Slider`.
**/
class DragBehavior extends Behavior<Display>
{
	/**
		The minimum x position of the target while dragging.
	**/
	public var minimumX:Int;

	/**
		The minimum y position of the target while dragging.
	**/
	public var minimumY:Int;
	
	/**
		The maximum x position of the target while dragging.
	**/
	public var maximumX:Int;

	/**
		The maximum y position of the target while dragging.
	**/
	public var maximumY:Int;
	
	/**
		A signal dispatched when a drag operation starts.
	**/
	public var dragStarted(default, null):Signal0;

	/**
		A signal dispatched when a drag operation updates.
	**/
	public var dragUpdated(default, null):Signal0;

	/**
		A signal dispatched when a drag operation completes.
	**/
	public var dragStopped(default, null):Signal0;
	
	/**
		The initial x position of the target when the drag operation commenced.
	**/
	var initialTargetX:Int;

	/**
		The initial y position of the target when the drag operation commenced.
	**/
	var initialTargetY:Int;

	/**
		Creates a new `DragBehavior`, attaching it to the target if supplied.

		@param target An optional target to attach the behavior to.
	**/
	public function new(?target:Display)
	{
		super(target);
		
		minimumX = minimumY = maximumX = maximumY = 0;
		
		dragStarted = new Signal0();
		dragUpdated = new Signal0();
		dragStopped = new Signal0();
	}
	
	#if touch
	/**
		When the behavior is added to a target, add a listener to touchStarted.
	**/
	override function add()
	{
		target.touchStarted.add(startDrag);
	}
	
	/**
		When the behavior is removed from a target, remove the touchStarted 
		listener.
	**/
	override function remove()
	{
		target.touchStarted.remove(startDrag);
	}
	
	/**
		When a touch starts, capture the event and start dragging. Add 
		listeners to touch.updated and touch.completed and dispatch dragStarted.
	**/
	function startDrag(touch:Touch)
	{
		if (!enabled) return;
		
		touch.capture();
		
		touch.updated.add(updateDrag);
		touch.completed.add(stopDrag);
		
		initialTargetX = target.x;
		initialTargetY = target.y;
		
		dragStarted.dispatch();
	}

	/**
		When a touch updates, calculate the new position, constrain to min/max 
		position and dispatch dragUpdated.
	**/
	function updateDrag(touch:Touch)
	{
		var currentTargetX = initialTargetX + touch.totalChangeX; 
		var currentTargetY = initialTargetY + touch.totalChangeY;
		
		target.x = Math.round(Math.min(maximumX, Math.max(minimumX, currentTargetX)));
		target.y = Math.round(Math.min(maximumY, Math.max(minimumY, currentTargetY)));
		
		dragUpdated.dispatch();
	}
	
	/**
		When the touch completes, remove updated and completed listeners from 
		the event and dispatch dragStopped.
	**/
	function stopDrag(touch:Touch)
	{
		touch.updated.remove(updateDrag);
		touch.completed.remove(stopDrag);
		
		dragStopped.dispatch();
	}
	#end
}
