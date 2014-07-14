package mui.util;

/**
	The Dispatcher class implements composable cross-target message 
	dispatching. Clients can listen to either all messages dispatched by the 
	Dispatcher, or messages of a particular type. Clients should remove 
	listeners where appropriate to ensure garbage collection.
*/
class Dispatcher
{
	var listeners:Array<ListenerInfo>;
	var listenersNeedCloning:Bool;

	public function new()
	{
		listeners = [];
		listenersNeedCloning = false;
	}

	/**
		Adds an listener to the Dispatcher.
	**/
	public function add(listener:Dynamic, ?type:Dynamic=null):Void
	{
		registerListener(listener, false, type);
	}

	public function addOnce(listener:Dynamic, ?type:Dynamic=null):Void
	{
		registerListener(listener, true, type);
	}

	public function remove(listener:Dynamic):Void
	{
		var index:Int = -1;

		for (i in 0...listeners.length)
		{
			var info = listeners[i];

			if (Reflect.compareMethods(info.listener, listener))
			{
				index = i;
				break;
			}
		}

		if (index == -1) return;

		if (listenersNeedCloning)
		{
			listeners = listeners.copy();
			listenersNeedCloning = false;
		}

		listeners.splice(index, 1);
	}

	public function removeAll():Void
	{
		listeners = [];
	}

	public function dispatch(?message:Dynamic=null, ?target:Dynamic):Bool
	{
		if (listeners.length == 0) return false;
		listenersNeedCloning = true;

		// local copy
		var list = listeners;
		var handled = false;

		for (i in 0...list.length)
		{
			var info = list[i];
			var result = false;

			if (message != null && info.type != null)
			{
				if (Std.is(message, info.type) || message == info.type)
				{
					result = if (target != null) info.listener(message, target);
					else info.listener(message);
				}
			}
			else
			{
				result = if (target != null) info.listener(message, target);
				else if (message != null) info.listener(message);
				else info.listener();
			}

			if (result == true) handled = true;
			if (info.once) remove(info.listener);
		}

		listenersNeedCloning = false;
		return handled;
	}

	public function has(listener:Dynamic)
	{
		for (info in listeners)
		{
			if (Reflect.compareMethods(info.listener, listener))
			{
				return true;
			}
		}

		return false;
	}

	public function hasType(message:Dynamic)
	{
		for (info in listeners)
		{
			if (Std.is(message, info.type) || message == info.type)
			{
				return true;
			}
		}

		return false;
	}

	function registerListener(listener:Dynamic, once:Bool, type:Dynamic):Void
	{
		if (listeners.length == 0)
		{
			listeners.push({listener:listener, once:once, type:type});
			return;
		}

		var info:ListenerInfo = getListener(listener);

		if (info != null)
		{
			if (info.once && !once)
			{
				throw "You cannot addOnce() then add() the same listener without removing the relationship first.";
			}
			else if (!info.once && once)
			{
				throw "You cannot add() then addOnce() the same listener without removing the relationship first.";
			}

			return;
		}

		if (listenersNeedCloning)
		{
			listeners = listeners.copy();
			listenersNeedCloning = false;
		}

		listeners.push({listener:listener, once:once, type:type});
	}

	function getListener(listener:Dynamic):ListenerInfo
	{
		for (info in listeners)
		{
			if (Reflect.compareMethods(info.listener, listener))
			{
				return info;
			}
		}

		return null;
	}
}

private typedef ListenerInfo = {
	var listener:Dynamic;
	var once:Bool;
	var type:Dynamic;
}
