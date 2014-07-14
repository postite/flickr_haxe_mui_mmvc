package mui.display;

import mloader.Loader;
import mloader.LoaderBase;
import mloader.LoaderQueue;
import mloader.ImageLoader;

/**
	A loader used to load the metadata and contents of an [AssetLibrary].
**/
class AssetLibraryLoader extends LoaderBase<AssetLibrary>
{
	var library:AssetLibrary;

	public function new(url:String, ?library:AssetLibrary)
	{
		super(url);

		if (library == null) library = new AssetLibrary();
		this.library = library;
	}

	override function loaderLoad()
	{
		var loader = new mloader.XmlObjectLoader<Array<ImageAsset>>();

		loader.mapNode("assets", "Array");
		loader.mapNode("parts", "Array");
		loader.mapClass("image", ImageAsset);
		loader.mapClass("part", ImageAssetPart);
		
		loader.loaded.add(xmlComplete).forType(Complete);
		loader.url = url;
		loader.load();
	}

	override function loaderCancel() {}

	function xmlComplete(event:LoaderEvent<Array<ImageAsset>>)
	{
		var assets = event.target.content;
		
		for (asset in assets)
		{
			for (part in asset.parts) part.configure(asset);
			library.set(asset.uri, asset);
		}
		
		preload(assets);
	}

	#if (flash || openfl)

	function preload(assets:Array<ImageAsset>)
	{
		// under ipa we compile the swf libraries into main application
		#if !openfl
		var loader = new mloader.SwfLoader();
		var swf = url.split(".xml").join(".swf");

		loader.loaded.add(preloadComplete).forType(Complete);
		loader.url = swf;
		loader.load();
		#else
		preloadComplete(null);
		#end
	}

	function preloadComplete(_)
	{
		content = library;
		loaderComplete();
	}

	#else

	function preload(assets:Array<ImageAsset>)
	{
		var loaderQueue = new LoaderQueue();
		if (assets.length == 0) preloadComplete(null);

		loaderQueue.loaded.add(preloadComplete).forType(Complete);

		for (asset in assets)
		{
			var loader = new mloader.ImageLoader();
			loader.url = library.resolveURI(asset.uri);
			loaderQueue.add(loader);
		}

		loaderQueue.load();
	}

	function preloadComplete(_)
	{
		loaderComplete();
	}

	#end
}
