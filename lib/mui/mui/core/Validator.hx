package mui.core;

/**
	`Validator` defines a simple validation stack used as a singleton instance 
	by `Node`. Nodes are added to the stack by calling `invalidate(node)`. 
	During validation, nodes are validated in the order they were added to the 
	stack. As validating one `Node` could potentially invalidate others, the 
	stack is processed until its length reaches zero.
***/
class Validator
{
	/**
		A boolean indicating whether the validating is awaiting validation (has 
		added a listener to `mui.Lib.frameRendered`)
	**/
	var valid:Bool;

	/**
		The validation stack.
	**/
	var stack:Array<Node>;
	
	/**
		Creates a new `Validator` instance. Note that `Node` creates a 
		singleton instance of `Validator` at `Node.validator`.
	**/
	public function new():Void
	{
		valid = true;
		stack = [];
	}
	
	/**
		Adds a `Node` to the end of the validation stack.

		@param node The node to add to the stack.
	**/
	public function invalidate(node:Node):Void
	{
		stack.push(node);
		
		if (valid)
		{
			delayValidation();
			valid = false;
		}
	}

	/**
		Validates the validation stack and any additional nodes invalidated 
		while doing so. Note that validate is called automatically before the 
		next frame, but can be called directly to force immediate validation.
	**/
	public function validate():Void
	{
		while (stack.length > 0)
		{
			var node = stack.shift();
			node.validate();
		}
		
		valid = true;
	}

	/**
		Adds a `mui.Lib.frameRendered` listener to `validate`.
	**/
	function delayValidation()
	{
		mui.Lib.frameRendered.addOnce(validate);
	}
}
