/*
Copyright (c) 2012 Massive Interactive

Permission is hereby granted, free of charge, to any person obtaining a copy of 
this software and associated documentation files (the "Software"), to deal in 
the Software without restriction, including without limitation the rights to 
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
of the Software, and to permit persons to whom the Software is furnished to do 
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all 
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
SOFTWARE.
*/

package mloader;

import mloader.Loader;
import msignal.EventSignal;

#if (js && !(nme || openfl))
/**
Loads an image at a defined url.
*/
class ImageLoader extends LoaderBase<LoadableImage>
{
	/**
		Specify your own image element to load the image into.
	*/
	#if haxe3
	public var image:js.html.Image;
	#else
	public var image:js.Dom.Image;
	#end
	
	public function new(?url:String)
	{
		super(url);
	}
	
	override function loaderLoad()
	{
		if (image == null)
		{
			#if haxe3
			content = cast js.Browser.document.createElement("img");
			#else
			content = cast js.Lib.document.createElement("img");
			#end
		}
		else
		{
			content = image;
		}
		
		#if !default_cross_origin
			#if !haxe3 untyped #end content.crossOrigin = "Anonymous";
		#end
		content.onload = imageLoad;
		content.onerror = imageError;
		content.src = url;
	}

	override function loaderCancel():Void
	{
		content.src = "";
	}

	function imageLoad(event)
	{
		content.onload = null;
		content.onerror = null;
		loaderComplete();
	}

	function imageError(event)
	{
		if (content == null)
			return;
		
		content.onload = null;
		content.onerror = null;
		loaderFail(IO(Std.string(event)));
	}
}

#elseif (flash || nme || openfl)

/**
Loads BitmapData from a defined url.
*/
class ImageLoader extends LoaderBase<LoadableImage>
{
	var loader:flash.display.Loader;

	public function new(?url:String)
	{
		super(url);

		loader = new flash.display.Loader();

		var loaderInfo = loader.contentLoaderInfo;
		loaderInfo.addEventListener(flash.events.ProgressEvent.PROGRESS, loaderProgressed);
		loaderInfo.addEventListener(flash.events.Event.COMPLETE, loaderCompleted);
		loaderInfo.addEventListener(flash.events.IOErrorEvent.IO_ERROR, loaderErrored);
	}

	override function loaderLoad()
	{
		#if (nme || openfl)
		if (url.indexOf("http://") == 0 || url.indexOf("https://") == 0)
		{
			loader.load(new flash.net.URLRequest(url));
		}
		else
		{
			#if openfl
			content = openfl.Assets.getBitmapData(url);
			#else
			content = nme.installer.Assets.getBitmapData(url);
			#end
			loaderComplete();
		}
		#else
		var loaderContext = new flash.system.LoaderContext(true);
		loader.load(new flash.net.URLRequest(url), loaderContext);
		#end
	}

	override function loaderCancel()
	{
		#if !(nme || openfl)
		loader.close();
		#end
	}
	
	function loaderProgressed(event)
	{
		progress = 0.0;

		if (event.bytesTotal > 0)
		{
			progress = event.bytesLoaded / event.bytesTotal;
		}

		loaded.dispatchType(Progress);
	}

	function loaderCompleted(event)
	{
		content = untyped loader.content.bitmapData;
		loaderComplete();
	}

	function loaderErrored(event)
	{
		loaderFail(IO(Std.string(event)));
	}
}

#else

/**
ImageLoading is not supported in neko.
*/
class ImageLoader extends LoaderBase<LoadableImage>
{
	public function new(?url:String)
	{
		super(url);
		
		throw "mloader.ImageLoader is not implemented on this platform";
	}
}
#end
