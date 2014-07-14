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

package mcore.crypto;
import haxe.io.Bytes;

#if haxe3
import haxe.crypto.BaseCode;
#else
import haxe.BaseCode;
#end

/**
	Provides Base64 encoding and decoding as defined by RFC 2045.
**/
class Base64
{
	public static inline var BASE:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
	public static inline var DEFAULT_VARIANT_CHARS:String = "+/";

	/**
		The variant base characters used in this Base64 instance. Defaults to '+/'.
	**/
	public var variants(default, null):String;

	var base:BaseCode;

	/**
		@param variants   optional string containing the variant characters of the base encoding. Defaults to '+/'
	**/
	public function new(?variants:String = DEFAULT_VARIANT_CHARS)
	{
		this.variants = variants;
		base = new BaseCode(Bytes.ofString(BASE + variants));
	}

	/**
		Base64 encode a string value.
	**/
	public static function encode(value:String):String
	{
		var base = new Base64();
		return base.encodeString(value);
	}

	/**
		Base64 encode a string value.
	**/
	public function encodeString(value:String):String
	{
		return encodeBytes(Bytes.ofString(value));
	}

	/**
		Base64 encode a byte array.
	**/
	public function encodeBytes(bytes:Bytes):String
	{
		var padding = switch (bytes.length % 3)
		{
			case 0: "";
			case 1: "==";
			case 2: "=";
			default: "";
		}

		return base.encodeBytes(bytes).toString() + padding;
	}

	/**
		Decode a base64 encoded string into a string value.
	**/
	public static function decode(value:String):String
	{
		var base = new Base64();
		return base.decodeString(value);
	}

	/**
		Decode a base64 encoded string into a string value.
	**/
	public function decodeString(value:String):String
	{
		return decodeBytes(Bytes.ofString(value)).toString();
	}

	/**
		Decode a base64 encoded byte array into a byte array.
	**/
	public function decodeBytes(bytes:Bytes):Bytes
	{
		var i = bytes.length;
		#if (haxe_ver >= 3.103)
		while (bytes.getString(i-1, 1) == '=')
		#else
		while (bytes.readString(i-1, 1) == '=')
		#end
			i--;

		if (i < bytes.length)
			bytes = bytes.sub(0, i);

		return base.decodeBytes(bytes);
	}
}
