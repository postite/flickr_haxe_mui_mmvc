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

/**
	A utility for creating and pooling class instances.

	Instances will be created when requested, and can be released into a pool. 
	Subsequent requests will return pooled instances if available, or create 
	additional instances if no pooled instances are available.
**/
class Pool<T>
{
	/**
		Creates a pool for a given type.

		```haxe
		var pool = Pool.forType(Foo);
		```
		
		@param type		The class to create a factory for.
		@return A factory for the type.
	**/
	public static function forType<T>(type:Class<T>):Pool<T>
	{
		return new Pool<T>(type);
	}

	/**
		The number of items currently inactive in the pool.
	**/
	public var size(get_size, null):Int;
	function get_size() { return instances.length; }

	var factory:Factory<T>;
	var instances:Array<T>;

	private function new(type:Class<T>)
	{
		factory = Factory.forType(type);
		instances = [];
	}

	/**
		Returns a class instance by either removing one from the pooled instances, 
		or creating a new instance if none are available.
		
		@return A pooled class instance.
	**/
	public function request():T
	{
		if (instances.length > 0)
			return instances.pop();

		return factory.create();
	}

	/**
		Releases an instance into the pool, making it available to subsequent 
		calls to request.
		
		@param instance The instance to release into the pool.
	**/
	public function release(instance:T)
	{
		instances.push(instance);
	}

	/**
		Removes all pooled instances.
	**/
	public function empty()
	{
		instances = [];
	}
}
