package mui.display;

import msignal.Signal;
import mui.core.Node;
import mui.layout.Layout;
import mui.event.Key;
import mui.event.Touch;
import mui.util.Assert;

#if js
import js.html.Element;
#end

/**
	The base of the display class hierarchy.

	Defines core display properties and methods, such as position, appearance, 
	the display list and input event handling.
**/
class Display extends Node
{
	@:input("checkbox", {group:"state"})
	@:set var enabled:Bool;

	@:input("checkbox", {group:"state"})
	@:set var visible:Bool;

	@:input("checkbox", {group:"layout"})
	@:set var clip:Bool;

	@:input("checkbox", {group:"state"})
	@:set var useHandCursor:Bool;

	@:input("range", {group:"state", minimum:0, maximum:1})
	@:set var alpha:Float;

	@:input("range", {group:"position", minimum:0, maximum:1000})
	@:set var x:Int = 0;

	@:input("range", {group:"position", minimum:0, maximum:1000})
	@:set var y:Int = 0;

	@:input("range", {group:"position", minimum:0, maximum:1000})
	@:set @:get var width:Int;

	@:input("range", {group:"position", minimum:0, maximum:1000})
	@:set @:get var height:Int;

	@:input("range", {group:"transform", minimum:0, maximum:10})
	@:set var scaleX:Float;

	@:input("range", {group:"transform", minimum:0, maximum:10})
	@:set var scaleY:Float;

	@:isVar @:input("range", {minimum:-500, maximum:500})
	public var scrollX(get_scrollX, set_scrollX):Int;
	function set_scrollX(value:Int) { return scrollX = changeValue("scrollX", value); }

	@:isVar @:input("range", {minimum:-500, maximum:500}) 
	public var scrollY(get_scrollY, set_scrollY):Int;
	function set_scrollY(value:Int) { return scrollY = changeValue("scrollY", value); }

	@:input("checkbox", {group:"layout"})
	@:set var resizeX:Bool;

	@:input("checkbox", {group:"layout"})
	@:set var resizeY:Bool;
	
	@:input("range", {group:"alignment",minimum:0, maximum:1})
	@:set var centerX:Null<Float>;

	@:input("range", {group:"alignment",minimum:0, maximum:1})
	@:set var centerY:Null<Float>;

	@:input("range", {group:"constraint", minimum:-500, maximum:500})
	@:set('left','right','top','bottom') var all:Null<Int>;

	@:input("range", {group:"constraint", minimum:-500, maximum:500})
	@:set var left:Null<Int>;

	@:input("range", {group:"constraint", minimum:-500, maximum:500})
	@:set var right:Null<Int>;

	@:input("range", {group:"constraint", minimum:-500, maximum:500})
	@:set var top:Null<Int>;

	@:input("range", {group:"constraint", minimum:-500, maximum:500})
	@:set var bottom:Null<Int>;

	#if js
	/**
		In the JS target this value offsets the position of the Displays children by a pixel value.

		This is required because adding a border (stroke) to an HTML element changes the origin of 
		it's children. In Rectangle we update this value based on strokeThickness and then add 
		to the displays x/y when updating position.
	**/
	@:set var childOffset:Int;
	#end

	var debugClassName:String;

	public function new()
	{
		super();

		#if key
		keyPressed = new Signal1<Key>(Key);
		keyReleased = new Signal1<Key>(Key);
		#end

		#if touch
		touchStarted = new Signal1<Touch>(Touch);
		touchEnded = new Signal1<Touch>(Touch);

		mouseX = 0;
		mouseY = 0;
		#end

		// children
		
		numChildren = 0;
		children = [];
		
		// display
		
		enabled = true;
		parent = null;
		index = -1;
		
		visible = true;
		alpha = 1;
		useHandCursor = false;
		
		// position
		
		x = 0;
		y = 0;
		
		scaleX = 1;
		scaleY = 1;
		
		// size
		
		width = 0;
		height = 0;
		
		contentWidth = 0;
		contentHeight = 0;
		
		clip = false;
		
		scrollX = 0;
		scrollY = 0;
		
		// constrain
		
		left = null;
		right = null;
		top = null;
		bottom = null;
		
		centerX = null;
		centerY = null;
		
		resizeX = false;
		resizeY = false;

		#if js
		childOffset = 0;
		#end

		_new();
	}
	
	function getDebugString():String
	{
		if (debugClassName == null)
		{
			var type:Dynamic = Type.getClass(this);
			var name = Type.getClassName(type);
			name = name.split(".").pop();
			debugClassName = name.split("_")[0];
		}
		return debugClassName;
	}
	
	public function iterator():Iterator<Display>
	{
		return children.iterator();
	}
	
	#if key ////////////////////////////////////////////////////////////////////

	public var keyPressed(default, null):Signal1<Key>;
	public var keyReleased(default, null):Signal1<Key>;

	public function keyPress(key:Key):Void
	{
		if (!enabled) return;
		keyPressed.dispatch(key);
		
		if (parent == null) return;
		if (key.isCaptured) return;
		
		parent.keyPress(key);
	}
	
	public function keyRelease(key:Key)
	{
		if (!enabled) return;
		keyReleased.dispatch(key);
		
		if (parent == null) return;
		if (key.isCaptured) return;
		
		parent.keyRelease(key);
	}

	#end ///////////////////////////////////////////////////////////////////////

	#if touch //////////////////////////////////////////////////////////////////
	
	public var touchStarted(default, null):Signal1<Touch>;
	public var touchEnded(default, null):Signal1<Touch>;

	public function touchStart(touch:Touch)
	{
		if (!enabled) return;
		touchStarted.dispatch(touch);

		if (parent == null) return;
		if (touch.isCaptured) return;
		parent.touchStart(touch);
	}
	
	public function touchEnd(touch:Touch)
	{
		if (!enabled) return;
		touchEnded.dispatch(touch);
		
		if (parent == null) return;
		if (touch.isCaptured) return;
		parent.touchEnd(touch);
	}

	public function getDisplayUnder(x:Int, y:Int):Display
	{
		if (x < 0 || x > width) return null;
		if (y < 0 || y > height) return null;
		
		if (!visible || !enabled) return null;
		if (children.length == 0) return cast(this, Display);
		
		var localX = x + scrollX;
		var localY = y + scrollY;
		var i = children.length;
		
		while (i > 0)
		{
			i -= 1;
			var display = children[i];
			
			var descendant = display.getDisplayUnder(localX - display.x, localY - display.y);
			if (descendant != null) return descendant;
		}
		
		return cast(this, Display);
	}

	/**
		Recursively checks if a display is a descendant of the current class.
	**/
	public function containsDisplay(d:Display)
	{
		var p = d;
		
		while (p != null)
		{
			if(p == this) return true;
			p = p.parent;
		}

		return false;
	}

	public var mouseX(get_mouseX, null):Int;
	public var mouseY(get_mouseY, null):Int;

	function get_mouseX():Int
	{
		#if js
		if (parent == null) return mouseX;
		return parent.mouseX + parent.scrollX - x;
		#end

		#if (flash || openfl)
		return Math.round(sprite.mouseX);
		#end
	}

	function get_mouseY():Int
	{
		#if js
		if (parent == null) return mouseY;
		return parent.mouseY + parent.scrollY - y;
		#end

		#if (flash || openfl)
		return Math.round(sprite.mouseY);
		#end
	}

	#end ///////////////////////////////////////////////////////////////////////

	var children:Array<Display>;
	
	public var parent(default, null):Display;
	public var index(default, null):Int;
	
	public var rootX(get_rootX, null):Int;
	function get_rootX():Int
	{
		if (parent == null) return 0;
		return (parent.rootX - parent.scrollX) + x;
	}
	
	public var rootY(get_rootY, null):Int;
	function get_rootY():Int
	{
		if (parent == null) return 0;
		return (parent.rootY - parent.scrollY) + y;
	}
	
	public var contentWidth(default, set_contentWidth):Int;
	function set_contentWidth(value:Int):Int
	{
		if (resizeX) width = value;
		return contentWidth = changeValue("contentWidth", value);
	}
	
	public var contentHeight(default, set_contentHeight):Int;
	function set_contentHeight(value:Int):Int
	{
		if (resizeY) height = value;
		return contentHeight = changeValue("contentHeight", value);
	}
	
	public var maxScrollX(get_maxScrollX, null):Int;
	function get_maxScrollX():Int { return Math.round(Math.max(0, contentWidth - width)); }
	
	public var maxScrollY(get_maxScrollY, null):Int;
	function get_maxScrollY():Int { return Math.round(Math.max(0, contentHeight - height)); }
	
	@:input('complex')
	public var layout(default, set_layout):Layout;
	function set_layout(value:Layout):Layout
	{
		if (layout != null) layout.target = null;
		layout = changeValue("layout", value);
		if (layout != null) layout.target = cast(this, Display);
		return value;
	}
	
	public var numChildren(default, null):Int;
	
	public function addChild(child:Display):Void
	{
		addChildAt(child, numChildren);
	}
	
	function isDescendantOf(display:Display):Bool
	{
		var p = parent;
		while (p != null)
		{
			if (p == display) return true;
			p = p.parent;
		}
		return false;
	}

	public function addChildAt(child:Display, index:Int):Void
	{
		Assert.that(child != null, "argument `child` cannot be `null`");
		Assert.that(child != this, "argument `child` cannot be be equal to `this`");
		Assert.that(!this.isDescendantOf(child), "argument `child` cannot be a parent hierarchy of `this`");
		Assert.that(index >= 0 && index <= numChildren, "argument `index` is out of bounds");
		
		if (child.parent != null)
		{
			child.parent.removeChild(child);
		}
		
		children.insert(index, child);
		numChildren += 1;
		
		_addChildAt(child, index);
		
		child.parent_addToParentAt(this, index);
		
		for (i in ++index...numChildren)
		{
			var next = children[i];
			next.parent_changeIndex(i);
		}
		
		invalidateProperty("children");
		child.addedToStage();
	}
	
	public function removeChild(child:Display):Void
	{
		var childIndex = getChildIndex(child);
		removeChildAt(childIndex);
	}
	
	public function removeChildAt(index:Int):Void
	{
		var child = getChildAt(index);
		child.removedFromStage();
		
		children.remove(child);
		numChildren -= 1;
		
		child.parent_removeFromParent();
		
		_removeChildAt(child, index);
		
		for (i in index...numChildren)
		{
			var next = children[i];
			next.parent_changeIndex(i);
		}
		
		invalidateProperty("children");
	}
	
	public function releaseChildAt(index:Int):Bool
	{
		return true;
	}

	/**
		Returns the index of the provided child in children of `this`

		@param child The display to locate
		@returns The index of `child` in the children of `this`
		@throws `AssertError` if `child` is not a child of `this`
	**/
	public function getChildIndex(child:Display):Int
	{
		Assert.that(child != null, "argument `child` cannot be `null`");
		Assert.that(child.parent == this, "argument `child` must be a child of `this`");

		for (i in 0...numChildren) if (children[i] == child) return i;

		Assert.that(false, "argument `child` is child of `this`, but is not in children!");
		return -1;
	}
	
	public function getChildAt(index:Int):Display
	{
		Assert.that(index >= 0 && index < numChildren, "argument `index` is out of bounds (0 <= " + index + " < " + numChildren + ")");
		return children[index];
	}
	
	public function parent_addToParentAt(parent:Display, index:Int)
	{
		// update parent reference
		this.parent = changeValue("parent", parent);
		
		// update index
		this.index = changeValue("index", index);
		
		// listen to parent changes
		parent.changed.add(parentChange);
	}
	
	public function parent_removeFromParent()
	{
		// remove parent change listener
		parent.changed.remove(parentChange);
		
		// nullify parent reference
		parent = changeValue("parent", null);
		
		// reset index to -1
		index = changeValue("index", -1);
	}
	
	public function parent_changeIndex(index:Int)
	{
		// update index
		this.index = changeValue("index", index);
	}
	
	/**
		When a display is added to the stage, it invokes `addedToStage` on each 
		of its children.
	**/
	public function addedToStage():Void
	{
		for (child in children) child.addedToStage();
	}

	/**
		When a display is removed from the stage, it invokes `removedFromStage` 
		on each of its children.
	**/
	public function removedFromStage():Void
	{
		for (child in children) child.removedFromStage();
	}

	/**
		When a display is destoryed it invokes `destroy` on each of 
		its children.
	**/
	public function destroy()
	{
		for (child in children) child.destroy();
	}

	#if uiml
	override public function setState(state:String):Void
	{
		super.setState(state);
		
		for (i in 0...numChildren)
		{
			children[i].setState(state);
		}
	}
	#end
	
	override function change(flag:Dynamic)
	{
		super.change(flag);

		if (parent != null && (flag.parent || flag.width || flag.height || flag.left || flag.right || flag.top || flag.bottom || flag.centerX || flag.centerY))
		{
			constrain(parent);
		}

		if (parent != null && (flag.width || flag.height))
		{
			untyped parent.childResized(cast this);
		}

		_change(flag);
	}

	function childResized(child:Display)
	{
		if (layout != null && layout.enabled && child.parent == layout.target)
		{
			layout.resizeDisplay(child.index);
		}
	}

	function parentChange(flag:Dynamic)
	{
		#if js
		if (flag.childOffset)
		{
			invalidateProperty("x");
			invalidateProperty("y");
		}
		#end

		if (flag.width || flag.height)
		{
			invalidateProperty("parent");
		}
	}
	
	function constrain(target:Display)
	{
		if (target == null) return;
		
		if (centerX == null)
		{
			if (left == null)
			{
				if (right != null)
				{
					x = target.width - (width + right);
				}
			}
			else
			{
				x = left;
				
				if (right != null)
				{
					width = target.width - (left + right);
				}
			}
		}
		else
		{
			x = Math.round((target.width - width) * centerX);
		}
		
		if (centerY == null)
		{
			if (top == null)
			{
				if (bottom != null)
				{
					y = target.height - (height + bottom);
				}
			}
			else
			{
				y = top;
				
				if (bottom != null)
				{
					height = target.height - (top + bottom);
				}
			}
		}
		else
		{
			y = Math.round((target.height - height) * centerY);
		}
	}

////////////////////////////////////////////////////////////////////////////////
#if js
////////////////////////////////////////////////////////////////////////////////
	
	public var element:Element;
	var scrollElement:Element;

	function _new()
	{
		element = scrollElement = createDisplay();
		element.className = "view";

		#if debug element.setAttribute("rel", getDebugString()); #end
	}

	function createDisplay()
	{
		return js.Browser.document.createElement("div");
	}

	function _addChildAt(child:Display, index:Int)
	{
		if (scrollElement.childNodes[index] != null)
		{
			scrollElement.insertBefore(child.element, scrollElement.childNodes[index]);
		}
		else
		{
			scrollElement.appendChild(child.element);
		}
	}

	function _removeChildAt(child:Display, index:Int)
	{
		scrollElement.removeChild(child.element);
	}

	function _change(flag:Dynamic):Void
	{
		if (flag.visible)
		{
			element.style.visibility = (visible ? "" : "hidden");
		}

		if (flag.alpha)
		{
			setStyle("opacity", Std.string(alpha));
		}

		if (flag.x)
		{
			var offset = (parent == null ? 0 : parent.childOffset);
			element.style.left = Std.string(x + offset) + "px";
		}

		if (flag.y)
		{
			var offset = (parent == null ? 0 : parent.childOffset);
			element.style.top = Std.string(y + offset) + "px";
		}

		if (flag.scaleX || flag.scaleY)
		{
			setStyle(JS.getPrefixedStyleName("transformOrigin"), "top left");
			setStyle(JS.getPrefixedStyleName("transform"), "scale(" + scaleX + "," + scaleY + ")");
		}

		if (flag.clip)
		{
			if (clip)
			{
				element.style.overflow = "hidden";
				scrollElement = js.Browser.document.createElement("div");

				while (element.hasChildNodes())
				{
					scrollElement.appendChild(element.removeChild(element.firstChild));
				}

				element.appendChild(scrollElement);
			}
			else
			{
				element.style.overflow = null;
				element.removeChild(scrollElement);

				while (scrollElement.hasChildNodes())
				{
					element.appendChild(scrollElement.removeChild(scrollElement.firstChild));
				}

				scrollElement = element;
			}
		}

		if (flag.width)
		{
			element.style.width = width + "px";
		}

		if (flag.height)
		{
			element.style.height = height + "px";
		}

		if (flag.scrollX || flag.scrollY)
		{
			untyped scrollElement.style[JS.getPrefixedStyleName("transform")] = 
				"translate(" + (-scrollX) + "px," + (-scrollY) + "px)";
		}

		#if touch
		if (flag.useHandCursor)
		{
			element.style.cursor = useHandCursor ? "pointer" : null;
		}
		#end
	}
	
	function get_scrollX()
	{
		return element.scrollLeft + scrollX;
	}
	
	function get_scrollY()
	{
		return element.scrollTop + scrollY;
	}
	
	// helper

	public function setStyle(property:String, value:String):Void
	{
		untyped element.style[property] = value;
	}

	public function bringToFront():Void
	{
		if (parent == null) return;
		element.parentNode.appendChild(element);
	}

////////////////////////////////////////////////////////////////////////////////
#elseif (flash || openfl)
////////////////////////////////////////////////////////////////////////////////

	public var sprite:flash.display.Sprite;
	
	function _new()
	{
		sprite = createDisplay();
		#if !openfl sprite.blendMode = flash.display.BlendMode.LAYER; #end
		#if debug sprite.name = getDebugString(); #end
	}
	
	function createDisplay()
	{
		return new flash.display.Sprite();
	}

	function _addChildAt(child:Display, index:Int)
	{
		sprite.addChildAt(child.sprite, index);
	}
	
	function _removeChildAt(child:Display, index:Int)
	{
		sprite.removeChildAt(index);
	}
	
	function _change(flag:Dynamic):Void
	{
		if (flag.visible)
		{
			sprite.visible = visible;
		}
		
		if (flag.alpha)
		{
			sprite.alpha = alpha;
		}
		
		if (flag.x)
		{
			sprite.x = Math.round(x);
		}
		
		if (flag.y)
		{
			sprite.y = Math.round(y);
		}
		
		if (flag.scaleX)
		{
			sprite.scaleX = scaleX;
		}
		
		if (flag.scaleY)
		{
			sprite.scaleY = scaleY;
		}
		
		if (flag.clip)
		{
			if (!clip) sprite.scrollRect = null;
		}
		
		if (clip)
		{
			if (flag.width || flag.height || flag.scrollX || flag.scrollY)
			{
				sprite.scrollRect = new flash.geom.Rectangle(scrollX, scrollY, width, height);
			}
		}
		else
		{
			if (flag.scrollX || flag.scrollY)
			{
				sprite.x = -Math.round(scrollX);
				sprite.y = -Math.round(scrollY);
			}
		}
		
		#if touch
		if (flag.useHandCursor)
		{
			#if !openfl sprite.buttonMode = useHandCursor; #end
			sprite.mouseChildren = !useHandCursor;
		}
		#end
	}
	
	function get_scrollX() 
	{ 
		return scrollX; 
	}
	
	function get_scrollY() 
	{ 
		return scrollY; 
	}

	public function bringToFront()
	{
		if (parent == null) return;
		sprite.parent.addChild(sprite);
	}
#end
}
