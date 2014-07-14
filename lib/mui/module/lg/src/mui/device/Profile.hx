package mui.device;

class Profile
{
	public static function init()
	{
		#if browser
		var map = new mui.event.KeyMap();
		#else
		var map = new mui.module.lg.KeyMap();
		#end
	}
}
