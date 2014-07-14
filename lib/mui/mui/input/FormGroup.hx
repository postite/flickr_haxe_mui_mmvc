package mui.input;

import mui.core.Component;
import mui.core.Container;
import mui.core.Skin;
import mui.display.Display;
import mui.display.Text;

class FormGroup extends Container
{
	@:set var label:String;
	@:set var labelPosition:FormLabelPosition;
	@:set var required:Bool;

	public var labelText:Text;

	public function new(?skin:Skin<FormGroup>)
	{
		labelText = new Text();

		super(skin);
		
		required = false;
		
		label = null;
		labelPosition = FormLabelPosition.Top;
		layout.enabled = true;
		layout.spacingX = 10;
		layout.spacingY = 14;
		resizeX = true;
		resizeY = true;
		
		addChild(labelText);
	}

	override function change(flag:Dynamic)
	{
		super.change(flag);

		if (flag.label || flag.labelPosition)
		{
			labelText.value = label;

			if (label == null || label == "")
			{
				layout.paddingTop = layout.paddingLeft = 0;
			}
			else
			{
				switch (labelPosition)
				{
					case Top:
						layout.paddingTop = labelText.height + 20;
						layout.paddingLeft = 0;
						labelText.y = 12;
					case Left:
						labelText.y = 10;
						layout.paddingTop = 0;
						layout.paddingLeft = labelText.width + 20;
					default:
				}
			}
		}
		
		if (flag.required)
		{
			for (c in components) setRequired(c);
		}
	}
	
	override public function addComponent(component:Component)
	{
		super.addComponent(component);
		setRequired(component);
	}
	
	function setRequired(component:Display):Void
	{
		if (component == null) return;
		if (!Std.is(component, Input)) return;
		var input:Input = cast(component, Input);
		input.required = required;
		input.isInRequiredGroup = required;
	}
}
