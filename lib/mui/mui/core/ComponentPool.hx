package mui.core;

import haxe.ds.StringMap;
import mui.core.ComponentFactory;
import mui.core.Component;

/**
	Components which are pooled can implement Reusable to be notified
	when they are about to be removed from the pool and reused. This
	gives them the opportunity to clear their state.

	Note that if the data property of a Component removed from the pool
	is the same as the data about to be set on it then `prepareForReuse()`
	is *not* called.
**/
interface Reusable
{
	function prepareForReuse():Void;
}

/**
	Given a data object, create a `Component` which should represent it.
	
	When a `Component` is no longer needed it can be pooled ready for reuse the
	next time a data object requires that type of Component for representation.
**/
class ComponentPool extends ComponentFactory
{
	var componentPools:StringMap<Array<Component>>;

	public function new(?component:Dynamic, ?skin:Dynamic)
	{
		super(component, skin);
		componentPools = new StringMap<Array<Component>>();
	}

	/**
		Create a `Component` to represent the data provided.
		
		If a `Component` already exists in the pool which can represent 
		the data, then this will be used instead.
	**/
	override public function create(data:Dynamic):Component
	{
		var componentInstance = getPooled(data);
		if (componentInstance == null)
		{
			componentInstance = super.create(data);
		}
		return componentInstance;
	}

	function getPooled(data:Dynamic):Component
	{
		var componentType = getComponentType(data);
		if (componentType != null)
		{
			var key = Type.getClassName(componentType);
			var pool = componentPools.get(key);

			if (pool != null && pool.length > 0)
			{
				var component = pool.pop();
				if (Std.is(component, Reusable) && component.data != data)
				{
					untyped component.prepareForReuse();
				}
				return component;
			}
		}
		return null;
	}

	/**
		Add a Component back to the pool for later reuse.
	**/
	public function add(component:Component)
	{
		var key = Type.getClassName(Type.getClass(component));
		
		if (componentPools.exists(key))
		{
			componentPools.get(key).push(component);
		}
		else
		{
			componentPools.set(key, [component]);
		}
	}

	public function clear()
	{
		componentPools = new StringMap<Array<Component>>();
	}

	override function getDefaultComponentType(data:Dynamic):Class<Dynamic>
	{
		var type = super.getDefaultComponentType(data);
		if (type == null) throw "'ComponentPool.getComponentType' must be set with a function returning the type of Component to represent the data provided.";
		return type;
	}
}
