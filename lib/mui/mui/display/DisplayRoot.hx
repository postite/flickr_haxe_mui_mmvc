package mui.display;

import mui.event.Screen;
import mui.util.Param;

#if touch
import mui.event.Touch;
#end

#if key
import mui.event.Key;
#end

#if (flash || openfl)
import flash.display.Stage;
import flash.display.StageScaleMode;
import flash.display.StageAlign;
import flash.display.StageQuality;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.KeyboardEvent;
#end

#if (flash)
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;
#end

/**
	The root of a display hierarchy, accessed through `Lib.displayRoot`,
**/
class DisplayRoot extends Rectangle
{
	inline static var DEFAULT_FRAME_RATE = 16;

	#if touch
	var touch:Touch;
	var previousMouseX:Int;
	var previousMouseY:Int;
	#end

	var defaultFrameRate:Int;
	
	public function new()
	{
		super();
		defaultFrameRate = DEFAULT_FRAME_RATE;
		
		#if touch
		previousMouseX = 0;
		previousMouseY = 0;
		#end
	}

	#if touch
	function checkMouseMove()
	{
		if (enabled && (mouseX != previousMouseX || mouseY != previousMouseY))
		{
			mui.Lib.mouseMoved.dispatch();

			if (touch != null)
			{
				touch.updatePosition(mouseX, mouseY);
			}
			previousMouseX = mouseX;
			previousMouseY = mouseY;
		}
	}
	#end

	public function setDefaultFrameRate(value:Int)
	{
		defaultFrameRate = value;
	}

////////////////////////////////////////////////////////////////////////////////
#if js
////////////////////////////////////////////////////////////////////////////////
	
	var document:Dynamic;
	var window:Dynamic;
	var eventListeners:Array<Dynamic>;

	override function _new()
	{
		super._new();
		eventListeners = [];

		document = js.Browser.document;
		window = js.Browser.window;

		var body = document.body;

		// attach to document
		body.appendChild(element);

		#if key
		// key
		addEventListener(window, "keydown", keyDown);
		addEventListener(window, "keyup", keyUp);
		#end

		#if touch
		// Add either touch or mouse listeners but not both as causes double click where both are supported.
		if (Reflect.hasField(document, 'ontouchstart'))
		{
			addEventListener(body, "touchstart", _touchStart);
			addEventListener(body, "touchend", _touchEnd);
			addEventListener(body, "touchmove", _touchMove);
		}
		else
		{
			addEventListener(body, "mousedown", mouseDown);
			addEventListener(body, "mouseup", mouseUp);
			addEventListener(body, "mousemove", mouseMove);
		}
		#end

		// screen
		addEventListener(window, "resize", resize);

		if (Reflect.hasField(window, "orientation"))
		{
			var orientation = angleToOrientation((untyped window).orientation);
			Screen.reorient(orientation);
			addEventListener(window, "orientationchange", reorient);
		}

		// set initial size
		width = window.innerWidth;
		height = window.innerHeight;

		Screen.resize(width, height);
		untyped window.requestAnimationFrame(enterFrame, element);
	}

	override function destroy()
	{
		removeAllEventListeners();
		super.destroy();
	}

	function enterFrame()
	{
		#if touch
		checkMouseMove();
		#end
		mui.Lib.frameEntered.dispatch();
		mui.Lib.frameRendered.dispatch();
		untyped window.requestAnimationFrame(enterFrame, element);
	}

	#if key
	function keyDown(e)
	{
		if (!enabled) return;
		var keyCode = e.keyCode;
		var key = new Key(keyCode);

		Key.press(key);
		if (key.isCaptured) cancelEvent(e);
	}

	function keyUp(e)
	{
		if (!enabled) return;
		var keyCode = e.keyCode;
		var key = new Key(keyCode);

		Key.release(key);
		if (key.isCaptured) cancelEvent(e);
	}
	#end

	#if touch
	function mouseDown(e)
	{
		if (!enabled || Reflect.hasField(e, "button") && e.button != 0) return;

		mouseX = e.clientX;
		mouseY = e.clientY;

		touch = new Touch(e.clientX, e.clientY);
		Touch.start(touch);
	}

	function mouseUp(e)
	{
		if (!enabled) return;

		if (touch != null)
		{
			touch.complete();
			touch = null;
		}
	}

	function mouseMove(e)
	{
		if (!enabled) return;

		mouseX = e.clientX;
		mouseY = e.clientY;
	}

	function _touchStart(e)
	{
		mouseDown(e.touches[0]);
	}

	function _touchEnd(e)
	{
		mouseUp(e.touches[0]);
	}

	function _touchMove(e)
	{
		mouseMove(e.touches[0]);
	}
	#end


	function resize(e)
	{
		width = window.innerWidth;
		height = window.innerHeight;
		mui.core.Node.validator.validate();
		Screen.resize(width, height);
	}

	function reorient(e)
	{
		var newOrientation = angleToOrientation(window.orientation);
		Screen.reorient(newOrientation);
	}

	function angleToOrientation(angle:Int):ScreenOrientation
	{
		return switch(angle)
		{
			case 90: LandscapeRight;
			case 180: PortraitUpsideDown;
			case -90: LandscapeLeft;
			default: Portrait;
		}
	}

	function addEventListener(element:Dynamic, event:String, handler:Dynamic)
	{
		var obj = {element:element, event:event, handler:Dynamic};
		eventListeners.push(obj);
		element.addEventListener(event, handler, false);
	}

	function removeAllEventListeners()
	{
		for (obj in eventListeners)
		{
			removeEventListener(obj.element, obj.event, obj.handler);
		}
		eventListeners = [];
	}

	function removeEventListener(element:Dynamic, event:String, handler:Dynamic)
	{
		element.removeEventListener(event, handler, false);
	}


	function cancelEvent(event:Dynamic)
	{
		event.preventDefault();
		event.stopPropagation();
	}

////////////////////////////////////////////////////////////////////////////////
#elseif (flash || openfl)
////////////////////////////////////////////////////////////////////////////////
	
	override function _new()
	{
		super._new();

		var stage = flash.Lib.current.stage;
		
		// add to current
		flash.Lib.current.addChild(sprite);
		
		#if !openfl
		// add build info context menu item
		var menu = new ContextMenu();
		menu.hideBuiltInItems();

		// add build params if available
		if (Param.isAvailable)
		{
			menu.customItems = [
				new ContextMenuItem(Param.get("app")),
				new ContextMenuItem(Param.get("build"))
			];
		}
		
		flash.Lib.current.contextMenu = menu;
		#end
		
		// setup stage
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		stage.quality = StageQuality.BEST;
		stage.stageFocusRect = false;
		stage.addEventListener(flash.events.Event.RESIZE, resize);
		
		// set initial size
		width = stage.stageWidth;
		height = stage.stageHeight;

		Screen.resize(width, height);
		
		stage.addEventListener(Event.ENTER_FRAME, enterFrame);
		stage.addEventListener(Event.RENDER, renderFrame);

		#if touch
		stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
		stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
		#end

		#if key
		stage.addEventListener(flash.events.KeyboardEvent.KEY_DOWN, keyDown);
		stage.addEventListener(flash.events.KeyboardEvent.KEY_UP, keyUp);
		#end
	}

	override function destroy()
	{
		var stage = flash.Lib.current.stage;

		stage.removeEventListener(Event.ENTER_FRAME, enterFrame);
		stage.removeEventListener(Event.RENDER, renderFrame);

		#if touch
		stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
		stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
		#end

		#if key
		stage.removeEventListener(flash.events.KeyboardEvent.KEY_DOWN, keyDown);
		stage.removeEventListener(flash.events.KeyboardEvent.KEY_UP, keyUp);
		#end

		super.destroy();
	}

	function enterFrame(e)
	{
		#if touch
		checkMouseMove();
		#end
		mui.Lib.frameEntered.dispatch();
		sprite.stage.invalidate();
	}

	function renderFrame(e)
	{
		mui.Lib.frameRendered.dispatch();
	}

	#if touch
	function mouseDown(e)
	{
		if (!enabled) return;

		touch = new Touch(e.stageX, e.stageY);
		Touch.start(touch);
	}

	function mouseUp(e)
	{
		if (!enabled) return;

		if (touch != null)
		{
			touch.complete();
			touch = null;
		}
	}
	#end

	#if key
	function keyDown(e)
	{
		var key = new Key(e.keyCode);
		Key.press(key);
		
		if (key.isCaptured)
		{
			e.stopPropagation();
			#if !openfl 
			e.preventDefault(); 
			#end
		}
	}

	function keyUp(e)
	{
		var key = new Key(e.keyCode);
		Key.release(key);
		
		if (key.isCaptured)
		{
			e.stopPropagation();
			#if !openfl 
			e.preventDefault(); 
			#end
		}
	}
	#end
	
	function resize(e)
	{
		if (sprite.stage == null) return;
		
		width = sprite.stage.stageWidth;
		height = sprite.stage.stageHeight;

		Screen.resize(width, height);
	}
#end
}
