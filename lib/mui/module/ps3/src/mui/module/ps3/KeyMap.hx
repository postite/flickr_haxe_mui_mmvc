package mui.module.ps3;

import mui.event.Key;

class KeyMap extends mui.event.KeyMapBase
{
	public function new()
	{
		super();
		
		set(KeyCode.INFORMATION, KeyAction.INFORMATION);
		set(KeyCode.ENTER, KeyAction.OK);
		
		set(KeyCode.CROSS, KeyAction.OK);
		set(KeyCode.CIRCLE, KeyAction.BACK);
		
		set(KeyCode.LEFT, KeyAction.LEFT);
		set(KeyCode.RIGHT, KeyAction.RIGHT);
		set(KeyCode.UP, KeyAction.UP);
		set(KeyCode.DOWN, KeyAction.DOWN);
		
		set(KeyCode.PLAY, KeyAction.PLAY);
		set(KeyCode.PAUSE, KeyAction.PAUSE);
		set(KeyCode.STOP, KeyAction.STOP);

		set(KeyCode.FAST_FORWARD, KeyAction.FAST_FORWARD);
		set(KeyCode.FAST_BACKWARD, KeyAction.FAST_BACKWARD);
		
		set(KeyCode.CHANNEL_UP, KeyAction.CHANNEL_UP);
		set(KeyCode.CHANNEL_DOWN, KeyAction.CHANNEL_DOWN);

		set(KeyCode.RED, KeyAction.RED);
		set(KeyCode.GREEN, KeyAction.GREEN);
		set(KeyCode.YELLOW, KeyAction.YELLOW);
		set(KeyCode.BLUE, KeyAction.BLUE);
	}	
}
