package mui.module.samsung;

#if !browser
extern
#end
class Audio
{
	inline public static var AUDIO_OUT_MODE_PCM = 0;
	inline public static var AUDIO_OUT_MODE_DOLBY = 1;
	inline public static var AUDIO_OUT_MODE_DTS = 2;

	inline public static var OUTPUT_DEVICE_MAIN_SPEAKER = 0;
	inline public static var OUTPUT_DEVICE_EARPHONE = 1;
	inline public static var OUTPUT_DEVICE_SUBWOOFER = 2;
	inline public static var OUTPUT_DEVICE_EXTERNAL = 3;
	inline public static var OUTPUT_DEVICE_RECEIVER = 4;

	inline public static var VOLUME_KEY_UP = 0;
	inline public static var VOLUME_KEY_DOWN = 1;

	public function new():Void {}

	public function CheckExternalOutMode(mode:Int):Int { return -1; }
	public function GetExternalOutMode():Int { return -1; }
	public function SetExternalOutMode(mode:Int):Int { return -1; }
	public function GetOutputDevice():Int { return -1; }
	public function GetSystemMute():Int { return -1; }
	public function SetSystemMute(mute:Bool):Int { return -1; }
	public function GetUserMute():Int { return -1; }
	public function SetUserMute(mute:Bool):Int { return -1; }
	public function GetVolume():Int { return -1; }
	public function IsActiveSourceOnCEC():Int { return -1; }
	public function SetTVSourceOnCEC():Int { return -1;}
	public function SetVolumeWithKey(ket:Int):Int { return -1; }
}
