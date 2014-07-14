package mtask.tool;

import sys.io.Process;

typedef Version =
{
	var major:Int;
	var minor:Int;
	var patch:String;
}

class Haxe
{
	/**
		Return the version of Haxe in use.
	*/
	public static var version(get_version, null):Version;
	static function get_version():Version
	{
		if (version == null)
		{
			// pre 3.0 there was no -version option so we need to parse it from help page
			var v = mtask.core.Process.run("haxe", ["-help"], false);

			// for some reason haxe 3.0 prints help page to stderr so we now 
			// try '-version' if we didn't get back anything from last command
			if (v == "")
			{
				v = mtask.core.Process.run("haxe", ["-version"], false);
			}
			else
			{
				v = v.substr(14, v.indexOf("-") - 15);
			}

			var parts = v.split(".");

			version = {
				major: Std.parseInt(parts[0]),
				minor: Std.parseInt(parts[1]),
				patch: (parts.length > 2) ? parts[2] : "0"
			};
		}
		return version;
	}
	
	public static function command(args:Array<String>):String
	{
		if (serverThread != null)
		{
			// use Haxe server if it is running
			args.push("--connect");
			args.push(Std.string(serverPort));
		}

		return mtask.core.Process.run("haxe", args);
	}

	/**
		Filters a Haxe 'types' xml on the path of each type.

		`filters` should be an array of strings to match against the beginning of 
		each type path. eg ["mmvc","msignal","Array","List"]
	**/
	public static function filterXml(path:String, filters:Array<String>):Void
	{
		var types = Xml.parse(msys.File.read(path));

		var filtered = Xml.createDocument();
		var root = Xml.createElement("haxe");
		filtered.addChild(root);

		for (element in types.firstElement().elements())
		{
			var path = element.get("path");

			for (filter in filters)
			{
				if (path.indexOf(filter) == 0)
				{
					root.addChild(element);
					break;
				}
			}
		}

		msys.File.write(path, filtered.toString());
	}

	//-------------------------------------------------------------------------- server

	/**
		The Haxe server thread.
	**/
	static var serverThread:neko.vm.Thread;

	/**
		The port to run the Haxe server on.
	**/
	public static var serverPort:Int = 4444;

	/**
		Starts the Haxe server if it is not already running.
	**/
	public static function startServer()
	{
		if (serverThread == null)
		{
			serverThread = neko.vm.Thread.create(serverMain);
		}
	}

	/**
		Stops the Haxe server if it is not already running.
	**/
	public static function stopServer()
	{
		if (serverThread != null)
		{
			serverThread.sendMessage(1);
			serverThread = null;
		}
	}

	/**
		The server thread entry point.
	**/
	static function serverMain()
	{
		Console.warn("haxe --wait " + serverPort);
		var process = new Process("haxe", ["--wait", Std.string(serverPort)]);
		if (neko.vm.Thread.readMessage(true)) process.kill();
	}
}
