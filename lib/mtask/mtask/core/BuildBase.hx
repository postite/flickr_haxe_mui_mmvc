package mtask.core;

/**
	The base class for a project's build configuration.

	`BuildBase` defines a standard set of modules for use in mtask builds. It should not be 
	instantiated directly, instead a projects `Build` class should sub-class it.
**/
class BuildBase extends BuildCore
{
	/**
		A boolean indicating if the current build is a project, or a global build. A project is 
		detected by the presence of a `project.json` file.
	**/
	public var isProject(default, null):Bool;

	/**
		`BuildBase` should not be instantiated directly, it should be sub-classed by your projects 
		`Build` class.
	**/
	function new()
	{
		super();
		
		// get version
		var mtaskPath = mtask.tool.HaxeLib.getLibraryPath("mtask");
		var path = mtaskPath + "project.json";
		if (!exists(path)) path = mtaskPath + "../project.json";

		if (exists(path))
		{
			var project = new Settings();
			project.load(path);
			version = project.get("project.version");
		}

		// detect project
		isProject = exists("project.json");

		// add environment resolvers
		env.addResolver("lib", mtask.tool.HaxeLib.getLibraryPath);
		env.addResolver("sys", Sys.getEnv);

		// load environment
		env.load("${lib.mtask}config.json");
		env.load("${build.home}config.json");

		// add core modules
		getModule(Help);
		getModule(Setup);

		if (isProject)
		{
			// create working dir
			if (!exists(".temp/mtask")) mkdir(".temp/mtask");

			// backwards compatability
			var settings = new Settings();
			settings.load("project.json");
			if (settings.get("project") == null) 
				untyped env.data.project = settings.data;
			else env.load("project.json");
			
			// user settings
			env.load("user.json");
			getModule(mtask.target.Plugin);
		}

		getModule(mtask.create.Plugin);
		loadPlugins();
		addModule(this);
	}

	override function loadPlugins()
	{
		// macro generated method
	}
}
