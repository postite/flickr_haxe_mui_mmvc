package mui.layout;

class GridLayout extends Layout
{
	public var wrapIndex:Int;

	public function new()
	{
		super();
		wrapIndex = 1;
		cellWidth = 0;
		cellHeight = 0;
	}

	override function layoutNext(cell:Cell, previous:Cell)
	{
		cell.x = paddingLeft + (cellWidth + spacingX) * getColumn(cell.index);
		cell.y = paddingTop + (cellHeight + spacingY) * getRow(cell.index);
	}

	function getColumn(index:Int)
	{
		return vertical ?
			Math.floor(index / wrapIndex)
			: index - getRow(index) * wrapIndex;
	}

	function getRow(index:Int)
	{
		return vertical ?
			index - getColumn(index) * wrapIndex
			: Math.floor(index / wrapIndex);
	}

	function getColumns()
	{
		return !vertical ? wrapIndex
			: Math.ceil(target.numChildren / wrapIndex);
	}

	function getRows()
	{
		return vertical ? wrapIndex
			: Math.ceil(target.numChildren / wrapIndex);
	}

	override public function next(index:Int, direction:Direction):Int
	{
		var column = getColumn(index);
		var row = getRow(index);

		return switch (direction)
		{
			case Direction.up: indexAt(column, row - 1);
			case Direction.down: indexAt(column, row + 1);
			case Direction.left: indexAt(column - 1, row);
			case Direction.right: indexAt(column + 1, row);
			case Direction.previous: previousIndex(index);
			case Direction.next: nextIndex(index);
		}
	}

	function indexAt(column:Int, row:Int):Int
	{
		var rows = getRows();
		var columns = getColumns();

		if (row < 0 || row > rows - 1
			|| column < 0 || column > columns - 1) return -1;

		var index = vertical ? row + (column * rows) : column + (row * columns);
		if (index > target.numChildren - 1) return target.numChildren - 1;
		return index;
	}

	override function isVisible(cell:Cell):Bool
	{
		if (vertical)
		{
			return cell.right() > target.scrollX && cell.x < target.scrollX + target.width;
		}
		else
		{
			return cell.bottom() > target.scrollY && cell.y < target.scrollY + target.height;
		}
	}

	override function isFirst(cell:Cell)
	{
		if (vertical)
		{
			return getRow(cell.index) == 0 && cell.x - spacingX <= target.scrollX;
		}
		else
		{
			return getColumn(cell.index) == 0 && cell.y - spacingY <= target.scrollY;
		}
	}

	override function isLast(cell:Cell)
	{
		if (vertical)
		{
			var rows = getRows();
			return getRow(cell.index) == rows - 1 && cell.right() + spacingX >= target.scrollX + target.width;
		}
		else
		{
			var columns = getColumns();
			return getColumn(cell.index) == columns - 1 && cell.bottom() + spacingY >= target.scrollY + target.height;
		}
	}

	override function measureLayout()
	{
		var columns = getColumns();
		target.contentWidth = paddingLeft + paddingRight + 
			columns * cellWidth + (columns - 1) * spacingX;

		var rows = getRows();
		target.contentHeight = paddingTop + paddingBottom + 
			rows * cellHeight + (rows - 1) * spacingY;
	}

	override function measureVirtual()
	{
		measureLayout();
	}
}
