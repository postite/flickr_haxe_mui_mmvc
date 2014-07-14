package mui.core;

import mui.core.Node;

/**
	Defines a simple mechanism for composing runtime behavior.

	A concrete `Behavior` has a target, typed using the type parameter `T`, 
	which must implement Changeable (and is usually a subclass of `Node`).
	The behavior listens for changes of state in its target, and is notified
	when it is added and removed. Behaviors can also be switched on and off
	using their `enabled` property.

	Behaviors are a powerful way of defining composable functionality in a 
	typesafe manner. They form the basis of layout, skinning, scrolling and more 
	in the MUI framework. For more examples see the `mui.behavior` package.
**/
class Behavior<T:Changeable> extends Node
{
	/**
		A boolean indicating the enabled state of the `Behavior`.
	**/
	public var enabled:Bool;

	/**
		Creates a new `Behavior` instance, optionally passing a target to 
		start observing.

		@param target The target to observe.
	**/
	function new(?target:T)
	{
		super();
		
		enabled = true;
		
		if (target != null)
		{
			this.target = target;
		}
	}
	
	/**
		The target of the behavior. When a target is set, the behavior first 
		removes itself from an existing target (if it has one), and then adds 
		itself to the new target. It does this by registering a listener with 
		the targets `changed` signal.
	**/
	public var target(default, set_target):T;

	function set_target(value:T):T
	{
		if (target != null)
		{
			remove();
			target.changed.remove(targetChange);
		}
		
		target = value;
		
		if (target != null)
		{
			target.changed.add(targetChange);
			add();
		}
		
		return target;
	}
	
	/**
		The target `changed` listener. Calls `update` if the behavior is 
		enabled.
	**/
	function targetChange(flag:Dynamic)
	{
		if (enabled)
		{
			update(flag);
		}
	}
	
	/**
		Called when the behavior is added to a new target.
	**/
	function add()
	{
		// abstract
	}
	
	/**
		Called when the observable properties of the behaviors target change.
	**/
	function update(flag:Dynamic)
	{
		// abstract
	}

	/**
		Called before the behavior is removed from a target.
	**/
	function remove()
	{
		// abstract
	}
}
