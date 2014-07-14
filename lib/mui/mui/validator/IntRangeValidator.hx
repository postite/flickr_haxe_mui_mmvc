package mui.validator;

class IntRangeValidator implements Validator
{
	var min:Int;
	var max:Int;
	
	@:isVar public var message(get, set):String;
	function get_message():String { return message; }
	function set_message(value:String):String { return message = value; }

	public function new(min:Int, max:Int, message:String)
	{
		this.min = min;
		this.max = max;
		this.message = message;
	}

	public function validate(data:Dynamic):ValidationResult
	{
		var value = Std.int(data);
		return {isError: !(value >= min && value <= max), message: message};
	}
}
