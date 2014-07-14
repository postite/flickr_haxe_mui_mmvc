package mui.input;

import mui.core.Skin;
import mui.display.Icon;

class FormGroupSkin extends Skin<FormGroup>
{
	var required:Icon;
	var theme:Theme;
	
	public function new(theme:Theme)
	{
		super();
		
		this.theme = theme;
		properties.labelText = { size:theme.textSize, color:theme.textColor, font:theme.textFont };
	}
	
	override function update(flag:Dynamic)
	{
		super.update(flag);
		
		if (flag.required)
		{
			if (target.required && required == null)
			{
				required = new Icon(theme.requiredIcon, theme.requiredIconTextSize, theme.textColorInvalid);
				required.font = theme.textFont;
				required.x = -20;
				target.addChild(required);
			}

			if (!target.required && required != null)
			{
				target.removeChild(required);
				required = null;
			}
		}
		
		if (flag.height && required != null)
		{
			required.y = Std.int((target.height + target.labelText.height) / 2) + 3;
		}
	}
}
