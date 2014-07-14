package mui.layout;

class Cell
{
	public var index:Int;
	
	public var x:Int;
	public var y:Int;

	public var width:Int;
	public var height:Int;

	public function new(index:Int)
	{
		this.index = index;
		x = y = width = height = 0;
	}

	inline public function right():Int
	{
		return x + width;
	}

	inline public function bottom():Int
	{
		return y + height;
	}

	public function clone():Cell
	{
		var cell = new Cell(index);
		cell.x = x;
		cell.y = y;
		cell.width = width;
		cell.height = height;
		return cell;
	}
}