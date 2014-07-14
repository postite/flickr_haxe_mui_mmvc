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

package mdata;

#if !haxe3
private typedef Map<String, T> = Hash<T>;
#end

#if sys
import sys.FileSystem;
import sys.io.File;
import sys.io.FileOutput;
#end

#if flash
import flash.net.SharedObject;
import flash.net.SharedObjectFlushStatus;
#end

#if js
import js.Cookie;
#end

/**
	A map based data structure backed by a local persistent data store.

	The implementation on each platform must be defined through a partial class 
	which will be automatically merged into this base class at compile time.
**/
class LocalStorage<T>
{
	/**
		Determines if storage expiry is based on a user's session. Default is false.

		Note that session based storage is only supported on the JS target currently.
	 **/
	public var sessionExpiry:Bool;

	var namespace:String;
	var hash:Map<String, T>;
	
	public function new(namespace:String)
	{
		this.namespace = namespace;
		sessionExpiry = false;
		_new(namespace);

		var value = loadSerializedHash();
		if (value != null)
			hash = haxe.Unserializer.run(value);
		else
			hash = new Map();
	}
	
	/**
		Returns a stored value for the specified key.

		If a key is not found then an ArgumentException is thrown.

		@param key 	unique key to access value
		@throws mcore.exception.ArgumentException if not found
	**/
	public function get(key:String):T
	{
		if (hash.exists(key))
			return hash.get(key);

		throw new mcore.exception.ArgumentException("invalid key (" + key + ")");
	}

	/**
		Stores a value against the specified key.

		@param key 	unique key
		@param value
	**/
	public function set(key:String, value:T)
	{
		hash.set(key, value);
	}

	/**
		Removes the value for the specified key.

		@param key 	key of value to remove
		@return if key was found and removed
	**/
	public function remove(key:String):Bool
	{
		if (!hash.exists(key)) return false;
		hash.remove(key);
		return true;
	}

	/**
		Checks if the key exists.

		@param key 	unique key
		@return true if key exists
	**/
	public function exists(key:String):Bool
	{
		return hash.exists(key);
	}

	/**
		Saves the hash to local storage.
	**/
	public function save()
	{
		var value = haxe.Serializer.run(hash);
		saveSerializedHash(value);
	}

	/**
		Returns iterator of keys.
	**/
	public function keys():Iterator<String>
	{
		return hash.keys();
	}

	/**
		Returns iterator of values.
	**/
	public function iterator():Iterator<T>
	{
		var values:Array<T> = new Array();
		for (key in keys())
			values.push(get(key));
		return values.iterator();
	}

	/**
		Returns string representation of this class.
	**/
	public function toString()
	{
		return "LocalStorage[" + namespace + "]";
	}

////////////////////////////////////////////////////////////////////////////////
#if (nme && android)
////////////////////////////////////////////////////////////////////////////////

	function _new(namespace:String)
	{
		if (native_getString == null)
		{
			native_getString = nme.JNI.createStaticMethod("org.haxe.nme.GameActivity","getUserPreference","(Ljava/lang/String;)Ljava/lang/String;");
			native_putString = nme.JNI.createStaticMethod("org.haxe.nme.GameActivity","setUserPreference","(Ljava/lang/String;Ljava/lang/String;)V");
			native_clear = nme.JNI.createStaticMethod("org.haxe.nme.GameActivity","clearUserPreference","(Ljava/lang/String;)V");
		}
	}
	
	function loadSerializedHash():String
	{
		var value = native_getString(namespace);
		return (value == "" || value == null) ? null : value;
	}

	function saveSerializedHash(value:String)
	{
		native_putString(namespace, haxe.Utf8.encode(value));
	}

	public function clear()
	{
		native_clear(namespace);
		hash = new Hash();
	}
	
	static var native_getString:Dynamic;
	static var native_putString:Dynamic;
	static var native_clear:Dynamic;

////////////////////////////////////////////////////////////////////////////////
#elseif (neko || cpp)
////////////////////////////////////////////////////////////////////////////////

	var path:String;

	function _new(namespace:String)
	{
		path = "storage." + namespace + ".txt";
	}
	
	function loadSerializedHash():String
	{
		return FileSystem.exists(path) ? File.getContent(path) : null;
	}
	
	public function saveSerializedHash(value:String)
	{
		var file = File.write(path, false);
		file.writeString(value);
		file.close();
	}

	public function clear()
	{
		if (FileSystem.exists(path))
			FileSystem.deleteFile(path);
		
		hash = new Map();
	}

////////////////////////////////////////////////////////////////////////////////
#elseif flash
////////////////////////////////////////////////////////////////////////////////

	var storage:SharedObject;
	
	function _new(namespace:String)
	{
		storage = SharedObject.getLocal(namespace);
	}
	
	function loadSerializedHash():String
	{
		return storage.data.data;
	}

	public function saveSerializedHash(value:String)
	{
		storage.setProperty("data", value);
		storage.flush();
	}

	public function clear()
	{
		storage.clear();
		storage.flush();
		hash = new Map();
	}

////////////////////////////////////////////////////////////////////////////////
#elseif js
////////////////////////////////////////////////////////////////////////////////
	
	function _new(namespace:String) {}

	function loadSerializedHash():String
	{
		return Cookie.exists(namespace) ? Cookie.get(namespace) : null;
	}

	public function saveSerializedHash(value:String)
	{
		var expiry = sessionExpiry ? null : 365 * 5; // 5 years
		Cookie.set(namespace, value, expiry);
	}

	public function clear()
	{
		Cookie.remove(namespace);
		hash = new Map();
	}

#else

	#error

#end
}
