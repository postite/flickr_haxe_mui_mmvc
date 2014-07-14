class Build extends mtask.core.BuildBase
{
	public function new()
	{
		super();
	}

	function common(t:mtask.target.Target)
	{
		t.addFlags(["font-source-sans-pro"]);
	}
	
	@target function web(t:mtask.target.Web)
	{
		common(t);
	}

	@target function flash(t:mtask.target.Flash)
	{
		common(t);
	}

	@target function air(t:mtask.target.AIR)
	{
		common(t);
	}

	@task function test()
	{
		cmd("haxelib", ["run", "munit", "test", "-coverage"]);
	}
}
