package mui.module.samsung;

#if !browser
extern
#end
class TVMW
{
	inline public static var PRFID_TICKER_ID = 0;
	inline public static var PRFID_CHILDLOCK_PIN = 1;
	inline public static var PRFID_HUB_TVID = 2;
	inline public static var PRFID_TICKER_AUTOBOOT = 3;
	inline public static var PRFID_TICKER_DURATION = 4;
	inline public static var PRFID_WIDGET_DPTIME = 5;
	inline public static var PRFID_CONTRACT = 6;
	inline public static var PRFID_TICKER_SAFE = 7;
	inline public static var PRFID_RESET = 8;
	inline public static var PRFID_PASSWD_RESET = 9;
	inline public static var PRFID_GEOIP_STATUS = 10;
	inline public static var PRFID_COUNTRY_CODE = 11;
	inline public static var PRFID_WLAN_DEFAULT_NETWORK = 12;
	inline public static var PRFID_AUTO_PROTECTION_TIME = 13;
	inline public static var PRFID_CHANNEL_BOUND_EXECUTE = 14;

	public function new():Void {}

	public function GetProfile(id:String):String { return ""; }
	public function SetProfile(id:String, value:String):Int { return 1; }
}
