package mdata;

import mdata.Collection;
import msignal.EventSignal;

enum ChangeLocation
{
	Range(start:Int, end:Int);
	Indices(i:Array<Int>);
}

class ListEvent<T> extends msignal.Event<List<T>, CollectionEventType<T>>
{
	public var location(default, null):ChangeLocation;
	
	public function new(type:CollectionEventType<T>, location:ChangeLocation)
	{
		super(type);
		this.location = location;
	}
}

#if haxe3
interface List<T> extends Collection<T>
#else
interface List<T> implements Collection<T>
#end
{
	/**
		Returns the first item found at the head of the List. 
		
		@throws mcore.exception.RangeException If the List is empty.
	**/
	var first(get_first, null):T;

	/**
		Returns the last item found at the tail of the List. 

		@throws mcore.exception.RangeException If the List is empty.
	**/
	var last(get_last, null):T;

	/**
		The number of items in the List.
	**/
	var length(get_length, null):Int;

	/**
		Inserts a value at a given index in the list.
		
		@param index The index at which to inset the value.
		@param value The value to insert.
		@throws mcore.exception.RangeException When index is outside of the 
			bounds of the List.
	**/
	function insert(index:Int, value:T):Void;

	/**
		Inserts a collection of values at a given index in the list.
		
		@param index The index at which to inset the values.
		@param values The collection of values to insert.
		@throws mcore.exception.RangeException When index is outside of the 
			bounds of the List.
	**/
	public function insertAll(index:Int, values:Iterable<T>):Void;
	
	/**
		Replace a value at a specified index.

		@param  index   the index of the value to replace
		@param  value   the value to set
		@return The replaced value
		@throws mcore.exception.RangeException When index is outside of the 
			bounds of the List.
	**/
	function set(index:Int, value:T):T;

	/**
		Replace a collection of values starting at a specified index.

		@param  index   The index at which to begin the replacements
		@param  value   The values to set
		@return The replaced values
		@throws mcore.exception.RangeException When index is outside of the 
			bounds of the List or when the index plus the number of values 
			exceeds the size of the List.
	**/
	function setAll(index:Int, values:Iterable<T>):Array<T>;

	/**
		Returns a value at a given index in the list.
		
		@param index The index of the value to return.
		@return The requested value.
		@throws mcore.exception.RangeException When index is outside of the 
			bounds of the List.
	**/
	function get(index:Int):T;

	/**
		Returns the first index at which the value exists in this List, or -1 
		if not found.
		
		@param value The value to index.
		@return The index of the value, or -1 if it is not found.
	**/
	function indexOf(value:T):Int;

	/**
		Returns the last index at which the value exists in this List, or -1 if not found.
	**/
	function lastIndexOf(value:T):Int;
	
	/**
		Remove the value at a specified index.
		
		@param index The index of the value to remove.
		@return The removed value.
		@throws mcore.exception.RangeException When index is outside of the 
			bounds of the List.
	**/
	function removeAt(index:Int):T;

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
	public function removeRange(startIndex:Int, endIndex:Null<Int> = null):Array<T>;
}
