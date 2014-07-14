package mtask.target;

/**
	A Web target for LG NetCast smart TVs.
**/
class LG extends Web
{
	public function new()
	{
		super();

		width = 1280;
		height = 720;

		addFlags(["touch", "key", "720p", "slow", "tv", "lg"]);
	}
}
