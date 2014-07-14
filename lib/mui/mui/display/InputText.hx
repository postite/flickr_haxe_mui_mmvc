package mui.display;

class InputText extends Text
{
	@:set var focused:Bool;
	@:set var placeholder:String;
	@:set var secureInput:Bool;
	@:set var maxLength:Int;

	public function new()
	{
		super();

		focused = false;
		placeholder = null;
		secureInput = false;
		maxLength = 0;
		selectable = true;
		autoSize = false;
		width = 200;

		#if js
		element.addEventListener('focus', focusInHandler);
		element.addEventListener('blur', focusOutHandler);
		element.addEventListener('input', inputChanged);
		#elseif (flash || openfl)
		textField.addEventListener(flash.events.FocusEvent.FOCUS_IN, focusInHandler);
		textField.addEventListener(flash.events.FocusEvent.FOCUS_OUT, focusOutHandler);
		textField.addEventListener(flash.events.Event.CHANGE, inputChanged);
		textField.type = flash.text.TextFieldType.INPUT;
		#end
	}

	public function focus()
	{
		#if js
		element.focus();
		#end

		#if (flash || openfl)
		flash.Lib.current.stage.focus = textField;
		#end
	}
	
	function focusInHandler(?e:Dynamic)
	{
		focused = true;
	}
	function focusOutHandler(?e:Dynamic)
	{
		focused = false;
	}
	
	function inputChanged(?e:Dynamic)
	{
		#if js
		value = untyped element.value;
		#end

		#if (flash || openfl)
		value = textField.text;
		#end
	}

	#if js
	
	override function createDisplay()
	{
		var display:Dynamic = js.Browser.document.createElement("input");
		display.type = "text";
		return display;
	}

	#end
	
	override function change(flag:Dynamic)
	{
		#if js
		// if (flag.multiline)
		// {
		// 	if (multiline)
		// 	{
		// 		element.removeChild(span);
		// 		span = js.Browser.document.createTextAreaElement();
		// 		span.addEventListener('focus', focusInHandler);
		// 		span.addEventListener('blur', focusOutHandler);
		// 		span.addEventListener('input', inputChanged);
		// 		span.style.resize = 'none';
		// 		element.appendChild(span);

		// 		invalidateProperty('width');
		// 		invalidateProperty('size');
		// 		invalidateProperty('font');
		// 		invalidateProperty('placeholder');
		// 	}
		// }
		#end

		if (flag.enabled)
		{
			#if js
			untyped element.disabled = !enabled;
			#elseif (flash || openfl)
			textField.type = enabled ? flash.text.TextFieldType.INPUT : flash.text.TextFieldType.DYNAMIC;
			#end
		}

		#if js
		if (flag.value && (untyped element.value != value))
		{
			untyped element.value = value;
		}

		if (flag.secureInput)
		{
			untyped element.type = secureInput ? "password" : "text";
		}
		#end

		#if (flash || openfl)
		if (flag.value) textField.text = value;
		if (flag.color) textField.textColor = color;
		if (flag.secureInput) textField.displayAsPassword = secureInput;
		#end

		if (flag.maxLength)
		{
			#if js
			untyped element.maxLength = maxLength > 0 ? maxLength : null;
			#elseif (flash || openfl)
			textField.maxChars = maxLength > 0 ? maxLength : 0;
			#end
		}

		super.change(flag);
	}
	
	override function destroy()
	{
		#if js
		element.removeEventListener('focus', focusInHandler);
		element.removeEventListener('blur', focusOutHandler);
		element.removeEventListener('input', inputChanged);
		#elseif (flash || openfl)
		textField.removeEventListener(flash.events.FocusEvent.FOCUS_IN, focusInHandler);
		textField.removeEventListener(flash.events.FocusEvent.FOCUS_OUT, focusOutHandler);
		textField.removeEventListener(flash.events.Event.CHANGE, inputChanged);
		#end
		
		super.destroy();
	}
}
