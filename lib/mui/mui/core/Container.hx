package mui.core;

import mui.behavior.ScrollBehavior;
import mui.core.Skin;
import mui.core.Component;
import mui.event.Key;
import mui.layout.Layout;
import mui.layout.Direction;
import mui.display.Display;

/**
	Container is an alias to a Dynamic DataContainer.
**/
typedef Container = DataContainer<Dynamic, Dynamic>;

/**
	`Container` is base class for a `Component` containing other Components.

	Each `Container` is responsible for the focus, selection and navigation 
	between it's children

	A Container can have non-component children added behind or infront of the 
	components inside it.
**/
class DataContainer<TData, TChildData> extends DataComponent<TData>
{
	/**
		Internal child display containing all components
	**/
	public var components(default, null):Display;

	/**
		Behaviour responsible for determining next/previous selection
		based on user input (i.e. directional keys)
	
		@see `mui.core.Navigator`
	*/
	public var navigator(default, null):Navigator;

	/**
		Behaviour responsible for updating the position of children
		components within the container

		@see `mui.behavior.ScrollBehavior`
	**/
	public var scroller(default, null):ScrollBehavior;
	
	override public function new(?skin:Skin<Dynamic>)
	{
		super(skin);
		
		margin = 0;

		components = new ContainerContent();
		addChild(components);
		
		components.changed.add(componentsChange);
		
		numComponents = 0;
		selectedIndex = -1;
		
		// children will be added behind components and foreground
		numChildren = 0;
		
		layout = new mui.layout.Layout();
		layout.enabled = false;
		
		navigator = new Navigator(this);
		scroller = new ScrollBehavior(components);
		scroller.enabled = false;
	}
	
	/**
		Utility for adding a non-Component child infront of `Component` children
		(by default `Display` children are added below Components)
	*/
	function addChildInfront(display:Display)
	{
		addChild(display);
		
		#if flash
		sprite.addChild(display.sprite);
		#elseif js
		element.appendChild(display.element);
		#end
	}

	override function change(flag:Dynamic):Void
	{
		super.change(flag);
		
		if (flag.selectedIndex)
		{
			bubble(SELECTION_CHANGED);
		}
	}
	
	function componentsChange(flag:Dynamic)
	{
		if (flag.contentWidth && resizeX)
		{
			width = components.contentWidth + marginLeft + marginRight;
		}
		
		if (flag.contentHeight && resizeY)
		{
			height = components.contentHeight + marginTop + marginBottom;
		}
	}
	
	override function set_layout(value:Layout):Layout
	{
		invalidateProperty("layout");
		return layout = components.layout = value;
	}
	
	//------------------------------------------------------------------------- margins

	/**
		Sets the top, bottom left and right margins to the same value, causing 
		the `components` display to be resized.
	**/
	public var margin(null, set_margin):Int;
	function set_margin(value:Int):Int { return marginLeft = marginRight = marginTop = marginBottom = value; }
	
	/**
		The left margin between the `Container` bounds and `components`.
	**/
	public var marginLeft(default, set_marginLeft):Int;
	function set_marginLeft(value:Int):Int
	{
		marginLeft = changeValue("marginLeft", value);
		resizeComponents();
		return marginLeft;
	}
	
	/**
		The right margin between the `Container` bounds and `components`.
	**/
	public var marginRight(default, set_marginRight):Int;
	function set_marginRight(value:Int):Int
	{
		marginRight = changeValue("marginRight", value);
		resizeComponents();
		return marginRight;
	}
	
	/**
		The top margin between the `Container` bounds and `components`.
	**/
	public var marginTop(default, set_marginTop):Int;
	function set_marginTop(value:Int):Int
	{
		marginTop = changeValue("marginTop", value);
		resizeComponents();
		return marginTop;
	}
	
	/**
		The bottom margin between the `Container` bounds and `components`.
	**/
	public var marginBottom(default, set_marginBottom):Int;
	function set_marginBottom(value:Int):Int
	{
		marginBottom = changeValue("marginBottom", value);
		resizeComponents();
		return marginBottom;
	}
	
	override function set_width(value:Int):Int
	{
		super.set_width(value);
		resizeComponents();
		return value;
	}

	override function set_height(value:Int):Int
	{
		super.set_height(value);
		resizeComponents();
		return value;
	}

	function resizeComponents()
	{
		if (components == null) return;
		components.x = marginLeft;
		components.y = marginTop;
		components.width = width - (marginLeft + marginRight);
		components.height = height - (marginTop + marginBottom);
	}

	/**
		Adds a non-Component child to the display at a specific index
		
		@param child 	a non-Component Display
		@param index 	location in array to add child
	**/
	override public function addChildAt(child:Display, index:Int):Void
	{
		super.addChildAt(child, index);
		
		#if debug
		if (Std.is(child, Component))
		{
			trace("warn", "Should not add component [", Type.getClassName(Type.getClass(child)), "] as child to [", Type.getClassName(Type.getClass(this)), "] , use addComponent or addComponentAt instead.");
		}
		#end
	}

	/**
		The number of child components.
	**/
	public var numComponents(default, null):Int;
	
	/**
		Adds a `Component` to the `Container`.
		
		@param component The `Component` to add
	**/
	public function addComponent(component:Component)
	{
		addComponentAt(component, numComponents);
	}
	
	/**
		Inserts a `Component` into the `Container` at a specific index.
		
		@param component The Component to insert
		@param index The index in child array at which to insert the component
	**/
	public function addComponentAt(component:Component, index:Int)
	{
		if (component.container != null)
		{
			component.container.removeComponent(component);
		}
		
		numComponents += 1;
		untyped component.container = this;
		components.addChildAt(component, index);

		if (selectedIndex == -1)
		{
			selectedComponent = navigator.closest(component);
		}
		
		invalidateProperty("components");
	}
	
	/**
		Removes a `Component` from this container

		@param component The Component to remove
	**/
	public function removeComponent(component:Component)
	{
		removeComponentAt(getComponentIndex(component));
	}
	
	/**
		Removes a `Component` from this container at a specific index

		@param index The index of the component to remove
	**/
	public function removeComponentAt(index:Int)
	{
		var component = getComponentAt(index);
		
		// adjust selected index based on component being removed
		selectedIndex -= (index <= selectedIndex ? 1 : 0);

		// reset component state
		component.focused = component.selected = component.pressed = false;

		// remove from display list
		components.removeChildAt(index);
		numComponents -= 1;
		component.container = null;
		
		if (selectedIndex > -1)
		{
			// update state of selected component
			selectedComponent = navigator.closest(selectedComponent);
			selectedComponent.selected = true;
			selectedComponent.focused = focused;
		}
		
		// notify watchers
		invalidateProperty("components");
	}
	
	/**
		Returns the index of a child component
		
		@param component Component child to locate
		@return The index of the component in the components array, or `-1` if 
			the component is not a child of this container.
	**/
	public function getComponentIndex(component:Component):Int
	{
		return components.getChildIndex(component);
	}
	
	/**
		Returns the child component at a specific index
		
		@param index The index of the child component to return
		@return The component at the specified index, of null if no component
			exists at that index.
	**/
	public function getComponentAt(index:Int):Component
	{
		var component = components.getChildAt(index);
		return cast component;
	}
	
	/**
		Removes all components from the Container
	**/
	public function removeComponents()
	{
		selectedIndex = -1;
		
		for (i in 0...numComponents)
		{
			removeComponentAt(0);
		}
	}
	
	#if touch

	/**
		Recursive method that returns the Display object at a specific x/y 
		location. Used for mouse and touch selection of components.
		
		@param x The x coordinate
		@param y The y coordinate
		@return the display under the coordinates, or null.
	**/
	override public function getDisplayUnder(x:Int, y:Int):Display
	{
		if (x < 0 || x > width) return null;
		if (y < 0 || y > height) return null;
		
		if (!visible || !enabled) return null;
		if (children.length == 0) return cast(this, Display);
		
		var localX = x + scrollX;
		var localY = y + scrollY;
		var i = children.length;
		
		while (i > 0)
		{
			i -= 1;
			var display = children[i];
			var descendant = display.getDisplayUnder(localX - display.x, localY - display.y);
			if (descendant != null) return descendant;
		}
		
		return cast(this, Display);
	}
	#end
	
	//------------------------------------------------------------------------- selection
	
	/**
		Index of the currently selected component, or `-1` if there is no 
		selection (or there are no children)
	**/
	public var selectedIndex(default, set_selectedIndex):Int;
	public function set_selectedIndex(value:Int):Int
	{
		mui.util.Assert.that(value >= -1 && value < numComponents, "argument `value` is out of bounds: " + value);

		if (!Reflect.hasField(initialValues, "selectedIndex"))
		{
			return selectedIndex = changeValue("selectedIndex", value);
		}
		
		if (value == selectedIndex)
		{
			return selectedIndex;
		}
		
		if (selectedComponent != null)
		{
			selectedComponent.selected = false;
		}
		
		selectedIndex = changeValue("selectedIndex", value);
		
		if (selectedComponent != null)
		{
			selectedComponent.selected = true;
			if (layout.enabled) layout.layoutDisplay(selectedIndex);
		}
		
		if (focused)
		{
			focus();
		}
		
		return selectedIndex;
	}
	
	/**
		The currently selected component, or `null` if there is no selection.

		Setting this value is equivalent to setting `selectedIndex` to 
		`getComponentIndex(component)` 
	**/
	public var selectedComponent(get_selectedComponent, set_selectedComponent):Component;
	public function get_selectedComponent():Component
	{
		if (selectedIndex == -1 || Math.isNaN(selectedIndex)) return null;
		return getComponentAt(selectedIndex);
	}
	
	public function set_selectedComponent(component:Component):Component
	{
		selectedIndex = component == null ? -1 : getComponentIndex(component);
		return component;
	}
	
	/**
		The `data` of the currently selected component, or `null` if there is 
		no selection.
	**/
	public var selectedData(get_selectedData, set_selectedData):TChildData;
	function get_selectedData():TChildData
	{
		if (selectedComponent == null) return null;
		return selectedComponent.data;
	}
	
	function set_selectedData(value:TChildData):TChildData
	{
		for (i in 0...numComponents)
		{
			if (getComponentAt(i).data == value)
			{
				selectedIndex = i;
				break;
			}
		}

		return value;
	}
	
	/**
		Overrides `focus()` to bubble focus to selected component if enabled.
	**/
	override public function focus():Void
	{
		if (!enabled) return;
		
		if (selectedComponent != null && selectedComponent.enabled) selectedComponent.focus();
		else super.focus();
	}
	
	/**
		Updates selected index when a child component receives focus
	**/
	override public function focusIn(source:Component)
	{
		super.focusIn(source);
		if (source == null) return;
		selectedIndex = getComponentIndex(source);
	}
	
	//------------------------------------------------------------------------- input
	
	#if key

	/**
		Manages focus between child components when directional keys pressed.
		Defers actual selection of next/previous to navigator behavior
	**/
	override public function keyPress(key:Key)
	{
		var next:Component = null;
		var selected = selectedComponent;
		var action = key.action;
		
		if (selectedIndex > -1 && action != null)
		{
			next = switch (key.action)
			{
				case UP: navigator.next(selected, Direction.up);
				case DOWN: navigator.next(selected, Direction.down);
				case LEFT: navigator.next(selected, Direction.left);
				case RIGHT: navigator.next(selected, Direction.right);
				default: null;
			}
		}
		
		if (next != null)
		{
			key.capture();
			next.focus();
		}
		else super.keyPress(key);
	}
	#end
}

private class ContainerContent extends Display
{
	public function new()
	{
		super();
	}
}

/**
	Enumerated `Container` event types.
**/
enum ContainerEvent
{
	/**
		Dispatched when the selected index changes in a container
	**/
	SELECTION_CHANGED;
}
