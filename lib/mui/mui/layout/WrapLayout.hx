package mui.layout;

/**
	A WrapLayout dynamically positions variable size items into rows and 
	columns. A vertical WrapLayout will layout items in a column until an item 
	will extend past the content area of the parent display, when the layout 
	moves to the next column. A horizontal WrapLayout behaves in the same way, 
	but with rows.
**/
class WrapLayout extends Layout
{
	/**
		A lookup of column index by display index.

		ie. columns[display.index] tells you what column the 10th item is in.
	**/
	var columns:Array<Int>;

	/**
		A lookup of row index by display index.

		ie. columns[display.index] tells you what row the 10th item is in.
	**/
	var rows:Array<Int>;

	override function reset()
	{
		super.reset();
		columns = [0];
		rows = [0];
	}

	override function layoutNext(cell:Cell, previous:Cell)
	{
		var column = columns[previous.index];
		var row = rows[previous.index];

		if (vertical)
		{
			row += 1;

			cell.x = previous.x;
			cell.y = previous.bottom() + spacingY;

			if (cell.bottom() > target.height - paddingBottom)
			{
				var maxWidth = 0;
				var index = previous.index;

				while (index > -1 && columns[index] == column)
				{
					var prev = getCell(index);
					if (prev.width > maxWidth) maxWidth = prev.width;
					index -= 1;
				}

				row = 0;
				column += 1;

				cell.y = paddingTop;
				cell.x = previous.x + maxWidth + spacingX;
			}
		}
		else
		{
			column += 1;

			cell.x = previous.right() + spacingX;
			cell.y = previous.y;

			if (cell.right() > target.width - paddingRight)
			{
				var maxHeight = 0;
				var index = previous.index;

				while (index > -1 && rows[index] == row)
				{
					var prev = getCell(index);
					if (prev.height > maxHeight) maxHeight = prev.height;
					index -= 1;
				}

				column = 0;
				row += 1;

				cell.x = paddingLeft;
				cell.y = previous.y + maxHeight + spacingY;
			}
		}

		columns[cell.index] = column;
		rows[cell.index] = row;
	}

	override function measureLayout()
	{
		var cell = getCell(target.numChildren - 1);

		if (vertical)
		{
			target.contentWidth = cell.right() + paddingRight;
			target.contentHeight = 0;
		}
		else
		{
			target.contentWidth = 0;
			target.contentHeight = cell.bottom() + paddingBottom;
		}
	}

	override function measureVirtual()
	{
		if (vertical)
		{
			target.contentWidth = 100000;
			target.contentHeight = 0;
		}
		else
		{
			target.contentWidth = 0;
			target.contentHeight = 100000;
		}
	}

	function getColumn(index:Int)
	{
		return columns[index];
	}

	function getRow(index:Int)
	{
		return rows[index];
	}

	override public function next(index:Int, direction:Direction):Int
	{
		var column = getColumn(index);
		var row = getRow(index);

		return switch (direction)
		{
			case Direction.up: 
				if (vertical) indexAt(column, row - 1);
				else getClosest(row - 1, getCell(index));
			case Direction.down: 
				if (vertical) indexAt(column, row + 1);
				else getClosest(row + 1, getCell(index));
			case Direction.left:
				if (vertical) getClosest(column - 1, getCell(index));
				else indexAt(column - 1, row);
			case Direction.right:
				if (vertical) getClosest(column + 1, getCell(index));
				else indexAt(column + 1, row);
			case Direction.previous: previousIndex(index);
			case Direction.next: nextIndex(index);
		}
	}

	function getClosest(block:Int, cell:Cell):Int
	{
		if (vertical)
		{
			var index = indexAt(block, 0);
			if (index == -1) return -1;

			var intersection = 0.0;
			var closest = getCell(index);

			while (index < target.numChildren)
			{   
				if (columns[index] != block) break;

				var possible = getCell(index);
				var top = Math.max(cell.y, possible.y);
				var bottom = Math.min(cell.bottom(), possible.bottom());
				var range = bottom - top;

				if (range > intersection)
				{
					intersection = range;
					closest = possible;
				}
				index ++;
			}

			return closest.index;
		}
		else
		{
			var index = indexAt(0, block);
			if (index == -1) return -1;

			var intersection = 0.0;
			var closest = getCell(index);

			while (index < target.numChildren)
			{   
				if (rows[index] != block) break;

				var possible = getCell(index);
				var left = Math.max(cell.x, possible.x);
				var right = Math.min(cell.right(), possible.right());
				var range = right - left;

				if (range > intersection)
				{
					intersection = range;
					closest = possible;
				}
				index ++;
			}

			return closest.index;
		}
	}

	function indexAt(column:Int, row:Int):Int
	{
		var closest = -1;

		if(column == -1 || row == -1) return -1;

		if (vertical)
		{
			for (i in 0...target.numChildren)
			{
				if (getColumn(i) == column)
				{
					if (getRow(i) == row)
					{
						return i;
					}

					closest = i;
				}
			}
		}
		else
		{
			for (i in 0...target.numChildren)
			{
				for (i in 0...target.numChildren)
				{
					if (getRow(i) == row)
					{
						if (getColumn(i) == column)
						{
							return i;
						}

						closest = i;
					}
				}
			}
		}

		return closest;
	}
}