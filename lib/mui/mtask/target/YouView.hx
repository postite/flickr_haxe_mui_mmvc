package mtask.target;

import sys.io.Process;

/**
	An Adobe AIR target for the YouView platform.
**/
class YouView extends mtask.target.AIR
{
	public var nativeExtensionDir:String;
	public var extension:String;

	public function new()
	{
		super();

		width = 1280;
		height = 720;

		addFlags(["key", "tv", "720p", "youview"]);
		extension = ".air";
		
		keystore = null;
		storepass = null;

		// target.afterCompile = function(path:String)
		// {
		// 	var name = replaceArgs("${project.id}-youview-quebec-${project.version}");
		// 	var targetPath = path + "/../" + name + target.extension;
		// 	if(msys.File.exists(targetPath)) rm(targetPath);
		// 	mv(path + target.extension, targetPath);
		// }
	}

	override function bundle()
	{
		if (keystore == null)
			throw "keystore is not set";
				
		if (storepass == null)
			throw "storepass is not set";

		nativeExtensionDir = replaceArgs("${lib.mui}module/youview/resource/ane");

		var args:Array<String> = [];

		if (extension == "airi")
		{
			args.push("-prepare");
		}
		else
		{
			args.push("-package");

			args.push("-storetype");
			args.push("pkcs12");

			args.push("-tsa");
			args.push("none");

			args.push("-keystore");
			args.push(keystore);

			args.push("-storepass");
			args.push(storepass);

			args.push("-target");
			args.push("airn");
		}

		args.push(path + extension);
		args.push(path + "/manifest.xml");

		args.push("-extdir");
		args.push(nativeExtensionDir);

		args.push("-C");
		args.push(path);

		args.push(".");
		
		mtask.tool.AIR.adt(args);
	}

	// function runADT(args:Array<String>)
	// {
	// 	var home = Sys.getEnv("AIR_HOME");
	// 	if (home == null) throw "The environment variable AIR_HOME is not set";

	// 	var bin = home + "/bin/adt" ;
	// 	trace(bin + " " + args.join(" "));
	// 	var p = new Process(bin,args);
	// 	if(p.exitCode() > 0) trace(p.stderr.readAll());
	// }
}
