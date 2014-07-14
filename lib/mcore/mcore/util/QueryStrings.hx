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


#if haxe3
import haxe.ds.StringMap;
#if js import js.Browser;#end
#else
private typedef StringMap<T> = Hash<T>
#if js private typedef Browser = js.Lib #end
#end

/**
	Utility for working with query string parameters.

	You can access either Flash or JavaScript parameters through the `QueryStringUtil.parameters` 
	property.

	Under JavaScript parameters are taken from the browser's window location, and under Flash 
	they're taken from the primary swf loader's parameters.
**/
class QueryStrings
{
	@:isVar static public var parameters(get_parameters, null):StringMap<String>;

	static function get_parameters():StringMap<String>
	{
		if (parameters == null)
		{
			#if (js && !nodejs)

			parameters = decodeQueryString(Browser.window.location.search);

			#else

			parameters = new StringMap();

			#if flash

			var params:Dynamic = flash.Lib.current.loaderInfo.parameters;
			for (key in Reflect.fields(params))
				parameters.set(key, StringTools.urlDecode(Reflect.field(params, key)));

			#end
			#end
		}
		return parameters;
	}

	public static function decodeQueryString(query:String):StringMap<String>
	{
		var params = new StringMap<String>();

		if (query != null && query.length > 0)
		{
			if (query.charAt(0) == "?")
				query = query.substr(1);
			
			var pairs = query.split("&");
			for (pair in pairs)
			{
				var pairValues = pair.split("=");
				params.set(pairValues.shift(), StringTools.urlDecode(pairValues.join("=")));
			}
		}	
		return params;
	}

	public static function encodeQueryString(params:StringMap<Dynamic>):String
	{
		var query = "";

		if (params != null)
		{
			for (key in params.keys())
				query += "&" + key + "=" + StringTools.urlEncode(Std.string(params.get(key)));

			if (query.length > 0)
				query = "?" + query.substr(1);
		}
		return query;
	}
}
