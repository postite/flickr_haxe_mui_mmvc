package mui.core;

import haxe.ds.StringMap;
import msignal.Signal;
import mui.util.Assert;

/**
	The root class of most MUI class hierarchies.

	Subclasses inherit the ability to monitor changes in internal state, and 
	broadcast those changes to other objects. This core functionality is used 
	as the basis for validation, binding, skinning and state management within 
	the framework.

	To participate in invalidation, `Node` subclasses must use the property 
	API to register changes in state. To simplify this process, `Node` uses a 
	build macro to generate property setters that notify the node of changes. 
	The following property:

	```haxe
	@:set var width:Int;
	```

	Will be expanded at compile time to:
	
	```haxe
	public var width(default, set_width):Int;
	function set_width(value:Int):Int
	{
		return width = changeValue("width", value);
	}
	```

	If custom setter behavior is required, it is possible to define the 
	function by hand; the macro metadata exists purely as a convenience. For 
	more information about available compiler metadata, see compile time 
	code generation with metadata.

	`Node` also defines and implements the `Changeable`	interface, which allows 
	other objects to register listeners for changes in property values.
**/
@:autoBuild(mui.core.NodeMacro.build())
class Node implements Changeable
{
	//-------------------------------------------------------------------------- static properties
	
	/**
		The singleton instance of the `Node` `Validator`. When a `Node` becomes 
		invalid, it adds itself to the validation stack by calling:

		```haxe
		Node.validator.invalidate(node)
		```

		During validation (before the next frame is entered) the `Validator` 
		removes the first `Node` from the stack and validates it, continuing 
		until the stack is empty.

		It is sometimes desirable to force immediate validation without waiting 
		for the next validation event. In these situations the clients can 
		trigger validation of the stack by calling:

		```haxe
		mui.core.Node.validator.validate();
		```
	**/
	public static var validator = new Validator();
	
	//-------------------------------------------------------------------------- constructor
	
	/**
		Creates a new generic `Node` instance. While instantiation is allowed, 
		`Node` functionality is generally inherited so that new properties can 
		be defined.
	**/  
	public function new()
	{
		valid = true;
		
		initialValues = {};
		previousValues = {};
		
		#if uiml
		states = new StringMap<Dynamic>();
		bindings = new StringMap<Array<Dynamic>>();
		#end

		changed = new Signal1<Dynamic>(Dynamic);
	}
	
	//-------------------------------------------------------------------------- public properties
	
	/**
		The `changed` signal is dispatched during validation if the state of a 
		node has changed. An anonymous flag object with fields matching the 
		changed properties set to `true` is dispatched, so that listeners can 
		easily check for changes:
		
		```haxe
		function changedHandler(flag:Dynamic)
		{
			if (flag.width)
			{
				// respond to change in width
			}
		}
		```
	**/
	public var changed(default, null):Signal1<Dynamic>;
	
	//-------------------------------------------------------------------------- private properties
	
	/**
		A boolean indicating whether the node is currently valid. When false, 
		the node is in the validation stack awaiting validation.
	**/
	var valid:Bool;
	
	/**
		An object containing the initial values of this Nodes properties, set 
		the first time changeValue is called. Its fields are used to determine 
		which properties have changed since the node was created.
	**/
	var initialValues:Dynamic;
	
	/**
		An object containing the previous values of properties that have 
		changed since the Node was validated. These fields are used during 
		validation to verify which properties have changed.
	**/
	var previousValues:Dynamic;

	//-------------------------------------------------------------------------- public methods
	
	/**
		Returns the initial value of a node property. The initial value is set 
		the first time `changeValue` is called.
		
		@param	property	The initial property to return.
		@return				The initial value of the property.
	**/
	public function getInitialValue(property:String):Dynamic
	{
		return Reflect.field(initialValues, property);
	}
	
	/**
		Returns the previous value of a node property if it has changed since 
		validation or `null` if the property has not changed.
		
		@param	property	The previous property to return.
		@return				The previous value of the property.
	**/
	public function getPreviousValue(property:String):Dynamic
	{
		return Reflect.field(previousValues, property);
	}
	
	/**
		Returns an object indicating which properties of the Node have changed 
		since it was initialized. This is useful for notifying new observers of 
		what has changed from a Node's initial state.
	**/
	public function getChangedValues():Dynamic
	{
		var changed:Dynamic = {};
		
		for (property in Reflect.fields(initialValues))
		{
			if (Reflect.field(this, property) != Reflect.field(initialValues, property))
			{
				Reflect.setField(changed, property, true);
			}
		}
		
		return changed;
	}
	
	/**
		Validates the `Node` by iterating over properties that might have 
		changed (for which `changeValue` was called since the last validation) 
		and comparing the current value to the previous value. If it is 
		determined that properties have changed, the `change` method is 
		called with a flag object indicating the changed properties.
	**/
	public function validate():Void
	{
		if (valid) return;
		valid = true;
		
		var flag:Dynamic = {};
		var hasChanged:Bool = false;
		
		var previousCopy = previousValues;
		previousValues = {};
		
		for (property in Reflect.fields(previousCopy))
		{
			var previousValue = Reflect.field(previousCopy, property);
			var currentValue = Reflect.field(this, property);
			
			if (currentValue != previousValue)
			{
				hasChanged = true;
				
				Reflect.setField(flag, property, true);
				
				#if uiml
				if (bindings.exists(property))
				{
					for (binding in bindings.get(property))
					{
						Reflect.setProperty(binding.target, binding.property, currentValue);
					}
				}
				#end
			}
		}
		
		if (hasChanged)
		{
			change(flag);
		}
	}

	//-------------------------------------------------------------------------- private methods
	
	/**
		Called by subclasses of Node to notify the validator of property 
		changes. Not that this method does not actually change the value of the 
		property, and should be called *before* the property changes.
		
		The pattern for property Node setters is as follows:
		
		```haxe
		public var property(default, set_property):Int;
		function set_property(value:Int):Int
		{
			return property = changeValue("property", value);
		}
		```
		
		@param	property	The property that changed.
		@param	value		The new value of the property.
		@return				The new value of the property.
	**/
	function changeValue(property:String, value:Dynamic):Dynamic
	{
		if (!Reflect.hasField(initialValues, property))
		{
			Reflect.setField(initialValues, property, value);
			return value;
		}
		
		var previousValue = Reflect.field(this, property);
		
		if (value == previousValue)
		{
			return value;
		}
		
		if (!Reflect.hasField(previousValues, property))
		{
			Reflect.setField(previousValues, property, previousValue);
		}
		
		invalidate();
		return value;
	}
	
	/**
		Called internally to force validation of a property, such that during the 
		next validation `change({property:true})` will be called.
		
		@param property The property to invalidate.
	**/
	function invalidateProperty(property:String):Void
	{
		Reflect.setField(previousValues, property, {});
		invalidate();
	}
	
	/**
		Adds the Node to the validation stack if it is valid.
	**/
	function invalidate():Void
	{
		if (!valid) return;
		valid = false;
		validator.invalidate(this);
	}
	
	/**
		Called when the properties of a Node change. This method is frequently 
		overridden in subclasses to centralise and optimise response to change in 
		internal state.
		
		@param flag an anonymous object with fields that have changed set to "true"
	**/
	function change(flag:Dynamic)
	{
		changed.dispatch(flag);
	}

	#if uiml
	/**
		A hash of property bindings.
	**/ 
	var bindings:StringMap<Array<Dynamic>>;
	
	/**
		A hash of property states. 
	**/
	var states:StringMap<Dynamic>;
	
	/**
		Binds the value of one node to that of another.
		
		@param	property		The property to bind.
		@param	target			The Node to bind the property to.
		@param	targetProperty	The property to set on the target when the bound 
								property changes.
	**/
	public function bindValue(property:String, target:Node, targetProperty:String)
	{
		var binding = {target:target, property:targetProperty};
		
		if (bindings.exists(property))
		{
			bindings.get(property).push(binding);
		}
		else
		{
			var destinations:Array<Dynamic> = [binding];
			bindings.set(property, destinations);
		}
		
		Reflect.setProperty(target, targetProperty, Reflect.field(this, property));
	}
	
	/**
		Sets a value state, such that when setState is called, properties with 
		values defined for that state will be updated.
		
		@param	name		The name of the state.
		@param	property	The property the state value will apply to.
		@param	value		The value of the property when in the named state.
	**/
	public function setValueState(name:String, property:String, value:Dynamic):Void
	{
		Assert.that(Reflect.hasField(this, property), "argument `property` must be an existing property of `this`");
		
		if (!states.exists(name))
		{
			states.set(name, {});
		}
		
		var state = states.get(name);
		Reflect.setField(state, property, value);
	}
	
	/**
		Sets the value of properties with a state value for the named state.
		
		@param	name	The name of the state.
	**/
	public function setState(name:String):Void
	{
		if (states.exists(name))
		{
			var state = states.get(name);
			
			for (field in Reflect.fields(state))
			{
				Reflect.setProperty(this, field, Reflect.field(state, field));
			}
		}
	}
	#end

	/**
		@return The string representation of this class. 
	**/
	public function toString()
	{
		return Type.getClassName(Type.getClass(this));
	}
}

/**
	Defines an observable and validatable API.

	Used primarily to allow other interfaces to participate in the 
	`Node` system.
**/
interface Changeable
{
	/**
		A signal dispatched when the observable properties of this instance are 
		validated. Allows observers to monitor changes in state.
	**/
	var changed(default, null):Signal1<Dynamic>;

	/**
		Validates the observable properties of this instance.
	**/
	function validate():Void;
}
