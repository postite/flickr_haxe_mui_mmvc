package mtask.target;

import mtask.target.Target;

/**
	An Android specific OpenFL target defining launch images and icons.
**/
class Android extends OpenFL
{
	public function new()
	{
		super();

		width = 0;
		height = 0;
		target = "android";

		addFlags(["touch", "key", "mobile", "android"]);
	}
}
