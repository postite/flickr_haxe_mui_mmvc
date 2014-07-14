package mtask.target;

import mtask.target.Target;

/**
	Builds a group of browser based targets covering a range of devices.
	
	Uses device detection to serve correct build file at runtime.
	
	Usage example:
	
		@target function browser(t:Browser)
		{
			t.addFlags(["touch", "liquid"]);
			t.addDevice("default", ["mouse", "touch", "large", "desktop"]);
			t.addDevice("tablet", ["large", "small", "tablet"]);
			t.addDevice("mobile", ["small", "mobile"]);
		}
		
	Build examples:
	
		mtask build browser -debug	// build all browser targets in debug mode
		mtask build browser -device mobile	// build just the mobile target
		mtask build browser -noflash // build all but disable auto build of default flash target
**/
class Browser extends App
{
	public var devices:Array<{id:String, flags:Array<String>, assetVariants:Array<String>}>;

	public var minimumFlashVersion:String;

	/**
		Base url used when loading resources like image assets and css.
	 */
	public var baseUrl:String;

	public function new()
	{
		super();

		flags.push("browser");
		devices = [];
		minimumFlashVersion = "10.3";
		baseUrl = "";
		generateAssets = false;
	}

	public function addDevice(id:String, flags:Array<String>, ?assetVariants:Array<String>)
	{
		if (assetVariants == null) assetVariants = [];
		devices.push({id:id, flags:flags, assetVariants:assetVariants});
	}

	override function compile()
	{
		for (device in devices)
		{
			if (config.device != null && config.device != device.id) 
				continue;
			
			params.baseUrl = baseUrl;
			params.variant = device.id;
			assetVariants = device.assetVariants;

			var web = new Web();
			imitate(web, this);
			web.flags = web.flags.concat(["web"]).concat(device.flags);
			web.addMatcher(".temp$", processIgnore);
			web.make();
			
			var devicePath = path + "/index." + device.id + ".js";
			if (exists(devicePath)) rm(devicePath);
			mv(path + "/index.js", devicePath);
			
			var mapPath = path + "/index.js.map";
			if (exists(mapPath))
			{
				var deviceMapPath = devicePath + ".map";
				if (exists(deviceMapPath)) rm(deviceMapPath);
				mv(mapPath, deviceMapPath);
			}
			
			if (device.id == "default" && !config.noflash)
			{
				var flash = new Flash();
				imitate(flash, this);
				flash.flags = flash.flags.concat(["flash"]).concat(device.flags);
				flash.addMatcher(".temp$", processIgnore);
				flash.make();
			}
		}
		
		var devicePath = path + "/index.js";
		if (exists(devicePath)) rm(devicePath);

		var defaultPath = path + "/index.default.js"; 
		if (exists(defaultPath)) mv(defaultPath, devicePath);
		
		var defaultMapPath = path + "/index.default.js.map";
		if (exists(defaultMapPath))
		{
			var mapPath = devicePath + ".map";
			if (exists(mapPath)) rm(mapPath);
			mv(defaultMapPath, mapPath);
		}

		super.compile();
	}

	function imitate(target1:Dynamic, target2:Dynamic)
	{
		for (field in ["id", "debug", "haxeArgs", "config", "flags", 
				"params", "title", "background", "width", "height", "assetVariants"])
			Reflect.setField(target1, field, Reflect.field(target2, field));
	}

	override public function run()
	{
		openURL(path);
	}
}
