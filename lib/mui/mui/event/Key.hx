package mui.event;

import haxe.ds.IntMap;
import haxe.Timer;

import msignal.Signal;
import mui.event.Input;

enum KeyAction
{
	UNKNOWN;
	LEFT;
	RIGHT;
	UP;
	DOWN;
	NEXT;
	PREVIOUS;
	OK;
	HOME;
	BACK;
	DEBUG;
	INFORMATION;
	EXIT;
	FAST_FORWARD;
	FAST_BACKWARD;
	SKIP_FORWARD;
	SKIP_BACKWARD;
	PLAY_PAUSE;
	PLAY;
	PAUSE;
	STOP;
	RECORD;
	SPACE;
	RED;
	GREEN;
	YELLOW;
	BLUE;
	CHANNEL_UP;
	CHANNEL_DOWN;
	VOLUME_UP;
	VOLUME_DOWN;
	VOLUME_MUTE;
	NUMBER(n:Int);
}

class Key extends Input
{
	public static var manager:KeyManager = new KeyManager();

	// deprecated
	public static var held(get_held, null):Bool;
	static function get_held():Bool { return manager.held; }

	public static var map(get_map, null):KeyMapBase;
	static function get_map():KeyMapBase { return manager.map; }

	public static var pressed(get_pressed, null):Signal1<Key>;
	static function get_pressed() { return manager.pressed; }

	public static var released(get_released, null):Signal1<Key>;
	static function get_released() { return manager.released; }

	public static function isDown(keyCode:Int) { return manager.isDown(keyCode); }
	public static function press(key:Key) { manager.press(key); }
	public static function release(key:Key) { manager.release(key); }

	public var code(default, null):Int;
	public var action(get_action, null):KeyAction;
	public var pressCount:Int;

	var keyAction:KeyAction;

	public function new(keyCode:Int, ?keyAction:KeyAction)
	{
		super();

		this.code = keyCode;
		this.keyAction = keyAction;
		this.pressCount = 0;
	}

	function get_action():KeyAction
	{
		if (keyAction != null) return keyAction;
		return manager.map.get(code);
	}

	public function toString():String
	{
		return "Key[" + code + ", " + action + "]x" + pressCount;
	}
}

class KeyManager
{
	inline public static var DEFAULT_HOLD_DELAY:Int = 600;
	inline public static var DEFAULT_HOLD_INTERVAL:Int = 200;

	static var previousPressCount:Int = 0;
	static var realPressCount:Int = 0;

	#if samsung
	static inline var MAX_SECS_WITHOUT_PRESS_BEFORE_RELEASE = 1;
	#end

	public var held(default, null):Bool;
	public var map(default, set_map):KeyMapBase;

	public var holdDelay:Int;
	public var holdInterval:Int;

	public var pressed(default, null):Signal1<Key>;
	public var released(default, null):Signal1<Key>;

	var pressedKeys:IntMap<Bool>;
	var timer:Timer;

	var currentKey:Key;
	var pressCount:Int;

	var lastPressEventTime:Float;

	public function new()
	{
		held = false;
		pressedKeys = new IntMap();

		holdDelay = DEFAULT_HOLD_DELAY;
		holdInterval = DEFAULT_HOLD_INTERVAL;

		pressed = new Signal1<Key>(Key);
		released = new Signal1<Key>(Key);
	}

	public function isDown(keyCode:Int)
	{
		return pressedKeys.exists(keyCode);
	}

	public function press(key:Key)
	{
		realPressCount ++;
		
		lastPressEventTime = Timer.stamp();

		if (currentKey != null)
		{
			if (key.code != currentKey.code)
			{
				release(currentKey);
			}
		}

		if (currentKey != null) return;

		held = false;
		currentKey = key;
		pressedKeys.set(key.code, true);
		pressCount = 0;
		
		dispatchPress(key);
		previousPressCount = realPressCount;
		mui.core.Node.validator.validate();
	}

	function dispatchPress(key:Key)
	{
		#if (key && touch)
		if (Input.mode != KEY)
		{
			var inputModeKnown = (Input.mode != null);
			Input.setMode(KEY);
			if (inputModeKnown)
			{
				switch (key.action)
				{
					// Don't action anything until current focus has been presented
					case OK, UP, DOWN, LEFT, RIGHT: return;
					default:
				}
			}
		}
		#end
		
		#if samsung
		// Note(Dom, feb 2013): This has been migrated from the samsung module.
		// Note(original): Samsung Maple browser has a bug where key release may not ever come through.
        // Here we add a fail safe to ensure that we end auto-key repeat if no press event
        // has come through for a defined period.
        // For more bug details see 4th comment: https://jira.massiveinteractive.com/browse/BTBRIM-756
        if (pressCount > 1 && (Timer.stamp() - lastPressEventTime) >= MAX_SECS_WITHOUT_PRESS_BEFORE_RELEASE)
        {
            release(key);
            return;
        }
        #end

		pressCount += 1;
		held = pressCount > 1;
		key.pressCount = pressCount;
		key.isCaptured = false;

		Input.setMode(KEY);
		pressed.dispatch(key);

		if (Focus.current != null)
		{
			#if key
			Focus.current.keyPress(key);
			#end
		}

		resetTimer();
		
		if (realPressCount > previousPressCount)
		{
			var delay = pressCount == 1 ? holdDelay : holdInterval;
			timer = Timer.delay(dispatchPress.bind(key), delay);
		}
	}

	public function release(key:Key)
	{
		if (currentKey != null && key.code == currentKey.code)
		{
			dispatchRelease(key);
			mui.core.Node.validator.validate();
		}
	}

	function dispatchRelease(key:Key)
	{
		held = false;
		currentKey = null;
		pressedKeys.remove(key.code);
		pressCount = 0;

		released.dispatch(key);

		if (Focus.current != null)
		{
			#if key
			Focus.current.keyRelease(key);
			#end
		}

		resetTimer();
	}

	function set_map(value:KeyMapBase):KeyMapBase
	{
		mui.util.Assert.that(value != null, "argument `value` cannot be `null`");
		map = value;
		return map;
	}

	function resetTimer()
	{
		if (timer != null)
		{
			timer.stop();
			timer = null;
		}
	}
}
