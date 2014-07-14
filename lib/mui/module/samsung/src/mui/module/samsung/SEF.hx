package mui.module.samsung;

#if !browser
extern
#end
class SEF
{
	public function new():Void {}

	public function Open(arg1:String, arg2:String, arg3:String):Bool { return true; }
	public function Execute(?arg1:Dynamic, ?arg2:Dynamic, ?arg3:Dynamic, ?arg4:Dynamic):Bool { return true; }
	public function Close():Bool { return true; }
}
