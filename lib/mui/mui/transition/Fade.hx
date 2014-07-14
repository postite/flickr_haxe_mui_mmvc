package mui.transition;

import msignal.Signal;
import mui.display.Display;
import mui.transition.Animation;

class Fade extends TAnimation<Fade>
{
	public var targetAlpha(get_targetAlpha, set_targetAlpha):Null<Float>;
	function get_targetAlpha() { return properties.alpha; }
	function set_targetAlpha(value:Float) { return properties.alpha = value; }

	public static inline function up(?settings:AnimationSettings):Fade
	{
		return new Fade(1, settings);
	}
	
	public static inline function down(?settings:AnimationSettings):Fade
	{
		return new Fade(0, settings);
	}
	
	public static inline function to(alpha:Float, ?settings:AnimationSettings)
	{
		return new Fade(alpha, settings);
	}
	
	private function new(alpha:Float, settings:AnimationSettings)
	{
		super({alpha:alpha}, settings);
	}
	
	public function from(alpha:Float):Fade
	{
		pre = function(view:Display)
		{
			view.alpha = alpha;
		}
		return this;
	}

	override function createCopy():Fade
	{
		return Fade.to(properties.alpha);
	}
}
