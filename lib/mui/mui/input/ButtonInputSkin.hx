package mui.input;

import mui.core.Skin;
import mui.core.Component;
import mui.display.Rectangle;
import mui.display.Display;
import mui.display.Color;
import mui.display.Text;
import mui.display.Icon;

class ButtonInputSkin extends ThemeSkin<ButtonInput>
{
	var display:Display;
	var checked:Icon;
	var label:Text;

	public function new(theme:Theme)
	{
		super(theme);

		defaultWidth = 80;
		defaultHeight = 20;
		
		display = new Display();
		addChild(display);

		display.width = display.height = 20;
		display.addChild(background);

		checked = new Icon();
		checked.visible = false;
		display.addChild(checked);

		checked.font = theme.iconFont;
		checked.color = theme.textColor;
		checked.size = 12;
		checked.centerX = checked.centerY = 0.5;

		label = new Text();
		addChild(label);

		label.size = theme.labelSize;
		label.font = theme.textFont;
		label.color = theme.labelColor;
		label.x = 30;
		label.selectable = false;
		label.centerY = 0.5;
	}
	
	override function update(flag:Dynamic)
	{
		super.update(flag);

		if (flag.data)
		{
			checked.visible = target.data;
		}

		if (flag.label)
		{
			label.value = target.label;
			target.width = label.x + label.width + 10;
		}

		if (flag.labelPosition || flag.label)
		{
			switch (target.labelPosition)
			{
				case FormLabelPosition.Left:
					label.x = 0;
					display.x = label.width + 10;
				case FormLabelPosition.Right:
					display.x = 0;
					label.x = display.width + 10;
				default:
			}
		}

		if (flag.enabled || flag.focused || flag.invalid) updateState(null);
	}
}
