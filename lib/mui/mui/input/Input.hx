package mui.input;

import mui.core.Component;
import mui.core.Skin;
import mui.validator.Validator;
import mui.validator.ValidationResult;

typedef Input = DataInput<Dynamic>;

class DataInput<TData:Dynamic> extends DataComponent<TData>
{
	@:set var invalid:Bool;
	@:set var required:Bool;
	@:set var path:String;
	@:set var validationLabel:String;
	
	public var requiredMessage:String;
	public var isInRequiredGroup:Bool;

	var hasHadFocus:Bool;
	var validators:Array<Validator>;
	
	public function new(?skin:Skin<Dynamic>)
	{
		super(skin);

		validators = [];
		invalid = false;
		path = null;
		hasHadFocus = false;
		required = false;
		requiredMessage = "this field is required";
		validationLabel = null;
		isInRequiredGroup = false;
	}

	/**
		Add a required validator to the input with the message provided.

		@param message The validation error message to return when the input 
			contains no value.
		@deprecated Use `required` and `requiredMessage` instead
	**/
	public function addRequiredValidator(message:String):Void
	{
		required = true;
		requiredMessage = message;
	}

	/**
		Adds a validator to the inputs array of validators.

		When `validateData` is called the data represented by the input will be 
		validated against each of the inputs validators. If a validator returns 
		a `ValidationResult` where `isError` is true, the input enters an 
		invalid state.
	**/
	public function addValidator(validator:Validator):Void
	{
		removeValidator(validator);
		validators.push(validator);
	}

	/**
		Removes the validator from the inputs array of validators.
	**/
	public function removeValidator(validator:Validator):Void
	{
		validators.remove(validator);
	}

	/**
		Validates the inputs data against each of its validator.
	**/
	public function validateData():ValidationResult
	{
		var value:Dynamic = data; 

		if (required)
		{
			if (value == null || (!Std.is(value, String) && value == false) || (Std.is(value, String) && Std.string(value).length == 0))
			{
				invalid = true;
				return {isError:true, message:requiredMessage};
			}
		}

		for (validator in validators)
		{
			var result = validator.validate(value);
			if (result.isError)
			{
				invalid = true;
				return result;
			}
		}

		invalid = false;
		return {isError:false, message:""};
	}

	/**
		Clears the data in the input.
	**/
	public function clearFormData()
	{
		if (!focused) hasHadFocus = false;
		invalid = false;
	}

	/**
		Returns the form representation of this input's data.
	**/
	public function getFormData()
	{
		return data;
	}

	/**
		Sets the inputs data from the form's representation it's data.
	**/
	public function setFormData(data:Dynamic)
	{
		this.data = data;
	}

	override function change(flag:Dynamic)
	{
		super.change(flag);

		if (flag.focused)
		{
			if (focused) hasHadFocus = true;
			else if (hasHadFocus) validateData();
		}
	}
}
