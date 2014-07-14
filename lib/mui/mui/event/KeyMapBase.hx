package mui.event;

import haxe.ds.IntMap;
import mui.event.Key;

class KeyMapBase
{
	var map:IntMap<KeyAction>;

	public function new()
	{
		map = new IntMap();
	}

	public function clear()
	{
		map = new IntMap();
	}

	public function set(keyCode:Int, action:KeyAction)
	{
		map.set(keyCode, action);
	}

	public function get(keyCode:Int)
	{
		if (map.exists(keyCode))
		{
			return map.get(keyCode);
		}

		return UNKNOWN;
	}

	public function remove(keyCode:Int)
	{
		map.remove(keyCode);
	}
}