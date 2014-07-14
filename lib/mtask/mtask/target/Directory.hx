package mtask.target;

/**
	A basic directory target.
**/
class Directory extends Target
{
	public function new()
	{
		super();
	}

	override function compile()
	{
		zip(path);
	}
}
