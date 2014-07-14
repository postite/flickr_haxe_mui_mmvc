package mui.module.samsung;

import haxe.ds.StringMap;
import mui.event.Key;
import msignal.Signal;


class Device
{
	static var plugins = new StringMap<Dynamic>();

	static var id:String;
	public static var plugin:Plugin = new Plugin();

	public static var startingUp(default, null):Signal0 = new Signal0();
	public static var ready(default, null):Signal0 = new Signal0();
	public static var shuttingDown(default, null):Signal0 = new Signal0();
	public static var isReady(default, null):Bool = false;

	#if debug
	/*
		When an app is launched from inside our samsunng dev app, startup
		is not called as the parent app has already initialized the plugin.
		In this case we need to trigger the event our self.
	*/
	static var started:Bool = false;
	static var forceStartup:Dynamic =
	{
		haxe.Timer.delay(startup, 500);
		null;
	}
	#end

	public static function startup()
	{
		#if debug
		if (started) return;
		started = true;
		#end
		
		var widget = new Widget();
		widget.sendReadyEvent();

		// var nnavi = getNNavi();
		// nnavi.ActivateReady();
		startingUp.dispatch();

		#if (debug || browser || samsung)
		rendered();
		#end
	}

	public static function rendered()
	{
		#if browser
		var map = new mui.event.KeyMap();
		#else
		var map = new mui.module.samsung.KeyMap();
		#end

		// set key map
		mui.event.Key.manager.map = map;

		// if there are listeners then they assume responsibility to unmap any 
		// system keys otherwise default keys are unmapped
		if (ready.numListeners == 0)
		{
			var map = Key.map;
			map.remove(KeyCode.VOLUME_UP);
			map.remove(KeyCode.VOLUME_DOWN);
			map.remove(KeyCode.VOLUME_MUTE);
			map.remove(KeyCode.INFO_LINK);
			map.remove(KeyCode.MENU);
			map.remove(KeyCode.EXIT);
			map.remove(KeyCode.SMART_HUB);
		}
		
		var nnavi = getNNavi();
		nnavi.SetBannerState(2);
		
		var plugin = getPlugin();
		var tvKey = new mui.module.samsung.TVKeyValue();

		// for volume osd
		// appCommon.UnregisterKey(KeyCode.VOLUME_UP);
		// appCommon.UnregisterKey(KeyCode.VOLUME_DOWN);
		// appCommon.UnregisterKey(KeyCode.VOLUME_MUTE);
		
		plugin.unregistKey(KeyCode.MENU);
		plugin.unregistKey(KeyCode.INFO_LINK);
		plugin.unregistKey(KeyCode.EXIT);

		isReady = true;
		ready.dispatch();
	}

	public static function shutdown()
	{
		// Video.destroyInstances();
		shuttingDown.dispatch();
	}

	public static function getSEF()
	{
		#if browser
		return new SEF();
		#else
		return getPluginObject("SEF");
		#end
	}

	public static function getPlayer():Player
	{
		#if browser
		return new Player();
		#else
		return getPluginObject("Player");
		#end
	}

	public static function getAudio():Audio
	{
		#if browser
		return new Audio();
		#else
		return getPluginObject("Audio");
		#end
	}

	public static function getNNavi():NNavi
	{
		#if browser
		return new NNavi();
		#else
		return getPluginObject("NNavi");
		#end
	}

	public static function getNetwork():Network
	{
		#if browser
		return new Network();
		#else
		return getPluginObject("Network");
		#end
	}

	public static function getTVMW():TVMW
	{
		#if browser
		return new TVMW();
		#else
		return getPluginObject("TVMW");
		#end
	}

	public static function getAppCommon():AppCommon
	{
		#if browser
		return new AppCommon();
		#else
		return getPluginObject("AppCommon");
		#end
	}

	public static function getPlugin():Plugin
	{
		if (plugin != null) return plugin;

		getPluginObject("NNavi");
		getPluginObject("TVMW");
		getPluginObject("Player");
		getPluginObject("AppCommon");

		plugin = new Plugin();
		return plugin;
	}

	static function getPluginObject(name:String):Dynamic
	{
		if (plugins.exists(name)) return plugins.get(name);

		var object = js.Browser.document.createElement("object");
		object.setAttribute("classid", "clsid:SAMSUNG-INFOLINK-"+name.toUpperCase());
		
		// set id so 'Plugin' can find objects – it expects 'pluginObjectVideo' 
		// not pluginObjectPlayer :(
		if (name == "Player") object.setAttribute("id", "pluginObjectVideo");
		else object.setAttribute("id", "pluginObject"+name);
		
		js.Browser.document.body.appendChild(object);
		plugins.set(name, object);

		return object;
	}

	/**
		Returns the device's unique identifier.
	**/
	public static function getID():String
	{
		if (id != null) return id;
		var network = getNetwork();
		var mac = network.GetMAC();
		var nnavi = getNNavi();
		id = nnavi.GetDUID(mac);
		return id;
	}
}
