package mui.validator;

class StringValidator implements Validator
{
	var regex:EReg;
	
	@:isVar public var message(get, set):String;
	function get_message():String { return message; }
	function set_message(value:String):String { return message = value; }

	public function new(regex:EReg, message:String)
	{
		this.regex = regex;
		this.message = message;
	}

	public function validate(data:Dynamic):ValidationResult
	{
		// Only validate against entered data. DataInput.required handles empty data.
		var s = Std.string(data);
		var result = (s != "") ? !regex.match(s) : false;
		
		return {isError:result, message:message};
	}
}
