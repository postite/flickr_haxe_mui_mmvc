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
import mdata.Collection;
import mcore.util.Iterables;
import mcore.util.Arrays;
import mcore.util.Types;

/**
	An abstract base Collection implementation backed by an Array.

	See `mdata.Collection` for more information.
**/
class CollectionBase<T> implements Collection<T>
{
	/**
		Dispatched when the values of this Collection change.
	**/
	public var changed(get_changed, null):EventSignal<Collection<T>, CollectionEventType<T>>;
	function get_changed() { return changed; }

	/**
		Determines whether change events are broadcast. Default is false. 
	**/
	@:isVar public var eventsEnabled(get_eventsEnabled, set_eventsEnabled):Bool;
	function get_eventsEnabled() { return eventsEnabled; }
	function set_eventsEnabled(value:Bool) { return eventsEnabled = value; }

	/**
		The number of values in this collection.
	**/
	public var size(get_size, null):Int;
	function get_size():Int { return source.length; }

	var source:Array<T>;

	private function new()
	{
		source = [];
		eventsEnabled = true;
		changed = new EventSignal(untyped this);
	}

	/**
		Adds a value to this Collection.
		
		@param value the value to add.
	**/
	public function add(value:T)
	{
		source.push(value);
		
		if (eventsEnabled)
			notifyChanged(CollectionEventType.Add([value]));
	}

	function notifyChanged(eventType:CollectionEventType<T>, ?payload:Dynamic)
	{
		changed.dispatchType(eventType);
	}

	/**
		Adds a collection of values to this collection.

		@param values   the collection of values to add.
	**/
	public function addAll(values:Iterable<T>):Void
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
			notifyChanged(Add(v));
		}
	}

	/**
		Removes all values from this Collection.
	**/
	public function clear()
	{
		if (isEmpty()) return;
		
		var values = source.splice(0, source.length);
		if (eventsEnabled)
			notifyChanged(CollectionEventType.Remove(values));
	}
	
	/**
		Returns true if the value is found in this Collection, using standard 
		equality.
		
		@param value the value to search for
	**/
	public function contains(value:T):Bool
	{
		return Iterables.contains(source, value);
	}

	/**
		Returns true if this Collection contains no values.
	**/
	public function isEmpty():Bool
	{
		return source.length == 0;
	}

	/**
		Returns an iterator for the values in this Collection.
	**/
	public function iterator():Iterator<T>
	{
		return source.iterator();
	}

	/**
		Remove the first occurrence of the specified value from this Collection.
		
		@param value    the value to remove.
		@return true if a value was removed, false if not found.
	**/
	public function remove(value:T):Bool
	{
		var hasChanged = false;
		var i = source.length;
		var removed = [];
		while (i-- > 0)
		{
			if (source[i] == value)
			{
				removed.push(source.splice(i, 1)[0]);
				hasChanged = true;
				break;
			}
		}
		
		if (eventsEnabled && hasChanged)
			notifyChanged(CollectionEventType.Remove(removed));

		return hasChanged;
	}

	/**
		Remove all occurrences of the specified values from this Collection.
		 
		@param values   the values to remove.
		@return true if one or more values were removed, false if not found.
	**/
	public function removeAll(values:Iterable<T>):Bool
	{
		var removed:Array<T> = [];
		for (value in values)
		{
			var i = source.length;
			while (i-- > 0)
			{
				if (source[i] == value)
				{
					removed.push(source.splice(i, 1)[0]);
				}
			}
		}

		if (eventsEnabled && removed.length > 0)
			notifyChanged(CollectionEventType.Remove(removed));

		return removed.length > 0;
	}
	
	/**
		Returns an Array containing the values in this Collection.
	**/
	public function toArray():Array<T>
	{
		return source.copy();
	}

	/**
		Returns a String representation of this Collection.
	**/
	public function toString():String
	{
		return Arrays.toString(source);
	}
}
