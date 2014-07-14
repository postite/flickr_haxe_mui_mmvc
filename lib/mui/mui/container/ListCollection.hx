package mui.container;

import mdata.Collection;
import mdata.List;
import mdata.SelectableList;
import mdata.ArrayList;
import mui.core.Container;
import mui.core.Skin;
import mui.core.ComponentFactory;
import mui.core.Component;
using mcore.util.Ints;

/**
	A specialized DataContainer, similar to a DataCollection but driven by a 
	`List` data structure instead of an `Array`.

	When a new List is assigned to the data of this Container, listeners are 
	automatically added for the addition and removal of data from that List. 
	Any changes detected in the List are then reflected in this ListCollection 
	through the adding and removing of child components.

	If a mdata.SelectableList is assigned as the data of this ListCollection 
	then an additional listener will be added for that Lists selectionChanged 
	signal. Any changes in the List selection will be then reflected in the 
	selectedIndex of this ListCollection.

	The ListCollection can be configured to only render a subset of the 
	underlying data list by specifying a custom start and end dataRange 
	(`setDataRange`)
**/
class ListCollection<TChildData> extends DataContainer<List<TChildData>, TChildData>
{
	/**
		The start and end data range for the collection set via `setRangeData`.
	**/
	public var dataRange(default, null):DataRange;

	/**
		Defines the bound start/end range for the current list data.

		See `setRangeData`.
	**/
	var boundedDataRange:DataRange;

	/**
		Indicates if list has an active data range
	**/
	var hasDataRange:Bool;

	/**
		Indicates if the list is currently replacing old children with new. 
	**/
	var replacingItems:Bool;
	
	public function new(?skin:Skin<Dynamic>):Void
	{
		super(skin);

		factory = new ComponentFactory(Component);
		layout.enabled = true;
		scroller.enabled = true;
		hasDataRange = false;
		replacingItems = false;
		dataRange = {start:0, end:-1};
		boundedDataRange = {start:0, end:0};
	}

	public var factory(default, set_factory):ComponentFactory;
	function set_factory(value:ComponentFactory):ComponentFactory { return factory = changeValue("factory", value); }

	/**
		Sets a constraint on the data set rendered by the collection

		@param start index of the range (use 0 to reset to full range)
		@param end index (defaults to -1 for all within range)
	**/
	public function setDataRange(start:Int, ?end:Int = -1)
	{
		dataRange = {start:start, end:Std.int(end)}; // Std.int needed to fix compilation bug under cpp
		hasDataRange = end != -1 || start > 0;

		if (childData != null)
			set_childData(childData);
	}

	/**
		Overrides `focus` to sync with SelectableList
	**/
	override public function focus():Void
	{
		if (!enabled) return;

		if (selectedComponent == null && childData != null && Std.is(childData, SelectableList))
		{
			var list:SelectableList<Dynamic> = cast childData;
			if (!list.isEmpty())
			{
				var i = list.selectedIndex.clamp(boundedDataRange.start, boundedDataRange.end-1);
				list.selectedIndex = i.clamp(0, list.size-1);
			}
		}
		super.focus();
	}

	override function change(flag:Dynamic)
	{
		super.change(flag);

		if (flag.data && data == null)
		{
			selectedIndex = -1;
		}
	}
	
	override function set_data(value:List<TChildData>):List<TChildData>
	{
		// need to do this here and not after invalidation as changes may have already
		// been triggered in child that we don't want to be listening to
		if (value == null) 
		{
			removeChildListener();
		}
		return super.set_data(value);
	}
	
	override function updateData(value:List<TChildData>)
	{
		childData = value;
	}

	public var childData(default, set_childData):List<TChildData>;
	function set_childData(value:List<TChildData>)
	{
		if (value == null) value = new ArrayList();
		
		removeChildListener();
		
		childData = value;

		updateDataRange();

		// avoid updating selected index while refreshing items as can cause index out of bounds
		// when selected index of childData is outside bounds of number of child components added
		replacingItems = true; 
		
		for (i in boundedDataRange.start...boundedDataRange.end)
		{
			var child:Component;

			var ii = i - boundedDataRange.start;

			if (ii < numComponents)
			{
				child = getComponentAt(ii);
			}
			else
			{
				child = factory.create(childData.get(i));
				addComponent(child);
			}

			updateComponent(child, childData.get(i));

			if (child == selectedComponent)
			{
				child.selected = true;
			}
		}

		var length = hasDataRange ? boundedDataRange.end-boundedDataRange.start : childData.length;
		for (i in length...numComponents)
		{
			removeComponentAt(length);
		}

		addChildListener();
		replacingItems = false;

		if (Std.is(childData, SelectableList))
			selectionChanged(untyped childData);

		return childData;
	}

	function updateComponent(component:Component, data:TChildData):Void
	{
		factory.setData(component, data);
	}

	function updateDataRange()
	{
		var length = childData != null ? childData.length : 0;

		if (hasDataRange)
		{
			var start = Std.int(Math.min(Math.max(0, dataRange.start), length));

			var end = length;

			if (dataRange.end > -1)
			{
				end = Std.int(Math.min(length, dataRange.end));
			}
			else if(dataRange.end < -1)
			{
				end = length+dataRange.end;
				end = Std.int(Math.max(start, end));
			}

			boundedDataRange = {start:start, end:end};
		}
		else
		{
			boundedDataRange = {start:0, end:length};
		}
	}

	function removeChildListener()
	{
		if (childData == null) return;
		
		childData.changed.remove(listChanged);

		if (Std.is(childData, SelectableList))
			untyped childData.selectionChanged.remove(selectionChanged);
	}
	
	function addChildListener()
	{
		if (childData == null) return;
		
		childData.changed.add(listChanged);
		
		if (Std.is(childData, SelectableList))
			untyped childData.selectionChanged.add(selectionChanged);
	}

	function listChanged(event:CollectionEvent<Dynamic>)
	{
		var e:ListEvent<Dynamic> = cast event;
		switch (e.type)
		{
			case Add(items): addItems(e);
			case Remove(items): removeItems(e);
			case Replace(items): replaceItems(e);
		}
	}
	
	function addItems(event:ListEvent<Dynamic>)
	{
		updateDataRange();

		switch (event.location)
		{
			case Range(s, e):

				if (hasDataRange)
				{
					s = Std.int(Math.max(boundedDataRange.start, s));
					e = Std.int(Math.min(boundedDataRange.end, e));
				}

				for (i in s...e)
				{
					var data:Dynamic = childData.get(i);
					var child = factory.create(data);
					addComponentAt(child, i-boundedDataRange.start);
					updateComponent(child, data);
				}
			
			case Indices(x):
				for (i in x)
				{
					var data:Dynamic = childData.get(i);
					var child = factory.create(data);
					addComponentAt(child, i-boundedDataRange.start);
					updateComponent(child, data);
				}
		}
	}
	
	function removeItems(event:ListEvent<Dynamic>)
	{
		switch (event.location)
		{
			case Range(s, e):
				if (hasDataRange)
				{
					s = Std.int(Math.max(boundedDataRange.start, s));
					e = Std.int(Math.min(boundedDataRange.end, e));
				}

				while (e-- > s)
				{
					removeComponentAt(e - boundedDataRange.start);
				}

			case Indices(x):
				var i = x.length;
				while (i-- > 0)
				{
					var index = x[i];

					if (!hasDataRange)
					{
						removeComponentAt(index);
					}
					else if (index.isWithin(boundedDataRange.start, boundedDataRange.end-1))
					{
						removeComponentAt(index-boundedDataRange.start);
					}
				}
		}

		if (boundedDataRange.start >= childData.length)
		{
			while (numComponents > 0)
				removeComponentAt(0);
		}

		updateDataRange();
	}

	function replaceItems(event:ListEvent<Dynamic>)
	{
		replacingItems = true;
		switch (event.location)
		{
			case Range(s, e):
				
				if (hasDataRange)
				{
					s = Std.int(Math.max(boundedDataRange.start, s));
					e = Std.int(Math.min(boundedDataRange.end, e));
				}

				while (e-- > s)
				{
					var i = e - boundedDataRange.start;
					var child = getComponentAt(i);
					var data:Dynamic = childData.get(e);

					// no factory api to check child type without creating, but still 
					// cheaper to create and discard than add/remove children when not necessary.
					var newChild = factory.create(data);
					if (Type.getClass(newChild) != Type.getClass(child))
					{
						removeComponentAt(i);
						addComponentAt(newChild, i);
						child = newChild;
					}

					updateComponent(child, data);
				}
			
			case Indices(x):
				var i = x.length;
				while (i-- > 0)
				{
					var index = x[i];

					if (hasDataRange && !index.isWithin(boundedDataRange.start, boundedDataRange.end - 1))
						continue;
					
					var x = index - boundedDataRange.start;
					var child = getComponentAt(x);
					var data = childData.get(index);

					// no factory api to check child type without creating, but still 
					// cheaper to create and discard than add/remove children when not necessary.
					var newChild = factory.create(data);
					if (Type.getClass(newChild) != Type.getClass(child))
					{
						removeComponentAt(x);
						addComponentAt(newChild, x);
						child = newChild;
					}

					updateComponent(child, data);
				}
		}
		replacingItems = false;
		
		if (Std.is(childData, SelectableList))
		{
			selectionChanged(untyped childData);
		}
	}
	
	function selectionChanged(list:SelectableList<TChildData>)
	{
		if (replacingItems) return;

		if (list.selectedIndex == -1)
		{
			selectedIndex = -1;
		}
		else if (list.selectedIndex.isWithin(boundedDataRange.start, boundedDataRange.end - 1))
		{
			selectedIndex = list.selectedIndex - boundedDataRange.start;
		}
	}

	override public function set_selectedIndex(value:Int):Int
	{
		var i = super.set_selectedIndex(value);
		
		if (!replacingItems && (!hasDataRange || focused) && Std.is(childData, SelectableList))
		{
			var list:SelectableList<Dynamic> = cast childData;
			var k = i + boundedDataRange.start;
			
			if (list.length > k && k.isWithin(boundedDataRange.start, boundedDataRange.end - 1))
			{
				list.selectedIndex = k;
			}
		}
		return i;
	}
}

private typedef DataRange =
{
	start:Int,
	end:Int
}
