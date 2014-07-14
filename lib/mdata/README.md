Overview
--------

A collection of [typed](http://haxe.org/ref/type_params) data structures and 
utilities to standardise working with collections in Haxe.

## Collections

A group of data structures built from a common [Collection API](src/mdata/Collection.hx).

This provides the following properties and operations available across all 
implementations:

```haxe
interface Collection<T>
{
	var size:Int;

	function changed:EventSignal<Collection<T>, CollectionEventType>;
	function add(value:T):Void;
	function addAll(values:Iterable<T>):Void;
	function clear():Void;
	function contains(value:T):Bool;
	function isEmpty():Bool;
	function iterator():Iterator<Null<T>>;
	function remove(value:T):Bool;
	function removeAll(values:Iterable<T>):Bool;
	function toArray():Array<T>;
}
```	

Implementations provided include:

* **[ArrayList](src/mdata/ArrayList.hx)** - Similar to a native Array but with 
  notification of changes and illegal access protection.
* **[SelectableList](src/mdata/SelectableList.hx)** - Built from an ArrayList 
  with the addition of selected index and value.
* **[Stack](src/mdata/Stack.hx)** - A LIFO stack.
* **[Set](src/mdata/Set.hx)** - A collection containing only unique values.
* **[Queue](src/mdata/Queue.hx)** - A FIFO queue with optional priority ordering.

#### Examples

You can download example usage [here](https://github.com/downloads/massiveinteractive/mdata/example.zip).

Creating a new instance:

```haxe
var list = new ArrayList<Foo>();
var stack:Stack<Foo> = new Stack();
```

Adding and removing values:

```haxe
collection.add(fooA);
collection.addAll([fooA, fooB, fooC]);
collection.remove(fooA);
collection.clear();
```

Accessing and iterating over values:

```haxe
trace(collection.contains(fooA));
trace(collection.size);
trace(collection.isEmpty())

for (foo in collection)
	trace(foo.bar);
```

Observing changes:

```haxe
collection.changed.add(changeHandler);
collection.add(fooA);
collection.remove(fooA);

function changeHandler(e:CollectionEvent<Foo>)
{
	switch (e.type)
	{
		case Add(items): trace("Items added to collection " + items);
		case Remove(items): trace("Items removed from collection " + items);
	}
}
```

## Collection Utilities

To perform common operations on Collections use the utility 
class **[mdata.Collections](src/mdata/Collections.hx)**.

Available methods:

```haxe
// Collections
function filter<T>(collection:Collection<T>, predicate:T -> Bool):Void
function copy<T>(collection:Collection<T>):Collection<T>

// Lists
function sort<T>(list:List<T>, ?comparator:T -> T -> Int):Void
function binarySearch<T>(list:List<T>, needle:T, ?comparator:T -> T -> Int):Int
function reverse<T>(list:List<T>):Void
function shuffle<T>(list:List<T>):Void
```

### Examples

```haxe
using mdata.Collections;
```

Filtering:

```haxe
var queue = new Queue<Int>([4,6,2,6,2,1]);
var predicate = function(value:Int) { return value <= 2; } 
queue.filter(predicate);

trace(queue.size); // 3
trace(queue.dequeue()); // 1
trace(queue.dequeue()); // 2
trace(queue.dequeue()); // 2
```

Sorting:

```haxe
var list = new ArrayList<Int>([4,6,2,6,2,1]);
list.sort();
trace(list); // 1,2,2,4,6,6

var comparator = function(a:Int, b:Int) { return b - a; };
list.sort(comparator);
trace(list); // 6,6,4,2,2,1
```

Searching:

```haxe
var list = new ArrayList<Int>([4,6,2,6,2,1]);
list.sort(); // must sort before doing a binary search

trace(list.binarySearch(4)); // 3
trace(list.binarySearch(8)); // -1

var comparator = function(a:Int, b:Int) { return b - a; };
list.sort(comparator);
trace(list.binarySearch(4, comparator)); // 2
```

## Factories and Pools

Utilities for creating and managing the lifecycle of objects.

* **[Pool](src/mdata/Pool.hx)** - A pool of commonly typed objects.
* **[Factory](src/mdata/Factory.hx)** - Create instances of a common type.
* **[FactoryPool](src/mdata/FactoryPool.hx)** - Create and recycle objects mapped to a set of defined types.


#### Examples

```haxe
var pool = Pool.forType(Date);
var instance = pool.request();
pool.release(instance);	
var instance2 = pool.request();
trace(instance == instance2);

var factory = Factory.forType(Foo);
var args = ["foo", true];
var foo = factory.create(args);
```

## Dictionaries

* **[Dictionary](src/mdata/Dictionary.hx)** - Dictionary allowing objects as keys
* **[LocalStorage](src/mdata/LocalStorage.hx)** - A map backed by persistent storage specific to the platform compiled for. e.g. [Cookies for js](src/mdata/LocalStorage_js.hx), [SharedObjects for flash](src/mdata/LocalStorage_flash.hx) and [file system for neko](src/mdata/LocalStorage_neko.hx))

Saving and retrieve values from an external location (e.g. local cookie or file)

#### Examples

##### Dictionary

```haxe
var dictionary = new Dictionary<Key, Value>();
var key = new Key();
var value = new Value();

dictionary.set(key, value);
dictionary.get(key);//returns value;
dictionary.delete(key);
```

##### LocalStorage

Getting and setting values

```haxe
var store = new LocalStorage("org.domain.catapp");
var cat = new Cat("tom");

store.set(cat.name, cat);
var catB = store.get(cat.name);
trace((cat == catB)); // true
```

Saving to backing store

```haxe
store.save();
```

Removing and checking existance of values

```haxe
trace(store.exists(cat.name)); // true
store.remove(cat.name);
trace(store.exists(cat.name)); // false
```

Iterating over keys and values

```haxe
for (catName in store.keys())
	trace(catName);

for (cat in store)
	trace(cat.name);	
```