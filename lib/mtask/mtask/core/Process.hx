package mtask.core;

import mtask.core.Error;
import neko.vm.Thread;

/**
	A helper class for working with processes in mtask.
**/
class Process
{
	/**
		Execute a process and return its stdout or stderr (depending on the 
		process exit code)
	**/
	public static function run(cmd:String, ?args:Array<String>, ?print:Bool=true):String
	{
		if (args == null) args = [];
		if (print) Console.warn([cmd].concat(args).join(" "));
		
		// indent output
		if (print) untyped Console.groupDepth += 1;

		var process = new sys.io.Process(cmd, args);
		process.stdin.writeString("a\n");

		var output = "";
		var error = "";
		var exitCode = readSync(process, function (line) {
			output += line + "\n";
			if (print) trace(line);
		}, function (line) {
			error += line + "\n";
		});

		if (print) untyped Console.groupDepth -= 1;

		if (exitCode != 0)
		{
			error = StringTools.trim(error);
			error = error.split("\n").join("\n  ");
			throw new Error("Process '" + cmd + "' exited with code '" + exitCode + "':\n  " + error);
		}
		
		return StringTools.trim(output);
	}
 
	static function readSync(process:sys.io.Process, 
		onOutput:String -> Void, onError:String -> Void):Int
	{
		read(process.stdout, onOutput);
		read(process.stderr, onError);
		
		#if !macro
		Thread.readMessage(true);
		Thread.readMessage(true);
 		#end
 		
		return process.exitCode();
	}
 
	static function read(input:haxe.io.Input, output:String ->Void)
	{
		#if macro
		while (true) try output(input.readLine())
		catch (e:haxe.io.Eof) break;
		#else
		var thread = Thread.create(function(){
			var main = Thread.readMessage(true);
			while (true) try output(input.readLine())
			catch (e:haxe.io.Eof) break;
			main.sendMessage(true);
		});
		thread.sendMessage(Thread.current());
		#end
	}
}
