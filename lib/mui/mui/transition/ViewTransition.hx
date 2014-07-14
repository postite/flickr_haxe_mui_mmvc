package mui.transition;

import haxe.ds.StringMap;

import mui.layout.Direction;
import mui.transition.Animation;
import msignal.Signal;
import mui.display.Display;
import mui.transition.Transition;

class ViewTransition
{
	public static function fade(?settings:AnimationSettings):ViewTransition
	{
		return new ViewTransition(Fade.up(settings).from(0), Fade.down(settings));
	}

	public static function slide(direction:Direction, ?settings:AnimationSettings):ViewTransition
	{
		return new ViewTransition(Slide.on(direction, settings), Slide.off(direction, settings));
	}
	
	public static function visibility():ViewTransition
	{
		return new ViewTransition(Visibility.on(), Visibility.off());
	}

	public var transitionInCompleted(get_transitionInCompleted, null):Signal0;
	function get_transitionInCompleted():Signal0 { return inTransition.completed; }
	
	public var transitionOutCompleted(get_transitionOutCompleted, null):Signal0;
	function get_transitionOutCompleted():Signal0 { return outTransition.completed; }

	public var inTransition(default, null):AnyTransition;
	public var outTransition(default, null):AnyTransition;
	
	public function new(inTransition:AnyTransition, outTransition:AnyTransition)
	{
		this.inTransition = inTransition;
		this.outTransition = outTransition; 
	}
	
	public function transitionIn(view:Display):Void
	{
		inTransition.apply(view);
	}
	
	public function transitionOut(view:Display):Void
	{
		outTransition.apply(view);
	}
}

class TransitionMap
{
	var hash:StringMap<ViewTransition>;

	public function new()
	{
		hash = new StringMap();
	}

	public function exists(key:Dynamic):Bool
	{
		return hash.exists(getKey(key));
	}
	
	inline function getKey(key:Dynamic):String
	{
		return Std.string(key);
	}

	public function get(key:Dynamic):ViewTransition
	{
		return hash.get(getKey(key));
	}

	public function set(key:Dynamic, viewTransition:ViewTransition)
	{
		hash.set(getKey(key), viewTransition);
	}

	public function remove(key:Dynamic)
	{
		var k = getKey(key);
		if (hash.exists(k)) 
			hash.remove(k);
	}
	
	public function clear()
	{
		hash = new StringMap();
	}

	public function iterator(): Iterator<ViewTransition>
	{
		return hash.iterator();
	}
}
