package mtask.core;

/**
	Defines a task option, generated at compile time by `ModuleMacro`.
**/
typedef Option = {name:String, type:String, optional:Bool, defaultValue:Dynamic};

/**
	Parses command line arguments into task arguments.

	`OptionParser` parses a string into an array of arguments for a task method 
	based on an array of options.
**/
class OptionParser
{
	/**
		A Hash of named type resolvers. To add a resolver, call `addType`
	**/
	var resolvers:Map<String, String -> Dynamic>;

	/**
		Creates a new `OptionParser` instance
	**/
	public function new()
	{
		resolvers = new Map();
	}

	/**
		Parses a string command into an array of arguments for a `Task`.
	**/
	public function parse(args:Array<String>, options:Array<Option>):Array<Dynamic>
	{
		args = args.copy();
		var id = args.shift();
		var hash = new Map<String, Dynamic>();
		var strings = [];

		while (args.length > 0)
		{
			var arg = args.shift();

			if (arg.charAt(0) == "-")
			{
				var field = arg.substr(1, arg.length - 1);
				
				if (args.length > 0 && args[0].charAt(0) != "-")
				{
					hash.set(field, args.shift());
				}
				else
				{
					hash.set(field, true);
				}
			}
			else
			{
				strings.push(arg);
			}
		}

		var args:Array<Dynamic> = [];

		for (option in options)
		{
			var name = option.name;
			var value:Dynamic;

			if (hash.exists(name))
			{
				value = hash.get(name);
				hash.remove(name);
			}
			else
			{
				value = strings.shift();
			}

			if (value == null)
			{
				if (option.optional)
				{
					value = option.defaultValue;
				}
				else
				{
					error("The task " + id + " requires the option -" + option.name);
				}
			}
			switch (option.type)
			{
				case "String":
					if (value != null && !Std.is(value, String))
						error("The option -" + name + " should be of type String " + value);

				case "Bool":
					if (Std.is(value, String))
					{
						if (value == "true" || value == "false" || value == "1" || value == "0")
							value = (value == "true" || value == "1");
						else
							error("The option -" + name + " should be of type Bool " + value);
					}
				case "Int":
					if (Std.is(value, String)) value = Std.parseFloat(value);
					if (Math.isNaN(value)|| value % 1 != 0) error("The option -" + name + " " + value + " should be of type Int");
				case "Float":
					if (Std.is(value, String)) value = Std.parseFloat(value);
					if (Math.isNaN(value)) error("The option -" + name + " " + value + " should be of type Int");
				
				case "Array<String>":
					if (value != null)
						value = value.split(",");

				case "Array<Int>":
					if (value != null)
					{
						value = value.split(",");
						for (i in 0...value.length) value[i] = Std.parseInt(value[i]);
					}
					
				case "Array<Float>":
					if (value != null)
					{
						value = value.split(",");
						for (i in 0...value.length) value[i] = Std.parseFloat(value[i]);
					}
					
				case "Dynamic":
					if (name == "rest")
					{
						value = {};
						for (key in hash.keys())
						{
							Reflect.setField(value, key, hash.get(key));
							hash.remove(key);
						}
					}
				
				default:
					if (Std.is(value, String))
					{
						var resolved = resolveType(option.type, value);
						if (resolved == null) error("Could not resolve type " + option.type + " from string " + value);
						else value = resolved;
					}
			}

			args.push(value);
		}

		for (key in hash.keys())
			error("Unknown option '" + key + "' for task '" + id + "'");
		for (string in strings)
			error("Unknown option '" + string + "' for task '" + id + "'");

		return args;
	}

	/**
		Adds a type resolver to `this`.

		Custom types can be resolved by registering a callback that turns a string argument into 
		an instance of the type.

		For example, by registering `MyType`:

		```haxe
		build.options.addType(MyType, function(id) {
			// find the correct instance of MyType
			return typeMap.get(id);
		});
		```

		Calling a task expecting this custom type will invoke the callback and provide the 
		resolved value to the task:

		```haxe
		@task function deploy(type:MyType) {
			trace(type);
		}
		```

		Called from the command line with `mtask deploy id`.
	**/
	public function addType<T>(type:Dynamic, resolver:String -> T):Void
	{
		resolvers.set(getTypeName(type), resolver);
	}

	function getTypeName(type:Dynamic)
	{
		try { return Type.getEnumName(type); }
		catch (e:Dynamic)
		{
			try { return Type.getClassName(type); }
			catch (e:Dynamic)
			{
				throw "Cannot determine type name of " + type;
				return null;
			}
		}	
	}

	function resolveType(type:String, arg:String):Dynamic
	{
		if (resolvers.exists(type)) return resolvers.get(type)(arg);
		
		var typeClass = Type.resolveClass(type);
		if (typeClass == null) return null;
		
		var typeSuper = Type.getSuperClass(typeClass);
		while (typeSuper != null)
		{
			var nameSuper = Type.getClassName(typeSuper);
			if (resolvers.exists(nameSuper))
			{
				var resolved = resolvers.get(nameSuper)(arg);
				if (Std.is(resolved, typeClass))
				{
					return resolved;
				}
				else
				{
					error("Resolved option was of incorrect type '"+
						Type.getClassName(Type.getClass(resolved))+
						"', task expected '"+Type.getClassName(typeClass)+"'");
				}
			}
			typeSuper = Type.getSuperClass(typeSuper);
		}
		
		return null;
	}

	function error(message:String)
	{
		throw new Error(message);
	}
}
