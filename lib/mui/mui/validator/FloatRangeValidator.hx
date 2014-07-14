package mui.validator;

class FloatRangeValidator implements Validator
{
	var min:Float;
	var max:Float;
	
	@:isVar public var message(get, set):String;
	function get_message():String { return message; }
	function set_message(value:String):String { return message = value; }

	public function new(min:Float, max:Float, message:String)
	{
		this.min = min;
		this.max = max;
		this.message = message;
	}

	public function validate(data:Dynamic):ValidationResult
	{
		var value = Std.parseFloat(data);
		return {isError: !(value >= min && value <= max), message: message};
	}
}
