package mui.display;

#if (flash || openfl)
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFieldType;
import flash.text.TextFieldAutoSize;
#end

import msignal.Signal;
import mcore.util.Colors;
using mui.display.Color;

/**
	Displays a string of text.

	Defines methods and properties for displaying, formatting and styling text 
	in an application.
**/
class Text extends mui.display.Rectangle
{
	public function new()
	{
		super();
		
		value = "";
		font = "SourceSansPro";
		size = 24;
		color = 0x000000;
		selectable = false;
		bold = false;
		italic = false;
		html = false;
		leading = 0;
		wrap = false;
		autoSize = true;
		multiline = false;
		letterSpacing = 0;
		align = "left";
		
		invalidateProperty("value");
		invalidateProperty("autoSize");
		invalidateProperty("selectable");
		invalidateProperty("font");
		invalidateProperty("size");
		invalidateProperty("color");
		invalidateProperty("multiline");
		invalidateProperty("wrap");
		
		sizeDirty = true;
	}

	//--------------------------------------------------------------------------- flag
	
	var sizeDirty:Bool;
	
	/**
		The value of the text.
	**/
	public var value(default, set_value):String;
	function set_value(value:String):String
	{
		if (value == null) value = "";
		sizeDirty = true;
		return this.value = changeValue("value", value);
	}
	
	/**
		The alignment of the value within the text object.
	**/
	public var align(default, set_align):String;
	function set_align(value:String):String { sizeDirty = true; return align = changeValue("align", value); }
	
	/**
		The font of the text.
	**/
	public var font(default, set_font):String;
	function set_font(value:String):String { sizeDirty = true; return font = changeValue("font", value); }
	
	/**
		Automatically resizes the text field based on the value. The width and
		height are ignored if this is set to true.
	**/
	public var autoSize(default, set_autoSize):Bool;
	function set_autoSize(value:Bool):Bool { sizeDirty = true; return autoSize = changeValue("autoSize", value); }
	
	/**
		Determines if the value can go over multiple lines.
	**/
	public var multiline(default, set_multiline):Bool;
	function set_multiline(value:Bool):Bool { sizeDirty = true; return multiline = changeValue("multiline", value); }
	
	/**
		Determines if the value will wrap.
	**/
	public var wrap(default, set_wrap):Bool;
	function set_wrap(value:Bool):Bool { sizeDirty = true; return wrap = changeValue("wrap", value); }
	
	/**
		The size of the text.
	**/
	public var size(default, set_size):Int;
	function set_size(value:Int):Int { sizeDirty = true; return size = changeValue("size", value); }
	
	/**
		The color of the text.
	**/
	public var color(default, set_color):Int;
	function set_color(value:Int):Int { sizeDirty = true; return color = changeValue("color", value); }
	
	/**
		Determines if the text value's input is HTML or plain text.
	**/
	public var html(default, set_html):Bool;
	function set_html(value:Bool):Bool { sizeDirty = true; return html = changeValue("html", value); }
	
	/**
		The spacing between lines of text.
	**/
	public var leading(default, set_leading):Int;
	function set_leading(value:Int):Int { sizeDirty = true; return leading = changeValue("leading", value); }
	
	/**
		The spacing between individual letters of text.
	**/
	public var letterSpacing(default, set_letterSpacing):Int;
	function set_letterSpacing(value:Int):Int { sizeDirty = true; return letterSpacing = changeValue("letterSpacing", value); }
	
	/**
		Determines whether italisize the text.
	**/
	public var italic(default, set_italic):Bool;
	function set_italic(value:Bool):Bool { sizeDirty = true; return italic = changeValue("italic", value); }
	
	/**
	Determines whether to bold the text.
	*/
	public var bold(default, set_bold):Bool;
	function set_bold(value:Bool):Bool { sizeDirty = true; return bold = changeValue("bold", value); }
	
	/**
		Determines whether to bold the text.
	**/
	public var selectable(default, set_selectable):Bool;
	function set_selectable(value:Bool):Bool { return selectable = changeValue("selectable", value); }
	
	// validate if dirty when accessing width/height
		
	override function get_width():Int
	{
		if (sizeDirty) validate();
		return super.get_width();
	}
	
	override function get_height():Int
	{
		if (sizeDirty) validate();
		return super.get_height();
	}
	
////////////////////////////////////////////////////////////////////////////////
#if js
////////////////////////////////////////////////////////////////////////////////
	
	static var NEWLINES = ~/\n/g;

	override function _new()
	{
		super._new();
		element.className += " view-text";
		element.style.fontFamily = font;
	}

	override function change(flag:Dynamic):Void
	{
		super.change(flag);
		
		if (flag.value)
		{
			if (html) element.innerHTML = value;
			else element.innerHTML = NEWLINES.replace(Std.string(value), '<br/>');
			sizeDirty = autoSize || !multiline; // height is always auto sized when single line
		}
		
		if (flag.wrap)
		{
			element.style.whiteSpace = (wrap ? "normal" : null);
			element.style.wordWrap = (wrap ? "break-word" : null);
		}
		
		if (flag.selectable)
		{
			untyped element.style[JS.getPrefixedStyleName("userSelect")] =
				(selectable ? "text" : null);
		}
		
		if (flag.leading || flag.font || flag.size || flag.color || flag.bold 
			|| flag.italic || flag.letterSpacing || flag.align)
		{
			if (flag.leading || flag.size) 
			{
				if (leading == 0) element.style.lineHeight = null;
				else element.style.lineHeight = (leading + size) + "px";
			}
			if (flag.font) element.style.fontFamily = font;
			if (flag.size) element.style.fontSize = size + "px";
			if (flag.bold) element.style.fontWeight = (bold ? "bold" : "normal");
			if (flag.italic) element.style.fontStyle = (italic ? "italic" : "normal");
			if (flag.letterSpacing) element.style.letterSpacing = letterSpacing + "px";
			if (flag.align) element.style.textAlign = align;
			if (flag.color) element.style.color = color.toRGBAStyle(1);
		}
		
		if (flag.width || flag.height || flag.autoSize || flag.multiline || flag.wrap)
		{
			element.style.width = autoSize && !(multiline && wrap) ? null : width + "px";
			element.style.height = (autoSize || !multiline) ? null : height + "px";
			sizeDirty = true;
		}
		
		if (sizeDirty) validateSize();
	}

	override function addChildAt(child:Display, index:Int)
	{
		throw "You can not add children to text fields.";
	}
	
	function validateSize()
	{
		sizeDirty = false;
		if (!(autoSize && !wrap) && !(autoSize || !multiline)) return;
		
		var parentNode:Dynamic = null;
		var nextSibling:Dynamic = null;

		var offDOM = (element.clientWidth == 0 && element.innerHTML != "");

		if (offDOM)
		{
			parentNode = element.parentNode;
			nextSibling = element.nextSibling;
			js.Browser.document.body.appendChild(element);
		}
		
		if (autoSize && !wrap) width = element.clientWidth;
		if (autoSize || !multiline) height = element.clientHeight;

		if (offDOM)
		{
			if (parentNode != null) parentNode.insertBefore(element, nextSibling);
			else js.Browser.document.body.removeChild(element);
		}
	}

////////////////////////////////////////////////////////////////////////////////
#elseif (flash || openfl)
////////////////////////////////////////////////////////////////////////////////
	
	public var textField:TextField;
	var textFormat:TextFormat;
	
	public var numLines(get_numLines, never):Int;
	function get_numLines():Int { return textField.numLines; }
	
	override function _new()
	{
		super._new();

		textField = createTextField();
		sprite.addChild(textField);

		textFormat = textField.defaultTextFormat;
		#if !openfl
		textFormat.kerning = true;
		textFormat.rightMargin = 2;
		#end
	}

	function createTextField()
	{
		var field = new TextField();
		
		field.selectable = false;
		field.mouseEnabled = false;
		field.embedFonts = true;
		field.x = field.y = -2;
		field.antiAliasType = flash.text.AntiAliasType.ADVANCED;
		field.gridFitType = flash.text.GridFitType.SUBPIXEL;
		
		#if !openfl
		// these properties not yet supported in openfl
		field.mouseWheelEnabled = false;
		field.condenseWhite = true;
		field.thickness = 100;
		#end

		return field;
	}
	
	override function change(flag:Dynamic):Void
	{
		super.change(flag);
		sizeDirty = false;
		
		if (flag.leading || flag.font || flag.size || flag.bold || flag.italic || flag.color || flag.letterSpacing || flag.align)
		{
			if (flag.leading) textFormat.leading = leading;
			#if openfl
			if (flag.font)
			{
				var fontName = font;
				if (fontName == null) fontName = "SourceSansPro";
				if (bold) fontName += "Bold";
				if (italic) fontName += "Italic";
				if (!bold && !italic) fontName += "Regular";
				textFormat.font = openfl.Assets.getFont("font/" + fontName + ".otf").fontName;
			}
			#else
			if (flag.font) textFormat.font = font;
			if (flag.bold) textFormat.bold = bold;
			if (flag.italic) textFormat.italic = italic;
			#end

			if (flag.size) textFormat.size = size;
			if (flag.color) textFormat.color = color;
			if (flag.letterSpacing) textFormat.letterSpacing = letterSpacing;
			if (flag.align) untyped textFormat.align = align;
			
			textField.defaultTextFormat = textFormat;
			textField.setTextFormat(textFormat);
		}
		
		if (flag.value)
		{
			if (html) textField.htmlText = value;
			else textField.text = value;
		}
		
		if (flag.autoSize)
		{
			textField.autoSize = (autoSize ? TextFieldAutoSize.LEFT : TextFieldAutoSize.NONE);
		}
		
		if (flag.wrap)
		{
			textField.wordWrap = wrap;
		}
		
		if (flag.multiline)
		{
			textField.multiline = multiline;
		}
		
		if (flag.selectable)
		{
			textField.selectable = textField.mouseEnabled = selectable;
		}
		
		if (autoSize && !(multiline && wrap))
		{
			width = Math.ceil(textField.width) - 4;
			if (textField.type == flash.text.TextFieldType.INPUT) width -= 14;
			if (width < 0) width = 0;
		}
		else textField.width = width + 4;
		
		if (autoSize || !(multiline && wrap))
		{
			height = Math.round(textField.textHeight);
			if (height < 0) height = 0;
		}
		textField.height = height + 4;
	}

////////////////////////////////////////////////////////////////////////////////
#else
////////////////////////////////////////////////////////////////////////////////

	function validateSize() {}

#end
}
