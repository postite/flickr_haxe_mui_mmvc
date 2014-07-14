package mui.layout;

import mui.display.Display;

class CircularLayout extends Layout
{
	public function new()
	{
		super();
		circular = true;
	}

	override function updateDisplay(display:Display, cell:Cell)
	{
		super.updateDisplay(display, wrapCell(cell));
	}

	function wrapCell(cell:Cell):Cell
	{
		if (target.numChildren == 1) return cell;
		var wrapped = cell.clone();
		
		if (vertical)
		{
			var total = getCell(target.numChildren - 1).bottom() + spacingY - paddingTop;
			var scroll = target.scrollY;

			wrapped.y = Math.floor(scroll / total) * total + wrapped.y;
			if (wrapped.y + wrapped.height < scroll) wrapped.y += total;
			else if (wrapped.y > scroll + target.height) wrapped.y -= total;
		}
		else
		{
			var total = getCell(target.numChildren - 1).right() + spacingX - paddingLeft;
			var scroll = target.scrollX;

			wrapped.x = Math.floor(scroll / total) * total + wrapped.x;
			if (wrapped.x + wrapped.width < scroll) wrapped.x += total;
			else if (wrapped.x > scroll + target.width) wrapped.x -= total;
		}

		return wrapped;
	}
	
	override function measureLayout()
	{
		if (vertical)
		{
			target.contentWidth = 0;
			target.contentHeight = 10000;
		}
		else
		{
			target.contentWidth = 10000;
			target.contentHeight = 0;
		}
	}

	override function measureVirtual()
	{
		measureLayout();
	}

	override function isVisible(cell:Cell):Bool
	{
		return super.isVisible(wrapCell(cell));
	}

	override function isFirst(cell:Cell):Bool
	{
		return super.isFirst(wrapCell(cell));
	}

	override function isLast(cell:Cell):Bool
	{
		return super.isLast(wrapCell(cell));
	}
}