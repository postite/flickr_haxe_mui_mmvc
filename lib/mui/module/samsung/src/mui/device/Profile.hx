package mui.device;

import mui.event.KeyMap;

class Profile
{
	public static function init()
	{
		#if (debug && !browser)
		mui.event.Key.released.add(function(key){
			if (key.code == mui.module.samsung.KeyCode.INFO)
			{
				js.Browser.window.location = js.Browser.window.location;
			}
		});
		#end
	}
}
