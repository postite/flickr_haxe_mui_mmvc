package mtask.target;

/**
	A Web target for the Samsung Smart TV platform.
**/
class Samsung extends Web
{
	public function new()
	{
		super();

		width = 1280;
		height = 720;

		addFlags(["key", "720p", "tv", "samsung"]);
	}
	
	override function compile()
	{
		super.compile();
		
		if (!browser && !debug)
		{
			zip(path);
			cp("${lib.mui}module/samsung/resource/widgetlist.xml", msys.Path.dirname(path) + "/widgetlist.xml");
			template(msys.Path.dirname(path) + "/widgetlist.xml", {id:build.env.get("project.id"), size:msys.File.size(path + ".zip")});
		}
	}
}
