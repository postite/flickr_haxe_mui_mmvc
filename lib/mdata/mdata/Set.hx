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

import mcore.util.Iterables;
import mdata.Collection;

/**
	A collection of unique values backed by an array.

	Example Usage:

	```haxe
	var set = new Set<String>();
	set.addAll(["foo", "bar"]);
	trace(set.size);//2
	set.add("bar");
	trace(set.size);//2
	set.add("cat");
	trace(set.size);//3
	```

	See `mdata.Collection` for more information.
**/
class Set<T> extends CollectionBase<T>
{
	/**
		@param values	optional collection of values to populate the set.
	**/
	public function new(?values:Iterable<T> = null)
	{
		super();

		if (values != null)
			addAll(values);
	}

	/**
		Adds a value to the collection.
		
		@param value The value to add.
	**/
	override public function add(value:T):Void
	{
		if (contains(value))
			return;

		super.add(value);
	}

	/**
		Adds an array of values to the collection.
		
		@param values The array of values to add to the collection.
	**/
	override public function addAll(values:Iterable<T>):Void
	{
		if (values == null)
			return;

		var added = [];
		var s = size;
		for (value in values)
		{
			if (!contains(value))
			{
				source.push(value);
				added.push(value);
			}
		}

		if (eventsEnabled && size > s)
			notifyChanged(Add(added));
	}
}
