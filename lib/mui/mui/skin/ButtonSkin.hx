package mui.skin;

import mui.display.Rectangle;
import mui.display.Text;
import mui.display.Color;
import mui.core.Skin;
import mui.core.Component;

class ButtonSkin extends Skin<Component>
{
	var background:Rectangle;
	var titleText:Text;
	
	public function new()
	{
		super();
		
		defaultWidth = 250;
		defaultHeight = 60;
		
		defaultStyles = 
		{
			focusColor:0xFFFFFF,
			selectedColor:0xD7D7D7,
			backgroundColor:0xE6E6E6
		}

		background = new Rectangle();
		addChild(background);
		
		background.fill = new Color(defaultStyles.backgroundColor);
		background.all = 0;
		
		titleText = new Text();
		addChild(titleText);
		
		titleText.size = 20;
		titleText.color = 0x000000;
		
		titleText.left = titleText.right = 5;
		titleText.align = "center";
		titleText.centerY = 0.5;
	}
	
	override function update(flag:Dynamic)
	{
		super.update(flag);
		
		if (flag.data)
		{
			titleText.value = Std.string(target.data);
		}
		
		if (flag.enabled)
		{
			target.alpha = (target.enabled ? 1.0 : 0.5);
		}
		
		if (flag.focused || flag.selected)
		{
			if (target.focused)
			{	
	
				background.fill = new Color(styles.focusColor);
				background.stroke = new Color(0x40A8F5);
			}
			else if (target.selected)
			{
				background.fill = new Color(styles.selectedColor);
				background.stroke = new Color(0xC7C7C7);
			}
			else
			{
				background.fill = new Color(styles.backgroundColor);
				background.stroke = new Color(0xC7C7C7, 0);
			}
		}
	}
}
