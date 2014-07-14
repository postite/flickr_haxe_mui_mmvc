package mui.display;

import mui.core.Node;

using mcore.util.Floats;
using mui.display.Color;

/**
	A color `GraphicStyle` with static methods for color transformation.

	```haxe
	rectangle.fill = new Color(0xFF0000);
	```
**/
class Color extends Node implements GraphicStyle
{
	//------------------------------------------------------------------------- rgb
	
	/**
		Converts a number to a hexadecimal value. Accepted values range between 
		0 (white) and 1 (black).
		@param gray A number between 0 and 1. 
		@returns The gray color in a hexadecimal format.
	**/
	public static function fromGray(gray:Float):Int
	{
		gray = gray.clamp(0, 1);
		return fromRGB(gray, gray, gray);
	}
	
	/**
		Converts a hexadecimal color to a grayscale value.
		@param color The hexadecimal color to convert.
		@returns A number representing the color converted to a grayscale value.
	**/
	public static function toGray(color:Int):Float
	{
		return 0.3 * toRed(color) + 0.59 * toGreen(color) + 0.11 * toBlue(color);
	}
	
	//------------------------------------------------------------------------- rgb
	
	/**
		Converts a color from RGB to hexadecimal
		@param red The red channel of the color.
		@param green The green channel of the color.
		@param blue The blue channel of the color.
		@returns The color as a hexadecimal number.
	**/
	public static function fromRGB(red:Float, green:Float, blue:Float):Int
	{
		red = red.clamp(0, 1) * 0xFF;
		green = green.clamp(0, 1) * 0xFF;
		blue = blue.clamp(0, 1) * 0xFF;
		
		return Math.round(red) << 16 | Math.round(green) << 8 | Math.round(blue);
	}
	
	/**
		Converts a color from hexadecimal to RGB
		@param color The hexadecimal color to apply the conversion to.
		@returns The color in a RGB format.
	**/
	public static function toRGB(color:Int):RGB
	{
		return {red:toRed(color), green:toGreen(color), blue:toBlue(color)};
	}
	
	/**
		Gets the red channel from a color
		@param color The original hexadecimal color.
		@returns The red channel of the color.
	**/
	inline public static function toRed(color:Int):Float
	{
		return (color >> 16 & 0xFF) / 0xFF;
	}
	
	/**
		Gets the green channel from a color
		@param color The original hexadecimal color.
		@returns The green channel of the color.
	**/
	inline public static function toGreen(color:Int):Float
	{
		return (color >> 8 & 0xFF) / 0xFF;
	}
	
	/**
		Gets the blue channel from a color
		@param color The original hexadecimal color.
		@returns The blue channel of the color.
	**/
	inline public static function toBlue(color:Int):Float
	{
		return (color & 0xFF) / 0xFF;
	}
	
	//------------------------------------------------------------------------- hsl
	
	/**
		Converts a color from HSL to hexadecimal
		@param hue A value representing the hue of the color.
		@param saturation A value representing the saturation of the color.
		@param lightness A value representing the lightness of the color.
		@returns The color as a hexadecimal number.
	**/
	public static function fromHSL(hue:Float, saturation:Float, lightness:Float):Int
	{
		hue = hue.wrap(0, 1);
		saturation = saturation.clamp(0, 1);
		lightness = lightness.clamp(0, 1);
		
		var red:Float;
		var green:Float;
		var blue:Float;
		
		if (saturation == 0)
		{
			red = green = blue = lightness; // achromatic
		}
		else
		{
			var q = lightness < 0.5 ? lightness * (1 + saturation) : lightness + saturation - lightness * saturation;
			var p = 2 * lightness - q;
			
			red = hue2rgb(p, q, hue + 1/3);
			green = hue2rgb(p, q, hue);
			blue = hue2rgb(p, q, hue - 1/3);
		}
		
		return fromRGB(red, green, blue);
	}
	
	/**
		Converts a color from hexadecimal to HSL
		@param color The color as a hexadecimal number.
		@returns The color in a HSL format.
	**/
	public static function toHSL(color:Int):HSL
	{
		var r = toRed(color);
		var g = toGreen(color);
		var b = toBlue(color);

		var max:Float = Math.max(r, Math.max(g, b));
		var min:Float = Math.min(r, Math.min(g, b));
		
		var h:Float, s:Float, l:Float;

		h = s = l = (max + min) / 2;

		if (max == min)
		{
			h = s = 0;
		}
		else
		{
			var d:Float = max - min;
			s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
			
			if (max == r) h = (g - b) / d + (g < b ? 6 : 0);
			else if (max == g) h = (b - r) / d + 2;
			else h = (r - g) / d + 4;
			
			h /= 6;
		}
		
		return {hue:h, saturation:s, lightness:l};
	}
	
	//channels
	
	/**
		Returns the hue of a color.
		@param color The color as a hexadecimal number.
		@returns The hue of a color.
	**/
	public static function toHue(color:Int):Float
	{
		return toHSL(color).hue;
	}
	
	/**
		Returns the saturation of a color.
		@param color The color as a hexadecimal number.
		@returns The saturation of a color.
	**/
	public static function toSaturation(color:Int):Float
	{
		return toHSL(color).saturation;
	}
	
	/**
		Returns the lightness of a color.
		@param color The color as a hexadecimal number.
		@returns The lightness of a color.
	**/
	public static function toLightness(color:Int):Float
	{
		return toHSL(color).lightness;
	}
	
	// modify
	
	public static function spin(color:Int, amount:Float):Int
	{
		var hsl = toHSL(color);
		return fromHSL(hsl.hue + amount, hsl.saturation, hsl.lightness);
	}
	
	/**
		Saturates a color
		@param color The color to apply the saturation to.
		@param amount An amount to saturate the color by.
		@returns The saturated color as a hexadecimal number.
	**/
	public static function saturate(color:Int, amount:Float):Int
	{
		var hsl = toHSL(color);
		return fromHSL(hsl.hue, hsl.saturation + amount, hsl.lightness);
	}
	
	/**
		Desaturates a color
		@param color The color to apply the saturation to.
		@param amount An amount to desaturate the color by.
		@returns The desaturated color as a hexadecimal number.
	**/
	public static function desaturate(color:Int, amount:Float):Int
	{
		var hsl = toHSL(color);
		return fromHSL(hsl.hue, hsl.saturation - amount, hsl.lightness);
	}
	
	/**
		Lightens a color
		@param color The color to lighten.
		@param amount An amount to lighten the color by.
		@returns The lightened color as a hexadecimal number.
	**/
	public static function lighten(color:Int, amount:Float):Int
	{
		var hsl = toHSL(color);
		return fromHSL(hsl.hue, hsl.saturation, hsl.lightness + amount);
	}
	
	/**
		Darkens a color
		@param color The color to darken.
		@param amount An amount to darken the color by.
		@returns The darkened color as a hexadecimal number.
	**/
	public static function darken(color:Int, amount:Float):Int
	{
		var hsl = toHSL(color);
		return fromHSL(hsl.hue, hsl.saturation, hsl.lightness - amount);
	}
	
	// helper
	
	private static function hue2rgb(p:Float, q:Float, t:Float):Float
	{
		if (t < 0) t += 1;
		if (t > 1) t -= 1;
		if (t < 1/6) return p + (q - p) * 6 * t;
		if (t < 1/2) return q;
		if (t < 2/3) return p + (q - p) * (2/3 - t) * 6;
		return p;
	}
	
	//------------------------------------------------------------------------- string
	
	/**
		Returns the color as a hexadecimal string with the prefix 0x.
		@param color The hexadecimal color.
		@returns The color as a hexadecimal string.
	**/
	public static function toHexString(color:Int):String
	{
		return "0x" + StringTools.lpad(StringTools.hex(color), "0", 6);
	}
	
	/**
		Returns the color as a hexadecimal string with the prefix #.
		@param color The hexadecimal color.
		@returns The color as a hexadecimal string.
	**/
	public static function toHexStyle(color:Int):String
	{
		return "#" + StringTools.lpad(StringTools.hex(color), "0", 6);
	}
	
	/**
		Returns the color as an rgb string.
		@param color The hexadecimal color.
		@returns The color as an rgb string.
	**/
	public static function toRGBStyle(color:Int):String
	{
		var rgb = color.toRGB();
		return "rgb(" + Math.floor(rgb.red * 0xFF) + "," + Math.floor(rgb.green * 0xFF) + "," + Math.floor(rgb.blue * 0xFF) + ")";
	}
	
	/**
		Returns the color as an rgba string.
		@param color The hexadecimal color.
		@param alpha The alpha channel of the color.
		@returns The color as an rgba string.
	**/
	public static function toRGBAStyle(color:Int, alpha:Float):String
	{
		var rgb = color.toRGB();
		return "rgba(" + Math.floor(rgb.red * 0xFF) + "," + Math.floor(rgb.green * 0xFF) + "," + Math.floor(rgb.blue * 0xFF) + "," + alpha + ")";
	}
	
	/**
		Casts a typed ColorValue to it's hexadecimal equivalent.
		@param c The typed value to cast.
		@returns The ColorValue as a hexadecimal number.
	**/
	public static function toInt(c:ColorValue):Int
	{
		return switch (c)
		{
			case black: 0x000000;
			case white: 0xFFFFFF;
			
			case red: 0xFF0000;
			case green: 0x00FF00;
			case blue: 0x0000FF;
			
			case yellow: 0xFFFF00;
			case aqua: 0x00FFFF;
			case fuchsia: 0xFF00FF;
			
			case gray(value): fromGray(value);
			case rgb(red, green, blue): fromRGB(red, green, blue);
			case hsl(hue, saturation, lightness): fromHSL(hue, saturation, lightness);
		}
	}
	
	/**
		@param value The hexadecimal value of the color. The default is 0xFFFFFF.
		@param alpha The alpha channel of the color. The default is 1.0.
	**/
	public function new(?value:Int=0xFFFFFF, ?alpha:Float=1.0):Void
	{
		super();
		
		// set initial values first
		this.value = 0xFFFFFF;
		this.alpha = 1.0;
		
		// then constructor params
		this.value = value;
		this.alpha = alpha;
	}
	
	/**
		A hexadecimal number representing the color.
	**/
	@:set var value:Int;
	
	/**
		A number between 0 and 1 representing the alpha channel of the color.
	**/
	@:set var alpha:Float;

	#if (flash || openfl)
	
	/**
		Fills an area with a color.
		@param graphic The area to fill.
	**/
	public function beginFill(graphic:Rectangle)
	{
		graphic.sprite.graphics.beginFill(value, alpha);
	}
	
	public function beginStroke(graphic:Rectangle)
	{
		beginFill(graphic);
	}
	
	#elseif js
	
	/**
		Applies a color to an area.
		@param graphic The area to apply the fill to.
	**/
	public function applyFill(graphic:Rectangle)
	{
		graphic.setStyle("backgroundColor", value.toRGBAStyle(alpha));
		graphic.setStyle("backgroundImage", null);
	}
	
	/**
		Applies a border to an area.
		@param graphic The area to apply the fill to.
	**/
	public function applyStroke(graphic:Rectangle)
	{
		graphic.setStyle("borderColor", value.toRGBAStyle(alpha));
	}
	
	#end
}

/**
	A structure representing the components of an RGB color.
**/
typedef RGB = {red:Float, green:Float, blue:Float}

/**
	A structure representing the components of an HSL color.
**/
typedef HSL = {hue:Float, saturation:Float, lightness:Float}

/**
	Enumerated color values.
**/
enum ColorValue
{
	black;
	white;
	red;
	green;
	blue;
	yellow;
	aqua;
	fuchsia;
	gray(value:Float);
	rgb(red:Float, green:Float, blue:Float);
	hsl(hue:Float, saturation:Float, lightness:Float);
}
