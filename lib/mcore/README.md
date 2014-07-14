Overview
---------

MCore is collection of lightweight, platform independent utilities that simplify cross 
platform development in Haxe. 

APIs are designed to work across all targets where applicable and provide 
consistent, stable behaviour.

**Usage**

You can find basic usage examples [here](https://github.com/downloads/massiveinteractive/mcore/examples.zip).

**Packages**

The following documented packages are available:

* **crypto** - SHA1 and Base64 encryption algorithms
* **exception** - Common exception classes
* **util** - Additional standalone class specific utilities

You can find examples for each package in the **[examples](https://github.com/massiveinteractive/mcore/tree/master/example)** folder.


## Exceptions

A collection of low level exception classes providing common metadata for any runtime application exception, including:

* exception type and message
* location (class name, method name and line number)
* originating cause and stack trace

All errors thrown within the Framework libraries extend the base mcore.exception.Exception class

Basic Example:

	try
	{
		throw new Exception("something bad happened");
	}
	catch(e:Exception)
	{
		trace(e.toString());
		//outputs "Exception: something bad happened at foo.Bar#doSomething(123)"
	}


## Utilities

Collection of class specific utilities for working with classes such as:

* Floats, Dates, Strings, etc
* Types, Reflection and Dynamic objects
* Colors
* URL Queries Strings (mcore.util.QueryStrings)

See individual classes for details and examples.

### [Timer](https://github.com/massiveinteractive/mcore/blob/master/src/mcore/util/Timer.hx)

Lightweight cross platform asynchronous timer.

#### Example Usage:

Create a timer which ticks indefinitely every second.

	var timer = new Timer(1000);
	timer.ticked.add(updateHadler);
	timer.start();

Create a timer which ticks every 500 milliseconds and which repeats twice.

	var timer = new Timer(500, 2);
	timer.ticked.add(updateHandler);
	timer.completed.addOnce(completedHandler);
	timer.start();

Create a timer which ticks only once after one second.

	Timer.runOnce(completedHandler, 1000);

### [Iterables](https://github.com/massiveinteractive/mcore/blob/master/src/mcore/util/Iterables.hx)

Utility methods to operate on Iterables.

Has some similarities to Haxe's Lambda class with the following main differences:

1. Favor native Arrays over Haxe based Lists
2. Inline methods where it makes sense for speed.

#### Available Operations

- **contains(element:T):Bool**  - Determine if an element is present in an iterable.
- **indexOf(element:T):Int** - Determine the index of an element in an iterable. -1 if not found.
- **find(predicate:T -> Bool):T** - Search for the first element that satisfies the predicate function.
Returns null if there is no such element.
- **filter(predicate:T -> Bool):T** - Filter an iterable by a predicate function and returns the matching elements in an array
- **concat(iterable):Array<T\>** - Concatenate the elements of two iterables into a single array.
- **map(selector:A -> B):Array<T>** - Apply a selector function to each element of an iterable, and
return the array of results.
- **mapWithIndex(selector:A -> Int -> B):Array<T\>** - Apply a selector function to each element of an iterable, also passing
in the index, and return the array of results.
- **fold(aggregator:A -> B ->B, seed:B):B** - Left fold each element using the aggregator function into a final aggregate.
- **foldRight(aggregator:A -> B ->B, seed:B):B** - Right fold each element using the aggregator function into a final aggregate.
- **reverse():Array<T\>** - Reverse the order of an iterable, returning as an array.
- **toArray():Array<T\>** - Convert an iterable to an array.
- **isEmpty():Bool** - Determine if an iterable has any elements.
- **size():Int** - Determine the number of elements in an iterable.
- **count(predicate:T -> Bool):Int** - Determine the number of elements in an iterable which fulfill a given predicate.


#### Example Usage

	using mcore.util.Iterables;

	var colorMap = new StringMap<String>();
	colorMap.set("a", "red");
	colorMap.set("b", "blue");
	colorMap.set("c", "green");
	colorMap.set("d", "brown");

	// Get the number of items in an iterable
	colorMap.size();
	// outputs: 3

	// Count the number of items which start with the letter 'b'
	colorMap.count(function(color:String) { return color.indexOf('b') == 0; } );
	// outputs: 2

	// get the piped list of all colors
	colorMap.fold(function(color:String, aggregate:String) {
		return aggregate + color + "|";
	}, "|");

	// outputs: |brown|green|blue|red|
	// Note that the order is not guaranteed when iterating a map so left or right fold would be ok here

	// Double the value of each item in an integer array and return in a new array
	[1,2,3,4,5].map(function(value:Int) { return value * 2; });
	// outputs: [2,4,6,8,10]
