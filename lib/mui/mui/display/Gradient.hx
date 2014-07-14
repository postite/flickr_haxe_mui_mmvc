package mui.display;

import mui.core.Node;
import mcore.util.Colors;

/**
	A `GraphicStyle` representing a color gradient.

	A gradient can be applied to a Rectangle through the rectangle's fill 
	property as demonstrated below. The same gradient can also be applied to 
	many rectangles through a single instance of the Gradient.
	
	```haxe
	var gradient = new Gradient([new GradientColor(0x454545, 1, 0.14),
								 new GradientColor(0x767575, 1, 0.85),
								 new GradientColor(0xa7a6a6, 1, 0.95)],
								 90);
	var rectangle = new Rectangle();
	rectangle.fill = gradient;
	```
**/
class Gradient extends Node implements GraphicStyle
{
	/**
		A list of GradientColors which to fill the gradient with.
	**/
	@:set var colors:Array<GradientColor>;

	/**
		A value indicating the rotate transformation of the gradient.
	**/
	@:set var rotation:Float;

	/**
		@param colors A list of GradientColors which to fill the Gradient with.
		@param rotation A value to apply to the rotate transformation of the 
		gradient.
	**/
	public function new(?colors:Array<GradientColor>, ?rotation:Float=0.0):Void
	{
		super();

		this.colors = [];
		this.rotation = 0;

		if (colors != null) this.colors = colors;
		this.rotation = rotation;
	}

	public function clone():Gradient
	{
		return new Gradient(colors, rotation);
	}
	
	#if (flash || openfl)

	/**
		Fills an area with a gradient.
		@param graphic The area to fill.
	**/
	public function beginFill(graphic:Rectangle)
	{
		var c = [];
		var a = [];
		var r = [];

		for (color in colors)
		{
			c.push(color.value);
			a.push(color.alpha);
			r.push(Std.int(color.position * 255));
		}

		var matrix:flash.geom.Matrix = new flash.geom.Matrix();
		matrix.createGradientBox(graphic.width, graphic.height, (rotation / 180) * Math.PI);
		graphic.sprite.graphics.beginGradientFill(flash.display.GradientType.LINEAR, cast c, a, r, matrix);
	}

	public function beginStroke(graphic:Rectangle)
	{
		var c = [];
		var a = [];
		var r = [];

		var colorStops:Array<Dynamic> = [];

		for (color in colors)
		{
			c.push(color.value);
			a.push(color.alpha);
			r.push(Std.int(color.position * 255));
		}

		var matrix:flash.geom.Matrix = new flash.geom.Matrix();
		matrix.createGradientBox(graphic.width, graphic.height, (rotation / 180) * Math.PI);
		graphic.sprite.graphics.beginGradientFill(flash.display.GradientType.LINEAR, cast c, a, r, matrix);
	}

	#elseif js

	/**
		Applies a gradient to an area. 
		@param graphic The area to apply the fill to.
	**/
	public function applyFill(graphic:Rectangle)
	{
		var styles:Array<String> = [];

		for (color in colors)
		{
			var rgbaStyle = Color.toRGBAStyle(color.value, color.alpha);
			styles.push(rgbaStyle + " " + Math.round(color.position * 100) + "%");
		}

		// set background color as fallback where gradient is not supported
		graphic.setStyle("backgroundColor", Color.toRGBAStyle(colors[0].value, colors[0].alpha));
		var gradient = JS.getPrefixedCSSName("linear-gradient(")+
			Std.int(-rotation)+"deg,"+styles.join(",")+")";
		graphic.setStyle("backgroundImage", gradient);
	}

	/**
		Applies a border to an area.
		@param graphic The area to apply the stroke to.
	**/
	public function applyStroke(graphic:Rectangle)
	{
		graphic.setStyle("borderColor", Color.toRGBStyle(colors[0].value));
	}
	#end

	#if uiml
	override public function setState(state:String)
	{
		super.setState(state);
		for (color in colors) color.setState(state);
	}
	#end
}