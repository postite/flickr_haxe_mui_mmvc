package mui.display;

import mui.core.Node;
import msignal.Signal;

/**
	A bitmap style for the fill or stroke of a `Rectangle`

	The Bitmap class loads and stores an instance of an image from a url. 
	Completed and failed signals can be listened for when loading the url. A 
	bitmap can be applied to a rectangle through the rectangle's fill property 
	as demonstrated below. The same bitmap can also be applied to many 
	rectangles through a single instance of the bitmap.
	
	```haxe
	var rectangle = new Rectangle();
	rectangle.fill = new Bitmap("/img/background.jpg");
	```
**/
class Bitmap extends Node implements GraphicStyle
{
	/**
		@param url The url of the bitmap to load.
	**/
	public function new(?url:String):Void
	{
		super();
		
		loadCompleted = new Signal0();
		loadFailed = new Signal0();
		
		this.url = "";
		scaleMode = NONE;
		bitmap = changeValue("bitmap", null);
		bitmapWidth = changeValue("bitmapWidth", 0);
		bitmapHeight = changeValue("bitmapHeight", 0);
		
		if (url != null) this.url = url;
	}
	
	/**
		Signifies that the bitmap was successfully loaded
	**/
	public var loadCompleted(default, null):Signal0;

	/**
		Signifies that the bitmap has failed to load
	**/
	public var loadFailed(default, null):Signal0;
	
	/**
		The url of the bitmap to load
	**/
	@:set var url:String;
	
	/**
		The scaling method of the bitmap. Accepts values of type ScaleMode.
	**/
	@:set var scaleMode:ScaleMode;
	
	/**
		Used to store an instance of the bitmap
	**/
	public var bitmap(default, null):Dynamic;

	/**
		The width of the bitmap
	**/
	public var bitmapWidth(default, null):Int;

	/**
		The height of the bitmap
	**/
	public var bitmapHeight(default, null):Int;
	
	#if (flash || nme || openfl)

	/**
		Fills an area with a bitmap image.
		@param graphic The area to fill.
	**/
	public function beginFill(graphic:Rectangle)
	{
		if (bitmap == null) return;
		
		var strokeThickness = graphic.strokeThickness;
		var strokeThickness2 = strokeThickness * 2;
		
		var matrix = new flash.geom.Matrix();
		
		var lw = graphic.width - strokeThickness2;
		var lh = graphic.height - strokeThickness2;
		
		var rw = lw / bitmap.width;
		var rh = lh / bitmap.height;
		
		switch(scaleMode)
		{
			case FIT:
				var s = (rw < rh ? rw : rh);
				matrix.scale(s, s);
				matrix.translate(graphic.strokeThickness + (lw - (bitmap.width * s)) * 0.5, graphic.strokeThickness + (lh - (bitmap.height * s)) * 0.5);
				graphic.sprite.graphics.beginBitmapFill(bitmap, matrix, false, true);
				
			case FILL:
				var s = (rw > rh ? rw : rh);
				matrix.scale(s, s);
				matrix.translate(graphic.strokeThickness + (lw - (bitmap.width * s)) * 0.5, graphic.strokeThickness + (lh - (bitmap.height * s)) * 0.5);
				graphic.sprite.graphics.beginBitmapFill(bitmap, matrix, false, true);
				
			case STRETCH:
				matrix.scale(rw, rh);
				matrix.translate(0, 0);
				graphic.sprite.graphics.beginBitmapFill(bitmap, matrix, false, true);
				
			case NONE:
				matrix.translate(graphic.strokeThickness, graphic.strokeThickness);
				graphic.sprite.graphics.beginBitmapFill(bitmap, matrix, true, true);
		}
	}
	
	public function beginStroke(graphic:Rectangle)
	{
		beginFill(graphic);
	}
	
	override function change(flag:Dynamic):Void
	{
		super.change(flag);
		
		if (flag.url)
		{
			var loader = new flash.display.Loader();
			loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, loadComplete);
			loader.contentLoaderInfo.addEventListener(flash.events.IOErrorEvent.IO_ERROR, loadFault);
			loader.load(new flash.net.URLRequest(url));
		}
	}
	
	function loadComplete(event:flash.events.Event)
	{
		bitmap = changeValue("bitmap", event.target.content.bitmapData);
		bitmapWidth = changeValue("bitmapWidth", bitmap.width);
		bitmapHeight = changeValue("bitmapHeight", bitmap.height);
		
		loadCompleted.dispatch();
	}
	
	function loadFault(event:flash.events.IOErrorEvent)
	{
		loadFailed.dispatch();
	}
	
	#elseif js

	/**
		Applies a bitmap to an area. The position is dictated by the value of 
		the bitmap's scale mode.

		@param graphic The area to apply the fill to.
	**/
	public function applyFill(graphic:Rectangle)
	{
		graphic.setStyle("backgroundImage", "url('" + url + "')");
				
		switch(scaleMode)
		{
			case FIT:
				graphic.setStyle("backgroundPosition", "50% 50%");
			case FILL:
				graphic.setStyle("backgroundPosition", "50% 50%");
			case STRETCH:
				graphic.setStyle("backgroundPosition", "50% 50%");
			case NONE:
				graphic.setStyle("backgroundRepeat", "repeat");
		}
	}

	/**
		Applies a border to an area.
		
		@param graphic The area to apply the stroke to.
	**/
	public function applyStroke(graphic:Rectangle)
	{
		graphic.setStyle(JS.getPrefixedStyleName("borderImage"), "url('" + url + "')");
	}
	#end
}

/**
	Defines different approaches to scaling a bitmap to a containing rectangle.
**/
enum ScaleMode
{
	/**
		Fill the available space while maintaining aspect ratio.
	**/
	FILL;

	/**
		Fit the entire bitmap within the available space while maintaining 
		aspect ratio.
	**/
	FIT;

	/**
		Stretch both width and height to that of the containing rectangle, 
		ignoring aspect ratio.
	**/
	STRETCH;

	/**
		Do not scale the bitmap.
	**/
	NONE;
}
