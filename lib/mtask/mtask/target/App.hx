package mtask.target;

import msys.Path;
import mtask.target.Target;

/**
	Base class for UI targets defining common properties and behavior.
**/
class App extends Target
{
	/**
		Base url used when loading resources like image assets and css.
	**/
	public var baseUrl:String;

	/**
		An anonymous object containing values that are compiled into the application as a JSON 
		resource. These can be configure at build time and accessed at runtime.
	**/
	public var params:Dynamic;

	/**
		The title of the application, used in package metadata, html titles and where a human 
		readable name is required for the application.
	**/
	public var title:String;

	/**
		The background color of the application as an unsigned integer.
	**/
	public var background:Int;

	/**
		The default width of the application, or `0` of the application always displays at the full 
		width of it's device of window.
	**/
	public var width:Int;

	/**
		The default height of the application, or `0` of the application always displays at the 
		full height of it's device of window.
	**/
	public var height:Int;

	/**
		An array of asset variants to generate for the application.

		For each variant, the asset files collected for the target will be filtered on that targets 
		flags plus the variant string. This allows, for example, multiple resolution asset 
		libraries to be generated and loaded at runtime. This property is an empty array by 
		default.
	**/
	public var assetVariants:Array<String>;

	// when this target is a variant of another (ie. mtask.target.Browser) this string is the 
	// identifier of that target. Assets for that target will be generated at `asset/variant`
	var variant:String;

	// whether the target is running in browser mode or not (confusingly, nothing to do with 
	// mtask.target.Browser)
	var browser:Bool;

	// a hexadecimal string representation of the applications background color
	var backgroundHex:String;

	// whether or not the target should generate asset libraries
	var generateAssets:Bool;

	public function new()
	{
		super();
		
		baseUrl = "";
		assetVariants = [];
		generateAssets = true;
		flags.push("app");
		params = {};
		title = build.env.get("project.name", build.env.get("project.id", "untitled"));
		background = 0xAFAEB3;
		width = 0;
		height = 0;
		browser = false;

		addMatcher("^asset.+(png|jpg)$", processAssetVariants, false);
		addMatcher("^asset.+xml$", processIgnore);
	}

	override function configure()
	{
		super.configure();

		variant = params.variant;
		browser = (config.browser == true);
		backgroundHex = StringTools.lpad(StringTools.hex(background), "0", 6);

		params.title = title;
		params.baseUrl = baseUrl;
		params.target = flags[flags.length - 1];
		params.width = width;
		params.height = height;
		params.app = replaceArgs("${project.id}-${project.version}");
		params.version = replaceArgs("${project.version}");
		params.build = replaceArgs("${user.name} " + Date.now().toString());
		
		write(".temp/mtask/params.json", haxe.Json.stringify(params));
	}

	function processAssetVariants(files:Array<TargetFile>)
	{
		if (!generateAssets) return;

		var variantFlags = [];
		if (variant != null) variantFlags.push(variant);

		if (assetVariants.length > 0)
		{
			for (assetVariant in assetVariants)
			{
				var variantPath = Path.join(variantFlags.concat([assetVariant]));
				var assets = filterFiles(files, flags.concat(variantFlags).concat([assetVariant]));
				processAssets(assets, variantPath);
			}
		}
		else
		{
			var assets = filterFiles(files, flags.concat(variantFlags));
			processAssets(assets, variant);
		}
	}

	function processAssets(files:Array<TargetFile>, variant:String)
	{
		var libraries = new Map();

		for (file in files)
		{
			var parts = Path.split(file.local);
			parts.shift(); // assets

			var id = parts.shift();
			file.local = parts.join("/");

			var images = [];
			if (libraries.exists(id)) images = libraries.get(id);
			else libraries.set(id, images);
			images.push(file);
		}

		for (id in libraries.keys())
		{
			processAssetLibrary(id, libraries.get(id), variant);
		}
	}

	function processAssetLibrary(id:String, files:Array<TargetFile>, variant:String)
	{
		var json:Bool = build.env.get('config.jsonAssetLibraries');
		if (json) generateJsonAssetLibrary(id, files, variant);
		else generateXmlAssetLibrary(id, files, variant);
	}

	function generateJsonAssetLibrary(id:String, files:Array<TargetFile>, variant:String)
	{
		var infos = files.map(function(file){
			var parts = [];
			var metaPath = file.absolute.substr(0, file.absolute.lastIndexOf(".")) + ".xml";
			if (exists(metaPath))
			{
				var xml = Xml.parse(read(metaPath)).firstElement().firstElement();
				for (node in xml.elements())
				{
					var part:Dynamic = {};
					part.id = node.get("id");
					if (node.get("x") != null) part.x = Std.parseInt(node.get("x"));
					if (node.get("y") != null) part.y = Std.parseInt(node.get("y"));
					if (node.get("width") != null) part.width = Std.parseInt(node.get("width"));
					if (node.get("height") != null) part.height = Std.parseInt(node.get("height"));
					if (node.get("frames") != null) part.frames = Std.parseInt(node.get("frames"));
					parts.push(part);
				}
			}
			var size = ImageUtil.getSize(file.absolute);
			var info:Dynamic = {id:file.local, width:size.width, height:size.height};
			if (parts.length > 0) info.parts = parts;
			return info;
		});
		var libPath = Path.join([path, "asset", variant]);
		if (!exists(libPath)) mkdir(libPath);
		write(Path.join([libPath, id+".json"]), haxe.Json.stringify(infos));
	}
	
	function generateXmlAssetLibrary(id:String, files:Array<TargetFile>, variant:String)
	{
		var images = [];

		for (file in files)
		{
			var size = ImageUtil.getSize(file.absolute);
			var body = "/>";

			// check for additional image metadata
			var metaPath = file.absolute.substr(0, file.absolute.lastIndexOf(".")) + ".xml";
			if (exists(metaPath))
			{
				var xml = Xml.parse(read(metaPath)).firstElement().firstElement();
				body = ">"+xml.toString().split("\n").join("").split("\t").join("")+"</image>";
			}

			var image = '<image uri="'+file.local+'" width="'+size.width+'" height="'+size.height+'"'+body;
			images.push(image);
		}

		var meta = '<assets>'+images.join("")+'</assets>';
		var libPath = Path.join([path, "asset", variant]);
		if (!exists(libPath)) mkdir(libPath);
		write(Path.join([libPath, id+".xml"]), meta);
	}

	override function getHaxeArgs():Array<String>
	{
		var args = super.getHaxeArgs();
		
		// add flag for each device flag
		for (flag in flags)
		{
			if (flag == "js" || flag == "flash") continue;
			args.push("-D");
			args.push(flag);
		}
		
		if (browser)
		{
			args.push("-D");
			args.push("browser");
		}

		// add params resource
		args.push("-resource");
		args.push(sys.FileSystem.fullPath(".temp/mtask/params.json")+"@params");

		return args;
	}
}
