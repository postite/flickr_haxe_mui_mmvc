package mui.behavior;

import mui.core.Behavior;
import mui.display.Display;

#if touch
import mui.event.Touch;
#end

/**
	Allows users to resize and position `Display` subclasses using touch or 
	mouse interaction.

	The behavior mimicks that of a desktop OS window, where dragging on edges 
	and corners resizes, and dragging on the central area repositions. Setting 
	the `modeMask` controls which operations are enabled.
**/
class ResizeBehavior extends Behavior<Display>
{
	/**
		A bit flag indicating the behavior should allow users to resize the 
		target by clicking and dragging its top edge.
	**/
	inline public static var TOP = 1 << 1;

	/**
		A bit flag indicating the behavior should allow users to resize the 
		target by clicking and dragging its bottom edge.
	**/
	inline public static var BOTTOM = 1 << 2;

	/**
		A bit flag indicating the behavior should allow users to resize the 
		target by clicking and dragging its left edge.
	**/
	inline public static var LEFT = 1 << 3;

	/**
		A bit flag indicating the behavior should allow users to resize the 
		target by clicking and dragging its right edge.
	**/
	inline public static var RIGHT = 1 << 4;

	/**
		A bit flag indicating the behavior should allow users to resize the 
		target by clicking and dragging any of its edges.
	**/
	inline public static var EDGES = TOP | BOTTOM | LEFT | RIGHT;
	
	/**
		A bit flag indicating the behavior should allow users to resize the 
		target by clicking and dragging its top left corner.
	**/
	inline public static var TOP_LEFT = 1 << 5;

	/**
		A bit flag indicating the behavior should allow users to resize the target 
		by clicking and dragging its top right corner.
	**/
	inline public static var TOP_RIGHT = 1 << 6;

	/**
		A bit flag indicating the behavior should allow users to resize the 
		target by clicking and dragging its bottom left corner.
	**/
	inline public static var BOTTOM_LEFT = 1 << 7;

	/**
		A bit flag indicating the behavior should allow users to resize the 
		target by clicking and dragging its bottom right corner.
	**/
	inline public static var BOTTOM_RIGHT = 1 << 8;

	/**
		A bit flag indicating the behavior should allow users to resize the 
		target by clicking and dragging any of its corners.
	**/
	inline public static var CORNERS = TOP_LEFT | TOP_RIGHT | BOTTOM_LEFT | BOTTOM_RIGHT;
	
	/**
		A bit flag indicating the behavior should allow users to reposition the 
		target by clicking and dragging its center.
	**/
	inline public static var DRAG = 1 << 9;

	/**
		A bit flag including all resize types.
	**/
	inline public static var ALL = EDGES | CORNERS | DRAG;
	
	/**
		Creates a new `ResizeBehavior`, attaching it to the target if supplied.

		@param target An optional target to attach the behavior to.
	**/
	public function new(?target:Display)
	{
		super(target);
		
		edge = 30;
		modeMask = ALL;
	}
	
	/**
		The thickness, in pixels, of the behaviors 'edge'. When a touch event 
		is detected, this value and that of modeMask are used to determine the 
		type of resize operation to perform.

		For example, the targets top left corner extends from (0,0) to 
		(edge,edge), while its top edge extends from (0,0) to (width, edge).
	**/
	public var edge:Int;

	/**
		A bit flag indicating the types of resizing to allow. Modes can be 
		combines using bitwise operators:
		
		```haxe
		var resize = new ResizeBehavior();
		
		// only allow resizing by dragging left edge
		resize.modeMask = ResizeBehavior.LEFT;
		
		// only allow resizing by dragging left or right edge
		resize.modeMask = ResizeBehavior.LEFT | ResizeBehavior.RIGHT;
		
		// allow dragging and resizing by bottom right corner
		resize.modeMask = ResizeBehavior.DRAG | ResizeBehavior.BOTTOM_RIGHT;
		```
	**/
	public var modeMask:Int;
	
	/**
		The mode of the most recent resize operation.
	**/
	var mode:Int;
	
	/**
		The x position of the target when the current resize operation 
		commenced.
	**/
	var startX:Int;

	/**
		The y position of the target when the current resize operation 
		commenced.
	**/
	var startY:Int;
	
	/**
		The width of the target when the current resize operation commenced.
	**/
	var startWidth:Int;

	/**
		The height of the target when the current resize operation commenced.
	**/
	var startHeight:Int;
	
	#if touch
	/**
		When the behavior is added to a target, add a listener to 
		`target.touchStarted`.
	**/
	override function add()
	{
		target.touchStarted.add(startResize);
	}
	
	/**
		When the behavior is removed from a target, remove the listener from
		`target.touchStarted`.
	**/
	override function remove()
	{
		target.touchStarted.remove(startResize);
	}
	
	/**
		When a touch commences, determin the current mode based on its position 
		and the modeMask, add listeners to touch.updated and touch.completed 
		and capture the event.
	**/
	function startResize(touch:Touch)
	{
		mode = 0;
		
		var width = target.width;
		var height = target.height;
		
		var mouseX = target.mouseX;
		var mouseY = target.mouseY;
		
		if (mouseX < edge)
		{
			if (mouseY < edge) mode = TOP_LEFT;
			else if (mouseY < height - edge) mode = LEFT;
			else mode = BOTTOM_LEFT;
		}
		else if (mouseX < width - edge)
		{
			if (mouseY < edge) mode = TOP;
			else if (mouseY < height - edge) mode = DRAG;
			else mode = BOTTOM;
		}
		else
		{
			if (mouseY < edge) mode = TOP_RIGHT;
			else if (mouseY < height - edge) mode = RIGHT;
			else mode = BOTTOM_RIGHT;
		}
		
		if (mode & modeMask == 0) return;
		
		startX = target.x;
		startY = target.y;

		startWidth = target.width;
		startHeight = target.height;
		
		touch.updated.add(updateResize);
		touch.completed.add(stopResize);
		touch.capture();
	}
	
	/**
		When the touch updates, determine the new position and size of the 
		target based on the current resize mode and the change in position of 
		the touch event.
	**/
	function updateResize(touch:Touch)
	{
		var changeX = touch.totalChangeX;
		var changeY = touch.totalChangeY;
		
		switch (mode)
		{
			case TOP_LEFT:
				target.x = startX + changeX;
				target.y = startY + changeY;
				target.width = startWidth - changeX;
				target.height = startHeight - changeY;
			case LEFT:
				target.x = startX + changeX;
				target.width = startWidth - changeX;
			case BOTTOM_LEFT:
				target.x = startX + changeX;
				target.width = startWidth - changeX;
				target.height = startHeight + changeY;
			case TOP:
				target.y = startY + changeY;
				target.height = startHeight - changeY;
			case DRAG:
				target.x = startX + changeX;
				target.y = startY + changeY;
			case BOTTOM:
				target.height = startHeight + changeY;
			case TOP_RIGHT:
				target.y = startY + changeY;
				target.width = startWidth + changeX;
				target.height = startHeight - changeY;
			case RIGHT:
				target.width = startWidth + changeX;
			case BOTTOM_RIGHT:
				target.width = startWidth + changeX;
				target.height = startHeight + changeY;
		}
	}
	
	/**
		When the touch completes remove touch.updated and touch.completed 
		listeners.
	**/
	function stopResize(touch:Touch)
	{
		touch.updated.remove(updateResize);
		touch.completed.remove(stopResize);
	}
	#end
}
