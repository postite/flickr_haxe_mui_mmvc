package mui.display;

/**
	Stores the metadata of a sprite, part of an `ImageAsset` in an 
	`AssetLibrary`.
**/
class ImageAssetPart
{
	public var asset:ImageAsset;

	public var id:String;
	public var frames:Int;

	public var x:Null<Int>;
	public var y:Int;

	public var width:Int;
	public var height:Int;
	
	public function new()
	{
		x = null;
		y = width = height = 0;
		frames = 1;
	}

	public function configure(asset:ImageAsset)
	{
		mui.util.Assert.that(asset.parts != null, "argument `asset` does not have any parts");
		var i = Lambda.indexOf(asset.parts, this);
		mui.util.Assert.that(i > -1, "`this` is not part of argument `asset`");

		var numParts = asset.parts.length;
		this.asset = asset;
		if (width == 0) width = Std.int(asset.width / numParts);
		if (frames > 1) width = Std.int(width / frames);
		if (height == 0) height = asset.height;
		if (x == null && numParts > 0) x = i * width;
	}

	#if (flash || openfl)
	public function getBitmapData(?frame:Int=0)
	{
		var x = this.x;

		if (frames > 1 && frame < frames)
		{
			x = width * frame;
		}
		
		var bitmapData = asset.getBitmapData();
		
		var partBitmapData = new flash.display.BitmapData(width, height, true, 0);
		partBitmapData.copyPixels(bitmapData, new flash.geom.Rectangle(x, y, width, height), new flash.geom.Point(0, 0), null, null, false);
		return partBitmapData;
	}
	#end
}
