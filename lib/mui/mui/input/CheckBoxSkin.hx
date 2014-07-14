package mui.input;

import mui.core.Skin;
import mui.display.Color;

class CheckBoxSkin extends ButtonInputSkin
{
	public function new(theme:Theme)
	{
		super(theme);
		checked.type = theme.checkedIcon;
	}
}
