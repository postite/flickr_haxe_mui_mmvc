package mui.layout;

import mui.core.Behavior;
import mui.display.Display;
import mui.display.VirtualDisplay;

class AbstractLayout extends Behavior<Display>
{
	@:set var circular:Bool;

	var validIndex:Int;
	var cells:Array<Cell>;
	var virtual:Bool;

	public function new()
	{
		super();
		circular = false;
		reset();
	}

	override function add()
	{
		virtual = Std.is(target, VirtualDisplay);
		reset();
	}

	override function update(flag:Dynamic)
	{
		if (flag.children || flag.layout || flag.width || flag.height)
		{
			invalidateProperty("target");
			reset();
		}

		if ((circular || virtual) && flag.scrollX || flag.scrollY)
		{
			invalidateProperty("target");
		}
	}

	override function change(flag:Dynamic)
	{
		if (!enabled || target == null) return;

		if (flag.cellWidth || flag.cellHeight || flag.vertical)
		{
			reset();
		}
		else if (flag.spacingX || flag.spacingY ||
			flag.paddingLeft || flag.paddingTop || 
			flag.paddingRight || flag.paddingBottom)
		{
			validIndex = -1;
		}

		if (flag.target || flag.cellAlignX || flag.cellAlignY || validIndex == -1)
		{
			if (target.numChildren > 0)
			{
				if (virtual) layoutVirtual();
				else layout();
			}
		}
	}

	function reset()
	{
		validIndex = -1;
		cells = [];
		if (virtual) measureVirtual();
	}

	function layoutFirst(cell:Cell)
	{
		// abstract
	}

	function layoutNext(cell:Cell, previous:Cell)
	{
		// abstract
	}

	function isVisible(cell:Cell):Bool
	{
		// abstract
		return true;
	}

	function isFirst(cell:Cell):Bool
	{
		// abstract
		return false;
	}

	function isLast(cell:Cell):Bool
	{
		// abstract
		return false;
	}

	function updateDisplay(display:Display, cell:Cell)
	{
		// abstract
	}

	function updateCell(cell:Cell)
	{
		// abstract
	}

	function measureLayout()
	{
		// abstract
	}

	function measureVirtual()
	{
		// abstract
	}

	public function resizeDisplay(index:Int)
	{
		// abstract
	}

	function layout()
	{
		for (index in 0...target.numChildren)
		{
			layoutDisplay(index);
		}
	}

	function layoutVirtual()
	{
		var first = target.numChildren;
		var nextFirst = first;
		var last = -1;

		for (display in target)
		{
			var index = display.index;
			var cell = getCell(index);
			
			if (isVisible(cell))
			{
				if (index < first) first = index;
				if (index > first && index < nextFirst) nextFirst = index;
				if (index > last) last = index;
				updateDisplay(display, cell);
			}
			else
			{
				releaseDisplay(index);
			}
		}

		// detect situation where there is a gap in the visible items, generally  
		// because of a selected Component
		if (nextFirst != target.numChildren && nextFirst - first > 1) first = nextFirst;
		if (first == target.numChildren) first = last = 0;

		var firstCell = getCell(first);
		if (!isVisible(firstCell)) return;
		
		while (!isFirst(firstCell))
		{
			first = previousIndex(first);
			if (first == -1) break;
			firstCell = getCell(first);
			layoutDisplay(first);
		}

		var lastCell = getCell(last);
		while (!isLast(lastCell))
		{
			last = nextIndex(last);
			if (last == -1) break;
			lastCell = getCell(last);
			layoutDisplay(last);
		}
	}

	public function layoutDisplay(index:Int)
	{
		var cell = getCell(index);
		var display = requestDisplay(index);
		updateDisplay(display, cell);
	}

	function getCell(index:Int):Cell
	{
		var cell = requestCell(index);
		if (index <= validIndex) return cell;

		if (index == 0)
		{
			layoutFirst(cell);
		}
		else
		{
			var previous = getCell(index - 1);
			layoutNext(cell, previous);
		}

		if (index > validIndex) validIndex = index;
		if (index == target.numChildren - 1) measureLayout();
		return cell;
	}

	/**
	Request a cell at an index, creating the cell if it does not exist.
	*/
	function requestCell(index:Int):Cell
	{
		return cells[index] == null ? cells[index] = createCell(index) : cells[index];
	}

	/**
	Creates a valid cell representing a display to layout.
	*/
	function createCell(index:Int)
	{
		var cell = new Cell(index);
		updateCell(cell);
		return cell;
	}

	function requestDisplay(index:Int):Display
	{
		return target.getChildAt(index);
	}

	public function releaseDisplay(index:Int)
	{
		target.releaseChildAt(index);
	}

	public function next(index:Int, direction:Direction):Int
	{
		return -1;
	}

	function nextIndex(index:Int):Int
	{
		return index < target.numChildren - 1 ? index + 1 : circular ? 0 : -1;
	}

	function previousIndex(index:Int):Int
	{
		return index > 0 ? index - 1 : circular ? target.numChildren - 1 : -1;
	}
}
