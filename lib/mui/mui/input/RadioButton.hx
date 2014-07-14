package mui.input;

import mui.core.Skin;
import mui.validator.ValidationResult;
import mui.validator.Validator;

class RadioButton extends ButtonInput
{
	public function new(?skin:Skin<ButtonInput>)
	{
		super(skin);
		
		#if js
		// When tabbing to a RadioButton you can action it by pushing
		// spacebar while it has focus. Additionally you can action 
		// the others within it's RadioGroup using the arrow keys.
		inputElement.addEventListener('change', inputChanged);
		inputElement.className = "view-radio";
		inputElement.type = "radio";
		#end
		
		data = false;
	}
	
	static function selectGroupButton(groupButton:ButtonInput)
	{
		if (groupButton.groupName == null) return;
		for (button in groupButton.getGroup())
			if (button != groupButton)
				button.data = false;
	}
	
	override function change(flag:Dynamic)
	{
		super.change(flag);
		if (flag.data && data) selectGroupButton(this);
	}
	
	override function action()
	{
		var selected:ButtonInput = null;

		if (groupName != null)
		{
			// Prevent unchecking a selected radio group
			var group = getGroup();
			for (radio in group)
			{
				if (radio.data == true)
				{
					selected = radio;
					updateGroupValidity(group, false);
					break;
				}
			}
		}
		
		if (selected == null || (selected != null && selected != this))
		{
			data = !data;
		}
	}
	
	override public function validateData():ValidationResult
	{
		var value:Dynamic = data;
		var group = getGroup();

		if (required)
		{
			var isError = true;

			for (radio in group)
			{
				if (radio.data == true)
				{
					isError = false;
					break;
				}
			}
			
			if (isError)
			{
				updateGroupValidity(group, true);
				return {isError: true, message: requiredMessage};
			}
		}
		
		for (validator in validators)
		{
			for (radio in group)
			{
				var result = validator.validate(radio.data);
				if (result.isError)
				{
					updateGroupValidity(group, true);
					return result;
				}
			}
		}
		
		updateGroupValidity(group, false);
		return {isError:false, message:""};
	}
	
	function updateGroupValidity(group:Array<ButtonInput>, invalid:Bool)
	{
		for (radio in group)
			radio.invalid = invalid;
	}
	
	
	override public function getFormData():Dynamic
	{
		if (groupName != null)
		{
			for (groupButton in getGroup())
				if (groupButton.data)
					return groupButton.groupValue;
		}
		
		return super.getFormData();
	}

	override public function setFormData(data:Dynamic)
	{
		if (groupName != null)
		{
			for (groupButton in getGroup())
			{
				if (groupButton.groupValue == data)
				{
					groupButton.data = true;
					return;
				}
			}
		}
		
		super.setFormData(data);
	}
	
	#if js
	function inputChanged(_)
	{
		if (inputElement.checked && !data) data = true;
	}
	
	override public function destroy()
	{
		inputElement.removeEventListener('change', inputChanged);
		super.destroy();
	}
	#end
}
