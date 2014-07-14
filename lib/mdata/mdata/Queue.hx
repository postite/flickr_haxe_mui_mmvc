package mdata;

import mdata.Collection;
import mcore.exception.IllegalOperationException;

/**
	A FIFO Queue with optional priority ordering.

	Example Usage:

	```haxe
	var queue = new Queue<String>();
	queue.enqueue("A");
	queue.enqueue("B");
	queue.enqueue("C");

	trace(queue.dequeue()); //outputs "A";
	trace(queue.dequeue()); //outputs "B";
	trace(queue.dequeue()); //outputs "C";
	```

	```haxe
	var comparator = function(a:Int, b:Int) { return a - b; }
	var queue = new Queue<Int>(comparator);
	queue.enqueue(2);
	queue.enqueue(5);
	queue.enqueue(1);

	trace(queue.dequeue()); //outputs 1;
	trace(queue.dequeue()); //outputs 2;
	trace(queue.dequeue()); //outputs 5;
	```

	See `mdata.Collection` for more information.
*/
class Queue<T> extends CollectionBase<T>
{
	/**
		Comparator used to sort a priority based Queue. Default is null meaning 
		the queue remains FIFO. 
	**/
	public var comparator(default, null):T->T->Int;

	/**
		@param values An optional collection of values to add to the end of 
			this Queue 
		@param comparator An optional comparator function to determine the 
			order of values in this Queue
	**/
	public function new(?values:Iterable<T>, ?comparator:T->T->Int)
	{
		super();
		
		if (values != null)
			addAll(values);

		this.comparator = comparator;
	}

	/**
		Add a value to the end of this Queue.
		
		If a comparator has been provided during Queue construction this will be 
		used to determine the placement of the value in this Queue.
	**/
	override public function add(value:T)
	{
		source.push(value);
		sort();
		if (eventsEnabled)
			notifyChanged(Add([value]));
	}

	function sort()
	{
		if (comparator != null)
			source.sort(comparator);
	}
	
	/**
		Adds a collection of values to the end of this Queue.

		@param values The collection of values to add to this collection.
	**/
	override public function addAll(values:Iterable<T>):Void
	{
		if (values == null) return;

		var s = source.length;
		for (value in values)
			source.push(value);

		if (source.length != s)
		{
			sort();
			if (eventsEnabled)
				notifyChanged(Add(source.slice(s)));
		}
	}

	/**
		Add a value to the back of this Queue.
		
		If a comparator has been provided during Queue construction this will 
		be used to determine the placement of the value in this Queue.
	**/
	public function enqueue(value:T):Void
	{
		add(value);
	}

	/**
		Remove and return the value at the front of this Queue. 
		
		@throws mcore.exception.IllegalOperationException if the Queue is empty
	**/
	public function dequeue():T
	{
		if (size == 0)
			throw new IllegalOperationException("The Queue is empty");
		
		var value = source.shift();
		if (eventsEnabled)
			notifyChanged(Remove([value]));
		return value;
	}
}
