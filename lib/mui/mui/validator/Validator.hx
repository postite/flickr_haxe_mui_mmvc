package mui.validator;

interface Validator
{
	public function validate(value:Dynamic):ValidationResult;
	public var message(get, set):String;
}
