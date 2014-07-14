package mui.input;

import mui.behavior.InputTextHintBehavior;
import mui.core.Skin;
import mui.display.InputText;
import mui.event.Key;

class TextInput extends Input.DataInput<String>
{
	public var inputText(default, null):InputText;

	@:set var placeholder:String;
	@:set var secureInput:Bool;
	@:set var maxLength:Int;	

	public function new(?skin:Skin<TextInput>)
	{
		inputText = new InputText();

		super(skin);
		
		maxLength = 0;
		secureInput = false;
		placeholder = null;
		
		addChild(inputText);
		inputText.changed.add(inputTextChanged);
		inputText.left = inputText.right = 10;
		inputText.centerY = 0.5;

		var behavior = new mui.behavior.ButtonBehavior(this);
		behavior.focusOnPress = false;
		behavior.focusOnRelease = true;
		
		createHintBehavior();
	}
	
	function createHintBehavior()
	{
		new InputTextHintBehavior(inputText);
	}
	
	override public function clearFormData()
	{
		super.clearFormData();
		data = "";
	}

	override public function focus()
	{
		super.focus();
		if (!inputText.focused) inputText.focus();
	}
		
	override function change(flag:Dynamic)
	{
		super.change(flag);
		
		if (flag.enabled)
		{
			inputText.enabled = enabled;
		}
		
		if (flag.placeholder)
		{
			inputText.placeholder = placeholder;
		}
		
		if (flag.secureInput)
		{
			inputText.secureInput = secureInput;
		}
		
		if (flag.maxLength)
		{
			inputText.maxLength = maxLength;
		}
	}
	

	function inputTextChanged(flag:Dynamic)
	{
		if (flag.focused && inputText.focused) focus();
		if (flag.value) data = inputText.value;
	}

	override function updateData(data:String)
	{
		inputText.value = data;
	}

	#if key
	override function keyPress(key:Key)
	{
		// prevent navigation
	}
	#end
}
