package mui.display;

/**
	A color stop in a `Gradient`.

	It contains the hexadecimal color, an alpha property and the position of 
	the stop.
**/
class GradientColor extends Color
{
	/**
		@param value The hexadecimal color.
		@param alpha An alpha/transparency value. The value ranges between 0 
			and 1. 1 is the default.
		@param position The position of the color stop. The value ranges 
			between 0 and 1. 0 is the default.
	**/
	public function new(?value:Int, ?alpha:Float=1.0, ?position:Float=0.0):Void
	{
		super(value, alpha);
		
		this.position = 0.0;
		this.position = position;
	}
	
	/**
		The position of the color stop. The value ranges between 0 and 1. 
		0 is the default.
	**/
	@:set var position:Float;
}