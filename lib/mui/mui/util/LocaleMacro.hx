package mui.util;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
#end

/**
	A lightweight compiletime (macro based) localisation API.

	To defined a locale

	1. Add compliation flag -D locale_XX where XX is the required language
	2. Define a matching locale JSON resource file (e.g. resource/locale/XX.json)
	
	Note: limited support for a subset of english and european langauges. See getLocale();
	Usage:

	Example
	-------

	In source:
		
		using mui.util.LocalMacro
		...

		var label = "Hello".toLocaleString();


	In resource file (resource/locale/en_au.json)

		{
			"Hello":"G'day mate"
		}

	In resource file (resource/locale/en_us.json)

		{
			"Hello":"howdy Partner"
		}


	Defining locale in haxe compiler args

		-D locale_en_au
**/
class LocaleMacro
{
	@:IgnoreCover
	macro public static function toLocaleString(expr:Expr):Expr
	{
		if (strings == null) strings = loadLocale();

		var key = switch (expr.expr)
		{
			case EConst(c):
			switch (c)
			{
				case CString(s): s;
				default: "";
			}
			default: "";
		}

		var string = Reflect.hasField(strings, key) ? Reflect.field(strings, key) : key;
		expr.expr = EConst(CString(string));
		return expr;
	}

	#if macro
	static var locale = getLocale();
	static var strings:Dynamic;

	static function getLocale():String
	{
		
		if (Context.defined("locale_en")) return "en";
		if (Context.defined("locale_fr")) return "fr";
		if (Context.defined("locale_de")) return "de";
		if (Context.defined("locale_it")) return "it";
		if (Context.defined("locale_es")) return "es";

		if (Context.defined("locale_en-au")) return "en-au";
		if (Context.defined("locale_en-ca")) return "en-ca";
		if (Context.defined("locale_en-uk")) return "en-uk";
		if (Context.defined("locale_en-us")) return "en-us";
		if (Context.defined("locale_fr_ca")) return "fr-ca";
		
		return "en";
	}

	static function loadLocale():Dynamic
	{
		var path = "resource/locale/" + locale + ".json";
		#if haxe_209
			return sys.FileSystem.exists(path) ? haxe.Json.parse(sys.io.File.getContent(path)) : {};
		#else
			return {};
		#end
		
	}	
	#end
}
