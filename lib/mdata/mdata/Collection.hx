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

import msignal.EventSignal;
import msignal.Signal;

/**
	Event dispatched when a collection has changed.
**/
typedef CollectionEvent<T> = Event<Collection<T>, CollectionEventType<T>>;

/**
	Enumerated collection event types.
**/
enum CollectionEventType<T>
{
	/**
		One or more items have been added to a collection.
	**/
	Add(items:Array<T>);

	/**
		One or more items have been removed from a collection.
	**/
	Remove(items:Array<T>);

	/**
		One or more items have been replaced in a collection
	**/
	Replace(items:Array<T>);
}

/**
	An API for working with collections of data.

	The collection interface defines an API for working with collections of 
	values. The API defines methods for adding, removing and manipulating 
	values in the collection.

	Creating a concrete instance (e.g. `ArrayList`, `Stack`, `Set`, etc):
	
	```haxe
	var collection = new CollectionImpl<Foo>();
	```

	Adding and removing values:
	
	```haxe
	collection.add(foo1);
	collection.addAll([foo1, foo2, foo3]);		
	collection.remove(foo1);
	collection.clear();
	```

	Measuring and accessing values:
	
	```haxe
	collection.size
	collection.contains(foo1);
	collection.isEmpty());
	```

	Iterating through values:
	
	```haxe
	for(foo in collection)
	{
		trace(foo.bar);
	}
	var array = collection.toArray();
	```

	Observing changes to collection:
	
	```haxe
	collection.changed.add(changeHandler);
	collection.add(foo2);

	// ...

	function changeHandler(e:CollectionEvent)
	{
		// will execute when collection contents changes
	}
	```
**/
interface Collection<T>
{
	/**
		Dispatched when the values of this Collection change.
	**/
	var changed(get_changed, null):EventSignal<Collection<T>, CollectionEventType<T>>;

	/**
		Determines whether change events are broadcast. Default is true. 
	**/
	var eventsEnabled(get_eventsEnabled, set_eventsEnabled):Bool;

	/**
		The number of values in this collection.
	**/
	var size(get_size, null):Int;

	/**
		Add a value to this collection.
		
		@param value the value to add.
	**/
	function add(value:T):Void;

	/**
		Add a collection of values to this Collection.
		
		@param values the collection of values to add.
	**/
	function addAll(values:Iterable<T>):Void;

	/**
		Removes all values from this Collection.
	**/
	function clear():Void;

	/**
		Returns true if a value in this collection is equal to the one provided.
		
		Comparison is made using standard equality.
		
		@param value the value to check for.
		@return `true` if value exists in collection, `false` otherwise
	**/
	function contains(value:T):Bool;

	/**
		Returns true if this Collection contains no values or false otherwise.
	**/
	function isEmpty():Bool;

	/**
		The iterator enumerating this Collection.
	**/
	function iterator():Iterator<T>;

	/**
		Remove the first occurrence of the specified value from this Collection.
		
		@param value    the value to remove.
		@return true if a value was removed, false if not found.
	**/
	function remove(value:T):Bool;

	/**
		Remove all occurrences of the specified values from this Collection.
		 
		@param values   the values to remove.
		@return true if one or more values were removed, false if not found.
	**/
	function removeAll(values:Iterable<T>):Bool;

	/**
		Returns the values from this collection as an Array.
	**/
	function toArray():Array<T>;

	/**
		Returns the string representation of this collection.
	**/
	function toString():String;
}
