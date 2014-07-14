package mtask.target;

/**
	A documentation target using the haxedoc utility.
**/
class HaxeDoc extends Target
{
	public function new()
	{
		super();
		flags.push("haxedoc");
	}

	override function compile()
	{
		msys.FS.cd(path, function(path){
			cmd("haxedoc", ["haxedoc.xml"]);
		});
	}
}
