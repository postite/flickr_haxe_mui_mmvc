package mui.input;

import mui.core.Collection;
import mui.event.Key;
import mui.control.Button;
import mui.display.Text;
import mui.display.Color;

class SelectCollection extends Collection
{
	public function new()
	{
		super();
		
		// TODO: default layout doesn't account for margin/stroke
		resizeY = true;
		factory.component = SelectCollectionItem;
		layout.enabled = true;
		fill = new Color(0xFFFFFF);
		// TODO: remove styling from here in favour of draw states or skin
		stroke = new Color(0x333333);
		strokeThickness = 1;
		margin = 1;
	}
	
	#if key
	override public function keyPress(key:Key)
	{
		if (key.action == BACK || key.action == EXIT || key.action == RIGHT || key.action == LEFT)
		{
			key.capture();
			bubbleFrom(BUTTON_ACTIONED, getComponentAt(selectedIndex));
		}
		else
		{
			super.keyPress(key);
		}
	}
	#end
}

class SelectCollectionItem extends Button
{
	var label:Text;
	
	public function new()
	{
		super();
		
		height = 30;
		left = 0;
		right = 0;
		
		label = new Text();
		label.autoSize = false;
		label.height = 20;
		label.left = label.right = 8;
		label.y = 7;
		label.size = 16;
		addChild(label);
	}

	override function updateData(data:Dynamic)
	{
		var v = Std.string(Reflect.hasField(data, "value") ? Reflect.field(data, "value") : data);
		var l = Reflect.hasField(data, "label") ? Std.string(Reflect.field(data, "label")) : v;
		label.value = l;
	}
	
	override function change(flag:Dynamic)
	{
		super.change(flag);
		
		if (flag.focused)
		{
			fill = focused ? new Color(0xcccccc) : null;
		}
	}
}
