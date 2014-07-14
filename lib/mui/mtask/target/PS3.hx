package mtask.target;

/**
	A Web target for PlayStation 3 embeded WebKit application.
**/
class PS3 extends Web
{
	public function new()
	{
		super();

		width = 1280;
		height = 720;

		addFlags(["key", "tv", "720p", "ps3"]);
	}
}
