package mui.input;

import mui.display.Rectangle;
import mui.display.Color;
import mui.display.Text;

class Theme
{
	public var iconFont:String;
	public var checkedIcon:String;
	public var downArrowIcon:String;
	public var requiredIcon:String;
	public var requiredIconTextSize:Int;
	
	public var labelColor:Int;
	public var labelSize:Int;

	public var textFont:String;
	public var textSize:Int;

	public var textColor:Int;
	public var textColorFocused:Int;
	public var textColorInvalid:Int;
	public var textColorDisabled:Int;

	public var backgroundColor:Int;
	public var backgroundColorFocused:Int;
	public var backgroundColorInvalid:Int;
	public var backgroundColorDisabled:Int;

	public var borderColor:Int;
	public var borderColorFocused:Int;
	public var borderColorInvalid:Int;
	public var borderColorDisabled:Int;

	public var borderWidth:Int;
	public var borderRadius:Int;
	public var defaultHeight:Int;

	public var showRequiredIcon:Bool;

	public function new()
	{
		borderWidth = 2;
		borderRadius = 6;

		iconFont = "FontAwesome";
		textFont = "SourceSansPro";
		textSize = 16;
		requiredIconTextSize = 21;
		defaultHeight = 40;
		checkedIcon = "#";
		downArrowIcon = "≈";
		requiredIcon = "*";
		labelColor = 0x4d4d4d;
		labelSize = 14;

		textColor = 0x4d4d4d;
		textColorFocused = 0x4d4d4d;
		textColorInvalid = 0xff0000;
		textColorDisabled = 0x4d4d4d;

		backgroundColor = 0xc8c8c8;
		backgroundColorFocused = 0xc8c8c8;
		backgroundColorInvalid = 0xffc3c3;
		backgroundColorDisabled = 0x727272;

		borderColor = 0xc8c8c8;
		borderColorFocused = 0xffffff;
		borderColorInvalid = 0xffc3c3;
		borderColorDisabled = 0x727272;

		showRequiredIcon = true;
	}
}
