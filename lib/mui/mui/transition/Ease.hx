package mui.transition;

class Ease
{
	public static function none(t:Float, b:Float, c:Float, d:Float):Float
	{
		return c * t / d + b;
	}

	public static function inQuad(t:Float, b:Float, c:Float, d:Float):Float
	{
		return c * (t /= d) * t + b;
	}

	public static function outQuad(t:Float, b:Float, c:Float, d:Float):Float
	{
		return -c * (t /= d) * (t - 2) + b;
	}

	public static function inOutQuad(t:Float, b:Float, c:Float, d:Float):Float
	{
		if ((t /= d / 2) < 1) return c / 2 * t * t + b;
		return -c / 2 * ((--t) * (t - 2) - 1) + b;
	}

	public static function inBounce(t:Float, b:Float, c:Float, d:Float):Float
	{
		return c - Tween.easeOutBounce(d-t, 0, c, d) + b;
	}

	public static function outBounce(t:Float, b:Float, c:Float, d:Float):Float
	{
		if ((t/=d) < (1/2.75)) {
			return c*(7.5625*t*t) + b;
		} else if (t < (2/2.75)) {
			return c*(7.5625*(t-=(1.5/2.75))*t + .75) + b;
		} else if (t < (2.5/2.75)) {
			return c*(7.5625*(t-=(2.25/2.75))*t + .9375) + b;
		} else {
			return c*(7.5625*(t-=(2.625/2.75))*t + .984375) + b;
		}
	}

	public static function inOutBounce(t:Float, b:Float, c:Float, d:Float):Float
	{
		if (t < d/2) return Tween.easeInBounce(t*2, 0, c, d) * .5 + b;
		return Tween.easeOutBounce(t*2-d, 0, c, d) * .5 + c*.5 + b;
	}

	public static function inCubic(t:Float, b:Float, c:Float, d:Float):Float
	{
		return c*(t/=d)*t*t + b;
	}

	public static function outCubic(t:Float, b:Float, c:Float, d:Float):Float
	{
		return c*((t=t/d-1)*t*t + 1) + b;
	}

	public static function inOutCubic(t:Float, b:Float, c:Float, d:Float):Float
	{
		if ((t/=d/2) < 1) return c/2*t*t*t + b;
		return c/2*((t-=2)*t*t + 2) + b;
	}
}
