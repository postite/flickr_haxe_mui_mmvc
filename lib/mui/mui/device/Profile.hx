package mui.device;

/**
	This class exposes a single, static initialization method used by modules 
	to initialize device specific functionality, like key maps.
**/
class Profile
{
	/**
		Called by the framework automatically after the display root is created.
	**/
	public static function init()
	{
		mui.event.Key.manager.map = new mui.event.KeyMap();
	}
}
