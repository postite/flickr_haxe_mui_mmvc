package mui.event;

import msignal.Signal;

class Screen
{
	public static var resized = new Signal1<Screen>(Screen);
	public static var reoriented = new Signal1<Screen>(Screen);

	public static var primary = new Screen();

	public static function resize(width:Int, height:Int)
	{
		primary.width = width;
		primary.height = height;
		resized.dispatch(primary);
	}

	public static function reorient(orientation:ScreenOrientation)
	{
		primary.orientation = orientation;
		reoriented.dispatch(primary);
	}

	public static function isLandscape()
	{
		return primary.orientation == LandscapeLeft || primary.orientation == LandscapeRight;
	}

	public var width:Int;
	public var height:Int;
	public var orientation:ScreenOrientation;

	public function new()
	{
		width = 800;
		height = 600;
		orientation = Portrait;
	}
}

enum ScreenOrientation
{
	OrientationUnknown;
	LandscapeLeft;
	LandscapeRight;
	Portrait;
	PortraitUpsideDown;
}
