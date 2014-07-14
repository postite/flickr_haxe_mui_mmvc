/**
	Helper methods for the JavaScript target.
**/
class JS
{
	static var prefix =  detectPrefix();

	/**
		Detects the current browser's vendor prefix.
	**/
	static function detectPrefix():String
	{
		var styles:String = untyped Array.prototype.slice.call(window.getComputedStyle(document.documentElement, "")).join('');

		var ereg = ~/-(moz|webkit|o|ms)-/;
		if (ereg.match(styles))
			return ereg.matched(1);
		// Cater for Presto based browser (ie. Opera 12.16 and below)
		else if (js.Browser.navigator.userAgent.toLowerCase().indexOf("presto")>=0)
			return "o";
		else
			return "";
	}

	/**
		Returns the vendor prefixed style name for `name`.

		ie. getPrefixedStyleName("transform") == "WebkitTransform"
	**/
	inline public static function getPrefixedStyleName(name:String):String
	{
		return prefix == "" ? name : prefix + name.charAt(0).toUpperCase() + name.substr(1);
	}

	/**
		Returns the vendor prefixed style name for `name`.

		ie. getPrefixedStyleName("transform") == "-webkit-transform"
	**/
	inline public static function getPrefixedCSSName(name:String):String
	{
		return prefix == "" ? name : "-" + prefix + "-" + name;
	}
}
