package mui.input;

import mui.control.Button;
import mui.core.Collection;
import mui.core.Component;
import mui.core.Skin;
import mui.display.Color;
import mui.display.Display;
import mui.display.Icon;
import mui.display.Rectangle;
import mui.display.Text;
import mui.event.Key;
import mui.input.Input;

typedef SelectInput = DataSelectInput<Dynamic>;

class DataSelectInput<TData> extends DataInput<TData>
{
	@:set var options:Array<TData>;
	@:set var optionsVisible:Bool;
	@:set var placeholder:String;
	@:set var dataLabel:String;

	public function new(?skin:Skin<SelectInput>)
	{
		super(skin);
		
		data = null;
		options = null;
		optionsVisible = false;
		placeholder = "";
		dataLabel = placeholder;
	}
	
	function getDataLabel(data:TData):String
	{
		if (data == null) return placeholder;
		return Reflect.hasField(data, "label") ? Reflect.field(data, "label") : Std.string(data);
	}

	override function set_data(value:TData):TData
	{
		dataLabel = getDataLabel(value);
		return super.set_data(value);
	}

	override public function clearFormData()
	{
		super.clearFormData();
		data = null;
	}
}
