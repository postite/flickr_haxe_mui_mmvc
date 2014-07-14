package mui.event;

import msignal.Signal;
import mui.core.Component;

class Focus
{
	public static var changed = new Signal1<Component>(Component);
	
	public static var current(default, set_current):Component;
	static function set_current(value:Component):Component
	{
		if (value == current) 
		{
			return current;
		}
		
		if (current != null)
		{
			current.focusOut(null);
		}
		
		current = value;
		
		if (current != null)
		{
			current.focusIn(null);
		}
		
		changed.dispatch(current);
		
		return value;
	}
}
