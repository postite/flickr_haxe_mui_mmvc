package mui.input;

import mui.display.Display;

#if js
import js.html.SelectElement;
import js.html.OptionElement;

/**
	NOTE: There is no programmatic way of displaying a select's drop down 
	options (which are handled by the OS). When navigating via keys you'll 
	never see the drop down. Instead you can cycle through it's values using 
	the arrow keys which simply changes the text value of the select. When 
	compiling with the 'key' flag this may cause issues with mui's global 
	arrow key logic for moving between components especially on TV target.
**/
class SelectDisplay extends Display
{
	var select:SelectElement;

	@:set var focused:Bool;
	@:set var optionsVisible:Bool;
	@:set var selectedIndex:Dynamic;

	public var selectedData(get, set):Dynamic;
	public var data(default, set):Array<Dynamic>;
	
	function get_selectedData():Dynamic
	{
		return data[selectedIndex];
	}

	function set_selectedData(value:Dynamic):Dynamic
	{
		for (i in 0...data.length)
		{
			if (data[i] == value)
			{
				selectedIndex = i;
				return value;
			}
		}
		return data[selectedIndex];
	}

	// Performing immediate DOM manipulation (rather than via change) so that options exist if/when setting initial value
	function set_data(values:Array<Dynamic>):Array<Dynamic>
	{
		if (values == null) values = [];
		data = values;
		selectedIndex = -1;
		validate();

		select.innerHTML = "";
		
		for (i in 0...values.length) 
		{
			var option = values[i];
			var optionElement:OptionElement = cast js.Browser.document.createElement("option");
			var value = Std.string(Reflect.hasField(option, "value") ? Reflect.field(option, "value") : option);
			optionElement.text = Reflect.hasField(option, "label") ? Std.string(Reflect.field(option, "label")) : value;
			if (Reflect.hasField(option, "disabled")) optionElement.setAttribute("disabled", "true");

			select.appendChild(optionElement);
		}
		select.selectedIndex = selectedIndex;
		
		return values;
	}
	
	public function new()
	{
		super();

		element.className += " view-select";
		select = cast element;
		
		select.addEventListener('focus', elementFocused);
		select.addEventListener('blur', elementBlurred);
		select.addEventListener('change', elementChanged);
		select.addEventListener('click', elementClicked);
		select.addEventListener('mousedown', elementPressed);

		selectedIndex = -1;
		optionsVisible = false;
		focused = false;
		data = [];
	}
	
	override function createDisplay()
	{
		return js.Browser.document.createElement("select");
	}
	
	function elementChanged(?_)
	{
		selectedIndex = select.selectedIndex;
	}
	
	function elementFocused(_)
	{
		focused = true;
		optionsVisible = false;
	}

	function elementBlurred(_)
	{
		focused = false;
	}

	function elementClicked(_)
	{
		optionsVisible = !optionsVisible;
	}

	function elementPressed(e:Dynamic)
	{
		e.stopPropagation();
	}

	override function change(flag:Dynamic)
	{
		super.change(flag);
		
		if (flag.enabled)
		{
			select.disabled = !enabled;
		}

		if (flag.focused && enabled && focused)
		{
			select.focus();
		}

		if (flag.selectedIndex)
		{
			select.selectedIndex = selectedIndex;
		}
	}
	
	override public function destroy()
	{
		select.removeEventListener('focus', elementFocused);
		select.removeEventListener('blur', elementBlurred);
		select.removeEventListener('change', elementChanged);
		select.removeEventListener('click', elementClicked);
		select.removeEventListener('mousedown', elementPressed);
		super.destroy();
	}
}

#else

class SelectDisplay extends Display
{
	@:set var focused:Bool;
	@:set var optionsVisible:Bool;
	@:set var selectedIndex:Dynamic;
	@:set var data:Dynamic;

	public var selectedData(get, set):Dynamic;
	
	function get_selectedData():Dynamic
	{
		return null;
	}

	function set_selectedData(value:Dynamic):Dynamic
	{
		return null;
	}

	public function new()
	{
		super();

		focused = false;
		optionsVisible = false;
		selectedIndex = -1;
		data = null;
	}

	override function touchStart(e)
	{
		super.touchStart(e);
	}
}

#end
