package mui.validator;

class EmailValidator extends StringValidator
{
	static var REGEX = ~/^[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i;
	
	public function new(?message:String)
	{
		if (message == null) message = "Email address is invalid";
		super(REGEX, message);
	}
}