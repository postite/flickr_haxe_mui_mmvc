package mtask.target;

import haxe.ds.StringMap;
import mtask.target.Target;

/**
	An iOS specific OpenFL target defining launch images and icons.
**/
class IOS extends OpenFL
{
	var launchImageMap:StringMap<String>;

	public function new()
	{
		super();

		width = 0;
		height = 0;

		addFlags(["touch", "mobile", "ios"]);
		addMatcher("^launch/.+", processLaunchImages);

		launchImageMap = new StringMap();
		launchImageMap.set("launch/iphone.png", "Default.png");
		launchImageMap.set("launch/iphone-retina.png", "Default@2x.png");
		launchImageMap.set("launch/iphone-retina-long.png", "Default-568h@2x.png");
		launchImageMap.set("launch/ipad.png", "Default-Portrait~ipad.png");
		launchImageMap.set("launch/ipad-retina.png", "Default-Portrait@2x~ipad.png");
		launchImageMap.set("launch/ipad-landscape.png", "Default-Landscape~ipad.png");
		launchImageMap.set("launch/ipad-retina-landscape.png", "Default-Landscape@2x~ipad.png");
	}

	function processLaunchImages(files:Array<TargetFile>)
	{
		for (file in files)
		{
			if (launchImageMap.exists(file.local))
			{
				file.local = launchImageMap.get(file.local);
			}
		}

		processUnmatched(files);
	}
}
