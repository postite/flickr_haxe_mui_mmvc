import mloader.Loader;
import mui.display.AssetDisplay;
import mui.display.Color;
import mui.display.GradientColor;
import mui.display.Gradient;
import mui.display.Rectangle;
import mui.display.Text;

class Main extends mui.container.Application
{
	/**
		This is the main enty point to the application.
	**/
	public static function main()
	{
		var loader = AssetDisplay.library.load("common");
		loader.loaded.addOnce(init).forType(Complete);
	}

	/**
		The application is initialized once the assets have loaded.
	**/
	static function init(_)
	{
		mui.Lib.display.addChild(new Main());
	}
	
	/**
		The application constructor.
	**/
	public function new()
	{
		super();
		
		fill = new Color(0x7A9AA9);

		var text = new Text();
		addChild(text);

		text.centerX = text.centerY = 0.5;
		text.value = "Hello World";
		text.color = 0xFFFFFF;
		text.size = 40;
		
		// var rect = new Rectangle();
		// components.addChild(rect);

		// rect.fill = new Color(0xFFCC00);
		// rect.width = rect.height = 100;
		
		// new mui.behavior.ResizeBehavior(rect);

		// var spinner = new AssetDisplay("placeholder.jpg");
		// rect.addChild(spinner);
		// rect.clip = true;

		// var spinner = new AssetDisplay("spinner.png", "spin");
		// rect.addChild(spinner);

		// spinner.centerX = spinner.centerY = 0.5;

		// var collection = new mui.core.Collection();
		// addComponent(collection);

		// collection.all = 0;
		// collection.factory.component = TestItem;
		
		// var data = [];
		// for (i in 0...30) data.push(i);
		// collection.data = data;
	}
}

// class TestItem extends mui.control.Button
// {
// 	var title:Text;

// 	public function new()
// 	{
// 		super();

// 		left = right = 0;
// 		height = 80;

// 		fill = new Gradient([new GradientColor(0xFFFFFF, 1, 0), new GradientColor(0xCCCCCC, 1, 1)], 90);

// 		title = new Text();
// 		addChild(title);

// 		title.x = 10;
// 		title.centerY = 0.5;
// 	}

// 	override function updateData(value:Dynamic)
// 	{
// 		title.value = "Item " + value;
// 	}
// }
