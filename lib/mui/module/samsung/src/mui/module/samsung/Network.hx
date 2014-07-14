package mui.module.samsung;

#if !browser
extern
#end
class Network
{
	inline public static var TYPE_NONE = -1;
	inline public static var TYPE_WIRELESS = 0;
	inline public static var TYPE_WIRED = 1;

	inline public static var DNS_MODE_AUTO = 0;
	inline public static var DNS_MODE_MANUAL = 1;

	public function new():Void {}

	public function CheckDNS(type:Int):Int { return 1; }
	public function CheckGateway(type:Int):Int { return 1; }
	public function CheckHTTP(type:Int):Int { return 1; }
	public function CheckPhysicalConnection(type:Int):Int { return 1; }
	public function GetActiveType():Int { return 1; }
	public function GetDNS(?type:Int):String { return "8.8.8.8"; }
	public function GetDNSMode(type:Int):Int { return 1; }
	public function GetGateway(type:Int):String { return ""; }
	public function GetIP(type:Int):String { return "127.127.1.1"; }
	public function GetIPMode(type:Int):Int { return 1; }
	public function GetMAC(?type:Int):String { return "d4:9a:20:e2:5b:ea"; }
	public function GetNetMask(?type:Int):String { return ""; }
	public function IsValidDNS(type:Int):Int { return 1; }
	public function IsValidGateway(type:Int):Int { return 1; }
	public function IsValidIP(type:Int):Int { return 1; }
	public function IsValidMAC(type:Int):Int { return 1; }
	public function IsValidSubnetMask(type:Int):Int { return 1; }
	public function SetDNSMode(type:Int, mode:Int):Int { return 1; }
	public function SetIPMode(type:Int, mode:Int):Int { return 1; }
}
