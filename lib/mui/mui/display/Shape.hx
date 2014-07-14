package mui.display;

import mcore.util.Colors;

#if flash
import flash.display.Sprite;
import flash.display.CapsStyle;
import flash.display.LineScaleMode;
#end

/**
	A canvas-like drawing surface.
**/
class Shape extends Display
{
	@:set var commands:String;

	override public function new():Void
	{	
		super();
		
		commands = "";
	}
	
	override function change(flag:Dynamic)
	{
		super.change(flag);
		
		if (flag.commands) draw(flag);
	}
	
	#if (flash || openfl)
	
	function draw(flag)
	{		
		if (commands.length > 0)
		{
			var g = sprite.graphics;
			g.clear();
			var c = commands.split(" ");
			
			while (c.length > 0)
			{
				switch (c.shift())
				{
					case "M": // moveTo
					g.moveTo(Std.parseFloat(c.shift()), Std.parseFloat(c.shift()));

					case "L": // lineTo
					g.lineTo(Std.parseFloat(c.shift()), Std.parseFloat(c.shift()));
					
					case "BF":
					g.beginFill(Std.parseInt(c.shift()), Std.parseFloat(c.shift()));
					
					case "EF":
					g.endFill();
					
					case "LS": // lineStyle(thickness:Number = NaN, color:uint = 0, alpha:Number = 1.0, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String = null, joints:String = null, miterLimit:Number = 3):void
					g.lineStyle(Std.parseInt(c.shift()), Std.parseInt(c.shift()), Std.parseFloat(c.shift()));
					
					case "CT": // curveTo - curveTo(controlX:Number, controlY:Number, anchorX:Number, anchorY:Number):void
					g.curveTo(Std.parseFloat(c.shift()), Std.parseFloat(c.shift()), Std.parseFloat(c.shift()), Std.parseFloat(c.shift()));
				}
			}
		}
	}
	
	#elseif js
	
	override function createDisplay()
	{
		return js.Browser.document.createElement("canvas");
	}

	function draw(flag:Dynamic)
	{
		if (flag.width || flag.height || flag.left || flag.right || flag.top || flag.bottom)
		{
			if (!(Math.isNaN(width) || Math.isNaN(height)))
			{
				var canvas:Dynamic = element;
				canvas.width = width;
				canvas.height = height;
			}
		}
		
		if (commands.length > 0)
		{
			var ctx = untyped element.getContext("2d");
			untyped ctx.clearRect(0, 0, element.width, element.height);
			
			var c = commands.split(" ");
			var fill:Bool = false;
			var stroke:Bool = false;
			
			while (c.length > 0)
			{
				switch (c.shift())
				{
					case "M": // moveTo
						ctx.moveTo(Std.parseFloat(c.shift()), Std.parseFloat(c.shift()));

					case "L": // lineTo
						ctx.lineTo(Std.parseFloat(c.shift()), Std.parseFloat(c.shift()));
					
					case "BF":
						ctx.beginPath();
						ctx.fillStyle = Color.toRGBAStyle(Std.parseInt(c.shift()), Std.parseFloat(c.shift()));
						fill = true;
					
					case "EF":
						if (fill) ctx.fill();
						if (stroke) ctx.stroke();
						fill = false;
						stroke = false;
					
					case "LS":
						// no canvas for stroke type?
						ctx.shift();
						ctx.shift();
						ctx.shift();
						stroke = true;
						
					case "CT":
						ctx.quadraticCurveTo(Std.parseFloat(c.shift()), Std.parseFloat(c.shift()), Std.parseFloat(c.shift()), Std.parseFloat(c.shift()));
				}
			}
		}
	}
	
	#else
	
	function draw(flag:Dynamic) {}
	
	#end
}
