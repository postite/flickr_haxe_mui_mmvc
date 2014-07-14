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

import mdata.Collection;
import msignal.Signal;
import mcore.exception.RangeException;
import mcore.exception.NotFoundException;
import msignal.EventSignal;

/**
	Decorates a List adding the ability to track a selected index over 
	its values.

	Broadcasts selection change event to observers when the selected 
	index changes.

	Example Usage:
	
	```haxe
	var list = new SelectableList<String>(new ArrayList<String>());
	list.addAll(["foo", "bar", "cat"]);
	list.selectionChanged.add(selectionChanged);
	list.selectedItem = "bar";

	function selectionChanged(list:SelectableList<String>)
	{
		trace(list.selectedIndex); // 1
	}
	```

	See `mdata.Collection` and `mdata.ArrayList` for more information.
**/
class SelectableList<T> implements List<T>
{
	/**
		Dispatched when the values of this Collection change.
	**/
	public var changed(get_changed, null):EventSignal<Collection<T>, CollectionEventType<T>>;
	function get_changed() { return source.changed; }

	/**
		Determines whether change events are broadcast. Default is true. 
	**/
	public var eventsEnabled(get_eventsEnabled, set_eventsEnabled):Bool;
	function get_eventsEnabled() { return source.eventsEnabled; }
	function set_eventsEnabled(value:Bool) { return source.eventsEnabled = value; }

	/**
		The number of values in this collection.
	**/
	public var size(get_size, null):Int;
	function get_size() { return source.size; }

	/**
		Returns the first item found at the head of the List. 
		
		@throws mcore.exception.RangeException If the List is empty.
	**/
	public var first(get_first, null):T;
	function get_first() { return source.first; }

	/**
		Returns the last item found at the tail of the List. 

		@throws mcore.exception.RangeException If the List is empty.
	**/
	public var last(get_last, null):T;
	function get_last() { return source.last; }

	/**
		The number of items in the List.
	**/
	public var length(get_length, null):Int;
	function get_length() { return source.length; }

	/**
		Dispatched when the selected index has changed.
	**/
	public var selectionChanged(default, null):Signal1<SelectableList<T>>;

	/**
		The previously selected index. -1 if selection has not been changed. 
	**/
	public var previousSelectedIndex(default, null):Int;

	/**
		The List which this SelectableList decorates. 
	**/
	public var source(default, null):List<T>;

	public function new(?list:List<T>, ?selectedIndex:Int = 0)
	{
		if (list == null) list = new ArrayList<T>();
		
		source = list;
		source.changed.addWithPriority(source_changed, 1000);

		selectionChanged = new Signal1<SelectableList<T>>(SelectableList);
		this.selectedIndex = (list.size > 0) ? selectedIndex : -1;
		previousSelectedIndex = -1;
	}

	function source_changed(e:CollectionEvent<T>)
	{
		if (source.size == 0 && selectedIndex != -1)
			previousSelectedIndex = selectedIndex = -1;
		else if(source.size > 0 && selectedIndex == -1)
		{
			previousSelectedIndex = selectedIndex;
			selectedIndex = 0;
		}
	}

	/**
		The currently selected index, or -1 if no value is selected.
	**/
	public var selectedIndex(default, set_selectedIndex):Int;

	function set_selectedIndex(value:Int):Int
	{
		var s = source.size;
		if (value >= s || (s == 0 && value != -1) || (s > 0 && value < 0))
		{
			throw RangeException.numeric(value, 0, size);
		}

		if (value != selectedIndex)
		{
			previousSelectedIndex = selectedIndex;
			selectedIndex = value;
			if (eventsEnabled)
				selectionChanged.dispatch(this);
		}

		return selectedIndex;
	}

	/**
		The currently selected value, or null if selected index is -1.
	**/
	public var selectedItem(get_selectedItem, set_selectedItem):T;
	function get_selectedItem():T { return source.get(selectedIndex); }

	function set_selectedItem(value:T):T
	{
		if (!source.contains(value))
		{
			throw new NotFoundException("Value was not found in List: " + Std.string(value));
		}

		selectedIndex = source.indexOf(value);
		return value;
	}

	/**
		Add a value to this collection.
		
		@param value		the value to add.
	**/
	public function add(value:T):Void
	{
		source.add(value);

		if (selectedIndex == -1)
			selectedIndex = 0;
	}

	/**
		Add a collection of values to this Collection.
		
		@param values		the collection of values to add.
	**/
	public function addAll(values:Iterable<T>):Void
	{
		source.addAll(values);

		if (selectedIndex == -1 && source.size > 0)
			selectedIndex = 0;
	}

	/**
		Inserts a value at a given index in the list.
		
		@param index The index at which to inset the value.
		@param value The value to insert.
		@throws mcore.exception.RangeException When index is outside of the 
			bounds of the List.
	**/
	public function insert(index:Int, value:T)
	{
		source.insert(index, value);

		if (selectedIndex == -1 && source.size > 0)
			selectedIndex = 0;
	}

	/**
		Inserts a collection of values at a given index in the list.
		
		@param index The index at which to inset the values.
		@param values The collection of values to insert.
		@throws mcore.exception.RangeException When index is outside of the 
			bounds of the List.
	**/
	public function insertAll(index:Int, values:Iterable<T>):Void
	{
		source.insertAll(index, values);

		if (selectedIndex == -1 && source.size > 0)
			selectedIndex = 0;
	}

	/**
		Removes all values from this Collection.
	**/
	public function clear():Void
	{
		source.clear();
		selectedIndex = -1;
	}

	/**
		Remove the first occurrence of the specified value from this Collection.
		
		@param value    the value to remove.
		@return true if a value was removed, false if not found.
	**/
	public function remove(value:T):Bool
	{
		var result = source.remove(value);
		
		if (selectedIndex >= source.size)
			selectedIndex = source.size - 1;
		
		return result;
	}

	/**
		Remove the value at a specified index.
		
		@param index The index of the value to remove.
		@return The removed value.
		@throws mcore.exception.RangeException When index is outside of the 
			bounds of the List.
	**/
	public function removeAt(index:Int):T
	{
		var result = source.removeAt(index);
		
		if (selectedIndex >= size)
			selectedIndex = size - 1;
		
		return result;
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
		var result = source.removeRange(startIndex, endIndex);

		if (selectedIndex >= size)
			selectedIndex = size - 1;
		
		return result;
	}	

	/**
		Remove all occurrences of the specified values from this Collection.
		 
		@param values   the values to remove.
		@return true if one or more values were removed, false if not found.
	**/
	public function removeAll(values:Iterable<T>)
	{
		var result = source.removeAll(values);
		
		if (selectedIndex >= size)
			selectedIndex = size - 1;
		
		return result;
	}

	/**
		Replace a value at a specified index.

		@return The replaced value
		@throws `RangeException` When index is outside of the bounds of the 
			List.
	**/
	public function set(index:Int, value:T):T
	{
		return source.set(index, value);
	}

	/**
		Replace a collection of values starting at a specified index.

		@param  index   The index at which to begin the replacements
		@param  values  The values to set
		@return The replaced values
		@throws `RangeException` When index is outside the bounds of the List 
			or when the index plus the number of values exceed the size of the 
			List.
	**/
	public function setAll(index:Int, values:Iterable<T>):Array<T>
	{
		return source.setAll(index, values);
	}
	
	/**
		Returns a value at a given index in the list.
		
		@param index The index of the value to return.
		@return The requested value.
		@throws `RangeException` When index is outside of the bounds of the 
			List.
	**/
	public function get(index:Int):T
	{
		return source.get(index);
	}

	/**
		Returns the first index at which the value exists in this List, or -1 
		if not found.
		
		@param value The value to index.
		@return The index of the value, or -1 if it is not found.
	**/
	public function indexOf(value:T):Int
	{
		return source.indexOf(value);
	}

	/**
		Returns the last index at which the value exists in this List, or -1 
		if not found.
	**/
	public function lastIndexOf(value:T):Int
	{
		return source.lastIndexOf(value);
	}

	/**
		Returns true if a value in this collection is equal to the one provided.
		
		Comparison is made using standard equality.
		
		@param value the value to check for.
		@return `true` if value exists in collection, `false` otherwise
	**/
	public function contains(value:T):Bool
	{
		return source.contains(value);
	}

	/**
		Returns true if this collection contains no values or false otherwise.
	**/
	public function isEmpty():Bool
	{
		return source.isEmpty();
	}

	/**
		The iterator enumerating this Collection.
	**/
	public function iterator():Iterator<T>
	{
		return source.iterator();
	}

	/**
		Returns the values from this collection as an Array.
	**/
	public function toArray():Array<T>
	{
		return source.toArray();
	}

	/**
		Returns the string representation of this collection.
	**/
	public function toString():String
	{
		return source.toString();
	}
}
