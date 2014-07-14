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

import mcore.exception.UnsupportedPlatformException;
import mcore.exception.FormatException;

/**
	Utility methods for working with dates
**/
class Dates
{
	/**
		Parses an ISO8601 time period into the number of milliseconds it 
		represents. The basic format of a time period is:
		[[value][units]]...
		Where value is an unsigned integer and units is one of:
		D	Days
		H	Hours
		M	Minuts
		S	Seconds
		
		@param value		The period string.
		@return The number of milliseconds represented by the period string.
		@see http://en.wikipedia.org/wiki/ISO_8601
	**/
	public static function parsePeriod(value:String):Int
	{
		var time:Int = 0;
		var buffer:String = "";
		
		for (i in 0...value.length)
		{
			var char:String = value.charAt(i);
			
			if (Std.parseInt(char) != null)
			{
				buffer += char;
			}
			else if (buffer.length > 0)
			{
				var unit:Int = switch(char)
				{
					case "D": 86400000;
					case "H": 3600000;
					case "M": 60000;
					case "S": 1000;
					default: 0;
				}

				time += unit * Std.parseInt(buffer);
				buffer = "";
			}
		}
		
		return time;
	}
	
	/**
		Converts a UTC timestamp to a timecode of the format: HH:MM:SS
		
		@param value 		the UTC time to convert
		@return the formatted timecode string
	**/
	public static function toTimeCode(value:Int):String 
	{
		var relative_date:String = "";
		var diff:Int = Std.int(value / 1000);
		var months:Int;
		var weeks:Int;
		var days:Int;
		var hours:Int;
		var minutes:Int;
		var seconds:Int;
		
		var dif:Int = diff;
		months = Math.floor(dif / 2419200);
		dif -= months * 2419200;
		weeks = Math.floor(dif / 604800);
		dif -= weeks * 604800;
		days = Math.floor(dif / 86400);
		dif -= days * 86400;
		hours = Math.floor(dif / 3600);
		dif -= hours * 3600;
		minutes = Math.floor(dif / 60);
		dif -= minutes * 60;
		seconds = dif;

		relative_date = StringTools.lpad(Std.string(hours), "0", 2) + ":" + 
			StringTools.lpad(Std.string(minutes), "0", 2) + ":" + 
			StringTools.lpad(Std.string(seconds), "0", 2);

		return relative_date;
	}


	#if (flash || js)
	
	static function getNativeDate():Dynamic
	{
		#if flash9
		return untyped __global__["Date"];
		#elseif flash
		return untyped _global["Date"];
		#elseif js
		return untyped __js__("Date");
		#else
		throw new mcore.exception.Exception("Date operation not supported under this platform");
		#end
		return null;
	}
	
	/**
		Converts a Date to UTC ISO-8601 compliant string.

		Example: 2012-06-20T12:11:08.188Z

		Currently only supported under JS, AS3 and AS2.
		
		@param date		the date to convert to utc iso string
		@return ISO-8601 compliant timestamp
	**/
	public static function toISOString(date:Date):String
	{
		var NativeDate = getNativeDate();
		var d = untyped __new__(NativeDate, date.getTime());
		
		return d.getUTCFullYear() + '-'
			+ StringTools.lpad("" + (d.getUTCMonth() + 1), "0", 2) + '-'
			+ StringTools.lpad("" + d.getUTCDate(), "0", 2) + 'T'
			+ StringTools.lpad("" + d.getUTCHours(), "0", 2) + ':'
			+ StringTools.lpad("" + d.getUTCMinutes(), "0", 2) + ':'
			+ StringTools.lpad("" + d.getUTCSeconds(), "0", 2) + '.'
			+ StringTools.rpad(("" + (Floats.round(d.getUTCMilliseconds()/1000, 3))).substr(2, 5), "0", 3)
			+ 'Z';
	}

	#else


	public static function toISOString(date:Date):String
	{
		throw new UnsupportedPlatformException("Unable to determine UTC date parts under this platform");
		return null;
	}

	#end

	#if (js || flash || php || cpp)
	/**
		Converts ISO-8601 compliant date string into a date object.

		Currently only supports UTC dates in the following format: YYYY-MM-DDThh:mm:ssZ

		Example: 2012-06-20T12:11:08.188Z

		@param value		the ISO-8601 string to convert to utc date
		@return Date object
	**/
	public static function fromISOString(value:String):Date
	{
		try
		{
			#if (debug)
			//NOTE(dom):invalid regexp with hxcpp 2.10
			if (!~/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d+)?Z/.match(value))
				throw "Invald format";
			#end

			var parts = value.split("-");
			var year = Std.parseInt(parts[0]);
			var month = Std.parseInt(parts[1]) - 1;

			parts = parts[2].split(":");
			var parts2 = parts[0].split("T");

			var date = Std.parseInt(parts2[0]);
			var hour = Std.parseInt(parts2[1]);
			var min = Std.parseInt(parts[1]);
			var sec = Std.parseInt(parts[2].split("Z")[0]);

			var utcTime = DateTools.makeUtc(year, month, date, hour, min, sec);

			return Date.fromTime(utcTime);
		}
		catch (e:Dynamic)
		{
			throw new FormatException("Date string is not in ISO compliant YYYY-MM-DDThh:mm:ssZ format [" + value + "]");
		}
		return null;
	}

	#else

	public static function fromISOString(value:String):Date
	{
		throw new UnsupportedPlatformException("Unable to determine UTC date parts under this platform");
		return null;
	}

	#end

	/**
		Converts a date to a UTC timestamp in *seconds*.
		
		This gives a consistent value across platforms by removing millisecond precision
		under platforms which support it.
		
		@param date		date to convert
		@return utc timestamp in seconds
	**/
	public static function toUTC(date:Date):Float
	{
		return Math.floor(date.getTime() / 1000);
	}

	/**
		Returns the UTC timezone offset from your local time in *minutes*.

		This can be positive or negative depending on your timezone and accounts for DST.
	**/
	public static function getUtcOffset():Int
	{
		var now = Date.now();
		#if (js || flash)
		return untyped now.getTimezoneOffset();
		#end
		throw new UnsupportedPlatformException("Unable to determine UTC offset under this platform");
		return 0;
	}
}
