package mui.input;

import mui.core.Container;
import mui.validator.ValidationResult;

typedef Form = DataForm<Dynamic>;

/**
	A DataForm is a specialised Container containing Input controls. If defines 
	methods for bi-direction updating of data; from the inputs to the form's 
	data, and from the form's data to the inputs.

	A form can also be validated by calling `validateData`.
**/
class DataForm<TData> extends DataContainer<TData, Dynamic>
{
	public function new()
	{
		super();
		
		layout.enabled = true;
		layout.padding = 20;
		layout.paddingLeft = layout.paddingRight = 80;
		layout.spacing = 10;
		resizeY = true;
	}

	/**
		@returns returns an iterator of the forms inputs.
	**/
	public function inputs():Iterator<Input>
	{
		return findInputs(this).iterator();
	}

	function findInputs(container:Container):Array<Input>
	{
		var inputs:Array<Input> = [];
		for (component in container.components)
		{
			if (Std.is(component, Input))
			{
				inputs.push(cast component);
			}
			else if (Std.is(component, Container))
			{
				for (input in findInputs(cast component))
					inputs.push(input);
			}

		}
		return inputs;
	}

	/**
		@returns the first input with the given path, or null if none found in this form.
	 **/
	public function getInputWithPath(path:String):Input
	{
		for (input in inputs())
			if (input.path == path)
				return input;
		return null;
	}

	/**
		Updates the data of the forms inputs with the forms data by calling 
		`updateInputFromData` for each input.
	**/
	override function updateData(data:TData)
	{
		Reflect.setField(this, "data", data);
		for (input in inputs()) updateInputFromData(input);
	}

	/**
		Updates the forms data with the data of its inputs by calling 
		`updateDataFromInput` for each input.
	**/
	function commitData():Void
	{
		for (input in inputs()) updateDataFromInput(input);
	}

	/**
		Updates a field of the form's data with the provided data.
		
		Example:

			setDataAtPath("user.firstName", "Tim");
		
		@param path The path of the field to update in dot notation.
		@param data The new value to assign to the data path.
	**/
	function setDataAtPath(path:String, data:Dynamic):Void
	{
		var value = this.data;
		var parts = path.split(".");
		var field = parts.pop();
		for (part in parts) value = Reflect.getProperty(value, part);
		Reflect.setProperty(value, field, data);
	}

	/**
		Returns a field from the forms data from the path provided.

		Example:

			getDataAtPath("user.firstName");

		@param path The path of the field to return in dot notation.
		@returns the data at the specified path.
	**/
	function getDataAtPath(path:String):Dynamic
	{
		var value = data;
		var parts = path.split(".");
		for (part in parts) value = Reflect.getProperty(value, part);
		return value;
	}

	/**
		Updates the data of an input from the form's data object.

		@param input The input to be updated.
	**/
	function updateInputFromData(input:Input):Void
	{
		if (input.path == null) return;
		input.setFormData(getDataAtPath(input.path));
	}

	/**
		Updates the form's data from the input provided.

		@param input The input from which the form's data will be updated.
	**/
	function updateDataFromInput(input:Input):Void
	{
		if (input.path == null) return;
		setDataAtPath(input.path, input.getFormData());
	}

	/**
		Returns the current input data for the provided path.

		@param path The path of the input to return the data for dot notation.
		@returns The data of the input with the provided path.
	**/
	public function getInputData(path:String):Dynamic
	{
		for (input in inputs())
		{
			if (input.path == path) return input.getFormData();
		}
		return null;
	}

	/**
		Validates each input in the form by calling `Input.validateData`, 
		returning an array of validation errors. If no validation errors are 
		found, `commitData` is called.

		@returns An array of validation errors for the form.
	**/
	public function validateData():Array<ValidationResult>
	{
		var fields = inputs();
		var errors = [];
		for (input in fields)
		{
			var result = input.validateData();
			if (result.isError) errors.push(result);
		}
		if (errors.length == 0) commitData();
		return errors;
	}

	/**
		Invokes `clearFormData` on each input in the form.
	**/
	public function clearData()
	{
		for (input in inputs()) input.clearFormData();
	}
}
