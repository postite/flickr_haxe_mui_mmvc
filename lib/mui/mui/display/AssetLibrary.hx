package mui.display;

import haxe.ds.StringMap;
import mui.util.Param;

/**
	A collection of assets loaded by an application in a single operation.
**/
class AssetLibrary
{
	/**
		The sub path from which to load the asset library.
	**/
	public var subPath:String;

	// a map of caches image assets
	var assetByURI:StringMap<ImageAsset>;

	// the base path of the library, determined from build params (baseUrl and variant) if found.
	// this is 'asset/' by default, but can be used to load assets from remote locations.
	var basePath:String;

	public function new()
	{
		subPath = '';
		assetByURI = new StringMap<ImageAsset>();
		basePath = "asset/";

		#if browser
		if (Param.isAvailable)
		{
			var baseUrl = Param.get("baseUrl");
			if (baseUrl != null) basePath = baseUrl + basePath;

			var variant = Param.get("variant");
			if (variant != null) basePath += variant + "/";
		}
		#end
	}

	/**
		Commences loading the `AssetLibrary` with id `library` and returns the loader instance.

		@param library The identifier of the library to load.
		@returns The `AssetLibraryLoader` instance.
	**/
	public function load(library:String):AssetLibraryLoader
	{
		var loader = new AssetLibraryLoader(resolveURI(library + ".xml"), this);
		loader.load();
		return loader;
	}

	/**
		Returns an `ImageAsset` from this `AssetLibrary` with the provided `uri`, or `null` if 
		none is found.

		@param uri The URI of the asset to retrieve.
		@returns The ImageAsset requested, or `null` if none is found.

	**/
	public function getAsset(uri:String):ImageAsset
	{
		if (assetByURI.exists(uri)) return assetByURI.get(uri);
		return null;
	}

	/**
		Adds the supplied asset to this library with the URI provided.

		@param uri The URI under which to store the asset.
		@param asset The asset to store.
	**/
	public function set(uri:String, asset:ImageAsset):Void
	{
		assetByURI.set(uri, asset);
	}
	
	/**
		Resolves a URI based on this `AssetLibraries` base path and sub-path.

		@param The URI to resolve.
		@returns The resolved URI.
	**/
	public function resolveURI(uri:String):String
	{
		return basePath + (subPath == null ? "" : subPath + "/") + uri;
	}
}
