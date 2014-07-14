package mui.device;

class Profile
{
	public static function init()
	{
		mui.module.ps3.WebMAF.dismissSplash();

		#if browser
		var map = new mui.event.KeyMap();
		#else
		var map = new mui.module.ps3.KeyMap();
		#end

		#if (!browser && tty)
		// ps3 can now be debugged through WebKit console, -D tty logs to 
		// DeviceManager instead
		Console.removePrinter(Console.defaultPrinter);
		Console.addPrinter(new mui.module.ps3.ConsolePrinter());
		#end

		// set key map
		mui.event.Key.manager.map = map;
	}
}
