package mtask.core;

using Lambda;

class Dependency
{
	/**
		Resolves mpm dependencies
	**/
	public static function resolve(args:Array<String>)
	{
		return args;
		
		var args = args.copy();
		var resolved = [];
		var deps = [];

		while (args.length > 0)
		{
			var arg = args.shift();

			if (arg == "-lib")
			{
				var lib = args.shift();
				getDependencies(lib, deps);
			}
			else
			{
				resolved.push(arg);
			}
		}
		
		for (lib in deps)
		{
			if (sys.FileSystem.exists("lib/"+lib))
			{
				resolved.push("-cp");
				resolved.push("lib/"+lib);
				resolved.push("-D");
				resolved.push(lib);
			}
			else
			{
				resolved.push("-lib");
				resolved.push(lib);
			}
		}

		return resolved;
	}

	static function getDependencies(lib:String, ?deps:Array<String>):Array<String>
	{
		if (deps == null) deps = [];
		
		if (!deps.has(lib))
		{
			deps.push(lib);

			for (lib in readDependencies(lib))
			{
				getDependencies(lib, deps);
			}
		}

		return deps;
	}

	/**
		Returns library dependencies for a local lib.
	**/
	static function readDependencies(lib:String):Array<String>
	{
		var path = "lib/"+lib+"/project.json";
		if (!sys.FileSystem.exists(path)) return [];

		var deps = [];
		var project = haxe.Json.parse(sys.io.File.getContent(path));
		for (lib in Reflect.fields(project.project.dependencies)) deps.push(lib);
		return deps;
	}
}
