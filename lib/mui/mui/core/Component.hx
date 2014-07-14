package mui.core;

import mui.core.Node;
import mui.event.Focus;
import mui.display.AssetDisplay;
import mui.display.Display;
import mui.display.Rectangle;
import mui.util.Dispatcher;

/**
	`Component` is an alias to a Dynamic DataComponent.
**/
typedef Component = DataComponent<Dynamic>;

/**
	The base class for any focusable object on screen, such as a button.

	Each `Component` can present its visual assets on screen through the 
	use of a specific mui.core.Skin. This keeps the logic around the 
	presentation of a `Component` detached from its inner workings, allowing 
	skins to be easily swapped at runtime and increasing the reusability of a 
	component's core.

	A `Component` also sits as the base class for mui.core.Container, a 
	specialized `Component` which supports the nesting of other components 
	inside it.
**/
class DataComponent<TData> extends AssetDisplay
{
	public var container(default, null):Container;
	public var dispatcher(default, null):Dispatcher;
	
	public function new(?skin:Skin<Dynamic>)
	{
		super();
		
		focused = false;
		selected = false;
		pressed = false;
		data = null;
		
		invalidateProperty("focused");
		invalidateProperty("selected");
		invalidateProperty("enabled");
		
		dispatcher = new Dispatcher();
		if (skin != null) this.skin = skin;
		
		#if markup
		buildMarkup();
		#end
	}

	#if markup
	function buildMarkup()
	{
		// markup hook
	}
	#end
	
	public function action()
	{
		// abstract
	}

	/**
		Sets a platform specific automation identifer on the component's display to simplify 
		writing automated tests in products like Selenium.
	**/
	inline public function setAutomationId(id:String):Void
	{
		#if (automation && js)
		element.id = id;
		#end
	}

	/**
		The current skin of the component, `null` if the component is not 
		using a skin.
	**/
	public var skin(default, set_skin):Skin<Dynamic>;
	function set_skin(value:Skin<Dynamic>):Skin<Dynamic>
	{
		if (skin != null) skin.target = null;
		skin = value;
		if (skin != null) skin.target = this;
		return skin;
	}
	
	/**
		Bubbles a message up the display hierarchy.
	**/
	public function bubble(message:Dynamic):Void
	{
		bubbleFrom(message, this);
	}
	
	function bubbleFrom(message:Dynamic, target:Component):Void
	{
		if (dispatcher.dispatch(message, target) == true) return;
		if (container == null) return;
		untyped container.bubbleFrom(message, target);
	}
	
	override public function addedToStage():Void
	{
		super.addedToStage();
		bubble(COMPONENT_ADDED);
	}

	override public function removedFromStage():Void
	{
		bubble(COMPONENT_REMOVED);
		super.removedFromStage();
	}

	/**
		Whether the component currently has input focus.
	**/
	public var focused(default, set_focused):Bool;
	function set_focused(value:Bool):Bool { return focused = changeValue("focused", value); }
	
	/**
		Whether the component is currently selected.

		Selected components will gain focus when their `container` gains focus.
	**/
	public var selected(default, set_selected):Bool;
	function set_selected(value:Bool):Bool { return selected = changeValue("selected", value); }
	
	/**
		Whather the component is currently being actioned (by key or touch press)
	**/
	public var pressed(default, set_pressed):Bool;
	function set_pressed(value:Bool):Bool { return pressed = changeValue("pressed", value); }
	
	/**
		The data represented by the component.
	**/
	public var data(default, set_data):TData;
	function set_data(value:TData):TData
	{
		if (value != null) updateData(value);
		return data = changeValue("data", value);
	}
	
	function updateData(newData:TData)
	{
		// abstract
	}
	
	/**
		Gives the component input focus.
	**/
	public function focus():Void
	{
		if (!enabled) return;
		Focus.current = this;
	}
	
	/**
		Called by the framework when this component (or one of its children in 
		the case of a `Container`) gains focus.
	**/
	public function focusIn(source:Component)
	{
		focused = true;
		
		if (container == null) return;
		container.focusIn(this);
	}
	
	/**
		Called by the framework when this component (or one of its children in 
		the case of a `Container`) looses focus.
	**/
	public function focusOut(source:Component)
	{
		focused = false;
		
		if (container == null) return;
		container.focusOut(this);
	}
}

/**
	Enumerated `Component` event types.
**/
enum ComponentEvent
{
	/**
		Dispatched when a component is added to the display hierarchy.
	**/
	COMPONENT_ADDED;

	/**
		Dispatched when a component is removed from the display hierarchy.
	**/
	COMPONENT_REMOVED;
}
