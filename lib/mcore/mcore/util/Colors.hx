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

package mcore.util;

/**
	Utility methods for working with colors.
**/
class Colors
{
	/**
		Converts a hexidecimal color to an array of its components. Each 
		component has a value between 0x00 and 0xFF.
		
		@param color 		the hexidecimal color to convert
		@return an array containing red, green abd blue components of color
	**/
	inline public static function hexToRGB(color:Int):Array<Int>
	{
		return [((color & 0xFF0000) >> 16),
				((color & 0x00FF00) >> 8),
				(color & 0x0000FF)];
	}
	
	/**
		Converts red, green and blue color components into a single 
		hexidecimal representation. Components are a value of 0x00 and 0xFF
		
		@param red 		the red component
		@param green 	the green component
		@param blue 	the blue component
		@return a hexidecimal representation of the color components
	**/
	inline public static function rgbToHex(red:Int, green:Int, blue:Int):Int
	{
		return red << 16 | green << 8 | blue;
	}
	
	/**
		Converts a hexidecimal color into a rgb style string.
		
		@param color 		the color to convert
		@return a style string of the form rgb(red,green,blue)
	**/
	inline public static function rgbStyle(color:Int):String
	{
		var rgb = hexToRGB(color);
		return "rgb(" + rgb[0] + "," + rgb[1] + "," + rgb[2] + ")";
	}
	
	/**
		Converts a hexidecimal color and alpha value into a rgba style string.
		
		@param color 		the color to convert
		@param alpha 		the style alpha
		@return a style string of the form rgba(red,green,blue,alpha)
	**/
	inline public static function rgbaStyle(color:Int, alpha:Float):String
	{
		var rgb = hexToRGB(color);
		return "rgba(" + rgb[0] + "," + rgb[1] + "," + rgb[2] + "," + alpha + ")";
	}
	
	/**
		Converts an rgba style string to a hexidecimal string reprisentation 
		of the color, discarding alpha.
		
		@param rgbStyle the style string
		@return the hexidecimal string
	**/
	inline public static function rgbaStyleToHex(rgbStyle:String):String
	{
		var rgbColorsStr:String, rgbColorsArr:Array<String>;
		rgbColorsStr = rgbStyle.substr(rgbStyle.indexOf("(") + 1, 11);
		rgbColorsArr = rgbColorsStr.split(",");
		return StringTools.hex(Colors.rgbToHex(Std.parseInt(rgbColorsArr[0]), Std.parseInt(rgbColorsArr[1]), Std.parseInt(rgbColorsArr[2])), 6);
	}
}
