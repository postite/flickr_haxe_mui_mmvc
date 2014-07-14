package mui.input;

import haxe.ds.StringMap;

import mui.behavior.ButtonBehavior;
import mui.input.Input;
import mui.core.Skin;
import mui.core.Component;

#if js
import js.html.InputElement;
#end

class ButtonInput extends DataInput<Bool>
{
	@:set var label:String;
	@:set var groupName:String;
	@:set var groupValue:Dynamic;
	@:set var labelPosition:FormLabelPosition;
	
	#if js
	var inputElement:InputElement;
	@:set var inputElementFocused:Bool;
	#end
	
	public function new(?skin:Skin<ButtonInput>)
	{
		super(skin);
		
		#if js
		inputElement = js.Browser.document.createInputElement();
		element.appendChild(inputElement);
		inputElement.addEventListener('focus', focusInHandler);
		inputElement.addEventListener('blur', focusOutHandler);
		#end
		
		focused = false;
		data = false;
		invalidateProperty('data');

		label = "";
		labelPosition = FormLabelPosition.Right;
		groupName = null;
		groupValue = null;

		new ButtonBehavior(this);
	}
	
	override function action()
	{
		data = !data;
	}
	
	override public function clearFormData()
	{
		super.clearFormData();

		if (groupName != null)
		{
			var group = getGroup();
			group[0].data = true;
		}
		else
		{
			data = false;
		}
	}

	/**
		Returns an `Array` of `ButtonInput` instances with the same `groupName` as `this`.

		If `groupName` is `null`, this method returns an `Array` containing `this`. Otherwise the 
		form containing the input is found (by climbing the display list) and all `ButtonInput` 
		instances contained by it with a matching `groupName` are returned in an `Array`.
	**/
	public function getGroup()
	{
		if (groupName == null) return [ this ];

		var formContainer = this.container;
		while (!Std.is(formContainer, Form))
		{
			if (formContainer == null) return [ this ];
			formContainer = formContainer.container;
		}

		var group = [];
		var form:Form = cast formContainer;
		var groupName = this.groupName;

		for (input in form.inputs())
		{
			if (!Std.is(input, ButtonInput)) continue;
			var button:ButtonInput = cast input;
			if (button.groupName == groupName) group.push(button);
		}

		return group;
	}
	
	#if js
	override public function focus()
	{
		super.focus();
		if (!inputElementFocused) inputElement.focus();
	}
	
	function focusInHandler(_)
	{
		inputElementFocused = true;
		if (!focused) focus();
	}

	function focusOutHandler(_)
	{
		inputElementFocused = false;
	}
	
	override function change(flag:Dynamic)
	{
		super.change(flag);
		
		if (flag.enabled) inputElement.disabled = !enabled;
		
		if (flag.inputElementFocused && enabled && inputElementFocused)
		{
			focus();
		}
		
		if (flag.data) inputElement.checked = data;
		if (flag.label) inputElement.value = label;
		if (flag.groupName) inputElement.name = groupName;
	}
	
	override public function destroy()
	{
		inputElement.removeEventListener('focus', focusInHandler);
		inputElement.removeEventListener('blur', focusOutHandler);
		super.destroy();
	}
	#end
}
