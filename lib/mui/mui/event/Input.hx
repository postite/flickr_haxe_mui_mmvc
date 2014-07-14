package mui.event;

import msignal.Signal;
import msignal.EventSignal;
import mui.display.Display;

class Input
{
	public static var mode(default, null):InputMode;
	public static var modeChanged = new Signal0();
	
	public static function setMode(value:InputMode)
	{
		if (value == mode) return;
		mode = value;
		modeChanged.dispatch();
	}
	
	public var captured:Signal1<Dynamic>;
	public var updated:Signal1<Dynamic>;
	public var completed:Signal1<Dynamic>;
	
	public var target:Display;
	public var bubbles:Bool;
	public var isCaptured:Bool;
	
	public function new()
	{
		bubbles = true;
		captured = new Signal1<Input>(Input);
		updated = new Signal1<Input>(Input);
		completed = new Signal1<Input>(Input);
		
		isCaptured = false;
	}
	
	public function capture()
	{
		if (isCaptured) return;
		isCaptured = true;
		captured.dispatch(this);
	}
	
	public function update()
	{
		updated.dispatch(this);
	}
	
	public function complete()
	{
		completed.dispatch(this);
		
		captured.removeAll();
		updated.removeAll();
		completed.removeAll();
	}
}

enum InputMode
{
	TOUCH;
	KEY;
}