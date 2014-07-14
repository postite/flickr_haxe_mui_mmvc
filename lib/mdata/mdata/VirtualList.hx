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

import msignal.Signal;
import mdata.List;
import mdata.Collection;
import mcore.util.Iterables;
import mcore.util.Arrays;
import mcore.exception.RangeException;
import mcore.exception.NotFoundException;
import msignal.EventSignal;

#if haxe3
import haxe.ds.IntMap;
#else
typedef IntMap<T> = IntHash<T>;
#end

/**
	An IntMap backed List whose size can be set without the need to allocate 
	memory for each index.

	The `VirtualList.defaultValue` will be returned for any index accessed 
	inside the bounds of the list, which has not yet had a value set.

	This data structure is primarily targeted at situations where a large list 
	of data is gradually being populated at random indices. For example when 
	loading pages of data into a list while a user scrolls through their visual 
	representation.

	Ideal usage would be to first set the total size of the list using 
	VirtualList.resize(newSize) and then subsequently set values in the list 
	using VirtualList.set(index, value) or VirtualList.setAll(index, values).

	Values can be retrieved efficiently using VirtualList.get(index).

	It should be noted that inserting additional or deleting existing values, 
	especially near the start of the list, becomes increasingly expensive as 
	the list grows in size. If you need to perform these operations regularly 
	then you would be best considering an alternate List implementation.

	Example Usage:
	
	```haxe
    var list = new VirtualList<Int>();
    list.resize(10000);

    // the value returned when accessing an index which has not yet been set
    list.defaultValue = -50;
    
    // set values passed through starting at index 101
    list.setAll(101, [20, 30, 40, 50]);

    list.get(103); // returns 40
    list.get(8000); // returns -50;    
	```
**/
class VirtualList<T> implements List<T>
{
	/**
		Dispatched when the values of this Collection change.
	**/
	public var changed(get_changed, null):EventSignal<Collection<T>, CollectionEventType<T>>;
	function get_changed() { return changed; }

	/**
		Determines whether change events are broadcast. Default is true. 
	**/
	@:isVar public var eventsEnabled(get_eventsEnabled, set_eventsEnabled):Bool;
	function get_eventsEnabled() { return eventsEnabled; }
	function set_eventsEnabled(value:Bool) { return eventsEnabled = value; }

	/**
		The number of values in this collection.
	**/
	public var size(get_size, null):Int;
	function get_size():Int { return size; }

	/**
		The number of items in the collection. Alias for size.
	**/
	public var length(get_length, null):Int;
	function get_length():Int { return size; }

	/**
		The first item in the collection.
	**/
	public var first(get_first, null):T;
	function get_first():T
	{
		if (isEmpty())
			throw RangeException.numeric(0, 0, 0);

		return get(0);
	}

	/**
		The last item in the collection.
	**/
	public var last(get_last, null):T;
	function get_last():T
	{
		if (isEmpty())
			throw RangeException.numeric(0, 0, 0);

		return get(size - 1);
	}

	/**
		The value returned when an index to be retrieved has not yet been set. Default is null. 
	**/
	public var defaultValue:Null<T>;

	var source:IntMap<T>;

	/**
		@param values   An optional array of values to populate this list.
	**/
	public function new(?values:Iterable<T>)
    {
	    eventsEnabled = true;
	    changed = new EventSignal(untyped this);
	    source = new IntMap();
	    size = 0;
	    addAll(values);
    }

	/**
		Adjust the size of this list.
		 
		If a size smaller that then current one is supplied, values will be 
		removed that exist beyond the new size.
		
		@param newSize  The size to make this list.
		@throws mcore.exception.RangeException If the new size is less than 0. 
	**/
	public function resize(newSize:Int):Void
	{
		if (newSize < 0)
		{
			throw RangeException.numeric(newSize, 0, size);
		}

		var s = size;
		size = newSize;
		
		if (newSize < s)
		{
			var removed = [];
			for (index in source.keys())
			{
				if (index >= size)
				{
					removed.push(source.get(index));
					source.remove(index);
				}
			}
			
			if (eventsEnabled)
				notifyChanged(Remove(removed), Range(newSize, s));
		}
		else if (newSize > s)
		{
			if (eventsEnabled)
				notifyChanged(Add([]), Range(s, newSize));
		}
	}

	/**
		Add a value to the end of this list.
		
		@param value    the value to add.
	**/
	public function add(value:T):Void
	{
		source.set(size++, value);
		
		if (eventsEnabled)
			notifyChanged(Add([value]), Indices([size - 1]));
	}

	/**
		Add a collection of values to the end of this list.
		
		@param values   the collection of values to add.
	**/
	public function addAll(values:Iterable<T>):Void
	{
		if (values == null) return;

		var s = size;
		for (value in values)
			source.set(size++, value);

		if (eventsEnabled && size != s)
		{
			var v:Array<T> = Std.is(values, Array) ? cast values : Iterables.toArray(values);
			notifyChanged(Add(v), Range(s, size));
		}
	}
	
	/**
		Replace a value at a specified index.

		@param index    The index at which to replace a value.
		@param value    The value to replace the current one.
		@return The replaced value.
		@throws `RangeException` When index is outside the bounds 
			of this list.
	**/
	public function set(index:Int, value:T):T
	{
		if (index < 0 || index > size)
		{
			throw RangeException.numeric(index, 0, size);
		}

		var item = get(index);
		source.set(index, value);

		if (eventsEnabled)
			notifyChanged(Replace([item]), Indices([index]));

		return item;
	}

	/**
		Replace a collection of values starting at a specified index.

		@param  index   The index at which to begin the replacements.
		@param  value   The values to set.
		@return The replaced values.
		@throws `RangeException` When index is outside the bounds of this list,
				or when the index plus the number of values exceeds the size of this list.
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
				removed.push(get(i));
				source.set(i++, value);
			}

			if (eventsEnabled)
				notifyChanged(Replace(removed), Range(index, max));
		}
		return removed;
	}
	
	/**
		Insert an additional value at a given index in this list.
		
		@param index The index at which to inset the value.
		@param value The value to insert.
		@throws `RangeException` When index is outside the bounds of this list.
	**/
	public function insert(index:Int, value:T):Void
	{
		if (index < 0 || index > size)
		{
			throw RangeException.numeric(index, 0, size);
		}

		var i = size;
		while (i-- > index)
		{
			if (source.exists(i))
			{
				source.set(i + 1, source.get(i));
				source.remove(i);
			}
		}

		source.set(index, value);
		size++;
		if (eventsEnabled)
			notifyChanged(Add([value]), Indices([index]));
	}

	/**
		Insert a collection of additional values starting at a given index in this list.
		
		@param index    The index at which to inset the first value.
		@param values   The collection of values to insert.
		@throws `RangeException` When index is outside the bounds of this list.
	**/
	public function insertAll(index:Int, values:Iterable<T>):Void
	{
		if (index < 0 || index > size)
		{
			throw RangeException.numeric(index, 0, size);
		}
		
		var count = Iterables.size(values);
		if (count == 0)
			return;
		
		var i = size;
		while (i-- > index)
		{
			if (source.exists(i))
			{
				source.set(i + count, source.get(i));
				source.remove(i);
			}
		}
		
		i = index;
		
		for (value in values)
			source.set(i++, value);

		size += count;
		
		if (eventsEnabled)
		{
			var v:Array<T> = Std.is(values, Array) ? cast values : Iterables.toArray(values);
			notifyChanged(Add(v), Range(index, index + v.length));
		}
	}

	/**
		Returns a value at a given index in this list.
		
		@param index    The index of the value to return.
		@return The requested value.
		@throws `RangeException` When index is outside the bounds of this list.
	**/
	public function get(index:Int):T
	{
		if (index < 0 || index >= size)
		{
			throw RangeException.numeric(index, 0, size);
		}
		
		// IntHash is backed by a Dictionary under AVM2 and this uses hasOwnProperty to determine
		// if an index is set. This is a slow operation on larger sets so we avoid it here if we can.
		// Under stress tests this one change reduced repeated lookup from 2.5s to 0.24s when the list
		// was reasonably full of values.
		
		var value = source.get(index);
		return value != null ? value : source.exists(index) ? value : defaultValue;
	}

	/**
		Returns the first index at which the value exists in this List, or -1 
		if not found.
		
		@param value    The value whose index to discover.
		@return The index of the value, or -1 if it was not found.
	**/
	public function indexOf(value:T):Int
	{
		var indices = sortedIndices();

		for (i in indices)
			if (source.get(i) == value)
				return i;
		return -1;
	}
	
	function sortedIndices():Array<Int>
	{
		var indices = [];
		for (i in source.keys())
			indices.push(i);
		indices.sort(function(a:Int, b:Int) { return a - b; });
		return indices;
	}

	/**
		Returns the last index at which the given value exists in this List, 
		or -1 if not found.
		
		@param value    The value whose last index to discover.
		@return The last index of the value, or -1 if it was not found.
	**/
	public function lastIndexOf(value:T):Int
	{
		var indices = sortedIndices();
		var i = indices.length;
		while (i-- > 0)
			if (source.get(i) == value)
				return i;
		return -1;
	}

	/**
		Removes all values from this Collection.
	**/
	public function clear():Void
	{
		if (isEmpty()) return;
		
		var removed = Iterables.toArray(source);
		var s = size;
		
		source = new IntMap();
		size = 0;

		if (eventsEnabled)
			notifyChanged(Remove(removed), Range(0, s));
	}

	function notifyChanged(eventType:CollectionEventType<T>, ?payload:Dynamic)
	{
		changed.dispatch(untyped new ListEvent(eventType, payload));
	}

	/**
		Remove the first occurrence of the specified value from this Collection.
		
		@param value    the value to remove.
		@return true if a value was removed, false if not found.
	**/
	public function remove(value:T):Bool
	{
		var indices = sortedIndices();
		var removedIndex = -1;
		for (i in indices)
		{
			if (removedIndex != -1)
			{
				source.set(i - 1, source.get(i));
				source.remove(i);
			}
			else if (source.get(i) == value)
			{
				source.remove(i);
				removedIndex = i;
			}
		}

		if (removedIndex != -1)
		{
			size--;
			if (eventsEnabled)
				notifyChanged(Remove([value]), Indices([removedIndex]));

			return true;
		}
		return false;
	}

	/**
		Remove the value at a specified index.
		
		@param index The index of the value to remove.
		@return The removed value.
		@throws `RangeException` When index is outside the bounds of this list.
	**/
	public function removeAt(index:Int):T
	{
		if (index < 0 || index >= size)
		{
			throw RangeException.numeric(index, 0, size);
		}
		
		var removed:T = defaultValue;
		if (source.exists(index))
		{
			removed = source.get(index);
			source.remove(index);
		}

		for (i in index...size)
		{
			if (source.exists(i)) 
			{
				source.set(i - 1, source.get(i));
				source.remove(i);
			}
		}

		size--;
		if (eventsEnabled)
			notifyChanged(Remove([removed]), Indices([index]));

		return removed;
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

		var removed = [];
		for (i in startIndex...endIndex)
		{
			if (source.exists(i))
			{
				removed.push(source.get(i));
				source.remove(i);
			}
			else
			{
				removed.push(defaultValue);
			}
		}
		
		for (i in endIndex...size)
		{
			source.set(i - removed.length, source.get(i));
			source.remove(i);
		}
		
		size -= removed.length;

		if (eventsEnabled)
		{
			notifyChanged(Remove(removed), Range(startIndex, endIndex));
		}

		return removed;	
	}

	/**
		Remove all occurrences of the specified values from this Collection.
		 
		@param values   The values to remove.
		@return True if one or more values were removed, false if not found.
	**/
	public function removeAll(values:Iterable<T>):Bool
	{
		if (values == null) return false;
		
		var removedValues = [];
		var removedIndices = [];

		for (index in source.keys())
		{
			for (value in values)
			{
				if (source.get(index) == value)
				{
					source.remove(index);
					removedValues.push(value);
					removedIndices.push(index);
				}
			}
		}

		var indices = sortedIndices();
		removedIndices.sort(function(a:Int, b:Int) { return a - b; });
		
		for (i in removedIndices)
		{
			for (x in indices)
			{
				if (x > i)
				{
					source.set(i - 1, source.get(i));
					source.remove(i);
				}
			}
		}
		
		if (removedValues.length > 0)
		{
			size -= removedValues.length;
			if (eventsEnabled)
				notifyChanged(Remove(removedValues), Indices(removedIndices));
			return true;
		}

		return false;
	}
	
	/**
		Returns true if a value in this list is equal to the one provided.
		
		Comparison is made using standard equality.
		
		@param value the value to check for.
		@return `true` if value exists in collection, `false` otherwise
	**/
	public function contains(value:T):Bool
	{
		return Iterables.contains(source, value);
	}

	/**
		Returns `true` if this list contains no values, `false` otherwise.
	**/
	public function isEmpty():Bool
	{
		return size == 0;
	}

	/**
		The iterator enumerating this list.
	**/
	public function iterator():Iterator<T>
	{
		return source.iterator();
	}

	/**
		Returns the values from this list as an Array.
	**/
	public function toArray():Array<T>
	{
		var indices = sortedIndices();
		var array = [];
		for (i in indices)
			array.push(source.get(i));
		return array;
	}

	/**
		Returns the string representation of this list.
	**/
	public function toString():String
	{
		return Arrays.toString(toArray());
	}
}
