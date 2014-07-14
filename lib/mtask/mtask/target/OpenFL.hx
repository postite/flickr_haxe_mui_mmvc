package mtask.target;

import mtask.target.Target;
using Lambda;

/**
	An OpenFL application target.
**/
class OpenFL extends App
{
	/**
		Activate OpenFL verbose mode
	**/
	public var verbose:Bool;

	/**
		The target to compile (cpp, android, blackberry, cpp, flash, html5, 
		ios, webos). Defaults to cpp
	**/
	public var target:String;

	/**
		The application id.
	**/
	public var packageID:String;

	/**
		The orientation of the application: Portrait, Landscape or Auto.
	**/
	public var orientation:Orientation;

	/**
		The main class of the application.
	**/
	var main:String;

	/**
		The block of configuration to inject.
	**/
	var block:String;

	var compilerFlags:Array<String>;

	public function new()
	{
		super();

		var id = build.env.get("project.id");
		id = ~/[\- ]/g.replace(id, "_");
		packageID = "com.massiveinteractive." + id;

		compilerFlags = [];
		flags.push("openfl");
		target = "ios";
		block = "";
		main = "Main";
		orientation = Auto;
	}

	public function addCompilerFlags(flags:Array<String>):Void
	{
		for(flag in flags)
			addCompilerFlag(flag);
	}

	public function addCompilerFlag(value:String):Void
	{
		compilerFlags.push(value);
	}

	override function processAssets(files:Array<TargetFile>, variant:String)
	{
		super.processAssets(files, variant);

		for (file in files)
		{
			var output = msys.Path.join([path, "asset", variant, file.local]);
			var dir = msys.Path.dirname(output);
			if (!exists(dir)) mkdir(dir);
			msys.FS.cp(file.absolute, output);
		}
	}
	
	override function processHxmls(files:Array<TargetFile>)
	{
		// get haxe args
		var args = getHaxeArgs();

		// create hxml lookup
		var lookup = new Map<String, String>();
		for (file in files) lookup.set(file.local, file.absolute);

		// main hxml args
		if (lookup.exists("main.hxml"))
		{
			args = getHaxeArgsFromPath(lookup.get("main.hxml"), lookup).concat(args);
		}

		var lines = [];

		while (args.length > 0)
		{
			var arg = args.shift();
			switch (arg)
			{
				case "-main": main = args.shift();
				case "-lib", "-resource", "-D", "--macro", "-cp", "--remap":
					var value = args.shift();
					if (arg == "-cp") value = sys.FileSystem.fullPath(value);
					lines.push('<compilerflag name="' + arg + '" value="' + value + '"/>');
			}
		}
		
		block = lines.join("\n\t");
	}

	override function compile()
	{
		super.compile();
		
		if (!exists(path + "/font")) mkdir(path + "/font");

		msys.FS.cd(path, function(path){
			cmd("haxelib", ["run", "openfl"].concat(getNMEArgs("build")));
		});
	}

	override public function run()
	{
		msys.FS.cd(path, function(path){
			cmd("haxelib", ["run", "openfl"].concat(getNMEArgs("run")));
		});
	}

	function getNMEArgs(command:String):Array<String>
	{
		var args = [command, "project.xml", target];
		if (debug) args.push("-debug");
		if (verbose) args.push("-verbose");
		if (Lambda.has(flags, "simulator")) args.push("-simulator");
		if (Lambda.has(flags, "ipad")) args.push("-ipad");

		for(flag in compilerFlags)
		{
			args.push(flag);
		}
		return args;
	}
}

/**
	Valid orientation values for an OpenFL target.
**/
enum Orientation
{
	Auto;
	Portrait;
	Landscape;
}
