package mui.input;

import mui.behavior.InputTextHintBehavior;
import mui.display.Rectangle;
import mui.display.Text;
import mui.display.Color;
import mui.display.InputText;

class TextArea extends Input.DataInput<String>
{
	var background:Rectangle;
	var inputText:InputText;

	@:set var placeholder:String;

	public function new()
	{
		super();

		placeholder = null;

		width = 280;
		height = 160;
		radius = 5;
		
		background = new Rectangle();
		addChild(background);

		background.all = 1;
		background.bottom = 2;
		background.radius = radius - 1;
		background.fill = new Color(0xFFFFFF);

		inputText = new InputText();
		addChild(inputText);

		inputText.changed.add(inputTextChanged);
		inputText.left = inputText.right = 10;
		inputText.top = inputText.bottom = 8;
		inputText.size = 16;
		inputText.multiline = inputText.wrap = true;
		
		createHintBehavior();
	}
	
	function createHintBehavior()
	{
		new InputTextHintBehavior(inputText);
	}
	
	override function change(flag:Dynamic)
	{
		super.change(flag);

		if (flag.focused || flag.invalid)
		{
			fill = new Color(focused ? 0x00DEF0 : (invalid ? 0xF2453C : 0xCCCCCC));
		}

		if (flag.placeholder)
		{
			inputText.placeholder = placeholder;
		}
	}

	function inputTextChanged(flag:Dynamic)
	{
		if (flag.focused)
		{
			if (inputText.focused) focus();
		}

		if (flag.value)
		{
			data = inputText.value;
		}
	}

	override function updateData(data:String)
	{
		inputText.value = data;
	}
}