package mtask.core;

import mtask.core.OptionParser;
import haxe.CallStack;

/**
	A mtask task instance, defining options, id and implementation.
	
	A task is a unit of work in an mtask build. Tasks are defined as instance 
	methods of modules, marked with the @task metadata. When the build 
	initializes, module fields are checked for metadata, and a task instance 
	is created for each field that is found. The task then uses additional 
	metadata generated by ModuleMacro to configure the behavior of the task.
**/
class Task
{
	static var depth = 0;
	
	var module:Module;
	var action:Dynamic;

	/**
		The id of the task.
	**/
	public var id(default, null):String;

	/**
		The options of the task.
	**/
	public var options(default, null):Array<Option>;

	/**
		A short description of the task.
	**/
	public var help(default, null):String;

	/**
		Detailed documentation for the task.
	**/
	public var docs(default, null):String;
	
	/**
		Creates a new task for the given module field.
	**/
	public function new(module:Module, field:String)
	{
		this.module = module;
		this.action = Reflect.field(module, field);

		var meta = Reflect.field(haxe.rtti.Meta.getFields(Type.getClass(module)), field);
		id = meta.task == null ? field : meta.task[0];
		docs = meta.docs == null ? "" : meta.docs[0];
		help = meta.help == null ? "" : meta.help[0];
		options = meta.options == null ? [] : meta.options;

		if (meta.man != null)
		{
			docs = meta.man[0];
			help = docs.split("\n")[0];
		}
	}
	
	/**
		Invokes the task with the provided argument string.
	**/
	public function invoke(taskArgs:Array<String>)
	{
		var args = module.build.options.parse(taskArgs, options);

		if (depth > 0) Console.group(taskArgs.join(" "));
		depth += 1;
		
		try
		{
			Reflect.callMethod(module, action, args);
			Console.groupEnd();
			depth -= 1;
		}
		catch (e:Error)
		{
			Console.groupEnd();
			depth -= 1;
			neko.Lib.rethrow(e);
		}
		catch (e:Dynamic)
		{
			Console.groupEnd();
			depth -= 1;

			var stack = CallStack.exceptionStack();
			var source = stack[0];
			stack.pop(); // anon function

			var message = switch (source)
			{
				case FilePos(_, file, line): file + ":" + line + ":" + " lines " + line + "-" + line + " : " + StringTools.trim(Std.string(e));
				default: "Unknown runtime error";
			}
			
			throw new Error("Runtime exception while executing task '" + id + "'\n" + message, stack);
		}
	}
}