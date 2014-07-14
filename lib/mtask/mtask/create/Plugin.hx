package mtask.create;

class Plugin extends mtask.core.Module
{
	var paths:Array<String>;
	var templates:Map<String, Class<Template>>;

	public function new()
	{
		super();

		moduleName = "create";
		templates = new Map();
		
		addTemplate("license", LicenseTemplate);
		addTemplate("source", SourceTemplate);
		addTemplate("test", TestTemplate);
		addTemplate("project", ProjectTemplate);

		paths = [];
		
		addTemplatePath("${lib.mtask}module/create/resource");
	}
	
	/**
		Create a template. Run `help create` for more info.

		Generates a templated file or directory at a specified path:
		  create project (app|empty|haxelib|neko) MyProject
		  create source (class|main) com.foo.Bar
		  create test (class|for) com.foo.Bar
		  create license (bsd|gpl|lgpl|mit|massive) LICENSE
	**/
	@task function create(template:String, type:String, path:String)
	{
		if (!templates.exists(template))
		{
			error("Unknown template '" + template + "'\n"+
				mtask.core.Error.PLUGIN_ERROR);
		}
		
		var templateClass = templates.get(template);
		var templateInstance = Type.createInstance(templateClass, [type, path]);
		templateInstance.compile();
	}

	/**
		List the available templates, or types for `template`
	**/
	@task("list:template") function list(?template:String)
	{
		if (template == null)
		{
			for (template in templates.keys()) Console.log(template);
		}
		else
		{
			if (!templates.exists(template))
			{
				error("Unknown template '" + template + "'\n"+
					mtask.core.Error.PLUGIN_ERROR);
			}

			var types = [];

			for (path in paths)
			{
				path = replaceArgs(path);
				var typesPath = path + "/" + template;
				if (!exists(typesPath)) continue;

				for (type in msys.Directory.readDirectory(typesPath))
				{
					Console.log(template + " " + type);
				}
			}
		}
	}

	/**
		Adds a template to the create module.
	**/
	public function addTemplate(id:String, template:Class<Template>)
	{
		templates.set(id, template);
	}

	/**
		Add a template lookup path.
	**/
	public function addTemplatePath(path:String)
	{
		paths.push(path);
	}

	/**
		Resolve the path of a template by searching the paths array.
	**/
	public function getTemplatePath(template:String, type:String)
	{
		var path = template + "/" + type;

		for (resources in paths)
		{
			resources = replaceArgs(resources);

			if (exists(resources + "/" + path))
			{
				return resources + "/" + path;
			}
		}

		error("Could not resolve template '"+template+"' of type '"+type+"'\n"+
			mtask.core.Error.PLUGIN_ERROR);

		return null;
	}
}
