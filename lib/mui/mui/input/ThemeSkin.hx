package mui.input;

import mui.core.Skin;
import mui.display.Rectangle;
import mui.display.Color;
import mui.display.Text;
import mui.display.Icon;

class ThemeSkin<TComponent:Input> extends Skin<TComponent>
{
	var required:Icon;
	var theme:Theme;
	var background:Rectangle;
	
	public function new(theme:Theme)
	{
		super();

		this.theme = theme;

		background = new Rectangle();
		background.all = 0;
		background.fill = new Color(theme.backgroundColor);
		background.stroke = new Color(theme.borderColor);
		background.strokeThickness = theme.borderWidth;
		background.radius = theme.borderRadius;
	}

	function updateState(text:Text)
	{
		var bck:Color = cast background.fill;
		var bdr:Color = cast background.stroke;

		if (target.focused)
		{
			bck.value = theme.backgroundColorFocused;
			bdr.value = theme.borderColorFocused;
			if (text != null) text.color = theme.textColorFocused;
		}
		else if (!target.enabled)
		{
			bck.value = theme.backgroundColorDisabled;
			bdr.value = theme.borderColorDisabled;
			if (text != null) text.color = theme.textColorDisabled;
		}
		else if (target.invalid)
		{
			bck.value = theme.backgroundColorInvalid;
			bdr.value = theme.borderColorInvalid;
			if (text != null) text.color = theme.textColorInvalid;
		}
		else
		{
			bck.value = theme.backgroundColor;
			bdr.value = theme.borderColor;
			if (text != null) text.color = theme.textColor;
		}
	}

	override function update(flag:Dynamic)
	{
		super.update(flag);
		if (flag.required)
		{		
			if (target.required && required == null && !target.isInRequiredGroup && theme.showRequiredIcon)
			{
				required = new Icon(theme.requiredIcon, theme.requiredIconTextSize, theme.textColorInvalid);
				required.font = theme.textFont;
				required.x = -20;
				required.centerY = 0.5;
				target.addChild(required);
			}

			if (!target.required && required != null)
			{
				target.removeChild(required);
				required = null;
			}
		}
	}
}
