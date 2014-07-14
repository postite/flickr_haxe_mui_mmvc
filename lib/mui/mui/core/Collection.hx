package mui.core;

import mui.core.Container;
import mui.core.Node;
import mui.layout.Layout;

typedef Collection = DataCollection<Dynamic, Dynamic>

/**
	A `DataContainer` that creates children in response to changes in it's data.
**/
class DataCollection<TData, TChildData> extends DataContainer<TData, TChildData>
{
	override public function new(?skin:Skin<Dynamic>):Void
	{
		super(skin);
		
		factory = new ComponentFactory(Component);
		layout.enabled = true;
		scroller.enabled = true;
	}

	/**
		The factory responsible for creating the collection's children.
	**/
	public var factory(default, set_factory):ComponentFactory;
	function set_factory(value:ComponentFactory):ComponentFactory { return factory = changeValue("factory", value); }
	
	/**
		If new data is an `Array` the `childData` property is updated with 
		the same value.
	**/
	override function updateData(value:TData)
	{
		if (Std.is(value, Array)) childData = cast value;
	}
	
	function createComponent(data:TChildData):Component
	{
		return factory.create(data);
	}

	function updateComponent(component:Component, data:TChildData):Void
	{
		factory.setData(component, data);
	}

	/**
		The `Array` of data that populates the collection's children.
	**/
	public var childData(default, set_childData):Array<TChildData>;
	function set_childData(value:Array<TChildData>):Array<TChildData>
	{
		if (value == null) value = [];
		childData = value;
		
		for (i in 0...childData.length)
		{
			var child:Component;
			
			if (i < numComponents)
			{
				child = getComponentAt(i);
			}
			else
			{
				child = createComponent(childData[i]);
				addComponent(child);
			}
			
			updateComponent(child, childData[i]);
			
			if (child == selectedComponent)
			{
				child.selected = true;
			}
		}
		
		for (i in childData.length...numComponents)
		{
			removeComponentAt(childData.length);
		}
		
		return childData;
	}
}
