package mui.display;

import haxe.ds.IntMap;
import haxe.Timer;
import mui.display.Display;

/**
	A display that creates it's childen when they are accessed.
**/
class VirtualDisplay extends Display
{
	public var requestChild:Int -> Display;
	public var releaseChild:Display -> Bool;
	public var visibleChildren:IntMap<Display>;
	
	public function new()
	{
		super();
		visibleChildren = new IntMap();
	}
	
	override public function addChildAt(child:Display, index:Int){}
	override public function removeChild(child:Display){}
	override public function removeChildAt(index:Int):Void{}

	public function populate(numChildren:Int)
	{
		this.numChildren = numChildren;
		invalidateProperty("children");
	}
	
	public function removeChildren()
	{
		for (i in visibleChildren.keys())
		{
			releaseChildAt(i);
		}

		populate(0);
		visibleChildren = new IntMap();
	}

	override public function getChildIndex(child:Display):Int
	{
		return child.index;
	}
	
	override public function getChildAt(index:Int):Display
	{
		if (index < 0 || index > numChildren - 1)
		{
			return super.getChildAt(index);
		}
		
		if (visibleChildren.exists(index))
		{
			return visibleChildren.get(index);
		}
		
		var child = requestChild(index);
		visibleChildren.set(index, child);
		addVirtualChildAt(child, index);

		return child;
	}
	
	override public function releaseChildAt(index:Int):Bool
	{
		if (!visibleChildren.exists(index)) return false;
		
		var child = visibleChildren.get(index);
		if (!releaseChild(child)) return false;

		visibleChildren.remove(index);
		removeVirtualChildAt(child, index);
		
		return true;
	}
	
	function addVirtualChildAt(child:Display, index:Int)
	{
		#if (flash || openfl)
		sprite.addChild(child.sprite);
		#elseif js
		scrollElement.appendChild(child.element);
		#end
		
		untyped
		{
			changed.add(child.parentChange);
			child.parent = child.changeValue("parent", this);
			child.index = child.changeValue("index", index);
		}
	}
	
	function removeVirtualChildAt(child:Display, index:Int)
	{
		#if (flash || openfl)
		sprite.removeChild(child.sprite);
		#elseif js
		scrollElement.removeChild(child.element);
		#end
		
		untyped
		{
			changed.remove(child.parentChange);
			child.parent = child.changeValue("parent", null);
			child.index = child.changeValue("index", -1);
		}
	}
	
	#if touch
	override public function getDisplayUnder(x:Int, y:Int):Display
	{
		if (x < 0 || x > width) return null;
		if (y < 0 || y > height) return null;
		
		if (!visible || !enabled) return null;
		if (numChildren == 0) return this;
		
		var localX = x + scrollX;
		var localY = y + scrollY;
		
		for (key in visibleChildren.keys())
		{
			var display = visibleChildren.get(key);
			var descendant = display.getDisplayUnder(localX - display.x, localY - display.y);
			if (descendant != null) return descendant;
		}
		
		return this;
	}
	#end

	override public function iterator()
	{
		return visibleChildren.iterator();
	}
}
