package mui.module.samsung;

import mconsole.Printer;

class ConsolePrinter implements Printer
{
	public function new() {}
	
	public function print(_, params, _, pos:haxe.PosInfos)
	{
		WebMAF.logTTY("|| "+pos.fileName + ":" + pos.lineNumber + ": " + params.join(" "));
	}
}
