package mui.core;

import mui.layout.Layout;
import mui.layout.Direction;

/**
	A `Navigator` instance is used by each `Container` to move selection 
	between its child components in response to key input. It defines logic for 
	skipping disabled components,and using the containers layout to determine 
	the next component to select in a given direction.
**/
class Navigator extends Behavior<Container>
{
	/**
		Whether to skip disabled components when searching for the next 
		component in a `Direction`
	**/
	public var skipDisabled:Bool;

	public function new(target:Container)
	{
		super(target);
		skipDisabled = true;
	}

	/**
		Returns the closest selectable sibling to the provided component.
	**/
	public function closest(component:Component):Component
	{
		if (component.enabled) return component;
		var index = component.index;
		
		var nextComponent = get(index, Direction.next);
		var previousComponent = get(index, Direction.previous);
		
		for (i in 0...target.numComponents)
		{
			if (nextComponent != null)
			{
				if (nextComponent.enabled)
				{
					return nextComponent;
				}

				nextComponent = get(index, Direction.next);
			}

			if (previousComponent != null)
			{
				if (previousComponent.enabled)
				{
					return previousComponent;
				}

				previousComponent = get(index, Direction.previous);
			}
		}

		return null;
	}

	/**
		Returns the next selectable sibling of the provided component in the 
		provided `Direction`.
	**/
	public function next(component:Component, direction:Direction):Component
	{
		var index = component.index;
		var nextComponent = get(index, direction);
		var prevComponent = null;

		while (nextComponent != null && nextComponent != component && nextComponent != prevComponent)
		{
			if (nextComponent.enabled)
			{
				return nextComponent;
			}
			else if (!skipDisabled)
			{
				return null;
			}

			prevComponent = nextComponent;
			nextComponent = get(nextComponent.index, direction);
		}

		return null;
	}

	function get(index:Int, direction:Direction):Component
	{
		var next = target.layout.next(index, direction);
		if (next == -1) return null;
		return target.getComponentAt(next);
	}
}
