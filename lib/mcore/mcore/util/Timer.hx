/*
Copyright (c) 2012 Massive Interactive

Permission is hereby granted, free of charge, to any person obtaining a copy of 
this software and associated documentation files (the "Software"), to deal in 
the Software without restriction, including without limitation the rights to 
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
of the Software, and to permit persons to whom the Software is furnished to do 
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all 
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
SOFTWARE.
*/

package mcore.util;

import mcore.exception.IllegalOperationException;
import msignal.Signal;

#if haxe3
import haxe.ds.IntMap;
import haxe.ds.StringMap;
#else
private typedef IntMap<T> = IntHash<T>
private typedef StringMap<T> = Hash<T>
#end


/**
	Dispatches a ticked signal at set intervals indefinitely, or a defined number of times.

	If a finite number of ticks are requested then a completed signal will be fired once the 
	repeat count is met.

	A timer can be started, stopped and reset. Reset will stop the timer and set its tick count 
	back to 0.

	If you're targeting a language without a run loop (cpp, php, neko) then you'll need to call 
	the static Timer.tick() from your own run loop. Alternatively you can create and run a 
	msys.RunLoop at the start of your application which will handle this for you.

	If you're using NME then this class should work as is.
**/
class Timer
{
	#if (!nme && (sys||neko||cpp||php))
	/**
		Should be called once before any code is run.

		This allows an exception to be raised when Timers are created with nothing to process them.
	**/
	public static function activate()
	{
		timeKeeper.activated = true;
	}

	/**
		Should be called each frame from main run-loop.

		@return true if more timers are pending, false if not.
	**/
	public static function tick():Bool
	{
		return timeKeeper.tick();
	}
	#end

	static var timeKeeper:TimeKeeper = new TimeKeeper();

	/**
		Signal fired everytime the timer elapses its defined delay period.
	**/
	public var ticked(default, null):Signal0;
	
	/**
		Signal fired when a repeat count limit is in place and met.
	**/
	public var completed(default, null):Signal0;

	/**
		True if the timer is running, false if not.
	**/
	public var running(default, null):Bool;
	
	/**
		The delay between ticks in milliseconds.
	**/
	public var delay:Int;
	
	/**
		Number of iterations the timer should tick. A value of 0 will tick indefinitely. Default is 0.
	**/
	public var repeatCount:Int;
	
	/**
		The number of times the Timer has already ticked. Calling reset will set this back to 0.
	**/
	public var tickCount:Int;

	/**
		Create a new Timer instance.
		
		@param delay		length of time between ticks in milliseconds
		@param repeatCount	[optional] number of times to tick. Default is 0 which will run indefinitely.
	**/
	public function new(delay:Int, ?repeatCount:Int = 0)
	{
		this.delay = delay > 0 ? delay : 1;
		this.repeatCount = repeatCount < 0 ? 0 : repeatCount;
		tickCount = 0;
		running = false;
		ticked = new Signal0();
		completed = new Signal0();
	}

	/**
		Run a timer once, calling the handler once completed.
		
		@param handler	function to call when timer has completed
		@param delay		length of time to wait before calling the handler
		@return the timer instance which is now running
	**/
	public static function runOnce(handler:Void->Void, delay:Int):Timer
	{
		var timer = new Timer(delay, 1);
		timer.completed.addOnce(handler);
		timer.start();
		return timer;
	}

	/**
		Start the timer.
	**/
	public function start()
	{
		if (running)
			return;

		running = true;
		timeKeeper.add(this);
	}

	/**
		Stop the timer.
	**/
	public function stop()
	{
		if (!running)
			return;

		running = false;
		timeKeeper.remove(this);
	}

	/**
		Reset the timer. This stops it running and resets the tick count to 0.
	**/
	public function reset()
	{
		this.stop();
		tickCount = 0;
	}
}

#if (js || flash9 || flash)

private class TimeKeeper
{
	var timers:IntMap<Timer>;
	var clearInterval:Int->Void;
	var scope:Dynamic;
	#if js
	var isIE:Bool;
	#end

	public function new()
	{
		timers = new IntMap();
		#if js
		#if haxe3
		var w = js.Browser.window;
		#else
		var w = js.Lib.window;
		#end
		isIE = (w != null && w.navigator != null && w.navigator.userAgent.indexOf(" MSIE ") != -1);
		#end
	}

	public function add(timer:Timer)
	{
		var id:Null<Int> = null;

		#if js
		if (isIE) {
			var delegate = function(){ tick(timer); };
			id = untyped window.setInterval(delegate, timer.delay);
		}
		else {
			id = untyped window.setInterval(tick, timer.delay, timer);
		}
		#elseif (flash9)
		id = untyped __global__["flash.utils.setInterval"](tick, timer.delay, timer);
		#elseif flash
		id = untyped _global["setInterval"](tick, timer.delay, timer);
		#end

		if (id != null)
			timers.set(id, timer);
		else
			throw new mcore.exception.Exception("Failed to create timer interval id.");
	}

	public function remove(timer:Timer)
	{
		for (id in timers.keys())
		{
			if (timers.get(id) == timer)
			{
				timers.remove(id);
				#if js
				untyped window.clearInterval(id);
				#elseif (flash9 || nme)
				untyped __global__["flash.utils.clearInterval"](id);
				#elseif flash
				untyped _global["clearInterval"](id);
				#end
				break;
			}
		}
	}

	function tick(timer:Timer)
	{
		timer.tickCount++;
		timer.ticked.dispatch();

		if (timer.repeatCount > 0 && timer.tickCount >= timer.repeatCount)
		{
			timer.stop();
			timer.completed.dispatch();
		}
	}
}

#elseif (sys||neko||cpp||php)

#if (haxe_208 && !haxe_209)
typedef Sys =
	#if cpp
	cpp.Sys;
	#elseif neko
	neko.Sys;
	#elseif php
	php.Sys;
	#end
#end

private typedef TimerContext =
{
	var timer:Timer;
	var lastRun:Float;
}

private class TimeKeeper
{
	public var activated:Bool;

	var timers:Array<TimerContext>;

	public function new()
	{
		timers = [];
		activated = false;
		
		// Adding here so the Timer class will work with NME without any additional setup.
		// Is there a nicer way to plug into nme event loop? mike
		#if nme
			var ticker = new nme.utils.Timer(10);
			ticker.addEventListener(nme.events.TimerEvent.TIMER, onTick);
			ticker.start();
			activated = true;
		#elseif openfl
			var ticker = new flash.utils.Timer(10);
			ticker.addEventListener(flash.events.TimerEvent.TIMER, onTick);
			ticker.start();
			activated = true;
		#end
	}
	
	#if (nme || openfl)
	function onTick(e:Dynamic)
	{
		tick();
	}
	#end

	public function add(timer:Timer)
	{
		if (!activated)
			throw new IllegalOperationException("Attempting to create a Timer with no run-loop to process it");

		timers.push({timer:timer, lastRun:Sys.time() * 1000});
	}

	public function remove(timer:Timer)
	{
		var i = timers.length;
		while (i-- > 0)
		{
			if (timers[i].timer == timer)
			{
				timers.splice(i, 1);
				break;
			}
		}
	}

	public function tick()
	{
		if (timers.length == 0)
			return false;

		var now = Sys.time() * 1000;
		var runners = [];
		for (context in timers)
		{
			if ((now - context.lastRun) >= context.timer.delay)
			{
				context.lastRun = now;
				runners.push(context.timer);
			}
		}

		runners.sort(comparator); // make sure timers with shorter delay are executed 1st

		for (timer in runners)
		{
			timer.tickCount++;
			timer.ticked.dispatch();

			if (timer.repeatCount > 0 && timer.tickCount >= timer.repeatCount)
			{
				timer.stop();
				timer.completed.dispatch();
			}
		}

		return timers.length > 0;
	}

	function comparator(a:Timer, b:Timer):Int
	{
		return a.delay - b.delay;
	}
}
#end
