package mui.display;

/**
	Stores the metadata of a bitmap in an `AssetLibrary`.
**/
class ImageAsset
{
	public var uri:String;
	public var width:Int;
	public var height:Int;
	public var parts:Array<ImageAssetPart>;

	public function new()
	{
		parts = [];
	}

	public function getPart(id:String)
	{
		for (part in parts)
		{
			if (part.id == id)
			{
				return part;
			}
		}

		return null;
	}

	#if (flash || openfl)

	var bitmapData:flash.display.BitmapData;

	public function getBitmapData()
	{
		if (bitmapData == null)
		{
			#if openfl
			bitmapData = openfl.Assets.getBitmapData("asset/" + uri);
			#else
			var id = "asset." + uri.split("/").join(".");
			var bitmapDataClass = Type.resolveClass(id);
			mui.util.Assert.that(bitmapDataClass != null, "could not resolve image asset class " + uri);
			bitmapData = Type.createInstance(bitmapDataClass, [null, null]);
			#end
			mui.util.Assert.that(Std.is(bitmapData, flash.display.BitmapData), "class " + uri + " is not of type flash.display.BitmapData");
		}

		return bitmapData;
	}
	#end
}
