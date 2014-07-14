package mui;

import msignal.Signal;
import mui.display.DisplayRoot;

/**
	The Lib class provides a static API to core framework events and the root 
	of the display hierarchy. The class cannot be instantiated.
**/
class Lib
{
	static var init =
	{
		Console.start();
		true;
	}

	/**
		Dispatched when the playhead enters a new frame.
	**/
	public static var frameEntered:Signal0 = new Signal0();

	/**
		Dispatched when the playhead renders the current frame.
	**/
	public static var frameRendered:Signal0 = new Signal0();

	/**
		Dispatched when an touch or mouse movement is detected.
	**/
	public static var mouseMoved:Signal0 = new Signal0();
	
	/**
		The root of the display hierarchy, lazily instantiated.
	**/
	public static var display(get_display, null):DisplayRoot;

	static function get_display():DisplayRoot
	{
		if (display == null)
		{
			display = new DisplayRoot();
			mui.device.Profile.init();
		}
		return display;
	}
}
