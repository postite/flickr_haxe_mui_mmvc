package mui.input;

import mui.core.Skin;
import mui.core.Component;
import mui.input.Input;

class NumberInput extends DataInput<Float>
{
	public function new(?skin:Skin<Dynamic>)
	{
		super();

		minimum = 0;
		maximum = 100;
		data = 0;
		
		if (skin != null) this.skin = skin;
	}

	override public function clearFormData()
	{
		data = minimum;
	}

	override function set_data(value:Float):Float
	{
		if (value > maximum)
			value = maximum;
		else if (value < minimum)
			value = minimum;

		return data = changeValue("data", value);
	}
	
	/**
		This property holds the sliders's minimum value.
		
		When setting this property, the maximum is adjusted if necessary to 
		ensure that the range remains valid. Also the slider's current value is 
		adjusted to be within the new range.
	**/  
	public var minimum(default, set_minimum):Float;
	function set_minimum(value:Float):Float
	{
		minimum = changeValue("minimum", value);
		
		if (maximum < minimum)
		{
			maximum = changeValue("maximum", minimum);
		}
		
		if (data < minimum)
		{
			data = changeValue("data", minimum);
		}
		
		return minimum;
	}
	
	/**
		This property holds the slider's maximum value.
		
		When setting this property, the minimum is adjusted if necessary to 
		ensure that the range remains valid. Also the slider's current value is 
		adjusted to be within the new range.
	**/
	public var maximum(default, set_maximum):Float;
	function set_maximum(value:Float):Float
	{
		maximum = changeValue("maximum", value);
		
		if (minimum > maximum)
		{
			minimum = changeValue("minimum", maximum);
		}
		
		if (data > maximum)
		{
			data = changeValue("data", maximum);
		}
		
		return maximum;
	}
}
