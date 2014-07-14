package mui.behavior;
import mui.core.Behavior.Behavior;
import mui.display.Display;
import mui.display.InputText;
import mui.display.Text;
import mui.input.Input;

class InputTextHintBehavior extends Behavior<InputText>
{
	var hint:Text;

	public function new(target:InputText) 
	{
		super(target);
	}
	
	override function add()
	{		
		hint = new Text();
		
		hint.left = target.left;
		hint.right = target.right;
		hint.centerY = target.centerY;
		hint.color = 0xa9a9a9;
		hint.font = target.font;
		hint.size = target.size;
		
		var parent = target.parent;
		parent.removeChild(target);
		parent.addChild(hint);
		parent.addChild(target);
		
		target.changed.add(change);
	}

	override function remove()
	{
		target.parent.removeChild(hint);
	}
	
	override function update(flag:Dynamic)
	{
		if (flag.placeholder || flag.value)
		{
			hint.value = null;
			if (target.value == null || target.value == "") hint.value = target.placeholder;
		}
	}
}
