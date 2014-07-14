package mui.display;

/**
	A display used to present a bitmap asset.
**/
class AssetDisplay extends mui.display.Rectangle
{
	public static var library = new AssetLibrary();
	
	public var assetFrameRate:Int;
	public var assetURI:String;
	public var assetPartID:String;
	public var assetFrame:Int;
	public var assetFrames:Int;

	var asset:ImageAsset;
	var assetPart:ImageAssetPart;
	var assetCounter:Int;

	public function new(?uri:String, ?part:String)
	{
		super();

		assetFrame = 0;
		assetFrames = 0;
		assetFrameRate = 1;
		
		if (uri != null)
		{
			setURI(uri, part);
		}
	}
	
	public function setURI(uri:String, ?part:String, ?autoSize:Bool=true)
	{
		mui.Lib.frameEntered.remove(nextAssetFrame);

		asset = library.getAsset(uri);
		mui.util.Assert.that(asset != null, "asset not found in library: " + library.resolveURI(uri));
		
		assetURI = uri;
		assetPartID = part;
		assetCounter = 0;

		if (part != null)
		{
			assetPart = asset.getPart(part);
			mui.util.Assert.that(assetPart != null, "asset part not found in library: " + library.resolveURI(uri) + "-" + part);
			assetFrames = assetPart.frames;

			if (autoSize)
			{
				width = assetPart.width;
				height = assetPart.height;
			}
			resumeAsset();
		}
		else
		{
			if (autoSize)
			{
				width = asset.width;
				height = asset.height;
			}
		}

		initAsset();	
	}

	public function nextAssetFrame()
	{
		if (++assetCounter > assetFrameRate)
		{
			if (++assetFrame >= assetFrames) assetFrame = 0;
			updateFrame();
			assetCounter = 0;
		}
	}
	
	public function pauseAsset()
	{
		if (assetFrames > 1)
			mui.Lib.frameEntered.remove(nextAssetFrame);
	}
	
	public function resumeAsset()
	{
		if (assetFrames > 1)
			mui.Lib.frameEntered.add(nextAssetFrame);
	}

	override function addedToStage()
	{
		resumeAsset();
		super.addedToStage();
	}

	override function removedFromStage()
	{
		pauseAsset();
		super.removedFromStage();
	}

	public function setPart(id:String)
	{
		assetPartID = id;

		if (assetURI != null)
		{
			assetPart = asset.getPart(assetPartID);
			assetFrame = 0;
			assetFrames = assetPart.frames;
			width = assetPart.width;
			height = assetPart.height;
	
			updateAsset();
		}
	}

	#if (flash || openfl)

	function initAsset()
	{
		updateAsset();
	}
	
	function clearAsset()
	{
		fill = null;
	}

	function updateAsset()
	{
		if (assetPartID != null)
		{
			var bitmapFill = new mui.display.Bitmap();
			untyped bitmapFill.bitmap = assetPart.getBitmapData(assetFrame);
			fill = bitmapFill;
		}
		else
		{
			var bitmapFill = new mui.display.Bitmap();
			untyped bitmapFill.bitmap = asset.getBitmapData();
			fill = bitmapFill;
		}
	}

	public function updateFrame()
	{
		var bitmapFill = new mui.display.Bitmap();
		untyped bitmapFill.bitmap = assetPart.getBitmapData(assetFrame);
		fill = bitmapFill;
	}

	#elseif js
	
	function initAsset()
	{
		fill = new mui.display.Bitmap(library.resolveURI(assetURI));
		updateAsset();
	}

	function clearAsset()
	{
		fill = null;
	}

	function updateAsset()
	{
		if (assetPart != null)
		{
			setStyle("backgroundPosition", "-" + assetPart.x + "px -" + assetPart.y + "px");
		}
		else
		{
			setStyle("backgroundPosition", "0px 0px");
		}
	}

	public function updateFrame()
	{
		setStyle("backgroundPosition", "-" + (width * assetFrame) + "px -" + assetPart.y + "px");
	}
	
	#end
}
