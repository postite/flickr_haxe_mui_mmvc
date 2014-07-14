package mui.event;

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
		set(KeyCode.BACKSPACE, BACK);
		set(KeyCode.SPACE, SPACE);
		set(KeyCode.PERIOD, DEBUG);
		
		set(KeyCode.LETTER_R, RED);
		set(KeyCode.LETTER_G, GREEN);
		set(KeyCode.LETTER_Y, YELLOW);
		set(KeyCode.LETTER_B, BLUE);

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
	inline public static var TAB = 9;
	inline public static var ESC = 27;
	inline public static var LEFT = 37;
	inline public static var UP = 38;
	inline public static var RIGHT = 39;
	inline public static var DOWN = 40;
	inline public static var ENTER = 13;
	inline public static var BACKSPACE = 8;
    inline public static var SPACE = 32;
	inline public static var DELETE = 46;
	inline public static var ASTERIX = 106;
	inline public static var PLUS = 107;
	inline public static var MINUS = 109;
	inline public static var PAGE_UP = 33;
	inline public static var PAGE_DOWN = 34;
	inline public static var PERIOD = 190;
	inline public static var SHIFT = 16;
	
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
	
	// letter
	inline public static var LETTER_A = 65;
	inline public static var LETTER_B = 66;
	inline public static var LETTER_C = 67;
	inline public static var LETTER_D = 68;
	inline public static var LETTER_E = 69;
	inline public static var LETTER_F = 70;
	inline public static var LETTER_G = 71;
	inline public static var LETTER_H = 72;
	inline public static var LETTER_I = 73;
	inline public static var LETTER_J = 74;
	inline public static var LETTER_K = 75;
	inline public static var LETTER_L = 76;
	inline public static var LETTER_M = 77;
	inline public static var LETTER_N = 78;
	inline public static var LETTER_O = 79;
	inline public static var LETTER_P = 80;
	inline public static var LETTER_Q = 81;
	inline public static var LETTER_R = 82;
	inline public static var LETTER_S = 83;
	inline public static var LETTER_T = 84;
	inline public static var LETTER_U = 85;
	inline public static var LETTER_V = 86;
	inline public static var LETTER_W = 87;
	inline public static var LETTER_X = 88;
	inline public static var LETTER_Y = 89;
	inline public static var LETTER_Z = 90;
}
