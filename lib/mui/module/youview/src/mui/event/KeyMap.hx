package mui.event;

import mui.event.Key;

class KeyMap extends KeyMapBase
{
	public function new()
	{
		super();

		set(KeyCode.LEFT, LEFT);
		set(KeyCode.RIGHT, RIGHT);
		set(KeyCode.UP, UP);
		set(KeyCode.DOWN, DOWN);
		set(KeyCode.ENTER, OK);
		set(KeyCode.BACK, BACK);
		set(KeyCode.REWIND, FAST_BACKWARD);
		set(KeyCode.FAST_FORWARD, FAST_FORWARD);
		set(KeyCode.PLAY, PLAY);
		set(KeyCode.PAUSE, PAUSE);
		set(KeyCode.STOP, STOP);
		
		set(KeyCode.INFO, INFORMATION);
		
		set(KeyCode.RED, RED);
		set(KeyCode.GREEN, GREEN);
		set(KeyCode.YELLOW, YELLOW);
		set(KeyCode.BLUE, BLUE);
		set(KeyCode.CHANNEL_UP, CHANNEL_UP);
		set(KeyCode.CHANNEL_DOWN, CHANNEL_DOWN);
		
		set(KeyCode.NUMBER_0, NUMBER(0));
		set(KeyCode.NUMBER_1, NUMBER(1));
		set(KeyCode.NUMBER_2, NUMBER(2));
		set(KeyCode.NUMBER_3, NUMBER(3));
		set(KeyCode.NUMBER_4, NUMBER(4));
		set(KeyCode.NUMBER_5, NUMBER(5));
		set(KeyCode.NUMBER_6, NUMBER(6));
		set(KeyCode.NUMBER_7, NUMBER(7));
		set(KeyCode.NUMBER_8, NUMBER(8));
		set(KeyCode.NUMBER_9, NUMBER(9));
	}
}

extern class KeyCode
{
	// special
	inline public static var LEFT = 37;
	inline public static var UP = 38;
	inline public static var RIGHT = 39;
	inline public static var DOWN = 40;
	inline public static var ENTER = 13;
	
	inline public static var HELP = 16777245;
	inline public static var SEARCH = 16777247;
	inline public static var BACK = 16777238;
	
	inline public static var AUDIO_DESCRIPTION = 16777239;
	inline public static var DELETE = 16777240;
	
	inline public static var INFO = 16777235;
	
	//transport
	inline public static var SKIP_BACKWARD = 16777229;
	inline public static var SKIP_FORWARD = 16777228;
	inline public static var REWIND = 16777227;
	inline public static var FAST_FORWARD = 16777226;
	inline public static var PAUSE = 16777224;
	inline public static var PLAY = 16777223;
	inline public static var STOP = 16777235;
	
	inline public static var CHANNEL_UP = 16777220;
	inline public static var CHANNEL_DOWN = 16777221;
	
	//Colour keys
	inline public static var RED = 16777216;
	inline public static var GREEN = 16777217;
	inline public static var YELLOW = 16777218;
	inline public static var BLUE = 16777219;
	
	// number
	inline public static var NUMBER_0 = 48;
	inline public static var NUMBER_1 = 49;
	inline public static var NUMBER_2 = 50;
	inline public static var NUMBER_3 = 51;
	inline public static var NUMBER_4 = 52;
	inline public static var NUMBER_5 = 53;
	inline public static var NUMBER_6 = 54;
	inline public static var NUMBER_7 = 55;
	inline public static var NUMBER_8 = 56;
	inline public static var NUMBER_9 = 57;
	
	inline public static var BACKSPACE = DELETE; //TODO: This is a workaround because TextInput.hx has a reference to BACKSPACE.
}
