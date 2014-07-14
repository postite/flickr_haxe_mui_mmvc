package mui.input;

import mui.display.Color;
import mui.display.Icon;
import mui.display.Text;
import mui.core.Skin;
import mui.core.Component;
import mui.core.Collection;

using Lambda;

class SelectInputSkin extends ThemeSkin<SelectInput>
{
	var arrow:Icon;
	var label:Text;
	var options:SelectDisplay;
	
	public function new(theme:Theme)
	{
		super(theme);
		
		defaultWidth = 385;
		defaultHeight = theme.defaultHeight;
		
		addChild(background);

		arrow = new Icon(theme.downArrowIcon, 20, theme.textColor);
		addChild(arrow);

		arrow.font = theme.iconFont;
		arrow.centerY = 0.5;
		arrow.right = 12;

		label = new Text();
		addChild(label);

		label.autoSize = false;
		label.height = 20;
		label.left = 16;
		label.right = 38;
		label.clip = true;
		label.size = theme.textSize;
		label.centerY = 0.5;
		label.font = theme.textFont;
		label.color = 0xa9a9a9;

		options = new SelectDisplay();
		addChild(options);

		options.changed.add(optionsChanged);
		options.all = 0;
	}
	
	override function update(flag:Dynamic)
	{
		super.update(flag);

		if (flag.options)
		{
			options.data = target.options;
		}

		if (flag.width)
		{
			options.width = target.width;
		}

		if (flag.dataLabel)
		{
			label.value = target.dataLabel;
		}

		if (flag.enabled)
		{
			options.enabled = target.enabled;
		}
		
		if (flag.enabled || flag.focused || flag.invalid || flag.data)
		{
			updateState(label);

			if (target.data == null)
			{
				options.selectedIndex = -1;
				label.color = 0xa9a9a9;
			}
			else
			{
				options.selectedIndex = target.options.indexOf(target.data);
			}
		}
	}

	function optionsChanged(flag:Dynamic)
	{
		if (flag.focused && options.focused)
		{
			target.focus();
		}

		if (flag.selectedIndex)
		{
			if (options.selectedData != null)
				target.data = options.selectedData;
		}

		if (flag.optionsVisible)
		{
			target.optionsVisible = options.optionsVisible;
		}
	}
}
