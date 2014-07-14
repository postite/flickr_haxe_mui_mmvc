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

package mcore.net;

import mcore.exception.FormatException;
import mcore.util.QueryStrings;

#if haxe3
import haxe.ds.StringMap;
#else
private typedef StringMap<T> = Hash<T>
#end

using mcore.util.Strings;

/**
	Represents a URI in the Generic form as detailed in RFC 2396.

	For performance reasons validation of uri strings are limited, meaning a
	malformed string is likely to result in URI instance with incorrect properties.

	If a uri string is parsed which starts with "www." it's scheme is assumed to be "http".

	Valid Examples:
		
		http://usr:pwd@www.test.com:81/dir/dir.2/index.htm?q1=0&&test1&test2=value#top
		https://www.test.com#top
		www.test.com
		test.com
		ws://localhost:2001
		wss://localhost:2001
		../../dir/src/app.js
		mailto:dave@example.com

	Usage:

		var uri = URI.parse("http://www.test.com/js/app.js?p=hello#top);
		trace(uri.scheme); // http
		trace(uri.host); // www.test.com
		trace(uri.path); // /js/app.js
		trace(uri.directory); // /js
		trace(uri.file); // app.js
		trace(uri.parameters.get("p")); // hello
		trace(uri.anchor); // top


	@see http://www.faqs.org/rfcs/rfc2396.html
**/
class URI
{
	public static inline var DEFAULT_SCHEME:String = "http";

	public static inline var DEFAULT_HTTP_PORT:Int = 80;
	public static inline var DEFAULT_HTTPS_PORT:Int = 443;
	public static inline var DEFAULT_WS_PORT:Int = 80;
	public static inline var DEFAULT_WSS_PORT:Int = 443;
	public static inline var DEFAULT_TELNET_PORT:Int = 21;
	public static inline var DEFAULT_SSH_PORT:Int = 22;

	/**
		Scheme if URI is absolute, null if relative.
		
		E.g http, https, ftp, ws, mailto, telnet.
	**/
	@:isVar public var scheme(get_scheme, set_scheme):String;

	/**
		User if present in URI or null if not.
		
		E.g 'dave' in 'mailto:dave@example.com'
	**/
	public var user:String;

	/**
		Password if present in URI or null if not.
		
		E.g. 'pwd' in 'http://usr:psd@example.com'
	**/
	public var password:String;

	/**
		User and, if present, password. Null if neither are present.
		
		E.g. 'usr:psd' in 'http://usr:psd@example.com' or 'usr' in http://usr@example.com
		
		Readonly.
	**/
	public var userInfo(get_userInfo, null):String;

	/**
		Host if URI is absolute, null if relative.
		
		E.g www.example.com
	**/
	public var host:String;

	/**
		If not explicitly defined then defaults to the following:
		
		- 21 for telnet
		- 22 for ssh
		- 80 for http and ws
		- 443 for https and wss.
		
		Null if undefined and the default port cannot be determined.
	**/
	@:isVar public var port(get_port, set_port):Null<Int>;

	/**
		The scheme, host and port concatenated 
		
		E.g. http://www.example.com:2000
		
		If the port is the default for the scheme then it will be omitted.

		Readonly.
	**/
	@:isVar public var qualifiedHost(get_qualifiedHost, null):String;

	/**
		Concatenation of userInfo, host and port. Null if URI is relative.
		
		Even if the port is the default for the scheme it will still be included.
		
		E.g. usr:pwd@www.test.com:80

		Readonly.
	**/
	public var authority(get_authority, null):String;

	/**
		StringMap containing the name-value pairs found in the URI's query string.
	**/
	public var parameters(default, null):StringMap<String>;

	/**
		The query parameters encoded as name-value pairs. Null if no query parameters are defined.
		
		E.g ?a=b&c=d.

		Setting this will reset the parameters map with the name-value pairs specified.
	**/
	public var query(get_query, set_query):String;

	/**
		Any path appended onto the host or null if undefined.
		
		E.g. /resource/path
	**/
	public var path:String;

	/**
		The path minus any file or null if no directory is defined.
		
		E.g. "/resource/path" given path "/resource/path/file.txt"

		Readonly.
	**/
	public var directory(get_directory, null):String;

	/**
		The file found under the path or null if no file is defined. 
		
		E.g. "file.txt" given path "path/to/file.txt"
		
		Readonly.
	**/
	public var file(get_file, null):String;

	/**
		The fragment (#) value if this URI has one. Null if undefined.
	**/
	public var fragment:String;
	
	
	static var REGEX = ~/^(([^:\/?#]+):)?(\/\/)?(([^\/?#]*))?([^?#]*)(\?([^#]*))?(#(.*))?/;
	
	// the divider after the scheme e.g. "//"
	var divide:String;

	/**
		Create a URI instance parsed and built from a valid RFC 2396 encoded string. 
		
		@param uriString The encoded string to parse into a URI instance.
		@throws mcore.exception.FormatException if uri is malformed. 
				Note that the URI parsing algorithm is very lenient so you are unlikely to see this exception raised.
	**/
	public static function parse(uriString:String):URI
	{
		// Unlikely to ever mismatch due to liberal regex.
		if (!REGEX.match(uriString))
			throw new FormatException("URI appears malformed: " + uriString);
		
		return buildURI(uriString);
	}
	
    function new(scheme:String, divide:String, user:String, password:String, host:String, port:Null<Int>, path:String, query:String, fragment:String)
    {
	    this.scheme = scheme;
	    this.divide = divide;
	    this.user = user;
	    this.password = password;
	    this.host = host;
	    this.port = port;
	    this.path = path;
	    this.parameters = QueryStrings.decodeQueryString(query);
	    this.fragment = fragment;
    }
	
	function get_scheme()
	{
		if (scheme != null)
			return scheme;
		
		if (host != null && host.indexOf("www.") == 0)
			return "http";
		
		return null;
	}
	
	function set_scheme(value:String):String
	{
		return scheme = value;
	}

	function get_port()
	{
		return (port != null) ? port : defaultPort();
	}

	function defaultPort()
	{
		return switch(scheme)
		{
			case "http": DEFAULT_HTTP_PORT;
			case "https": DEFAULT_HTTPS_PORT;
			case "ws": DEFAULT_WS_PORT;
			case "wss": DEFAULT_WSS_PORT;
			case "telnet": DEFAULT_TELNET_PORT;
			case "ssh": DEFAULT_SSH_PORT;
			default: null;
		}
	}
	
	function set_port(value:Null<Int>):Null<Int>
	{
		return port = value;
	}
	
	function get_userInfo()
	{
		if (user != null)
			return (password != null) ? user + ":" + password : user;
		else if (password != null)
			return password;
		else
			return null;
	}
	
	function get_qualifiedHost()
	{
		var s = "";

		if (scheme != null)
			s += scheme + ":";
		if (divide != null)
			s += divide;
		if (host != null)
			s += host;
		if (port != defaultPort())
			s += ":" + port;

		return s;
	}
	
	function get_authority()
	{
		var s = "";
		if (userInfo != null)
			s += userInfo + "@";

		if (host != null)
			s += host;
		
		if (port != null)
			s += ":" + port;
		
		return (s != "") ? s : null;
	}
	
	function get_query()
	{
		var str = QueryStrings.encodeQueryString(parameters);
		return (str == "") ? null : str;
	}
	
	function set_query(value:String):String
	{
		parameters = QueryStrings.decodeQueryString(value);
		return value;
	}
	
	function get_directory()
	{
		if (path == null)
			return null;
		
		if (file == null)
			return path;
		
		var parts = path.split("/");
		parts.pop();
		return parts.join("/");
	}
	
	function get_file()
	{
		if (path == null)
			return null;
		
		var file = path.split("/").pop();
		if (file.indexOf(".") != -1)
			return file;
		return null;
	}

	/**
		Return a copy of this URI instance. 
	**/
	public function copy():URI
	{
		return URI.parse(toString());
	}

	/**
		Compare this URI with a given value to determine of they are equal.
		  
		Comparison is made on the string representation of each.
	**/
	public function equals(value:Dynamic)
	{
		var uri = Std.string(value);
		return uri == toString();
	}

	/**
		Constructs and returns the string representation of this URI. 
	**/
	public function toString()
	{
		var s = "";
		
		if (scheme != null)
			s += scheme + ":";
		if (divide != null)
			s += divide;
		if (userInfo != null)
			s += userInfo + "@";
		if (host != null)
			s += host;
		if (port != defaultPort())
			s += ":" + port;
		if (path != "")
			s += path;

		s += QueryStrings.encodeQueryString(parameters);

		if (fragment != null)
			s += "#" + fragment;
		
		return s;
	}

	static function buildURI(value:String):URI
	{
		var scheme = REGEX.matched(2);
		var divide = REGEX.matched(3);
		var host = REGEX.matched(4);
		var user:String = null;
		var password:String = null;
		var path = REGEX.matched(6);
		var port:Null<Int> = null;
		var query = REGEX.matched(7);
		var fragment = REGEX.matched(9);
		
		// regex isn't perfect so do a little post-processing
		
		// if relative host takes first relative path segment
		if (host == "..")
		{
			path = host + path;
			host = null;
		}
		else
		{
			// www.example.com:45 causes issues due to first ':' making scheme www.example.com
			var i = Std.parseInt(host);
			if (i != 0 && i != null)
			{
				port = i;
				host = scheme;
				scheme = null;
			}
		}

		if (host != null)
		{
			var parts:Array<String>;
			if (host.indexOf("@") != -1)
			{
				parts = host.split("@");
				user = parts.shift();
				host = parts.join("@");
				
				if (user.indexOf(":") != -1)
				{
					parts = user.split(":");
					user = parts.shift();
					password = parts.join(":");
				}
			}

			if (host.indexOf(":") != -1)
			{
				parts = host.split(":");
				port = Std.parseInt(parts.pop());
				host = parts.join(":");
			}
		}

		if (path != null && path.length > 1 && path.lastChar() == "/")
			path = path.substr(0, path.length - 1);
		
		if (fragment != null)
			fragment = fragment.substr(1);

		return new URI(scheme, divide, user, password, host, port, path, query, fragment);		
	}
}
