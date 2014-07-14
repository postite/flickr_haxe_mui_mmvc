package mui.display;

import msignal.Signal;
import mui.display.Bitmap;
import mloader.Loader;
import mloader.ImageLoader;
import mloader.LoaderQueue;

#if js
import js.Browser;
import js.html.ImageElement;
#end
/**
	Displays an image loaded from a url.

	Unlike the Bitmap class, an Image is actually a Rectangle and does not need 
	to be applied to other objects.
	
	```haxe
	var image = new Image();
	image.url = "example.jpg";
	```
**/
class Image extends Rectangle
{
	/**
		The url of the image to load.
	**/
	@:set var url:String;
	
	/**
		Determines if the object's dimensions are automatically calculated 
		based on the width and height of the loaded image.
	**/
	@:set var autoSize:Bool;
	
	/**
		The scaling method of the bitmap. Accepts values of type ScaleMode.
		
		Note: When using `ScaleMode.FILL` you should also set `clip = true`
	**/
	@:set var scaleMode:ScaleMode;

	/**
		Singals that the image successfully loaded.
	**/
	public var loaded(default, null):Signal0;

	/**
		Singals that the image failed to load.
	**/
	public var failed(default, null):Signal0;

	/**
		The width of the loaded image. 
	**/
	public var imageWidth(default, null):Int;

	/**
		The height of the loaded image.
	**/
	public var imageHeight(default, null):Int;

	/**
		The loader used to load the image.
	**/
	public var loader(default, set_loader):ImageLoader;
	function set_loader(value:ImageLoader):ImageLoader
	{
		if (loader != null)
		{
			#if js 
			loader.image = null; 
			#end
			loader.loaded.removeAll();
		}

		if (value != null)
		{
			value.loaded.add(loadComplete).forType(Complete);
			value.loaded.add(loadFail).forType(Fail(null));
		}
		return loader = value;
	}

	/**
		Optional `LoaderQueue` to manage when the image should load.
		
		Set `loaderQueue.autoLoad` to true if you want the queue to load the 
		image automatically.
	**/
	public var loaderQueue:LoaderQueue;

	#if (flash || openfl)
	var image:flash.display.Bitmap;
	#elseif js
	var image:ImageElement;
	#else
	var image:Dynamic;
	#end
	
	public function new()
	{
		super();
		
		loader = new ImageLoader();
		
		#if (flash || openfl)
		image = new flash.display.Bitmap();
		sprite.addChild(image);
		#elseif js
		image = cast Browser.document.createElement("img");
		element.appendChild(image);

		// prevents image dragging
		image.onmousedown = function(e) { untyped e.preventDefault(); }
		#end
		
		url = "";
		autoSize = true;
		imageWidth = 0;
		imageHeight = 0;
		scaleMode = NONE;
		
		loaded = new Signal0();
		failed = new Signal0();
	}
	
	override function change(flag:Dynamic):Void
	{
		super.change(flag);
		
		if (flag.width || flag.height)
		{
			if (imageWidth > 0 && imageHeight > 0) updateScale();
		}
		
		if (flag.url)
		{
			load(url);
		}
	}
	
	function updateScale()
	{
		var sw = width / imageWidth;
		var sh = height / imageHeight;
		
		var s = switch (scaleMode)
		{
			case FIT: (sw < sh ? sw : sh);
			case FILL: (sw > sh ? sw : sh);
			case STRETCH: (sw < sh ? sw : sh);
			case NONE: 1;
		}
		
		#if js
		image.width = Std.int(s * imageWidth);
		image.height = Std.int(s * imageHeight);
		image.style.left = Std.int((width - image.width) * 0.5) + "px";
		image.style.top = Std.int((height - image.height) * 0.5) + "px";
		#elseif (flash || openfl)
		image.width = s * imageWidth;
		image.height = s * imageHeight;
		image.x = (width - image.width) * 0.5;
		image.y = (height - image.height) * 0.5;
		#end
	}

	function load(url)
	{
		#if js
		untyped image.removeAttribute('width');
		untyped image.removeAttribute('height');
		loader.image = cast image;
		#end
		
		visible = false;
		imageWidth = 0;
		imageHeight = 0;
		loader.url = url;
		
		if (loaderQueue == null)
		{
			if (url != null && url != "")
				loader.load();
		}
		else
		{
			loaderQueue.remove(loader);
			
			if (url != null && url != "")
			{
				// don't call load(), queue can choose to autoload
				loaderQueue.add(loader);
			}
		}
	}
	
	function loadComplete(e:LoaderEvent<Dynamic>)
	{
		#if (flash || openfl)
		image.bitmapData = loader.content;
		#end

		imageWidth = changeValue("imageWidth", image.width);
		imageHeight = changeValue("imageHeight", image.height);

		if (autoSize)
		{
			width = imageWidth;
			height = imageHeight;
		}

		updateScale();
		visible = true;
		loaded.dispatch();
	}

	function loadFail(e:LoaderEvent<Dynamic>)
	{
		failed.dispatch();
	}
}
