package mui.input;

class ThemeFormBuilder extends FormBuilder
{
	var theme:Theme;
	
	public function new(theme:Theme)
	{
		super();
		this.theme = theme;
	}

	override function createCheckBox():CheckBox
	{
		return new CheckBox(new CheckBoxSkin(theme));
	}

	override function createRadioButton():RadioButton
	{
		return new RadioButton(new RadioButtonSkin(theme));
	}

	override function createSelectInput():SelectInput
	{
		return new SelectInput(new SelectInputSkin(theme));
	}

	override function createTextInput():TextInput
	{
		return new TextInput(new TextInputSkin(theme));
	}

	override function createGroup():FormGroup
	{
		return new FormGroup(new FormGroupSkin(theme));
	}

	override function createRangeInput():RangeInput
	{
		return new RangeInput(new RangeInputSkin(theme));
	}
}
