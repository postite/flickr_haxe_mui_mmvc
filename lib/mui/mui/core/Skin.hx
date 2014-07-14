package mui.core;

import mui.display.Display;
import mui.core.Component;
import Type;

/**
	A behavior responsible for managing the visual elements of a target component.

	A skin adds/removes its children (`Displays`) when a target is set/removed.
	A skin listens to changes on it's target `Component` and updates accordingly.
**/
class Skin<T:mui.core.Component.DataComponent<Dynamic>> extends Behavior<T>
{
	/**
		A static instance of an empty skin
	**/
	public static var NONE = new Skin();
	
	/**
		Defines the minimum width of the target Component
		Cannot be used in combination with defaultWidth
	**/
	var minWidth:Int;

	/**
		Defines the minimum height of the target Component
		Cannot be used in combination with defaultHeight
	**/
	var minHeight:Int;
	
	/**
		Defines the maximum width of the target Component
		Cannot be used in combination with defaultWidth
	**/
	var maxWidth:Int;
	
	/**
		Defines the maximum height of the target Component
		Cannot be used in combination with defaultHeight
	**/
	var maxHeight:Int;
	
	/**
		Defines the width of the target Component
		Overrides any min/max width values
	**/
	var defaultWidth:Null<Int>;

	/**
		Defines the height of the target Component
		Overrides any min/max the values
	**/
	var defaultHeight:Null<Int>;
	
	public function new(?target:T)
	{
		super(target);
		
		minWidth = 0;
		minHeight = 0;

		maxWidth = 5000;
		maxHeight = 5000;
		
		defaultWidth = null;
		defaultHeight = null;
		
		properties = {};
		parts = [];
		
		defaultStyles = {};
		styles = {};
	}
	
	/**
		Properties to apply to the target Component when set
	**/
	public var properties:Dynamic;

	/**
		Children to add to the target Component when set
	**/
	var parts:Array<Display>;
	
	override function add()
	{
		copy(properties, target);
		for (part in parts) target.addChild(part);
		measure();
	}
	
	override function remove()
	{
		for (part in parts) target.removeChild(part);
	}
	
	function measure()
	{
		if (defaultWidth != null) target.width = defaultWidth;
		else if (target.width > maxWidth) target.width = maxWidth;
		else if (target.width < minWidth) target.width = minWidth;
	
		if (defaultHeight != null) target.height = defaultHeight;
		else if (target.height > maxHeight) target.height = maxHeight;
		else if (target.height < minHeight) target.height = minHeight;
	}
	
	// to help ease the transition
	
	function addChild(child:Display)
	{
		parts.push(child);
	}
	
	//-------------------------------------------------------------------------- Styles 

	var defaultStyles:Dynamic;
	
	public var styles(default, set_styles):Dynamic;
	function set_styles(value:Dynamic):Dynamic {return styles = changeValue("styles", mergeStyles(value));}
	
	public function appendStyles(fromStyles:Dynamic):Void
	{
		styles = mergeStyles(fromStyles, styles);
		changeValue("styles", styles);
	}
	
	public function revertStyles():Void
	{
		styles = mergeStyles({});
		changeValue("styles", styles);
	}
	
	function mergeStyles(fromStyles:Dynamic, ?existingStyles:Dynamic):Dynamic
	{
		var o= {};
		copy(defaultStyles, o);

		if(existingStyles != null)
		{
			copy(existingStyles, o);
		}

		copy(fromStyles, o);
		return o;
	}

	function copy(fromObject:Dynamic, toObject:Dynamic)
	{
		for (field in Reflect.fields(fromObject))
		{
			var fromValue = Reflect.field(fromObject, field);
			var toValue = Reflect.field(toObject, field);
			
			if (isMergable(fromValue) && isMergable(toValue))
			{
				copy(fromValue, toValue);
			}
			else
			{
				Reflect.setProperty(toObject, field, fromValue);
			}
		}
	}

	function isMergable(value:Dynamic)
	{
		return switch (Type.typeof(value))
		{
			case TClass(_), TObject: !Std.is(value, String);
			default: false;
		}
	}
}
