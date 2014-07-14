package mdata;

using mcore.util.Arrays;

/**
	Utility methods to operate on Collections. 
**/
class Collections
{
    private function new()
    {}

	/**
		Filter a Collection by applying a predicate to each value. 
		
		If the predicate returns false, the value is removed from the 
		Collection.
		
		@param collection the Collection to filter
		@param predicate the filtering function, taking a collection's value 
			and returning true if the item should remain in the collection.
	**/
	public static function filter<T>(collection:Collection<T>, predicate:T -> Bool):Void
	{
		var removedValues:Array<T> = [];
		
		for (item in collection)
			if (!predicate(item))
				removedValues.push(item);
		
		collection.removeAll(removedValues);
	}


	/**
		Returns a copy of the supplied Collection.
		
		All values in the supplied Collection are added to the returned 
		Collection.
	**/
	public static function copy<T>(collection:Collection<T>):Collection<T>
	{
		var type:Class<Dynamic> = Type.getClass(collection);
		var slist:SelectableList<T> = null;
		if (type == SelectableList)
		{
			slist =  cast collection;
			type = Type.getClass(slist.source);
		}
		var copy:Dynamic = null;
		#if neko
		// see http://haxe.org/forum/thread/3395#nabble-td5795056
		try {
			// most likely one param so try it first
			copy = Type.createInstance(type, [null]);
		}
		catch(e:Dynamic) {
			try {
				copy = Type.createInstance(type, [null, null]);
			}
			catch(e:Dynamic) {
				copy = Type.createInstance(type, []);
			}
		}
		#else
		copy = Type.createInstance(type, []);
		#end

		copy.addAll(collection.toArray());
		
		if (slist != null)
			copy = new SelectableList<T>(copy);
		
		return copy;
	}

	/**
		Sort a List using an optional comparator function.
		
		If no comparator is provided then the List is sorted into ascending 
		order according to the natural ordering of its values.
		
		The comparator will take two values (A and B) and must return:

		- 0 if A is equal to B
		- Greater than 0 if A should appear after B
		- Less than 0 if A should appear before B
	**/
	public static function sort<T>(list:List<T>, ?comparator:T -> T -> Int):Void
	{
		if (comparator == null)
			comparator = DEFAULT_COMPARATOR;
		
		// hacky but internal and for speed
		if (!list.eventsEnabled && Reflect.hasField(list, "source") && Std.is(untyped list.source, Array))
		{
			untyped list.source.sort(comparator);
		}
		else
		{
			var array = list.toArray();
			array.sort(comparator);
			list.setAll(0, array);
		}
	}

	static var DEFAULT_COMPARATOR:Dynamic -> Dynamic -> Int =
		function(a:Dynamic, b:Dynamic) {
			if (a > b)
				return 1;
			if (a < b)
				return -1;
			return 0;
		};
	
	/**
		Search for a value in a List using a binary search.
		
		The List must be sorted in ascending order according to an optional 
		comparator. If no comparator is provided then the List must be sorted 
		in ascending order according to the natural order of the values it 
		contains.
		
		@param list         the list to be searched
		@param needle       the value to search for
		@param comparator   the optional comparator indicating the ordering of the List
		@return The index of the value in the List if found or -1 if not
	**/
	public static function binarySearch<T>(list:List<T>, needle:T, ?comparator:T -> T -> Int):Int
	{
		if (comparator == null)
			comparator = DEFAULT_COMPARATOR;
		
		var min = 0;
		var max = list.length - 1;

		while (min <= max)
		{
			var mid = (min + max) >>> 1;
			var cmp = comparator(list.get(mid), needle);

			if (cmp < 0)
				min = mid + 1;
			else if (cmp > 0)
				max = mid - 1;
			else
				return mid;
		}
		return -1;		
	}

	/**
		Reverse the order of the values in a List. 
	**/
	public static function reverse<T>(list:List<T>):Void
	{
		// hacky but internal and for speed
		if (!list.eventsEnabled && Reflect.hasField(list, "source") && Std.is(untyped list.source, Array))
		{
			untyped list.source.reverse();
		}
		else
		{
			var a = list.toArray();
			a.reverse();
			list.setAll(0, a);
		}
	}

	/**
		Shuffle the values of a List into random order. 
	**/
	public static function shuffle<T>(list:List<T>):Void
	{
		var a = list.toArray().shuffle();
		list.setAll(0, a);
	}
}
