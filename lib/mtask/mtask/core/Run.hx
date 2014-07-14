package mtask.core;

import haxe.CallStack;
import msys.File;
import msys.Path;
using Lambda;

/**
	The mtask build runner, responsible for building build executables.

	This is the "main" class of the mtask HaxeLib runner. It's purpose is to 
	compile the project build and execute it in the correct working directory 
	(where the haxelib run mtask command was executed). It also streams stdout 
	and stderr from the process exits correctly on exceptions.
**/
class Run
{
	static var run:Array<String> -> Void;
	
	/**
		The entry point to the runner. Executes build and catches any 
		un-caught exceptions, and exiting with the correct exit code.
	**/
	public static function main()
	{
		// configure console
		Console.defaultPrinter.printLineNumbers = false;
		Console.defaultPrinter.printPosition = false;
		Console.defaultPrinter.colorize = true;
		Console.start();

		try
		{
			// ensure mtask is installed
			mtask.tool.HaxeLib.require("mtask");

			var args = getArgs();
			// run build
			if (args.length > 0) runBuild(args);
			// enter repl
			else new REPL(runBuild);

			Sys.exit(0);
		}
		catch (e:Dynamic)
		{
			// need to use class name so exceptions from loaded module get caught :)
			if (Type.getClassName(Type.getClass(e)) == "mtask.core.Error")
				Console.error(e.message, e.stack);
			else
				Console.error(Std.string(e), CallStack.exceptionStack());
			Sys.exit(1);
		}
	}

	/**
		Compiles the build for the current working directory if the is no 
		existing build, or the build is outdated, or force is true.
	**/
	static function compileBuild(?force:Bool=false, ?verbose:Bool=false):Void
	{
		var compile = force;
		var path:String = null;
		var buildPath = "build";

		// create bin if it does not exist
		var home = Path.join([msys.System.userDirectory, ".mtask"]);
		var bin = Path.join([home, "bin"]);
		if (!msys.File.exists(bin)) msys.FS.mkdir_p(bin, {});

		if (File.exists(Path.join(["build", "Build.hx"])))
		{
			// if in project, guid based on working dir
			var guid = haxe.crypto.Md5.encode(Sys.getCwd()).substr(0, 10);
			path = Path.join([bin, guid + ".n"]);

			// compile if bin is outdated (compared to ./build)
			if (!msys.File.exists(path) || msys.File.outdates("build", path)) compile = true;
		}
		else
		{
			// set build path to mtask home
			buildPath = home;

			// else use common build
			path = Path.join([bin, "mtask.n"]);

			// compile if bin doesn't exist
			var buildFile = Path.join([buildPath, "Build.hx"]);
			if (!msys.File.exists(path) || (msys.File.exists(buildFile) && msys.File.outdates(buildFile, path))) compile = true;
		}

		if (compile)
		{
			var args = ["-neko", path, "-main", "mtask.core.Main", "-lib", 
				"mtask", "-cp", buildPath, "-D", "use_rtti_doc", "-D", 
				"absolute_path", "-D", "neko_v1"];

			trace("compiling build...");
			mtask.core.Process.run("haxe", args, verbose);
		}
		
		if (compile || run == null) loadBuild(path);
	}

	/**
		Loads the build module from path, and updates the `run` method with 
		the exported `run` method from the module.
	**/
	static function loadBuild(path:String)
	{
		var loader = neko.vm.Loader.local();
		loader.setCache(path, null);

		var module = loader.loadModule(path);
		run = module.getExports().get("run");

		if (run == null) throw new Error("Unable to load build");
	}

	/**
		Runs a single build task. If the task is "c" we force recompilation.
	**/
	static function runBuild(args:Array<String>)
	{
		var verbose = args.has("-v");

		// compile the build
		var force = args[0] == "c";
		compileBuild(force, verbose);
		if (force) return;

		// execute the task
		run(args);
	}

	/**
		Checks if the last argument is a working directory passed in by 
		HaxeLib. If it is, we change to that directory and return the joined 
		args without the working directory argument.
	**/
	public static function getArgs():Array<String>
	{
		var args = Sys.args();
		
		// make sure neko strings are wrapped
		for (i in 0...args.length) args[i] = ""+args[i];

		if (args.length > 0)
		{
			var path = new haxe.io.Path(args[args.length - 1]).toString();
			var slash = path.substr(-1);

			if (slash == "/" || slash == "\\")
			{
				path = path.substr(0, path.length - 1);
			}
			
			if (File.exists(path) && File.isDirectory(path))
			{
				Sys.setCwd(path);
				args.pop();
			}
		}

		return args;
	}
}
