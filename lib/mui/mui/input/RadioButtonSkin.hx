package mui.input;

import mui.display.Color;

class RadioButtonSkin extends ButtonInputSkin
{
	public function new(theme:Theme)
	{
		super(theme);
		
		checked.fill = new Color(theme.textColor);
		background.radius = checked.radius = 20;
	}
}
