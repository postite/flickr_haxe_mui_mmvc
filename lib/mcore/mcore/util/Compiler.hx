package mcore.util;

class Compiler
{
	/**
		Prints a compiler warning indicating a method or class is deprecated.
	**/
	#if haxe3 macro #else @:macro #end
	public static function deprecated(message:String) 
	{
		var clazz:String = haxe.macro.Context.getLocalClass().get().name;
		var method:String = haxe.macro.Context.getLocalMethod();

		var location:String = clazz;

		if(method != "new") location += "." + method;

		haxe.macro.Context.warning(location + " is deprecated. " + message, haxe.macro.Context.currentPos());

		return haxe.macro.Context.makeExpr("@deprecated", haxe.macro.Context.currentPos());
	}

	/**
		Prints a compiler warning indicating an API is not supported on the current platform
		
		This can be used to highlight behaviours due to inconsistencies with the Haxe APIs on a 
		specific platform(s)
	**/
	#if haxe3 macro #else @:macro #end
	public static function unsupported(message:String) 
	{
		var clazz:String = haxe.macro.Context.getLocalClass().get().name;
		var method:String = haxe.macro.Context.getLocalMethod();

		var location:String = clazz;

		if(method != "new") location += "." + method;

		haxe.macro.Context.warning(location + " is not supported on the current platform. " + message, haxe.macro.Context.currentPos());

		return haxe.macro.Context.makeExpr("@unsupported", haxe.macro.Context.currentPos());
	}
}