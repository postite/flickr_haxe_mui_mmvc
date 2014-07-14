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
import mcore.exception.Exception;
import mcore.exception.RangeException;

/**
	The Stack class represents a last-in-first-out (LIFO) stack of objects. The 
	usual push and pop operations are provided, as well as a method to peek at the 
	top item on the stack, a method to test for whether the stack is empty, and a 
	method to search the stack for an item and discover how far it is from the top.

	Example Usage:
	
	```haxe
	var stack = new Stack<String>();
	stack.pushAll(["foo", "bar"]);
	stack.push("cat");
	trace(stack.peek());//outputs "cat"
	stack.popToValue("foo");
	trace(stack.peek());//outputs "foo"
	```

	See `mdata.Collection` for more information.
**/
class Stack<T> extends CollectionBase<T>
{
	/**
		@param values An optional array of values to populate the stack.
	**/
	public function new(?values:Array<T> = null)
	{
		super();

		if (values != null)
		{
			pushAll(values);
		}
	}

	/**
		Adds a value at the top of the stack.
		
		@param value The value to add.
	**/
	public function push(value:T)
	{
		add(value);
	}

	/**
		Adds an array of values to the top of the stack.
		
		@param values The array of value to add.
	**/
	public function pushAll(values:Array<T>)
	{
		addAll(values);
	}

	/**
		Inserts a value at a given depth in the stack, and removes any existing
		items at or above the given depth
		
		@param depth The dpeth at which to insert the value.
		@param value The value to insert.
		@throws `RangeException` 	if depth is outside the current size of the stack
	**/
	public function pushAtDepth(depth:Int, value:T)
	{
		if (depth < 0 || depth >= size)
		{
			throw RangeException.numeric(depth, 0, size);
		}

		var values = source.splice(depth, size - depth);
		if (eventsEnabled)
			notifyChanged(CollectionEventType.Remove(values));
		push(value);
	}

	/**
		Inserts a value above an existing value.
		Any values above the old value are removed from the stack
		
		@param oldValue		The value to insert above.
		@param newValue		The value to be inserted.
		@throws `RangeException` if old value is not in stack
	
	**/
	public function pushAtValue(oldValue:T, newValue:T)
	{
		var depth = depthOf(oldValue);
		if (depth < 0)
		{
			throw RangeException.numeric(depth, 0, size);
		}

		depth++;

		if (depth == size)
		{
			push(newValue);
		}
		else
		{
			pushAtDepth(depth, newValue);
		}
	}

	/**
		Returns the depth of a value within the stack, or -1 if it is not present.
		
		@param value The value to search for.
		@return The depth of the value, or -1 if it is not found.
	**/
	public function depthOf(value:T):Int
	{
		var i = source.length; // top down search
		while (i-- > 0)
		{
			if (source[i] == value) return i;
		}
			
		return -1;
	}

	/**
		Removes the value at the top of the stack and returns it.
		
		@return The value at the top of the stack.
		@throws `EmptyStackException` If the stack is empty.
	**/
	public function pop():T
	{
		if (isEmpty())
		{
			throw new EmptyStackException();
		}
		
		var value = source.pop();
		if (eventsEnabled)
			notifyChanged(CollectionEventType.Remove([value]));
		return value;
	}

	/**
		Removes a value from the stack.
		
		@param value The value to remove.
	**/
	public function popToValue(value:T):Void
	{
		popToDepth(depthOf(value));
	}

	/**
		Removes a value from the stack at a specific depth.
		
		@param depth The depth of the value to remove.
		@throws mdata.EmptyStackException If the stack is empty.
		@throws `RangeException` If the specified depth is outside the range 
			contained in the stack.
	**/
	public function popToDepth(depth:Int)
	{
		if (isEmpty())
		{
			throw new EmptyStackException();
		}
		
		if (depth < 0 || depth >= size)
		{
			throw RangeException.numeric(depth, 0, size);
		}

		if (++depth < size) // not top item
		{
			var values = source.splice(depth, size - depth);
			if (eventsEnabled)
				notifyChanged(CollectionEventType.Remove(values));
		}
	}

	/**
		Returns the object at the top of the stack without removing it.
		
		@return The object at the top of the stack.
		@throws `EmptyStackException` If the stack is empty.
	**/
	public function peek():T
	{
		if (isEmpty())
		{
			throw new EmptyStackException();
		}
		
		return source[size - 1];
	}
}

/**
	An exception thrown by a stack when a peek or pop operation fails due to 
	the stack being empty.

	See `mcore.exception.Exception` for more information.
**/
class EmptyStackException extends Exception
{
	public function new(?message:String="", ?id:Int=0)
	{
		super(message, id);
	}
}
