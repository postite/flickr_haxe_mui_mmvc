package mui.validator;

class RequiredValidator implements Validator
{
	@:isVar public var message(get, set):String;
	function get_message():String { return message; }
	function set_message(value:String):String { return message = value; }

	public function new(message:String)
	{
		this.message = message;
	}

	public function validate(data:Dynamic):ValidationResult
	{
		var isError = false;
		
		if (data == null) isError = true;
		else if (Std.is(data, String)) isError = StringTools.trim(data).length == 0;
		else if (Reflect.isObject(data) && Reflect.hasField(data, "value")) isError = StringTools.trim(Reflect.getProperty(data, "value")).length == 0;
		
		return {isError:isError, message:message};
	}
}
