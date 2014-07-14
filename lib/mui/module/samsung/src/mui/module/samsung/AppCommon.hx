package mui.module.samsung;

#if !browser
extern
#end
class AppCommon
{
	inline public static var MESSAGE_APP_DEACTIVE = 0;
	inline public static var MESSAGE_APP_ACTIVE = 1;
	inline public static var MESSAGE_APP_INITIALIZED = 2;
	inline public static var MESSAGE_START_XLET_BY_APPLIST = 3;
	inline public static var MESSAGE_TIMEZONE_CHANGED = 4;
	inline public static var MESSAGE_XLET_SHOW_STATE_CHANGE = 5;
	inline public static var MESSAGE_JAM_INITIALIZED = 6;
	inline public static var MESSAGE_CHANGE_TV_MODE_START = 7;
	inline public static var MESSAGE_CHANGE_BURNPROOF_TIME = 8;
	inline public static var MESSAGE_CHANGE_DATASERVICE_AUTO_LAUNCH = 9;
	inline public static var MESSAGE_NOTIFY_BANNER_HIDE = 10;
	inline public static var MESSAGE_DATASERVICE_PREPARE = 11;
	inline public static var MESSAGE_DATASERVICE_RECEIVE = 12;
	inline public static var MESSAGE_DATASERVICE_ERROR = 13;
	inline public static var MESSAGE_DATASERVICE_HIDE = 14;
	inline public static var MESSAGE_POWER_ON_FROM_STANDBY = 15;
	inline public static var MESSAGE_POWER_ON_BY_WAKEUP_UPGRADE = 16;
	inline public static var MESSAGE_POWER_ON_BY_WAKEUP_STANDBY = 17;
	inline public static var MESSAGE_NOTIFY_POWER_OFF = 18;
	inline public static var MESSAGE_RESET_TIME = 19;
	inline public static var MESSAGE_CHANGE_CHILDLOCK = 20;
	inline public static var MESSAGE_CHANGE_RATING_BLOCK = 21;
	inline public static var MESSAGE_CHANGE_AUDIO_LANGUAGE = 22;
	inline public static var MESSAGE_INPUT_OCCUR = 23;
	inline public static var MESSAGE_SWD_START = 24;
	inline public static var MESSAGE_SWD_END = 25;
	inline public static var MESSAGE_SWD_START_YES = 26;
	inline public static var MESSAGE_SWD_START_NO = 27;
	inline public static var MESSAGE_CC_DATA_SUBSCRIBE = 28;
	inline public static var MESSAGE_CC_DATA = 29;
	inline public static var MESSAGE_AUTO_MOTION_DEMO_ON = 30;
	inline public static var MESSAGE_AUTO_MOTION_DEMO_OFF = 31;
	inline public static var MESSAGE_MOVIE_PLUS_DEMO_ON = 32;
	inline public static var MESSAGE_MOVIE_PLUS_DEMO_OFF = 33;
	inline public static var MESSAGE_REAL_DEMO_ON = 34;
	inline public static var MESSAGE_REAL_DEMO_OFF = 35;
	inline public static var MESSAGE_LED_DEMO_ON = 36;
	inline public static var MESSAGE_LED_DEMO_OFF = 37;
	inline public static var MESSAGE_SMOOTHMOTION_DEMO_ON = 38;
	inline public static var MESSAGE_SMOOTHMOTION_DEMO_OFF = 39;
	inline public static var MESSAGE_WAKEUP_UPGRADE_START = 40;
	inline public static var MESSAGE_POWER_OFF_START = 41;
	inline public static var MESSAGE_REMIND_RECORD = 42;
	inline public static var MESSAGE_IME_INPUT_WAIT_START = 43;
	inline public static var MESSAGE_IME_INPUT_WAIT_END = 44;
	inline public static var MESSAGE_IME_INPUT = 45;

	public function new():Void {}

	public function CheckReservedKey(key:Int):Int { return 0; }
	public function IsKeyRegister(key:Int):Int { return 0; }
	
	public function RegisterKey(key:Int):Int { return 1; }
	public function RegisterAllKey():Int { return 1; }
	public function RegisterColorKey():Int { return 1; }
	public function RegisterNaviKey():Int { return 1; }
	public function RegisterNumKey():Int { return 1; }
	public function RegisterPlaybackKey():Int { return 1; }

	public function UnregisterAllKey():Int { return 1; }
	public function UnregisterColorKey():Int { return 1; }
	public function UnregisterNaviKey():Int { return 1; }
	public function UnregisterKey(key:Int):Int { return 1; }
	public function UnregisterNumKey():Int { return 1; }
	public function UnregisterPlaybackKey():Int { return 1; }

	public function SendKeyToTVViewer():Int { return 1; }
	public function SendEvent_IME(start:Int, inputType:Int, charType:Int, option:Int):Int { return 1; }
	public function SendEvent_IME_Sync(string:String):Int { return 1; }

	public function SubscribeEvent(message:Int):Int { return 1; }
	public function UnsubscribeEvent(message:Int):Int { return 1; }

	public var OnMessage:String -> Void;
}
