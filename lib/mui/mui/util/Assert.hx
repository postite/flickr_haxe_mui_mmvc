package mui.util;

/**
	A utility for making assertions about program state.

	Assertions are only executed when in debug mode, so as to reduce runtime 
	overhead in release programs.

	Example:
	
	```haxe
	mui.util.Assert.that(1 == 1, "one should certainly equal one!");
	```
**/
class Assert
{
	inline public static function that(expr:Bool, message:String)
	{
		#if debug
		if (!expr) throw "Assertion failed: " + message;
		#end
	}
}
