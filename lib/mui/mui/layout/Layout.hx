package mui.layout;

import mui.display.Display;
import mui.display.VirtualDisplay;

class Layout extends AbstractLayout
{
	@:set var vertical:Bool;

	@:input('range',{group:'layout', minimum:0, maximum:100})
	@:set('paddingLeft','paddingRight','paddingTop','paddingBottom') var padding:Int;

	@:input('range',{group:'layout', minimum:0, maximum:100})
	@:set var paddingLeft:Int;

	@:input('range',{group:'layout', minimum:0, maximum:100})
	@:set var paddingRight:Int;

	@:input('range',{group:'layout', minimum:0, maximum:100})
	@:set var paddingTop:Int;

	@:input('range',{group:'layout', minimum:0, maximum:100})
	@:set var paddingBottom:Int;

	@:input('range',{group:'layout', minimum:0, maximum:100})
	@:set('spacingX','spacingY') var spacing:Int;

	@:input('range',{group:'layout', minimum:0, maximum:100})
	@:set var spacingX:Int;

	@:input('range',{group:'layout', minimum:0, maximum:100})
	@:set var spacingY:Int;
	
	@:input('range',{group:'layout', minimum:0, maximum:200})
	@:set var cellWidth:Null<Int>;

	@:input('range',{group:'layout', minimum:0, maximum:200})
	@:set var cellHeight:Null<Int>;

	@:input('range',{group:'layout', minimum:0, maximum:1})
	@:set var cellAlignX:Float;

	@:input('range',{group:'layout', minimum:0, maximum:1})
	@:set var cellAlignY:Float;

	public function new()
	{
		super();
		cellWidth = cellHeight = null;
		vertical = true;
		paddingLeft = paddingRight = paddingTop = paddingBottom = spacingX = spacingY = 0;
		cellAlignX = cellAlignY = 0;
	}

	override function layoutFirst(cell:Cell)
	{
		cell.x = paddingLeft;
		cell.y = paddingTop;
	}

	override function layoutNext(cell:Cell, previous:Cell)
	{
		if (vertical)
		{
			cell.y = previous.bottom() + spacingY;
			cell.x = previous.x;
		}
		else
		{
			cell.x = previous.right() + spacingX;
			cell.y = previous.y;
		}
	}

	override function isVisible(cell:Cell):Bool
	{
		if (vertical)
		{
			return cell.bottom() > target.scrollY && cell.y < target.scrollY + target.height;
		}
		else
		{
			return cell.right() > target.scrollX && cell.x < target.scrollX + target.width;
		}
	}

	override function isFirst(cell:Cell):Bool
	{
		if (vertical)
		{
			return cell.y - spacingY <= target.scrollY;
		}
		else
		{
			return cell.x - spacingX <= target.scrollX;
		}
	}

	override function isLast(cell:Cell):Bool
	{
		if (vertical)
		{
			return cell.bottom() + spacingY >= target.scrollY + target.height;
		}
		else
		{
			return cell.right() + spacingX >= target.scrollX + target.width;
		}
	}

	override function updateCell(cell:Cell)
	{
		var index = cell.index;
		cell.width = cellWidth == null ? Std.int(requestDisplay(index).width) : cellWidth;
		cell.height = cellHeight == null ? Std.int(requestDisplay(index).height) : cellHeight;
	}

	override function updateDisplay(display:Display, cell:Cell)
	{
		display.x = cell.x + Math.round((cell.width - display.width) * cellAlignX);
		display.y = cell.y + Math.round((cell.height - display.height) * cellAlignY);
	}

	override public function resizeDisplay(index:Int)
	{
		if (cellWidth != null && cellHeight != null)
		{
			if (cellAlignX != 0 || cellAlignY != 0)
			{
				updateDisplay(requestDisplay(index), requestCell(index));
			}
			
			return;
		}

		var update = (cells[index] != null);
		var cell = requestCell(index);
		// only update if cell is not new
		if (update) updateCell(cell);
		if (index < validIndex) validIndex = index;
		if (index == target.numChildren - 1) measureLayout();
		
		invalidateProperty("target");
	}

	override public function next(index:Int, direction:Direction):Int
	{
		var previous = previousIndex(index);
		var next = nextIndex(index);

		return switch (direction)
		{
			case Direction.left: vertical ? -1 : previous;
			case Direction.right: vertical ? -1 : next;
			case Direction.up: vertical ? previous : -1;
			case Direction.down: vertical ? next : -1;
			case Direction.previous: previous;
			case Direction.next: next;
		}
	}

	override function measureLayout()
	{
		var cell = getCell(target.numChildren - 1);
		target.contentWidth = cell.right() + paddingRight;
		target.contentHeight = cell.bottom() + paddingBottom;
	}

	override function measureVirtual()
	{
		if (vertical)
		{
			var w = (cellWidth != null && target.numChildren > 0) ? cellWidth : 0;
			target.contentWidth = paddingLeft + w + paddingRight;

			var h = 0;
			if (target.numChildren > 0)
			{
				h = (cellHeight == null) ? 100000 : (target.numChildren * (cellHeight + spacingY)) - spacingY;
			}
			target.contentHeight = paddingTop + h + paddingBottom;
		}
		else
		{
			var w = 0;
			if (target.numChildren > 0)
			{
				w = (cellWidth == null) ? 100000 : (target.numChildren * (cellWidth + spacingX)) - spacingX;
			}
			target.contentWidth = paddingLeft + w + paddingRight;


			var h = (cellHeight != null && target.numChildren > 0) ? cellHeight : 0;
			target.contentHeight = paddingTop + h + paddingBottom;
		}
	}
}
