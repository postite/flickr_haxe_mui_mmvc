package mui.display;

import mui.display.Text;
import mui.display.Display;
import mui.display.Rectangle;
import mui.display.Color;

/**
	A display used to render an font text.
**/
class Icon extends Rectangle
{
	var text:Text;

	public var color(get_color, set_color):Int;
	function get_color() { return text.color; }
	function set_color(value:Int) { return text.color = value; }

	public var type(get_type, set_type):String;
	function get_type() { return text.value; }
	function set_type(value:String) { return text.value = value; }

	public var size(get_size, set_size):Int;
	function get_size() { return text.size; }
	function set_size(value:Int)
	{
		text.y = -Math.round(value * 0.07);
		return text.size = text.width = text.height = width = height = value;
	}

	public var font(get_font, set_font):String;
	function get_font() { return text.font; }
	function set_font(value:String) { return text.font = value; }

	public function new(?type:String="", ?size:Int=32, ?color:Int=0x000000)
	{
		super();

		text = new Text();
		addChild(text);

		text.align = "center";
		text.multiline = true;
		text.autoSize = false;
		
		this.color = color;
		this.type = type;
		this.size = size;
		this.font = "FontAwesome";
	}
}
