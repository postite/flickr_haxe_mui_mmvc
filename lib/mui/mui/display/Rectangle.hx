package mui.display;

/**
	A display that renders as a rectangle with fill, border and optional 
	rounded corners.

	Defines the properties used to style a rectangular area of the display. 
	The `fill` and `stroke` properties can be set to a `GraphicStyle` 
	implementation instance such as `Color`, `Bitmap` or `GradientColor`. 
	Corner radius can be set using the `radius` property, or individually 
	using the individual corner properties.
**/
class Rectangle extends Display
{
	var isRounded:Bool;
	var isComplex:Bool;
	
	public function new():Void
	{
		super();
		
		isRounded = false;
		isComplex = false;
		fill = null;
		stroke = null;
		strokeThickness = 0.0;
		radius = 0;
	}
	
	/**
		The style of the rectangle's fill.
	**/
	public var fill(default, set_fill):GraphicStyle;
	function set_fill(value:GraphicStyle):GraphicStyle
	{
		if (fill != null)
		{
			fill.changed.remove(fillChange);
		}
		
		fill = changeValue("fill", value);
		
		if (fill != null) 
		{
			fill.changed.add(fillChange);
		}
		
		return fill;
	}
	
	/**
		The style of the rectangle's stroke.
	**/
	public var stroke(default, set_stroke):GraphicStyle;
	function set_stroke(value:GraphicStyle):GraphicStyle
	{
		if (stroke != null)
		{
			stroke.changed.remove(strokeChange);
		}
		
		stroke = changeValue("stroke", value);
		
		if (stroke != null)
		{
			stroke.changed.add(strokeChange);
		}
		
		return stroke;
	}
	
	/**
		Determines the thickness of the stroke. Used in conjunction with the 
		stroke property.
	**/
	public var strokeThickness(default, set_strokeThickness):Float;
	function set_strokeThickness(value:Float):Float
	{
		value = Math.max(0, value);
		#if js childOffset = -Std.int(value); #end
		return strokeThickness = changeValue("strokeThickness", value);
	}
	
	
	/**
		Rounds the corners of a rectangle. The greater the radius, the rounder 
		the corners. The default value is 0 and the minimum value is 0.
	**/
	@:set('radiusTopLeft','radiusTopRight','radiusBottomLeft','radiusBottomRight') var radius:Float;
	
	/**
		Rounds only the top left corner of the rectangle. The default value is 
		0 and the minimum value is 0.
	**/
	@:set var radiusTopLeft:Float;

	/**
		Rounds only the top right corner of the rectangle. The default value is 
		0 and the minimum value is 0.
	**/
	@:set var radiusTopRight:Float;

	/**
		Rounds only the bottom left corner of the rectangle. The default value 
		is 0 and the minimum value is 0.
	**/
	@:set var radiusBottomLeft:Float;

	/**
		Rounds only the bottom right corner of the rectangle. The default value 
		is 0 and the minimum value is 0.
	**/
	@:set var radiusBottomRight:Float;
	
	#if uiml
	override public function setState(state:String):Void
	{
		super.setState(state);
		
		if (fill != null) fill.setState(state);
		if (stroke != null) stroke.setState(state);
	}
	#end
	
	function fillChange(flag:Dynamic)
	{
		invalidateProperty("fill");
	}
	
	function strokeChange(flag:Dynamic)
	{
		invalidateProperty("stroke");
	}
	
	override function change(flag:Dynamic):Void
	{
		super.change(flag);
		
		if (flag.radiusTopLeft || flag.radiusTopRight || flag.radiusBottomLeft || flag.radiusBottomRight)
		{
			flag.radius = true;
			isRounded = (flag.radiusTopLeft > 0 || flag.radiusTopRight > 0 || flag.radiusBottomLeft > 0 || flag.radiusBottomRight > 0);
			isComplex = !(radiusTopLeft == radiusTopRight && radiusTopLeft == radiusBottomLeft && radiusBottomLeft == radiusBottomRight);
		}
		
		draw(flag);
	}

////////////////////////////////////////////////////////////////////////////////
#if js
////////////////////////////////////////////////////////////////////////////////
	
	function draw(flag:Dynamic)
	{
		var minSize = Math.min(width, height);
		
		var strokeThickness = Math.min(this.strokeThickness, minSize * 0.5);
		var strokeThickness2 = strokeThickness * 2;
		
		var radius = Math.min(radiusTopLeft, minSize * 0.5);
		var radius2 = radius * 2;
		var fillRadius2 = Math.max(0, (radius - strokeThickness) * 2);
		
		if (flag.width || flag.height || flag.strokeThickness)
		{
			if (!(Math.isNaN(width) || Math.isNaN(height) || Math.isNaN(strokeThickness)))
			{
				element.style.width = width >= 0 ? Std.string(width - strokeThickness2) + "px" : null;
				element.style.height = height >= 0 ? Std.string(height - strokeThickness2) + "px" : null;
			}
		}
		
		if (flag.stroke || flag.strokeThickness)
		{
			if (strokeThickness > 0)
			{
				setStyle("borderStyle", "solid");
				setStyle("borderWidth", strokeThickness + "px");
				
				if (stroke != null)
				{
					stroke.applyStroke(this);
				}
				else
				{
					setStyle("borderColor", "transparent");
				}
			}
			else
			{
				setStyle("borderStyle", null);
				setStyle("borderWidth", null);
			}
		}
		
		if (flag.fill || flag.strokeThickness)
		{
			if (fill != null)
			{
				fill.applyFill(this);
			}
			else
			{
				setStyle("background", null);
			}
		}
		
		if (flag.radius || flag.width || flag.height)
		{
			if (isRounded)
			{
				if (isComplex)
				{
					var sl = Math.min(1, (height - strokeThickness) / (radiusTopLeft + radiusBottomLeft));
					var sr = Math.min(1, (height - strokeThickness) / (radiusTopRight + radiusBottomRight));
					var st = Math.min(1, (width - strokeThickness) / (radiusTopLeft + radiusTopRight));
					var sb = Math.min(1, (width - strokeThickness) / (radiusBottomLeft + radiusBottomRight));

					var tl = Math.floor(radiusTopLeft * Math.min(st, sl));
					var tr = Math.floor(radiusTopRight * Math.min(st, sr));
					var bl = Math.floor(radiusBottomLeft * Math.min(sb, sl));
					var br = Math.floor(radiusBottomRight * Math.min(sb, sr));

					var stl = (tl > 0 ? tl + "px" : null);
					var str = (tr > 0 ? tr + "px" : null);
					var sbl = (bl > 0 ? bl + "px" : null);
					var sbr = (br > 0 ? br + "px" : null);
					
					setStyle("borderTopLeftRadius", stl);
					setStyle("borderTopRightRadius", str);
					setStyle("borderBottomLeftRadius", sbl);
					setStyle("borderBottomRightRadius", sbr);
				}
				else
				{
					setStyle("borderRadius", radius + "px");
				}
			}
			else
			{
				setStyle("borderRadius", null);
			}
		}
	}

////////////////////////////////////////////////////////////////////////////////
#elseif (flash || openfl)
////////////////////////////////////////////////////////////////////////////////
	
	function draw(flag:Dynamic)
	{
		sprite.graphics.clear();
		
		var minSize = Math.min(width, height);
		
		var strokeThickness = Math.min(this.strokeThickness, minSize * 0.5);
		var strokeThickness2 = strokeThickness * 2;
		
		var radius = Math.min(radiusTopLeft, minSize * 0.5);
		var radius2 = radius * 2;
		var fillRadius2 = Math.max(0, (radius - strokeThickness) * 2);
		
		width = Math.isNaN(width) ? 0 : width;
		height = Math.isNaN(height) ? 0 : height;
		strokeThickness = Math.isNaN(strokeThickness) ? 0 : strokeThickness;
		strokeThickness2 = Math.isNaN(strokeThickness2) ? 0 : strokeThickness2;
		
		#if openfl
		// force software renderer in openfl for antialiased curves
		sprite.cacheAsBitmap = isRounded;
		#end

		if (isRounded)
		{
			if (isComplex)
			{
				var sl = Math.min(1, (height - strokeThickness) / (radiusTopLeft + radiusBottomLeft));
				var sr = Math.min(1, (height - strokeThickness) / (radiusTopRight + radiusBottomRight));
				var st = Math.min(1, (width - strokeThickness) / (radiusTopLeft + radiusTopRight));
				var sb = Math.min(1, (width - strokeThickness) / (radiusBottomLeft + radiusBottomRight));
				
				var tl = Math.floor(radiusTopLeft * Math.min(st, sl));
				var tr = Math.floor(radiusTopRight * Math.min(st, sr));
				var bl = Math.floor(radiusBottomLeft * Math.min(sb, sl));
				var br = Math.floor(radiusBottomRight * Math.min(sb, sr));
		
				if (stroke != null && strokeThickness > 0)
				{
					stroke.beginStroke(this);
					
					#if openfl
					sprite.graphics.drawRoundRect(0, 0, width, height, tl);
					sprite.graphics.drawRoundRect(strokeThickness, strokeThickness, width - strokeThickness2, height - strokeThickness2, Math.max(tl - strokeThickness, 0));
					#else
					sprite.graphics.drawRoundRectComplex(0, 0, width, height, tl, tr, bl, br);
					sprite.graphics.drawRoundRectComplex(strokeThickness, strokeThickness, width - strokeThickness2, height - strokeThickness2,
						Math.max(tl - strokeThickness, 0),
						Math.max(tr - strokeThickness, 0),
						Math.max(bl - strokeThickness, 0),
						Math.max(br - strokeThickness, 0));
					#end
					
					sprite.graphics.endFill();
				}

				if (fill != null)
				{
					fill.beginFill(this);
					
					#if openfl
					drawRoundRectComplex(strokeThickness, strokeThickness, width - strokeThickness2, height - strokeThickness2,
						Math.max(tl - strokeThickness, 0),
						Math.max(tr - strokeThickness, 0),
						Math.max(bl - strokeThickness, 0),
						Math.max(br - strokeThickness, 0));
					#else
					sprite.graphics.drawRoundRectComplex(strokeThickness, strokeThickness, width - strokeThickness2, height - strokeThickness2,
						Math.max(tl - strokeThickness, 0),
						Math.max(tr - strokeThickness, 0),
						Math.max(bl - strokeThickness, 0),
						Math.max(br - strokeThickness, 0));
					#end
					
					sprite.graphics.endFill();
				}
			}
			else
			{
				if (stroke != null && strokeThickness > 0)
				{
					stroke.beginStroke(this);
					
					sprite.graphics.drawRoundRect(0, 0, width, height, radius2, radius2);
					sprite.graphics.drawRoundRect(strokeThickness, strokeThickness, width - strokeThickness2, height - strokeThickness2, fillRadius2, fillRadius2);
					
					sprite.graphics.endFill();
				}

				if (fill != null)
				{
					fill.beginFill(this);
					
					sprite.graphics.drawRoundRect(strokeThickness, strokeThickness, width - strokeThickness2, height - strokeThickness2, fillRadius2, fillRadius2);
					
					sprite.graphics.endFill();
				}
			}
		}
		else
		{
			if (stroke != null && strokeThickness > 0)
			{
				stroke.beginStroke(this);
				
				sprite.graphics.drawRect(0, 0, width, height);
				sprite.graphics.drawRect(strokeThickness, strokeThickness, width - strokeThickness2, height - strokeThickness2);
				
				sprite.graphics.endFill();
			}

			if (fill != null)
			{
				fill.beginFill(this);
				
				sprite.graphics.drawRect(strokeThickness, strokeThickness, width - strokeThickness2, height - strokeThickness2);
				
				sprite.graphics.endFill();
			}
		}
	}

	#if openfl

	function drawRoundRectComplex(x:Float, y:Float, width:Float, height:Float, tl:Float, tr:Float, bl:Float, br:Float)
	{
		var graphics = sprite.graphics;
		graphics.moveTo(x+tl, y);

		graphics.lineTo(x+width-tr, y);
		drawArc(x+width-tr, y+tr, tr, -Math.PI/2, 0, false);

		graphics.lineTo(x+width, y+height-br);
		drawArc(x+width-br, y+height-br, br, 0, Math.PI/2, false);

		graphics.lineTo(x+bl, y+height);
		drawArc(x+bl, y+height-bl, bl, Math.PI/2, Math.PI, false);

		graphics.lineTo(x, y+tl);
		drawArc(x+tl, y+tl, tl, -Math.PI, -Math.PI/2, false);
	}

	function drawArc(x:Float, y:Float, radius:Float, startAngle:Float, endAngle:Float, ccw:Bool)
	{
		var graphics = sprite.graphics;
		var arcAngle = Math.abs(startAngle - endAngle);
		var segs = Math.ceil(arcAngle / (Math.PI/4)); // 45 deg segments
		var segAngle = arcAngle / segs;

		var theta = segAngle;
		if (ccw) theta = -theta;
		var theta2 = theta * 0.5;
		var angle = startAngle;

		var ax = x + Math.cos(angle) * radius;
		var ay = y + Math.sin(angle) * radius;

		if (segs > 0)
		{
			for (i in 0...segs)
			{
				// increment our angle
				angle += theta;

				// find the angle halfway between the last angle and the new
				var angleMid = angle - theta2;

				// calculate our end point
				var bx = x + Math.cos(angle) * radius;
				var by = y + Math.sin(angle) * radius;

				// calculate our control point
				var cx = x + Math.cos(angleMid) * (radius / Math.cos(theta2));
				var cy = y + Math.sin(angleMid) * (radius / Math.cos(theta2));

				// draw the arc segment
				graphics.curveTo(cx, cy, bx, by);
			}
		}
	}

	#end

////////////////////////////////////////////////////////////////////////////////
#else
////////////////////////////////////////////////////////////////////////////////

	function draw(flag:Dynamic) {}

#end
}
