package mui.module.samsung;

#if !browser
extern
#end
class Player
{
	inline public static var APS_ALL_OFF = 0;
	inline public static var APS_AGC_ON_ONLY = 1;
	inline public static var APS_AGC_ON_CS_2L = 2;
	inline public static var APS_AGC_ON_CS_4L = 3;

	inline public static var CGMS_COPY_FREE = 0;
	inline public static var CGMS_COPY_NO_MORE = 1;
	inline public static var CGMS_COPY_ONCE = 2;
	inline public static var CGMS_COPY_NEVER = 3;

	inline public static var PROPERTY_COOKIE = 1;

	public function new():Void
	{
		style = {};
	}

	public var style(default, null):Dynamic;

	public var OnStreamInfoReady:String;
	public var OnBufferingStart:String;
	public var OnBufferingComplete:String;
	public var OnCurrentPlayTime:String;
	public var OnRenderingComplete:String;

	public var OnNetworkDisconnected:String;
	public var OnStreamNotFound:String;
	public var OnConnectionFailed:String;
	public var OnRenderError:String;
	public var OnAuthenticationFailed:String;

	public function InitPlayer(url:String):Bool { return true; }
	public function StartPlayback(?seekTime:Float):Void {}
	public function ResumePlay(url:String, seekTime:Float):Bool { return true; }
	public function Resume():Bool { return true; }
	public function Play(url:String):Bool { return true; }
	public function Pause():Bool { return true; }
	public function Stop():Void {}
	public function JumpForward(offset:Float):Bool { return true; }
	public function JumpBackward(offset:Float):Bool { return true; }
	public function SetDisplayArea(x:Int, y:Int, width:Int, height:Int):Void {}
	public function SetPlaybackSpeed(speed:Float):Void {}
	public function SetCropArea(x:Int, y:Int, width:Int, height:Int):Bool { return true; }
	public function SetICT(flag:Bool):Bool { return true; }
	public function SetInitialBuffer(bytes:Int):Bool { return true; }
	public function SetInitialTimeOut(seconds:Float):Bool { return true; }
	public function SetMacrovision(type:Int):Bool { return true; }
	public function ClearScreen():Bool { return true; }
	public function GetAvailableBitrates():String { return ""; }
	public function GetCurrentBitrates():String { return ""; }
	public function GetDuration():Float { return 0; }
	public function GetLiveDuration():String { return ""; }
	public function GetPlayerVersion():String { return ""; }
	public function GetVideoWidth():Int { return 0; }
	public function GetVideoHeight():Int { return 0; }
	public function SetPendingBuffer(bytes:Int):Bool { return true; }
	public function SetPlayerProperty(type:Int, param:String, num:Int):Bool { return true; }
	public function SetTotalBufferSize(bytes:Int):Bool { return true; }
	public function SetVBIData(macrovisionType:Int, cgmsType:Int):Bool { return true; }
}
