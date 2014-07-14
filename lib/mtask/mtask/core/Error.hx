package mtask.core;

import haxe.CallStack;

/**
	Represents a known error state that should print a message and exit.

	When an error occurs in an mtask build, it is either an expected error (a compilation error in 
	a Haxe build, for example) or an unknown error (like a runtime error in the build itself). This 
	class is used to differentiate between these two states. Known errors print a short, 
	descriptive message to the user and exit the build. Unknown errors will print a complete 
	exception stack trace, and exit the build.

	When extending mtask, throw a known error like this:
	
	```haxe
	throw new mtask.core.Error("Something expected happened.");
	```

	All other exceptions will will display a stack trace:
	
	```haxe
	throw "Something unexpected happened";
	```
**/
class Error
{
	/**
		A standard error message trouble shooting plugin issues.
	**/
	public static var PLUGIN_ERROR = "Maybe you don't have a plugin active. "+
		"Run `mtask config plugin` to list plugins.\n"+
		"If the plugin is active, you might need to recompile with `mtask c`";
	
	var message:String;
	var stack:Array<StackItem>;

	/**
		Create a new error with message and optional exception stack.

		@param message A message describing the error.
		@param stack an optional stack trace from the source of the error.
	**/
	public function new(message:String, ?stack:Array<StackItem>)
	{
		if (stack == null) stack = [];
		this.message = message;
		this.stack = stack;
	}
	
	/**
		Returns a human readable string for `this`.
	**/
	public function toString()
	{
		return message;
	}
}
