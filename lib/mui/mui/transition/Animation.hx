package mui.transition;

import msignal.Signal;
import mui.display.Display;
import mui.transition.Transition;

typedef Animation = TAnimation<TAnimation<Dynamic>>;

typedef AnimationSettings =
{
	@:optional var duration:Null<Int>;
	@:optional var delay:Null<Int>;
	@:optional var ease:Float->Float->Float->Float->Float;
}

class TAnimation<T:Dynamic> implements Transition<T>
{
	public var duration:Int;
	public var delay:Int;
	public var ease:Float->Float->Float->Float->Float;
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
	
	public var properties:Dynamic;
	public var completed:Signal0;
	
	var active:Array<Tween>;
	
	public static inline function parallel():Composite
	{
		return Composite.parallel();
	}

	public static inline function sequential():Composite
	{
		return Composite.sequential();
	}
	
	public static inline function create(properties:Dynamic, ?settings:AnimationSettings)
	{
		return new Animation(properties, settings);
	}
	
	private function new(properties:Dynamic, ?settings:AnimationSettings)
	{
		this.properties = properties == null ? {} : properties; // should probably create a copy here

		duration = Tween.defaultDuration;
		delay = 0;
		ease = Ease.none;
		
		// support the supply of settings as an object to make it easy to
		// create an animation in a single readable line of code.
		if (settings != null)
		{
			if (settings.duration != null)
				duration = settings.duration;
			if (settings.delay != null)
				delay = settings.delay;
			if (settings.ease != null)
				ease = settings.ease;
		}
		completed = new Signal0();
		active = [];
	}
	
	public function apply(view:Display):T
	{
		cancel(view);
		
		if (pre != null)
			pre(view);
		
		startAnimation(view);
		
		return untyped this; // once again working around issues with Haxe Type Parameters
	}
	
	function startAnimation(view:Display)
	{
		var settings:Dynamic = {
			duration:duration,
			delay:delay,
			easing:ease,
			onCancelled:animationCancelled.bind(view),
			onComplete:animationComplete,
			onCompleteParams:view
		};
		
		active.push(new Tween(view, properties, settings));
	}
	
	function animationCancelled(view:Display)
	{
		removeTween(view);
	}
	
	function animationComplete(view:Display)
	{
		removeTween(view);
		
		if (post != null)
			post(view);

		if (active.length == 0)
			completed.dispatch();
	}
	
	public function isActive(view:Display)
	{
		for (tween in active)
			if (tween.target == view)
				return true;
		return false;
	}
	
	public function cancel(view:Display)
	{
		var tween = removeTween(view);
		if (tween != null)
			tween.cancel();
	}

	function removeTween(view:Display):Tween
	{
		var i = active.length;
		while (i-- > 0)
			if (active[i].target == view)
				return active.splice(i, 1)[0];
		return null;
	}
	
	public function copy():T
	{
		var copy:Dynamic = createCopy();
		copy.duration = duration;
		copy.delay = delay;
		copy.ease = ease;
		return copy;
	}

	function createCopy():T
	{
		return cast new TAnimation<T>(mcore.util.Dynamics.copy(properties));
	}
}

class Composite implements Transition<Composite>
{
	public var isParallel:Bool;
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

	var transitions:Array<AnyTransition>;
	var completedCount:Int;
	var view:Display;

	public static function parallel():Composite
	{
		return new Composite(true);
	}

	public static function sequential():Composite
	{
		return new Composite(false);
	}
	
	private function new(?isParallel:Bool = true)
	{
		this.isParallel = isParallel;
		completed = new Signal0();
		transitions = [];
	}

	public function apply(view:Display):Composite
	{
		completedCount = 0;
		this.view = view;

		if (pre != null)
			pre(view);

		if (isParallel)
		{
			for (transition in transitions)
				transition.apply(view);
		}
		else
		{
			transitions[0].apply(view);
		}
		return this;
	}

	public function add(transition:AnyTransition):Composite
	{
		transitions.push(transition);
		transition.completed.add(onTranstionCompleted);

		return this;
	}

	function onTranstionCompleted()
	{
		if (++completedCount >= transitions.length)
		{
			if (post != null)
				post(view);
				
			view = null;
			completed.dispatch();
		}
		else if (!isParallel)
		{
			transitions[completedCount].apply(view);
		}
	}

	public function copy():Composite
	{
		var copy = new Composite(isParallel);
		for (transition in transitions)
			copy.add(transition.copy());
		return copy;
	}
}	
