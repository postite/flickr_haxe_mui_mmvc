package mui.module.samsung;

import mui.event.Key;

class KeyMap extends mui.event.KeyMapBase
{
	var plugin:Plugin;

	public function new()
	{
		super();
		
		plugin = Device.getPlugin();

		set(KeyCode.ENTER, KeyAction.OK);
		set(KeyCode.RETURN, KeyAction.BACK);
		set(KeyCode.LEFT, KeyAction.LEFT);
		set(KeyCode.RIGHT, KeyAction.RIGHT);
		set(KeyCode.UP, KeyAction.UP);
		set(KeyCode.DOWN, KeyAction.DOWN);

		set(KeyCode.PLAY, KeyAction.PLAY);
		set(KeyCode.PAUSE, KeyAction.PAUSE);
		set(KeyCode.STOP, KeyAction.STOP);
		set(KeyCode.FAST_FORWARD, KeyAction.FAST_FORWARD);
		set(KeyCode.REWIND, KeyAction.FAST_BACKWARD);
		set(KeyCode.RECORD, KeyAction.RECORD);

		set(KeyCode.VOLUME_UP, KeyAction.VOLUME_UP);
		set(KeyCode.VOLUME_DOWN, KeyAction.VOLUME_DOWN);
		set(KeyCode.VOLUME_MUTE, KeyAction.VOLUME_MUTE);

		set(KeyCode.CHANNEL_UP, KeyAction.CHANNEL_UP);
		set(KeyCode.CHANNEL_DOWN, KeyAction.CHANNEL_DOWN);

		set(KeyCode.RED, KeyAction.RED);
		set(KeyCode.GREEN, KeyAction.GREEN);
		set(KeyCode.YELLOW, KeyAction.YELLOW);
		set(KeyCode.BLUE, KeyAction.BLUE);

		set(KeyCode.INFO, KeyAction.INFORMATION);
		set(KeyCode.EXIT, KeyAction.EXIT);

		set(KeyCode.NUMBER_0, KeyAction.NUMBER(0));
		set(KeyCode.NUMBER_1, KeyAction.NUMBER(1));
		set(KeyCode.NUMBER_2, KeyAction.NUMBER(2));
		set(KeyCode.NUMBER_3, KeyAction.NUMBER(3));
		set(KeyCode.NUMBER_4, KeyAction.NUMBER(4));
		set(KeyCode.NUMBER_5, KeyAction.NUMBER(5));
		set(KeyCode.NUMBER_6, KeyAction.NUMBER(6));
		set(KeyCode.NUMBER_7, KeyAction.NUMBER(7));
		set(KeyCode.NUMBER_8, KeyAction.NUMBER(8));
		set(KeyCode.NUMBER_9, KeyAction.NUMBER(9));        
	}

	override public function set(keyCode:Int, action:KeyAction)
	{
		super.set(keyCode, action);
		// plugin.registKey(keyCode);
	}
	
	override public function remove(keyCode:Int)
	{
		super.remove(keyCode);
		// plugin.unregistKey(keyCode);
	}
}
