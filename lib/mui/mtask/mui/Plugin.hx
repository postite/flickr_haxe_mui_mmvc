package mtask.mui;

class Plugin extends mtask.core.Module
{
	public function new()
	{
		super();

		moduleName = "mui";
		getModule(mtask.create.Plugin).addTemplatePath("${lib.mui}module/create/resource");
	}
	
	@target function samsung(t:mtask.target.Samsung) {}
	@target function lg(t:mtask.target.LG) {}
	@target function ps3(t:mtask.target.PS3) {}
	@target function youview(t:mtask.target.YouView) {}
	@target function ios(t:mtask.target.IOS) {}
	@target function android(t:mtask.target.Android) {}
}
