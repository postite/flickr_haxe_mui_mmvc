package mui.behavior;

import mui.core.Behavior;
import mui.display.Display;
import mui.transition.Tween;

/**
	Resizes a `Display` relative to its parent.

	The behavior is provided with the original dimensions of the `Display`. 
	Subsequently setting `aspectRatio` will cause the behaviors target to 
	resize according to the rules documented in `AspectRatio`. The size change 
	can optionally be animated by setting the `animateAspectChange` flag.
**/
class AspectScaleBehavior extends Behavior<Display>
{
	/**
		The original width of the target, used to determine new size based on 
		the current `aspectRatio`.
	**/
	public var originalWidth(default, null):Int;

	/**
		The original height of the target, used to determine new size based on 
		the current `aspectRatio`.
	**/
	public var originalHeight(default, null):Int;

	/**
		Whether changes to the size of the target should be animated. Defaults 
		to `true`.
	**/
	public var animateAspectChange:Bool;
	
	/**
		Creates a new `AspectScaleBehavior` with the provided original 
		dimensions.

		@param originalWidth The original display width.
		@param originalHeight The original display height.
	**/
	public function new(originalWidth:Int, originalHeight:Int)
	{
		super();

		this.originalWidth = originalWidth;
		this.originalHeight = originalHeight;

		animateAspectChange = true;
	}	
	
	/**
		The aspect ratio used to resize the target. See `AspectRatio` for 
		possible values and how each affects the target.
	**/
	public var aspectRatio(default, set_aspectRatio):AspectRatio;
	function set_aspectRatio(value:AspectRatio):AspectRatio
	{
		var parent = target.parent;
		
		var targetX:Int;
		var targetY:Int;
		var targetW:Int;
		var targetH:Int;
		
		var widthScale = parent.width / originalWidth;
		var heightScale = parent.height / originalHeight;
		
		switch (value)
		{
			case FIT:
				var fillScale = Math.min(widthScale, heightScale);
				targetW = Math.ceil(originalWidth * fillScale);
				targetH = Math.ceil(originalHeight * fillScale);
				targetX = Math.round((parent.width - targetW) / 2);
				targetY = Math.round((parent.height - targetH) / 2);
			case FILL:
				var fitScale = Math.max(widthScale, heightScale);
				targetW = Math.ceil(originalWidth * fitScale);
				targetH = Math.ceil(originalHeight * fitScale);
				targetX = Math.round((parent.width - targetW) / 2);
				targetY = Math.round((parent.height - targetH) / 2);
			case FOUR_THREE:	
				targetH = Math.ceil(parent.height);
				targetW = Math.ceil(parent.height * (4 / 3));
				targetX = Math.round((parent.width - targetW) / 2);
				targetY = 0;
			case SIXTEEN_NINE:	
				targetH = Math.ceil(parent.height);
				targetW = Math.ceil(parent.height * (16 / 9));
				targetX = Math.round((parent.width - targetW) / 2);
				targetY = 0;
			case EXACT_FIT:		
				targetW = Math.ceil(parent.width);
				targetH = Math.ceil(parent.height);
				targetX = 0;
				targetY = 0;
			case NO_SCALE:
				targetW = originalWidth;
				targetH = originalHeight;
				targetX = Math.round((parent.width - originalWidth) / 2);
				targetY = Math.round((parent.height - originalHeight) / 2);
		}
		
		if (animateAspectChange)
		{
			new Tween(target, { x:targetX, y:targetY, width:targetW, height:targetH }, { frames:8, easing:Tween.easeOutQuad} );
		}
		else
		{
			target.x = targetX;
			target.y = targetY;
			target.width = targetW;
			target.height = targetH;
		}
		
		return aspectRatio = changeValue("aspectRatio", value);
	}
}

/**
	The enumerated values of `AspectScaleBehavior.aspectRatio`.

	All values result in targets centered within the visible area of their 
	parent.
**/
enum AspectRatio
{
	/**
		Maintains the original aspect ratio, resizing the target to fit within 
		the size of its parent. If the target has a different aspect ratio to 
		its parent, this value will result in horizontal or vertical gaps 
		around the target.
	**/
	FIT;

	/**
		Maintains the original aspect ratio, resizing the target to completely 
		fill the visible area of its parent. If the target has a different 
		aspect ratio to its parent, this value will result in horizontal or 
		vertical overflow outside the parent's visible area.
	**/
	FILL;

	/**
		Resizes the height of the target to that of its parent, and its aspect 
		ratio to four by three.
	**/
	FOUR_THREE;

	/**
		Resizes the height of the target to that of its parent, and its aspect 
		ratio to sixteen by nine.
	**/
	SIXTEEN_NINE;

	/**
		Maintains the original size of the target, only centering it within its 
		parent's visible area.
	**/
	NO_SCALE;
	
	/**
		Resizes the target to the exact width and height of its parent.
	**/
	EXACT_FIT;
}
