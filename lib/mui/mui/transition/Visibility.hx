package mui.transition;

import msignal.Signal;
import mui.display.Display;

class Visibility implements Transition<Visibility>
{
	public var completed:Signal0;
	public var pre(default, set_pre):Display->Void;
	function set_pre(value:Display->Void)
	{
		if (pre != null)
		{
			var outer = pre;
			pre = function(view) { outer(view); value(view); }
		}
		else
		{
			pre = value;
		}
		return pre;
	}
	
	public var post(default, set_post):Display->Void;
	function set_post(value:Display->Void)
	{
		if (post != null)
		{
			var outer = post;
			post = function(view) { outer(view); value(view); }
		}
		else
		{
			post = value;
		}
		return post;
	}
	
	public var visible:Null<Bool>;
	
	public static function on():Visibility
	{
		return new Visibility(true);
	}
	
	public static function off():Visibility
	{
		return new Visibility(false);
	}
	
	public static function toggle():Visibility
	{
		return new Visibility(null);
	}

	private function new(visible:Null<Bool>)
	{
		this.visible = visible;
		completed = new Signal0();
	}

	public function apply(view:Display):Visibility
	{
		if (pre != null)
			pre(view);
		view.visible = visible == null ? !view.visible : visible;
		
		if (post != null)
			post(view);

		completed.dispatch();
		return this;
	}
	public function copy():Visibility
	{
		return new Visibility(visible);
	}
}
