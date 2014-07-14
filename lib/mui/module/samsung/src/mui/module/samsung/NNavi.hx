package mui.module.samsung;

#if !browser
extern
#end
class NNavi
{
	inline public static var PL_NNAVI_PATH_WIDGET_MANAGER = 0;
	inline public static var PL_NNAVI_PATH_WIDGET_NORMAL = 1;

	inline public static var PL_ST_SERVICE = 0;
	inline public static var PL_ST_DEVELOPMENT = 1;
	inline public static var PL_ST_DEVELOPING = 2;

	inline public static var PL_NNAVI_SYSTEM_VERSION_LEEUM = 0;
	inline public static var PL_NNAVI_SYSTEM_VERSION_COMP = 1;

	public function new():Void {}

	public function ActivateReady():Bool { return true; }
	public function ActivateWithData(type:Int, data:String):Bool { return true; }
	public function ChangeWidgetManager():Bool { return true; }
	public function GetAppKey():String { return "AppKey"; }
	public function GetDUID(mac:String):String { return "U7CB3EXSFCVQC"; }
	public function GetFirmware():String { return "T-SPHAKRC-1000"; }
	public function GetModelCode():String { return "LNXXB650_KOR"; }
	public function GetPath(type:Int):String { return ""; }
	public function GetRemoconType():Int { return 0; }
	public function GetServerType():Int { return 0; }
	public function GetSupportPIG():Int { return 0; }
	public function GetSystemVersion(type:Int):String { return ""; }
	public function GetToken(sessionID:String, userID:String, seed:String):String { return ""; }
	public function ResetWidgetData():Int { return 0; }
	public function SendEventToDevice(event:Int, data:String):Bool { return true; }
	public function SetBannerState(state:Int):Bool { return true; }
}
