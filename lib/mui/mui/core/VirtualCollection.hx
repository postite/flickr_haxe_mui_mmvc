package mui.core;

import mui.core.Component;
import mui.core.Collection;
import mui.display.Display;
import mui.display.VirtualDisplay;

typedef VirtualCollection = DataVirtualCollection<Dynamic, Dynamic>;

/**
	A virtual collection only creates the components visible on screen, and 
	recycles a single pool of components.
**/
class DataVirtualCollection<TData, TChildData> extends DataCollection<TData, TChildData>
{
	var virtualDisplay:VirtualDisplay;
	public var dontCull:Bool;

	/**
		The pool of components used to populate the collection.
	**/
	public var pool(get_pool, set_pool):ComponentPool;
	function get_pool() { return cast(factory, ComponentPool); }
	function set_pool(value:ComponentPool):ComponentPool { return cast factory = value; }

	public function new()
	{
		super();

		numChildren = 1;
		dontCull = false;

		components.changed.remove(componentsChange);
		super.removeChild(components);

		virtualDisplay = new VirtualDisplay();
		virtualDisplay.requestChild = requestComponent;
		virtualDisplay.releaseChild = releaseComponent;
		virtualDisplay.layout = layout;

		components = virtualDisplay;
		addChildAt(components, 0);

		components.changed.add(componentsChange);
		components.clip = true;
		
		scroller.target = components;
		numChildren = 0;

		factory = new ComponentPool(Component);
	}

	override function set_childData(value:Array<TChildData>):Array<TChildData>
	{
		if(value == null) value = [];
		childData = value;

		selectedIndex = -1;
		releaseAll();
		numComponents = changeValue("numComponents", childData.length);
		virtualDisplay.populate(numComponents);

		if (numComponents > 0)
		{
			var first = getComponentAt(0);
			selectedComponent = navigator.closest(first);
		}

		return value;
	}

	function requestComponent(index:Int):Display
	{
		var data = childData[index];
		var component:Component = null;

		component = requestPooled(index);
		updateComponent(component, data);
		component.selected = (index == selectedIndex);
		untyped component.container = this;
		component.addedToStage();

		return component;
	}

	function releaseComponent(display:Display):Bool
	{
		var component = cast(display, mui.core.Component);
		if (component == selectedComponent || dontCull) return false;

		component.removedFromStage();
		component.focused = false;
		component.selected = false;
		releasePooled(component);

		return true;
	}

	function requestPooled(index:Int):Component
	{
		return pool.create(childData[index]);
	}
	
	function releasePooled(component:Component)
	{
		return pool.add(component);
	}
	
	function releaseAll()
	{
		var cull = dontCull;
		dontCull = false;

		var i = selectedIndex;
		selectedIndex = -1;

		for (i in virtualDisplay.visibleChildren.keys())
		{
			var childComponent = getComponentAt(i);
			if (childComponent == null) continue;

			childComponent.removedFromStage();
			virtualDisplay.releaseChildAt(i);
		}
		
		selectedIndex = i;
		dontCull = cull;
	}
}
