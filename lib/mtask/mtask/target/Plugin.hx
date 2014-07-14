package mtask.target;

import mtask.target.Target;
import mtask.target.App;
import mtask.target.HaxeLib;
import mtask.target.HaxeDoc;
import mtask.target.XCross;
import mtask.target.Doc;
import mtask.target.Web;
import mtask.target.Flash;
import mtask.target.AIR;
import mtask.target.OpenFL;
import mtask.core.Module;
import mcore.util.Dynamics;

/**
	The target plugin, defining tasks for working with targets.
**/
class Plugin extends Module
{
	public var targets(default, null):Map<String, Target>;

	@target function haxelib(t:HaxeLib) {}
	@target function web(t:Web) {}
	@target function flash(t:Flash) {}
	@target function haxedoc(t:HaxeDoc) {}
	@target function xcross(t:XCross) {}
	@target function doc(t:Doc) {}
	@target function air(t:AIR) {}
	@target function openfl(t:OpenFL) {}
	
	public function new()
	{
		super();

		targets = new Map();
		
		moduleName = "target";

		build.options.addType(Target, function(id:String){
			return getTarget(id);
		});
	}

	override public function moduleAdded(module:Module)
	{
		if (!build.isProject) return;
		var typeMeta = haxe.rtti.Meta.getFields(Type.getClass(module));
		
		for (field in Reflect.fields(typeMeta))
		{
			var meta = Reflect.field(typeMeta, field);
			
			if (Reflect.hasField(meta, "target"))
			{
				var id = meta.target == null ? field : meta.target[0];
				var action = Reflect.field(module, field);
				var targetType = Type.resolveClass(meta.args[0]);
				var target:Target = Type.createInstance(targetType, []);
				target.id = id;
				targets.set(id, target);
				Reflect.callMethod(module, action, [target]);
			}
		}
	}

	/**
		Deletes the bin directory

		As targets are progressively compiled, cleaning a project ensures no 
		stale files exist in final build artifacts.
	**/
	@task function clean()
	{
		rm("bin");
	}

	/**
		Build a target
	**/
	@task("build") function buildRelease(target:Target, ?debug:Bool, ?rest:Dynamic)
	{
		target.debug = debug;
		if (rest != null) Dynamics.merge(target.config, rest);
		target.executeBuild(target.id);
	}

	/**
		Print a target's Haxe args
	**/
	@task function display(target:Target, file:String, ?hxml:Bool=false, ?debug:Bool, ?rest:Dynamic)
	{
		Console.removePrinter(Console.defaultPrinter);

		target.debug = debug;
		if (rest != null) Dynamics.merge(target.config, rest);
		var args = target.getHaxeFileArgs(file);
		if (hxml)
		{
			for (i in 0...args.length)
			{
				var arg = args[i];
				if (i > 0) Sys.print(arg.charAt(0) == '-' ? '\n' : ' ');
				Sys.print(arg);
			}
			Sys.print('\n');
		}
		else
		{
			args = args.map(function(arg) return ~/([()"',])/g.replace(arg, "\\$1"));
			Sys.println('haxe ' + args.join(' '));
		}

		Console.addPrinter(Console.defaultPrinter);
	}

	/**
		Build and run a target
	**/
	@task("run") function runRelease(target:Target, ?debug:Bool, ?rest:Dynamic)
	{
		target.debug = debug;
		if (rest != null) Dynamics.merge(target.config, rest);
		target.executeBuild(target.id);
		target.run();
	}

	/**
		List all targets
	**/
	@task("list:target") function listTarget()
	{
		for (target in targets.keys())
		{
			Console.log(target);
		}
	}

	function executeBuild(path:String, debug:Bool):Target
	{
		var target = getTarget(path);
		target.debug = debug;
		target.executeBuild(path);
		return target;
	}
	
	/**
		Returns a target based on it's path. First checks for an exact match, 
		then recursively checks for matches in each parent directory (in case 
		the path is part of another target). Finally we return an empty target.
	**/
	public function getTarget(path:String):Target
	{
		var parts = path.split("/");

		while (parts.length > 0)
		{
			var id = parts.join("/");

			if (targets.exists(id))
			{
				return targets.get(id);
			}

			parts.pop();
		}

		var target = new Target();
		target.id = path;
		target.flags.push(path);
		return target;
	}
}
