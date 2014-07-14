package mui.transition;

import msignal.Signal;

#if frameTween
typedef Tween = FrameTween;

class FrameTween
{
	public static inline function easeNone(t:Float, b:Float, c:Float, d:Float):Float
	{
		return Ease.none(t, b, c, d);
	}

	public static inline function easeInQuad(t:Float, b:Float, c:Float, d:Float):Float
	{
		return Ease.inQuad(t, b, c, d);
	}

	public static inline function easeOutQuad(t:Float, b:Float, c:Float, d:Float):Float
	{
		return Ease.outQuad(t, b, c, d);
	}

	public static inline function easeInOutQuad(t:Float, b:Float, c:Float, d:Float):Float
	{
		return Ease.inOutQuad(t, b, c, d);
	}

	public static inline function easeInBounce(t:Float, b:Float, c:Float, d:Float):Float
	{
		return Ease.inBounce(t, b, c, d);
	}

	public static inline function easeOutBounce(t:Float, b:Float, c:Float, d:Float):Float
	{
		return Ease.outBounce(t, b, c, d);
	}

	public static inline function easeInOutBounce(t:Float, b:Float, c:Float, d:Float):Float
	{
		return Ease.inOutBounce(t, b, c, d);
	}

	public static inline function easeInCubic(t:Float, b:Float, c:Float, d:Float):Float
	{
		return Ease.inCubic(t, b, c, d);
	}

	public static inline function easeOutCubic(t:Float, b:Float, c:Float, d:Float):Float
	{
		return Ease.outCubic(t, b, c, d);
	}

	public static inline function easeInOutCubic(t:Float, b:Float, c:Float, d:Float):Float
	{
		return Ease.inOutCubic(t, b, c, d);
	}

	private static var tweens:Array<Tween> = new Array<Tween>();

	// properties
	public var target:Dynamic;
	public var start:Dynamic;
	public var change:Dynamic;
	public var properties:Dynamic;

	// settings
	public var frame:Int;
	public var frames:Int;
	public var easing:Dynamic;

	// callbacks
	public var onUpdate:Dynamic;
	public var onComplete:Dynamic;
	public var onCompleteParams:Dynamic;
	public var onCancelled:Dynamic;

	public function new(target:Dynamic, properties:Dynamic, ?settings:Dynamic)
	{
		var sharedTargets:Array<Tween> = [];
		for (tween in tweens)
		{
			if (tween.target == target)
				sharedTargets.push(tween);
		}

		tweens.push(this);
		frames = 12;

		this.target = target;
		this.properties = properties;

		start = {};
		change = {};

		for (property in Reflect.fields(properties))
		{
			// cancel any active tween which shares the same target and property
			var i = sharedTargets.length;
			while (i-- > 0)
			{
				var tween = sharedTargets[i];
				if (Reflect.hasField(tween.properties, property))
				{
					tween.cancel();
					sharedTargets.splice(i, 1);
				}
			}

			Reflect.setField(start, property, Std.parseFloat(Reflect.field(target, property)));
			Reflect.setField(change, property, Reflect.field(properties, property) - Reflect.field(target, property));
		}

		if (settings != null)
		{
			for (property in Reflect.fields(settings))
			{
				Reflect.setField(this, property, Reflect.field(settings, property));
			}
		}

		if (easing == null) easing = easeNone;
		mui.Lib.frameEntered.add(update);
	}

	public function cancel():Void
	{
		stop();

		if (onCancelled != null)
			onCancelled();
	}

	function stop()
	{
		tweens.remove(this);
		mui.Lib.frameEntered.remove(update);	
	}

	function update():Void
	{
		if (++frame > 0)
		{
			var position:Float = easing(frame, 0, 1, frames);

			for (property in Reflect.fields(start))
			{
				var value:Float = Reflect.field(start, property) + Reflect.field(change, property) * position;
				Reflect.setProperty(target, property, value);
			}

			if (onUpdate != null) onUpdate();
		}

		if (frame >= frames)
		{
			stop();
			if (onComplete != null)
			{
				if (onCompleteParams != null)
				{
					onComplete(onCompleteParams);
				}
				else
				{
					onComplete();
				}
			}
		}
	}
}



#else
typedef Tween = TimeTween;

class TimeTween
{
	public static inline function easeNone(t:Float, b:Float, c:Float, d:Float):Float
	{
		return Ease.none(t, b, c, d);
	}
	
	public static inline function easeInQuad(t:Float, b:Float, c:Float, d:Float):Float
	{
		return Ease.inQuad(t, b, c, d);
	}
	
	public static inline function easeOutQuad(t:Float, b:Float, c:Float, d:Float):Float
	{
		return Ease.outQuad(t, b, c, d);
	}
	
	public static inline function easeInOutQuad(t:Float, b:Float, c:Float, d:Float):Float
	{
		return Ease.inOutQuad(t, b, c, d);
	}
	
	public static inline function easeInBounce(t:Float, b:Float, c:Float, d:Float):Float
	{
		return Ease.inBounce(t, b, c, d);
	}

	public static inline function easeOutBounce(t:Float, b:Float, c:Float, d:Float):Float
	{
		return Ease.outBounce(t, b, c, d);
	}
	
	public static inline function easeInOutBounce(t:Float, b:Float, c:Float, d:Float):Float
	{
		return Ease.inOutBounce(t, b, c, d);
	}
	
	public static inline function easeInCubic(t:Float, b:Float, c:Float, d:Float):Float
	{
		return Ease.inCubic(t, b, c, d);
	}

	public static inline function easeOutCubic(t:Float, b:Float, c:Float, d:Float):Float
	{
		return Ease.outCubic(t, b, c, d);
	}

	public static inline function easeInOutCubic(t:Float, b:Float, c:Float, d:Float):Float
	{
		return Ease.inOutCubic(t, b, c, d);
	}
	
	public static function getActiveTweens()
	{
		return tweens;
	}

	public static function updateActiveTweens()
	{
		frameTime = haxe.Timer.stamp();
		for(tween in tweens)
		{
			tween.update();
		}
	}

	public static var defaultDuration:Int = 500;
	public static var fps:Int = 24;
   
	static var frameTime:Float;

	public static var renderFrame:Signal0 =  mui.Lib.frameEntered;
	private static var tweens:Array<Tween> = new Array<Tween>();

	static function addTween(tween:Tween)
	{
		if(tweens.length == 0) renderFrame.add(updateActiveTweens);
		tweens.push(tween);
	}

	static function removeTween(tween:Tween)
	{
		tweens.remove(tween);
		if(tweens.length == 0) renderFrame.remove(updateActiveTweens);
	}

	// properties
	public var target:Dynamic;
	public var start:Dynamic;
	public var change:Dynamic;
	public var properties:Dynamic;

	// settings
	public var frame:Null<Int>;
	public var frames:Null<Int>;
	public var easing:Dynamic;
	public var duration:Float;

	var delay:Int;
	var startTime:Float;
	var elapsedTime:Float;

	// callbacks
	public var onUpdate:Dynamic;
	public var onComplete:Dynamic;
	public var onCompleteParams:Dynamic;
	public var onCancelled:Dynamic;

	public function new(target:Dynamic, properties:Dynamic, ?settings:Dynamic)
	{
		var sharedTargets:Array<Tween> = [];
		for (tween in tweens)
		{
			if (tween.target == target)
				sharedTargets.push(tween);
		}

		addTween(this);
		duration = defaultDuration;

		this.target = target;
		this.properties = properties;

		start = {};
		change = {};

		for (property in Reflect.fields(properties))
		{
			// cancel any active tween which shares the same target and property
			var i = sharedTargets.length;
			while (i-- > 0)
			{
				var tween = sharedTargets[i];
				if (Reflect.hasField(tween.properties, property))
				{
					tween.cancel();
					sharedTargets.splice(i, 1);
				}
			}

			Reflect.setField(start, property, Std.parseFloat(Reflect.field(target, property)));
			Reflect.setField(change, property, Reflect.field(properties, property) - Reflect.field(target, property));
		}

		if (settings != null)
		{
			for (property in Reflect.fields(settings))
			{
				Reflect.setField(this, property, Reflect.field(settings, property));
			}
		}

		if (easing == null) easing = easeNone;
		if (frames != null) duration = Math.round((frames / fps) * 1000);
		if (frame != null) delay = Math.round((-frame / fps) * 1000);
		if (!(delay > 0)) delay = 0;
		
		startTime = timeStamp();
	}

	public function cancel():Void
	{
		stop();

		if (onCancelled != null)
			onCancelled();
	}

	function stop()
	{
		removeTween(this);
	}

	public function update():Void
	{
		// TODO (alex.syed) perhaps this should be done in DisplayRoot to be more efficient.
		elapsedTime = timeStamp() - (startTime + delay);
		if (elapsedTime < 0)
			return;
		
		if(elapsedTime < duration)
		{
			var position:Float = easing(elapsedTime, 0, 1, duration);

			for (property in Reflect.fields(start))
			{
				var value:Float = Reflect.field(start, property) + Reflect.field(change, property) * position;
				Reflect.setProperty(target, property, value);
			}

			if (onUpdate != null) onUpdate();
		}
		else
		{
			// set final position.
			var position:Float = easing(duration, 0, 1, duration);

			for (property in Reflect.fields(start))
			{
				var value:Float = Reflect.field(start, property) + Reflect.field(change, property) * position;
				Reflect.setProperty(target, property, value);
			}

			stop();
			if (onComplete != null)
			{
				if (onCompleteParams != null)
				{
					onComplete(onCompleteParams);
				}
				else
				{
					onComplete();
				}
			}
		}
	}

	static inline function timeStamp():Float
	{
		#if flash
		return flash.Lib.getTimer();
		#elseif js
		return Date.now().getTime();
		#elseif cpp
		return untyped __global__.__time_stamp() * 1000;
		#else
		return 0;
		#end
	}
}

#end
