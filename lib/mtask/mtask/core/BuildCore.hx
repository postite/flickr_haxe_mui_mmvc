package mtask.core;

import mtask.core.PropertyUtil;

/**
	Defines the core objects and methods needed by a build.

	`BuildCore` defines the standard functionality of a build. It provides methods for adding and 
	retrieving modules.
**/
class BuildCore extends Module implements PropertyResolver
{
	/**
		Whether to print additional debug information, `true` if the `-v` argument is provided when 
		calling the command line tool.
	**/
	public var verbose(default, null):Bool;

	/**
		The build environment settings.
	**/
	public var env(default, null):Settings;

	/**
		The modules that have been added to the build.
	**/
	public var modules(default, null):Array<Module>;

	/**
		An instance of `OptionParser` used parse task options
	**/
	public var options(default, null):OptionParser;

	/**
		An array of loaded plugin ids.
	**/
	public var plugins(default, null):Array<String>;

	/**
		The current build version.
	**/
	public var version(default, null):String;

	/**
		The mtask home directory.
	**/
	public var home(default, null):String;

	/**
		`BuildCore` should not be instantiated directly, it should be sub-classed by your projects 
		`Build` class.
	**/
	function new()
	{
		super();

		if (!Std.is(this, Build)) throw "Build must be Build!";
		untyped Module.main = build = this;

		// get mtask home
		home = msys.Path.join([msys.System.userDirectory, ".mtask/"]);
		version = "unknown";

		// create env
		env = new Settings();
		env.addResolver("build", this);

		// create lists
		modules = [];
		plugins = [];
		
		// create option parser
		options = new OptionParser();

		// initialise console printer
		var printer = Console.defaultPrinter;
		printer.printPosition = false;
		printer.printLineNumbers = false;
		printer.colorize = true;
		Console.start();
	}

	/**
		Adds a module to the build. Checks for `@task` metadata on the modules instance fields, 
		creating new tasks for each. Once added, `moduleAdded` is invoked on all modules to give 
		them an opportunity to react to new modules (eg. the target module checks new modules for 
		`@target` meta).
	**/
	function addModule(module:Module)
	{
		modules.push(cast module);
		
		var typeMeta = haxe.rtti.Meta.getFields(Type.getClass(module));
		
		for (field in Reflect.fields(typeMeta))
		{
			var meta = Reflect.field(typeMeta, field);
			
			if (Reflect.hasField(meta, "task"))
			{
				var task = new Task(module, field);
				module.tasks[Std.parseInt(meta.index[0])] = task;
			}
		}

		for (m in modules) m.moduleAdded(module);
	}

	/**
		Returns a singleton instance of the module for this build, instantiating and adding it if 
		it has not yet been requested.
	**/
	override public function getModule<T>(type:Class<T>):T
	{
		for (module in modules)
		{
			if (Std.is(module, type))
			{
				return cast module;
			}
		}

		var module = Type.createInstance(type, []);
		addModule(cast module);
		return module;
	}

	/**
		Invokes a task that matches the provided argument string, throwing an `Error` if no 
		matching task is found.
	**/
	override public function invoke(task:String)
	{
		invokeArgs(task.split(" "));
	}

	/**
		Invokes a task that matches the provided arguments, throwing an exception if none is found.
	**/
	override public function invokeArgs(args:Array<String>)
	{
		verbose = args.remove("-v");
		getTask(args).invoke(args);
	}

	/**
		Returns the task that matches the provided argument string, throwing an `Error` if no 
		matching task is found.
	**/
	public function getTask(args:Array<String>):Task
	{
		var id = args[0];
		
		for (module in modules)
		{
			for (task in module.tasks)
			{
				if (id == task.id) return task;
			}
		}
		
		error("No task matches '" + args.join(" ") + "'");
		return null;
	}

	/**
		Returns `true` if the provided argument string maps to a `Task` or `false` if not.
	**/
	public function hasTask(args:String):Bool
	{
		var id = args.split(" ")[0];
		
		for (module in modules)
		{
			for (task in module.tasks)
			{
				if (id == task.id) return true;
			}
		}
		return false;
	}
	
	/**
		Resolves properties for `replaceArgs`
	**/
	public function resolve(property:String):Dynamic
	{
		return env.get(property);
	}

	function loadPlugins()
	{
		// macro generated method
	}
}
