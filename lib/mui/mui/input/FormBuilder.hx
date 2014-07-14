package mui.input;

import mui.core.Container;
import mui.core.Component;
import mui.display.Display;
import mui.validator.Validator;
import mui.validator.MatchValidator;

class FormBuilder
{
	var form:Form;
	var container:Container;
	var input:Input;

	public function new() {}

	public function build(form:Form):FormBuilder
	{
		this.form = form;
		this.container = form;
		return this;
	}

	public function group(label:String):FormBuilder
	{
		container = form;
		input = null;

		var group = createGroup();
		group.label = label;
		container.addComponent(group);
		container = group;
		return this;
	}

	public function hgroup(label:String):FormBuilder
	{
		group(label);
		container.layout.vertical = false;
		return this;
	}

	public function endGroup()
	{
		container = form;
		input = null;
		return this;
	}

	public function add(component:Component)
	{
		container.addComponent(component);
		return this;
	}
	
	public function text(path:String, placeholder:String, ?maxLength:Int=0):FormBuilder
	{
		var textInput = createTextInput();
		textInput.path = path;
		textInput.placeholder = placeholder;
		textInput.maxLength = maxLength;
		container.addComponent(textInput);
		input = textInput;
		return this;
	}

	public function password(path:String, placeholder:String, ?maxLength:Int=0):FormBuilder
	{
		var textInput = createTextInput();
		textInput.path = path;
		textInput.placeholder = placeholder;
		textInput.secureInput = true;
		textInput.maxLength = maxLength;
		input = textInput;
		container.addComponent(input);
		return this;
	}

	public function select(path:String, options:Array<Dynamic>, ?placeholder:String)
	{
		var select = createSelectInput();
		select.path = path;
		select.options = options;
		if (placeholder != null) select.placeholder = placeholder;

		input = select;
		container.addComponent(input);
		return this;
	}
	
	/**
		Provide a shared `path` between each radio in a group which maps to a `Dynamic`.
		Individual `Bool` values aren't required for each radio in the form's VO.
	**/ 
	public function radio(path:String, label:String, value:Dynamic)
	{
		var button = createRadioButton();
		button.path = path;
		button.label = label;
		button.groupName = path;
		button.groupValue = value;
		input = button;
		container.addComponent(input);
		return this;
	}
	
	/**
		For single checkboxes provide a unique `path` which maps to a `Bool` in
		the form's VO.
		
		For multi-select checkboxes provide a shared `path` which maps to a
		`String` in the form's VO and give eackbox a unique `value`.
	**/ 
	public function checkbox(path:String, label:String, ?value:Dynamic = null)
	{
		var button = createCheckBox();
		button.path = path;
		button.label = label;
		input = button;
		container.addComponent(input);
		if (value != null)
		{
			button.groupName = path;
			button.groupValue = value;
		}
		return this;
	}
	
	public function range(path:String, min:Float, max:Float)
	{
		var range = createRangeInput();
		range.path = path;
		range.minimum = min;
		range.maximum = max;
		input = range;
		container.addComponent(input);
		return this;
	}
	
	/**
		As part of the form's validation cycle the user will need
		to provide the input with a valid value.
		
		When assigning to a `ButtonInput` you only need to set
		`required` on one `Input` within a group.
		It's also recommended to provide a `validationLabel` 
		to this required `ButtonInput`.
	**/ 
	public function required(?error:String=null):FormBuilder
	{
		if (input == null) throw "Error: no input";
		input.required = true;
		if (error != null) input.requiredMessage = error;
		return this;
	}
	
	public function requiredGroup():FormBuilder
	{
		if (container != null && Std.is(container, FormGroup))
		{
			var group:FormGroup = cast(container, FormGroup);
			group.required = true;
		}
		return this;
	}
	
	public function validate(validator:Validator):FormBuilder
	{
		if (input == null) throw "Error: no input";
		input.addValidator(validator);
		return this;
	}

	public function matches(path:String, error:String):FormBuilder
	{
		if (input == null) throw "Error: no input";
		input.addValidator(new MatchValidator(form, path, error));
		return this;
	}

	public function size(width:Int, ?height:Int=0):FormBuilder
	{
		if (input == null) throw "Error: no input";
		input.width = width;
		if (height > 0) input.height = height;
		return this;
	}
	
	public function validationLabel(label:String):FormBuilder
	{
		if (input == null) throw "Error: no input";
		input.validationLabel = label;
		return this;
	}

	// factories

	function createSelectInput():SelectInput
	{
		return new SelectInput();
	}

	function createGroup():FormGroup
	{
		return new FormGroup();
	}

	function createCheckBox():CheckBox
	{
		return new CheckBox();
	}

	function createRadioButton():RadioButton
	{
		return new RadioButton();
	}

	function createTextInput():TextInput
	{
		return new TextInput();
	}
	
	function createRangeInput():RangeInput
	{
		return new RangeInput();
	}
}
