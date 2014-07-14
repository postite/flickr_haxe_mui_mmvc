class Build extends mtask.core.BuildBase
{
	public function new()
	{
		super();
	}

	function common(t:mtask.target.Target)
	{
		t.addFlags(["font-source-sans-pro", "key"]);
	}

	@target function web(t:mtask.target.Web)
	{
		common(t);
	}

	@target function flash(t:mtask.target.Flash)
	{
		common(t);
	}

	@target function ps3(t:mtask.target.PS3)
	{
		common(t);
	}

	@target function lg(t:mtask.target.LG)
	{
		common(t);
	}

	@target function samsung(t:mtask.target.Samsung)
	{
		common(t);
	}
	
	@task function test()
	{
		invoke("build flash");
		invoke("build web");
		invoke("build ps3");
		invoke("build lg");
		invoke("build samsung");
	}
}
