package mui.input;

import mui.display.Color;
import mui.display.Text;
import mui.core.Skin;
import mui.core.Component;

class TextInputSkin extends ThemeSkin<TextInput>
{
	public function new(theme:Theme)
	{
		super(theme);
		
		defaultWidth = 385;
		defaultHeight = theme.defaultHeight;
		
		addChild(background);
		properties.inputText = { left:16, right:16, size:theme.textSize, color:theme.textColor, font:theme.textFont };
	}

	override function update(flag:Dynamic)
	{
		super.update(flag);

		if (flag.enabled || flag.focused || flag.invalid) updateState(target.inputText);
	}
}
