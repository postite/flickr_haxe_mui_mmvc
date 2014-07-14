package mui.validator;

import mui.input.Form;

class MatchValidator implements Validator
{
	var form:Form;
	var path:String;
	
	@:isVar public var message(get, set):String;
	function get_message():String { return message; }
	function set_message(value:String):String { return message = value; }

	public function new(form:Form, path:String, message:String)
	{
		this.form = form;
		this.path = path;
		this.message = message;
	}

	public function validate(data:Dynamic):ValidationResult
	{
		var matchData = form.getInputData(path);
		return {isError:data != matchData, message:message};
	}
}