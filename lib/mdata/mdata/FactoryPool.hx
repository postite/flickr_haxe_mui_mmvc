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
	Utility class providing typed API for creating and recycling class instances
	with optional handlers for manipulating instances when added and removed from pool

	Features:
	
	- Map a typed data class with a typed instance class
	- Map multiple data types to the same instance types
	- Map different data types to different instance types
	- Optional handlers for manipulating instances when added and removed from pool
	- Request an instance using a data object
	- Release an instance back into the pool

	E.g.
	
	```haxe
	map(String, Foo)
	```

	Optional add and remove handlers can be set to configure the instance when
	it is requested from the pool or released back into the pool

	E.g.
	
	```haxe
	map(String, Foo, addFoo, recycleFoo);

	function addFoo(instance:Foo, data:String){}
	function recycleFoo(instance:Foo) {}
	```
**/
class FactoryPool
{
	var dataTypes:Array<Class<Dynamic>>;
	var instanceTypes:Array<Class<Dynamic>>;
	var instancePools:Array<Array<Dynamic>>;
	var adders:Array<Dynamic -> Dynamic -> Void>;
	var removers:Array<Dynamic -> Void>;

	public function new()
	{
		dataTypes = [];
		instanceTypes = [];
		instancePools = [];
		adders = [];
		removers = [];
	}

	/**
		Maps a typed data class with a typed instance class.
		Multiple data types can be registed for the same instance types
		Different data types can be registered for different instance types 

		Optional add and remove handlers can be set to configure the instance 
		when it is requested from the pool or released back into the pool

		E.g.
		
		```haxe
		map(String, Foo, addFoo, recycleFoo);

		function addFoo(instance:Foo, data:String){}
		function recycleFoo(instance:Foo) {}
		```

		@param dataType The data class type to map
		@param instanceType The class type to create an instance of when requested
		@param add Optional function handler when initialise is created or
			removed from the pool
		@param remove Optional function handler when instance is released back 
			into pool
	**/
	public function map<TData, TInstance>(dataType:Class<TData>, instanceType:Class<TInstance>,
		?add:TInstance -> TData -> Void=null,
		?remove:TInstance -> Void=null)
	{

		if(add == null) add = defaultAdd;
		if(remove == null) remove = defaultRemove;
		
		dataTypes.push(dataType);
		instanceTypes.push(instanceType);
		instancePools.push([]);
		adders.push(add);
		removers.push(remove);
	}

	/**
		Request a factory instance based on the current data.
		Returns an instance from a pool based on the class type of the data object

		@param data an instance of the data type to look up in the map
		@return a pooled instance from the corresponding data map, or null if 
			no mapping found
	**/
	public function request(data:Dynamic)
	{
		if (data == null) return null;

		for (i in 0...dataTypes.length)
		{
			var dataType = dataTypes[i];
			
			if (Std.is(data, dataType))
			{
				var instancePool = instancePools[i];
				var add = adders[i];

				if (instancePool.length > 0)
				{
					var instance = instancePool.pop();
					add(instance, data);
					return instance;
				}

				var instanceType:Class<Dynamic> = instanceTypes[i];
				var instance = mcore.util.Types.createInstance(instanceType, []);
				add(instance, data);
				return instance;
			}
		}

		return null;
	}

	/**
		Releases an existing instance back into the pool

		@param instance 	this instance to release
	**/
	public function release(instance:Dynamic)
	{
		for (i in 0...instanceTypes.length)
		{
			var instanceType = instanceTypes[i];
			var remove = removers[i];

			if (Std.is(instance, instanceType))
			{
				var instancePool = instancePools[i];
				instancePool.unshift(instance);
				remove(instance);
			}
		}
	}


	function defaultAdd<TInstance, TData>(instance:TInstance, data:TData)
	{

	}

	function defaultRemove<TInstance>(instance:TInstance)
	{
		
	}
}
