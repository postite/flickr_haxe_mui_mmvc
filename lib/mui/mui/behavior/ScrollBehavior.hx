package mui.behavior;

import mui.core.Behavior;
import mui.display.Display;
import mui.transition.Tween;
import mui.layout.AlignX;
import mui.layout.AlignY;

#if touch
import mui.event.Touch;
#end

/**
	Scrolls the content of a `Container` programatically and in response to 
	`Touch` events.

	`ScrollBehavior` adds touch based scrolling to `Display` subclasses. The 
	behavior uses the `contentWidth` and `contentHeight` properties of the 
	target to determine if scrolling is possible, and if so allows users to 
	scroll the display using touch.

	The behavior can be customised to match the native scrolling behaviors of 
	different platforms using its properties.

	The behavior also allows scrolling of content to arbitrary positions through 
	calling the `scrollTo` method, and scrolling child content into view using 
	the `setTarget` method.
**/
class ScrollBehavior extends Behavior<Display>
{
	/**
		Controls whether the behavior prevents the target from being scrolled 
		past the horizontal edges of its content, as determined by its 
		`contentWidth`.

		When `true` while scrolled past the edge of its content, the 
		overscroll amount is multiplied by `spring`, allowing for a 
		spring like behavior. When released, the content scrolls back to the 
		edge of the content.

		When `false` content can be scrolled any amount in a horizontal 
		direction.
	**/
	public var constrainX:Bool;

	/**
		Controls whether the behavior prevents the target from being scrolled 
		past the vertical edges of its content, as determined by its 
		`contentHeight`.

		When `true` while scrolled past the edge of its content, the overscroll 
		amount is multiplied by `spring`, allowing for a spring like behavior. 
		When released, the content scrolls back to the edge of the content.

		When `false` content can be scrolled any amount in a vertical direction.
	**/
	public var constrainY:Bool;
	
	/**
		If the behavior constrains the scroll position of the targets content, 
		ie. if `constrainX` or `constrainY` are `true`, this property controls 
		the amount by which overscrolling is 'dampened' while scrolling. The 
		overscroll amount is multiplied by `spring` such that `0` prevents it 
		completely, and `1` does not dampen overscroll at all. The default 
		value is `0.5`.
	**/
	public var spring:Float;

	/**
		Whether the behavior should animate scrolling initiated by the 
		`scrollTo` method. When `true`, content is scrolled either using a 
		`Tween` if `tweenSettings` is not `null`, or a simple exponential 
		falloff transition.
	**/
	public var animated:Bool;

	/**
		The tween settings to use when animating calls to `scrollTo`. If `null` 
		content is scrolled using a simple exponential falloff transition.
	**/
	public var tweenSettings:Dynamic;

	/**
		Whether or not to use inertial scrolling. When `true` content will 
		keep its momentum when the touch event that initiated scrolling 
		completes. When `false` scrolling stops immediately after the touch 
		event completes.
	**/
	public var inertiaEnabled:Bool;
	
	/**
		Whether the behavior should respond to touch events on the target. When 
		`false`, the behavior can still be used to scroll content using the 
		`scrollTo` and `setTarget` methods. Defaults to `true`.
	**/
	public var touchEnabled:Bool;

	/**
		Controls how targeted content is horizontally aligned within the 
		target content area when using the setTarget method. Defaults to 
		`mui.layout.AlignX.center`.
	**/
	public var alignSelectionX:AlignX;

	/**
		Controls how targeted content is vertically aligned within the target 
		content area when using the setTarget method. Defaults to 
		`mui.layout.AlignY.middle`.
	**/
	public var alignSelectionY:AlignY;

	/**
		Controls whether the behavior will scroll content in a horizontal 
		direction. Defaults to `true`.
	**/
	public var scrollX:Bool;

	/**
		Controls whether the behavior will scroll content in a vertical 
		direction. Defaults to `true`.
	**/
	public var scrollY:Bool;

	var targetX:Null<Int>;
	var targetY:Null<Int>;
	
	var startScrollX:Int;
	var startScrollY:Int;
	
	var velocityX:Float;
	var velocityY:Float;
	
	var cancelled:Bool;
	var activeTween:Tween;

	var realScrollX(default, set_realScrollX):Float;
	function set_realScrollX(value:Float):Float
	{
		if (target != null) target.scrollX = Math.round(value);
		return realScrollX = value;
	}
	
	var realScrollY(default, set_realScrollY):Float;
	function set_realScrollY(value:Float):Float
	{
		if (target != null) target.scrollY = Math.round(value);
		return realScrollY = value;
	}
	
	/**
		Creates a new `ScrollBehavior`, attaching it to the target if 
		supplied.

		@param target An optional display to attach the behavior to.
	**/
	public function new(target:Display)
	{
		super(target);
		
		touchEnabled = true;
		animated = true;
		spring = 0.5;

		alignSelectionX = AlignX.center;
		alignSelectionY = AlignY.middle;
		
		constrainX = true;
		constrainY = true;
		
		inertiaEnabled = true;
		
		velocityX = 0;
		velocityY = 0;
		
		scrollX = true;
		scrollY = true;
		
		realScrollX = 0;
		realScrollY = 0;
	}
	
	/**
		Scrolls the targets content to the position provided.
		
		@param x		The horizontal position to scroll to.
		@param y		The vertical position to scroll to.
		@param animate	Whether to animate the scroll.
	**/
	public function scrollTo(x:Int, y:Int, ?animate:Bool=true)
	{
		if (!enabled) return;
		targetX = x;
		
		if (constrainX)
		{
			targetX = constrain(targetX, target.maxScrollX, 0);
		}
	
		targetY = y;
		
		if (constrainY)
		{
			targetY = constrain(targetY, target.maxScrollY, 0);
		}
		
		if (mui.event.Key.held || !animated)
		{
			animate = false;
		}

		if (tweenSettings != null && tweenSettings.onStart != null)
		{
			tweenSettings.onStart();
		}

		if (animate)
		{
			if (tweenSettings != null)
			{
				activeTween = new Tween(this, {realScrollX:targetX, realScrollY:targetY}, tweenSettings);
				targetX = targetY = null;
			}
			else
			{
				mui.Lib.frameEntered.add(updateInertia);
			}
		}
		else
		{
			if (activeTween != null)
			{
				activeTween.cancel();
				activeTween = null;
			}
			realScrollX = targetX;
			realScrollY = targetY;

			if (tweenSettings != null && tweenSettings.onComplete != null)
			{
				tweenSettings.onComplete();
			}
		}
	}

	/**
		Scrolls the targets content to reveal the provided display.

		@param display The display to reveal.
		@param animate Whether to animate the scroll.
	**/
	public function setTarget(display:Display, ?animate:Bool=true):Void
	{
		var selectionX = 0.0;
		var selectionY = 0.0;
		
		var scrollWidth = target.width;
		var scrollHeight = target.height;
		
		if (target.layout != null)
		{
			scrollWidth -= target.layout.paddingLeft + target.layout.paddingRight;
			scrollHeight -= target.layout.paddingTop + target.layout.paddingBottom;
		}
		
		selectionX = switch (alignSelectionX)
		{
			case left: 0;
			case center: (scrollWidth - display.width) * 0.5;
			case right: scrollWidth- display.width;
		}
		
		selectionY = switch (alignSelectionY)
		{
			case top: 0;
			case middle: (scrollHeight - display.height) * 0.5;
			case bottom: scrollHeight - display.height;
		}
		
		if (target.layout != null)
		{
			selectionX += target.layout.paddingLeft;
			selectionY += target.layout.paddingTop;
		}
		
		var x = Math.round(display.x - selectionX);
		var y = Math.round(display.y - selectionY);
		
		if (x != targetX || y != targetY)
		{
			scrollTo(x, y, animate);
		}
	}
	
	override function add()
	{
		#if touch
		target.touchStarted.add(startScroll);
		#end

		mui.Lib.frameEntered.add(updateInertia);
	}
	
	override function remove()
	{
		#if touch
		target.touchStarted.remove(startScroll);
		#end

		mui.Lib.frameEntered.remove(updateInertia);
	}

	#if touch
	function startScroll(touch:Touch)
	{
		if (!enabled || !touchEnabled) return;
		
		cancelled = false;
		
		velocityX = 0;
		velocityY = 0;
		
		targetX = null;
		targetY = null;
		
		startScrollX = Math.round(realScrollX);
		startScrollY = Math.round(realScrollY);
		
		touch.completed.add(stopScroll);
		touch.updated.add(updateScroll);
		touch.captured.add(cancelScroll);
		
		mui.Lib.frameEntered.remove(updateInertia);
	}
	
	function cancelScroll(touch:Touch)
	{
		cancelled = true;
		
		touch.completed.remove(stopScroll);
		touch.updated.remove(updateScroll);
		mui.Lib.frameEntered.add(updateInertia);
		
		velocityX = velocityY = 0;
		realScrollX = startScrollX;
		realScrollY = startScrollY;
	}
	
	function updateScroll(touch:Touch)
	{
		if (!enabled || cancelled) return;
		
		var deltaX = Math.round(touch.totalChangeX);
		var deltaY = Math.round(touch.totalChangeY);
		
		if (!touch.isCaptured)
		{
			var delta = Math.sqrt(deltaX * deltaX + deltaY * deltaY);
			if (delta > 2)
			{
				var direction = Math.abs(Math.round(Math.atan2(deltaY, deltaX) / (Math.PI / 2))); // / 4 allows diagonal
				if ((scrollX && (direction == 0 || direction == 2)) || (scrollY && direction == 1))
				{
					touch.captured.remove(cancelScroll);
					touch.capture();
				}
			}
		}

		var newX = startScrollX - deltaX;
		var newY = startScrollY - deltaY;
		
		var maxScrollX = target.maxScrollX;
		var maxScrollY = target.maxScrollY;
		
		if (maxScrollX > 0)
		{
			if (constrainX)
			{
				newX = constrain(newX, maxScrollX, spring);
			}
			
			if (scrollX)
			{
				realScrollX = newX;
			}
		}
		
		if (maxScrollY > 0)
		{
			if (constrainY)
			{
				newY = constrain(newY, maxScrollY, spring);
			}
			
			if (scrollY)
			{
				realScrollY = newY;
			}
		}
	}
	
	function stopScroll(touch:Touch)
	{
		velocityX = (scrollX && target.maxScrollX != 0) ? touch.changeX : 0;
		velocityY = (scrollY && target.maxScrollY != 0) ? touch.changeY : 0;
		mui.Lib.frameEntered.add(updateInertia);
	}
	#end
	
	function updateInertia():Void
	{
		if (!enabled) return;
		
		if (!inertiaEnabled)
		{
			if (constrainY && scrollY)
			{
				if (realScrollY < 0) 
					realScrollY = 0;
				else if (target.maxScrollY > 0 && realScrollY > target.maxScrollY)
					realScrollY = target.maxScrollY;
			}
			else if (constrainX && scrollX)
			{
				if (realScrollX < 0) 
					realScrollX = 0;
				else if (target.maxScrollX > 0 && realScrollX > target.maxScrollX)
					realScrollX = target.maxScrollX;
			}
			
			mui.Lib.frameEntered.remove(updateInertia);
			return;
		}
		
		var frictionX = 0.92;
		var frictionY = 0.92;
		var acceleration = 0.4;
		var endX = targetX;
		var endY = targetY;
		var bounceX = false;
		var bounceY = false;

		if (targetX != null)
		{
			velocityX = (realScrollX - targetX) * acceleration;
			frictionX = 1;
		}
		else if (constrainX)
		{
			if (realScrollX < 0) 
			{
				bounceX = realScrollX < -1;
				endX = 0;
				velocityX += realScrollX * 0.1;
				frictionX = 0.6;
			}
			else if (target.maxScrollX > 0 && realScrollX > target.maxScrollX)
			{
				bounceX = realScrollX > target.maxScrollX + 1;
				endX = target.maxScrollX;
				velocityX += (realScrollX - endX) * 0.1;
				frictionX = 0.6;
			}

			if (spring == 0)
			{
				if (realScrollX <= 0)
				{
					velocityX = 0;
					realScrollX = 0;
				}
				else if (realScrollX >= target.maxScrollX)
				{
					velocityX = 0;
					realScrollX = target.maxScrollX;
				}
			}
		}
		
		if (targetY != null)
		{
			velocityY = (realScrollY - targetY) * acceleration;
			frictionY = 1;
		}
		else if (constrainY)
		{
			if (realScrollY < 0)
			{
				bounceY = realScrollY < -1;
				endY = 0;
				velocityY += realScrollY * 0.1;
				frictionY = 0.6;
			}
			else if (target.maxScrollY > 0 && realScrollY > target.maxScrollY)
			{
				bounceY = realScrollY > target.maxScrollY + 1;
				endY = target.maxScrollY;
				velocityY += (realScrollY - endY) * 0.1;
				frictionY = 0.6;
			}

			if (spring == 0)
			{
				if (realScrollY <= 0)
				{
					velocityY = 0;
					realScrollY = 0;
				}
				else if (realScrollY >= target.maxScrollY)
				{
					velocityY = 0;
					realScrollY = target.maxScrollY;
				}
			}
		}
		
		if (scrollX)
		{
			velocityX *= frictionX;
			
			if (!bounceX && Math.abs(velocityX) < 0.2)
			{
				if (endX != null)
					realScrollX = endX;
				else
					realScrollX -= velocityX;
				
				velocityX = 0;
			}
			else
			{
				realScrollX -= velocityX;
			}
		}
		
		if (scrollY)
		{
			velocityY *= frictionY;

			if (!bounceY && Math.abs(velocityY) < 0.2)
			{
				if (endY != null)
					realScrollY = endY;
				else
					realScrollY -= velocityY;
				velocityY = 0;
			}
			else
			{
				realScrollY -= velocityY;
			}
		}
		
		if (velocityX == 0 && velocityY == 0)
		{
			mui.Lib.frameEntered.remove(updateInertia);
		}
	}
	
	function constrain(value:Int, maxValue:Int, spring:Float):Int
	{
		if (value < 0)
		{
			return Math.round(value * spring);
		}
		
		if (value > maxValue)
		{
			return Math.round(maxValue + ((value - maxValue) * spring));
		}
		
		return value;
	}
}
