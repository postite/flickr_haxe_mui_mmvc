package mui.input;

import mui.core.Skin;

class CheckBox extends ButtonInput
{
	public function new(?skin:Skin<ButtonInput>)
	{
		super(skin);
		
		#if js
		// When tabbing to a Checkbox you can action it by pushing
		// spacebar while it has focus.
		inputElement.addEventListener('change', inputChanged);
		inputElement.className = "view-checkbox";
		inputElement.type = "checkbox";
		#end
		
		data = false;
	}
	
	override public function getFormData():Dynamic
	{
		if (groupName != null)
		{
			var values = [];
			for (button in getGroup()) if (button.data == true) values.push(button.groupValue);
			if (values.length > 0) return values.toString();
			else return "";
		}
		
		return super.getFormData();
	}

	override public function setFormData(data:Dynamic)
	{
		if (groupName != null && Std.is(data, String))
		{
			var values:Array<String> = data.split(",");
			var value:String = null;
			
			for (groupButton in getGroup())
				for(value in values)
					if (groupButton.groupValue == value)
						groupButton.data = true;
		}
		else if (Std.is(data, String))
		{
			super.setFormData(false);
		}
		else
		{
			super.setFormData(data);
		}
	}
	
	#if js
	function inputChanged(_)
	{
		if (inputElement.checked != data) data = inputElement.checked;
	}
	
	override public function destroy()
	{
		inputElement.removeEventListener('change', inputChanged);
		super.destroy();
	}
	#end
}
