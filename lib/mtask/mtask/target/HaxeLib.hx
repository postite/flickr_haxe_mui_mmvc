package mtask.target;

import mtask.core.Settings.PrettyJson;

/**
	A HaxeLib archive target.
	
	The HaxeLib target compiles Haxe libraries for deployment to http://lib.haxe.org
	It provides useful defaults for metadata in haxelib.xml and will optionally 
	filter generated haxedoc.xml to include only the packages in your library.

	The HaxeLib target will resolve templates in the following order
		
		[mtask]/resource/target/haxelib
		[project]/target/haxelib
		[project]/target/${target.id}
**/
class HaxeLib extends Target
{
	/**
		The name of the HaxeLib project, it must contain at least 3 of the 
		following allowed characters: [A-Za-z0-9_-.] (no spaces are allowed)

		This value defaults to project.id
	**/
	public var name:String;

	/**
		The URL of the projects website or respository. Please specify at 
		least the repository URL for your project, or better the home page 
		if you have any.

		This value defaults to "http://lib.haxe.org/p/${project.id}"
	**/
	public var url:String;

	/**
		Your username in the HaxeLib database. The first time the project 
		is submitted, you will be asked to register the account. Usernames 
		have the same naming rules as project names. Passwords are sent 
		encrypted (MD5) on the server and only the encrypted version is 
		stored. You can have several users for a given project if you want.

		This value defaults to user.haxelib
	**/
	public var username:String;

	/**
		The description of your project. Try to keep it small, only 2-3 sentences 
		explaining what it's doing. More information will be available on the 
		project page anyway.

		This value defaults to "Library description."
	**/
	public var description:String;

	/*
		Projects must be open source to be hosted in the central HaxeLib
		repository on lib.haxe.org

		This value defaults to MIT
	**/
	public var license:HaxeLibLicense;

	/**
		This is the information about the version you are submitting. The version 
		name must match the same naming rules as the project name.

		Thie value defaults to project.version
	**/
	public var version:String;

	/**
		A version description indicating the changes made since the last release.

		This value defaults to "Initial release."
	**/
	public var versionDescription:String;
	
	/**
		An array of haxelib dependencies, with optional versions. Dependencies 
		can be added by calling `addDependency(name, version)`
	**/
	var dependencies:Array<{name:String, version:Null<String>}>;

	/**
		An array of haxelib tags. See http://lib.haxe.org/ for commonly used 
		tags. Tags can be added by calling `addTag(tag)`
	**/
	var tags:Array<String>;

	/**
		A generated block of Xml based on the libraries dependencies and tags.
	**/
	var block:String;
	
	/**
		HaxeLib project descriptor used to generate haxelib.json.
	*/
	var descriptor:HaxeLibDescriptor;
	
	public function new()
	{
		super();
		flags.push("haxelib");

		// set defaults
		name = build.env.get("project.id");
		version = build.env.get("project.version");
		url = build.env.get("project.url", "http://lib.haxe.org/p/" + name);
		description = build.env.get("project.description", "");
		username = build.env.get("haxelib.user");
		versionDescription = "";
		license = MIT;

		// init properties
		dependencies = [];
		tags = [];
		block = "";

		// add project dependencies if found
		var deps = build.env.get("project.dependencies", {});
		for (lib in Reflect.fields(deps)) addDependency(lib);
	}
	
	/**
		Add a library dependency with an optional version. Unversioned 
		dependencies will require the end-user have the latest version of that 
		library installed.
	**/
	public function addDependency(name:String, ?version:String=null)
	{
		for (dependency in dependencies) if (dependency.name == name)
		{
			dependency.version = version;
			return;
		}
		dependencies.push({name:name, version:version});
	}

	/**
		Add a library tag, allowing for easier discovery on http://lib.haxe.org
	**/
	public function addTag(name:String)
	{
		tags.push(name);
	}

	/**
		Generates the `block` value for use in the haxelib.xml template.
	**/
	override function configure()
	{
		super.configure();

		var args = [];
		var dependenciesObj = {};
		
		// dependencies
		for (dep in dependencies)
		{
			var arg = '\n\t<depends name="' + dep.name + '"';
			var v = (dep.version == null) ? "" : dep.version;
			
			if (v != "")
			{
				arg += ' version="' + dep.version + '"';
			}
			arg += '/>';
			args.push(arg);

			Reflect.setProperty(dependenciesObj, dep.name, v);
		}

		// tags
		for (tag in tags)
		{
			args.push('\n\t<tag v="' + tag + '"/>');
		}
		
		// build block
		block = args.join("");
		
		// build descriptor
		descriptor = {
			name:name,
			version:version,
			license:Std.string(license),
			description:description,
			releasenote:versionDescription,
			contributors:[username],
			url:url,
			tags:tags,
			dependencies:dependenciesObj
		};
	}

	override function make()
	{
		// clean if release
		if (!debug && exists(path)) rm(path);

		super.make();
	}

	override function compile()
	{
		super.compile();

		write(path + "/haxelib.json", PrettyJson.stringify(descriptor));
		
		// copy the haxelib.xml to src so we can use haxelib dev if src exists
		if (exists("src")) 
		{
			cp(path + "/haxelib.json", "src");
			cp(path + "/haxelib.xml", "src");
		}
	}

	/**
		Copies LICENSE, filters docs, creates ZIP
	**/
	override function bundle()
	{
		super.bundle();
		
		// if a license is present, copy it to the haxelib
		if (exists("LICENSE"))
		{
			cp("LICENSE", path + "/LICENSE");
		}
		
		// if a haxedoc.xml is present, filter by types in the src path
		if (exists(path + "/haxedoc.xml") && exists("src"))
		{
			var filters = [];
			for (path in msys.Directory.readDirectory("src"))
			{
				if (msys.File.isDirectory("src/" + path) || StringTools.endsWith(path, ".hx"))
				{
					filters.push(path);
				}
			}
			Console.warn("filter haxedoc.xml " + filters.join(" "));
			mtask.tool.Haxe.filterXml(path + "/haxedoc.xml", filters);
		}

		// zip it good
		zip(path);
	}
}

/** 
	Definition of haxelib.json
	
	See specification for more details https://gist.github.com/Dr-Emann/5673379
*/
typedef HaxeLibDescriptor =
{
	var name:String;
	var license:String;
	var description:String;
	var releasenote:String;
	var contributors:Array<String>;
	var version:String;
	@:optional var url:String;
	@:optional var tags:Array<String>;
	@:optional var dependencies:Dynamic;
}

/**
	The licenses allowed by HaxeLib
**/
enum HaxeLibLicense
{
	/**
		Massachusetts Institute of Technology license
		see: http://opensource.org/licenses/mit-license.php
	**/
	MIT;

	/**
		GNU General Public License
		see: http://www.gnu.org/licenses/gpl.html
	**/
	GPL;

	/**
		GNU Lesser General Public License
		see: http://www.gnu.org/licenses/lgpl.html
	**/
	LGPL;

	/**
		Berkeley Software Distribution license
		see: http://opensource.org/licenses/bsd-license.php
	**/
	BSD;

	/**
		Public domain license
		see: http://en.wikipedia.org/wiki/Public_domain
	**/
	Public;

	/**
		Closed source license, prevents accidental submission to HaxeLib.
	**/
	Closed;
}
