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

import mdata.List;
import mdata.ArrayList;
import mdata.Collection;
import mcore.util.Iterables;
import mcore.exception.RangeException;

/**
	An ordered collection of indexed values.

	ArrayLists protect against out of range access and can notify observers 
	when values are added, inserted or removed.

	Example Usage:

	```haxe
	var list = new ArrayList<String>();
	list.addAll(["foo", "bar", "cat"]);
	trace(list.first);//outputs "foo";
	trace(list.last);//outputs "cat";
	```

	See `mdata.Collection` for more information.
**/
#if haxe3
class ArrayList<T> extends CollectionBase<T> implements List<T>
#else
class ArrayList<T> extends CollectionBase<T>, implements List<T>
#end
{
	/**
		Creates a new ArrayList containing an optional array of values.
		
		@param values optional collection of values to populate the ArrayList
	**/
	public function new(?values:Iterable<T> = null)
	{
		super();

		if (values != null)
			addAll(values);
	}

	/**
		The first item in the collection.
	**/
	public var first(get_first, null):T;

	function get_first():T
	{
		if (isEmpty())
			throw RangeException.numeric(0, 0, 0);

		return source[0];
	}

	/**
		The last item in the collection.
	**/
	public var last(get_last, null):T;

	function get_last():T
	{
		if (isEmpty())
			throw RangeException.numeric(0, 0, 0);

		return source[size - 1];
	}

	/**
		The number of items in the collection.
	**/
	public var length(get_length, null):Int;

	function get_length():Int
	{
		return source.length;
	}

	/**
		Adds a value to this List.
		
		@param value the value to add.
	**/
	override public function add(value:T):Void
	{
		source.push(value);
		
		if (eventsEnabled)
			notifyChanged(Add([value]), Indices([source.length - 1]));
	}
	
	/**
		Adds a collection of values to this collection.

		@param values the collection of values to add.
	**/
	override public function addAll(values:Iterable<T>):Void
	{
		if (values == null) return;
		
		var s = source.length;
		for (value in values)
		{
			source.push(value);
		}

		if (eventsEnabled && source.length != s)
		{
			var v:Array<T> = Std.is(values, Array) ? cast values : Iterables.toArray(values);
			notifyChanged(Add(v), Range(s, source.length));
		}
	}

	/**
		Inserts a value at a given index in the list.
		
		@param index The index at which to inset the value.
		@param value The value to insert.
		@throws `RangeException` when index is outside of the range of the 
			list (index < 0 || index > size).
	**/
	public function insert(index:Int, value:T):Void
	{
		if (index < 0 || index > size)
		{
			throw RangeException.numeric(index, 0, size);
		}

		source.insert(index, value);
		
		if (eventsEnabled)
			notifyChanged(Add([value]), Indices([index]));
	}

	/**
		Inserts a collection of values at a given index in the list.
		
		@param index The index at which to inset the value.
		@param values The collection of values to insert.
		@throws `RangeException` when index is outside of the range of the 
			list (index < 0 || index > size).
	**/
	public function insertAll(index:Int, values:Iterable<T>):Void
	{
		if (index < 0 || index > size)
		{
			throw RangeException.numeric(index, 0, size);
		}
		
		var i = index;
		for (value in values)
			source.insert(i++, value);

		if (eventsEnabled && i != index)
		{
			var v:Array<T> = Std.is(values, Array) ? cast values : Iterables.toArray(values);
			notifyChanged(Add(v), Range(index, i));
		}
	}

	/**
		Replaces a value at a specified index.

		@return The replaced value
		@throws `RangeException` when index is outside of the range of the 
			list (index < 0 || index > size).
	**/
	public function set(index:Int, value:T):T
	{
		if (index < 0 || index > size)
		{
			throw RangeException.numeric(index, 0, size);
		}
		
		var item = source[index];
		source[index] = value;
		
		if (eventsEnabled)
			notifyChanged(Replace([item]), Indices([index]));
		
		return item;
	}

	/**
		Replace a collection of values starting at a specified index.

		@param  index The index at which to begin replacement.
		@param  values The values to set
		@return The replaced values
		@throws `RangeException` when index is outside the bounds of the List
			or when the index plus the number of values exceed the size of the 
			list.
	**/
	public function setAll(index:Int, values:Iterable<T>):Array<T>
	{
		var count = Iterables.size(values);
		var max = index + count;

		if (index < 0)
		{
			throw RangeException.numeric(index, 0, size);
		}
		else if (max > size)
		{
			throw RangeException.numeric(max, 0, size);
		}

		var removed = [];
		if (count > 0)
		{
			var i = index;
			for (value in values)
			{
				removed.push(source[i]);
				source[i++] = value;
			}
	
			if (eventsEnabled)
				notifyChanged(Replace(removed), Range(index, max));
		}
		return removed;
	}

	/**
		Returns a value at a given index in the list.
		
		@param index The index of the value to return.
		@return The requested value.
		@throws `RangeException` when index is outside of the range of the 
			list (index < 0 || index > size).
	**/
	public function get(index:Int):T
	{
		if (index < 0 || index >= size)
		{
			throw RangeException.numeric(index, 0, size);
		}

		return source[index];
	}

	/**
		Returns the first index at which value exists in the list, or `-1` if 
		it is not found.
		
		@param value The value to index.
		@return The index of the value, or -1 if it is not found.
	**/
	public function indexOf(value:T):Int
	{
		for (i in 0...source.length)
			if (source[i] == value)
				return i;
		
		return -1;
	}

	/**
		Returns the last index at which the value exists in this List, or `-1` 
		if not found.
	**/
	public function lastIndexOf(value:T):Int
	{
		var i = source.length;
		while (i-- > 0)
			if (source[i] == value)
				return i;
		
		return -1;
	}

	/**
		Removes all values from this List.
	**/
	override public function clear():Void
	{
		if (isEmpty()) return;

		var s = source.length;
		var values = source.splice(0, source.length);
		trace('REMOVED');
		if (eventsEnabled)
		{
			
			notifyChanged(Remove(values), Range(0, s));
		}
	}

	override function notifyChanged(eventType:CollectionEventType<T>, ?payload:Dynamic)
	{
		changed.dispatch(untyped new ListEvent(eventType, payload));
	}

	/**
		Remove the value at a specified index.
		
		@param index The index of the value to remove.
		@return The removed value.
		@throws `RangeException` when index is outside of the range of the 
			list (index < 0 || index > size).
	**/
	public function removeAt(index:Int):T
	{
		if (index < 0 || index >= size)
		{
			throw RangeException.numeric(index, 0, size);
		}

		var value = source.splice(index, 1);
		if (eventsEnabled)
			notifyChanged(Remove(value), Indices([index]));
		return value[0];
	}
    
	/**
		Remove the first occurrence of the specified value from this List.
		
		@param value The value to remove.
		@return `true` if a value was removed, `false` if not found.
	**/
	override public function remove(value:T):Bool
	{
		var index = -1;
		var removed:Array<T> = null;
		for (i in 0...source.length)
		{
			if (source[i] == value)
			{
				index = i;
				removed = source.splice(i, 1);
				break;
			}
		}
		
		if (eventsEnabled && index != -1)
			notifyChanged(Remove(removed), Indices([index]));

		return index != -1;
	}

	/**
		Remove a range of values starting at a specified index up until, but not including
		an end index. 
		
		If no end index is defined then the range extends to the end of the List.
		
		A negative end index is processed as an offset from the end of the List. For example
		`list.removeRange(4, -1)` removes the third value through to the second last.
		
		If the endIndex is greater than the length of the List it is capped at this value.
		
		If the start index is greater than or equal to the end index, an empty Array is returned.
		
		@param startIndex The index at which to begin the removal (inclusive)
		@param endIndex The index at which to end the removal (exclusive)
		@return An Array of removed values
		@throws mcore.exception.RangeException When startIndex is outside of the 
			bounds of the List.
	**/
	public function removeRange(startIndex:Int, endIndex:Null<Int> = null):Array<T>
	{
		if (startIndex < 0 || startIndex >= size) throw RangeException.numeric(startIndex, 0, size);
		else if (endIndex == null || endIndex > size) endIndex = size;
		else if (endIndex < 0) endIndex = size + endIndex;
		
		if (endIndex <= startIndex) return [];
		
		var removed = source.splice(startIndex, endIndex - startIndex);

		if (eventsEnabled)
			notifyChanged(Remove(removed), Range(startIndex, endIndex));
		
		return removed;
	}

	/**
		Remove all occurrences of the specified values from this List.
		 
		@param values The values to remove.
		@return `true` if one or more values were removed, `false` if not found.
	**/
	override public function removeAll(values:Iterable<T>):Bool
	{
		if (values == null) return false;
		
		var removed:Array<T> = [];
		var indices:Array<Int> = [];
		var i = source.length;
		while (i-- > 0)
		{
			for (value in values)
			{
				if (source[i] == value)
				{
					removed.push(source.splice(i, 1)[0]);
					indices.unshift(i);
					break;
				}
			}
		}

		if (eventsEnabled && removed.length > 0)
		{
			notifyChanged(Remove(removed), Indices(indices));
		}

		return removed.length > 0;
	}
}
