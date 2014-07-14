package mui.input;

import mui.event.Key;
import mui.core.Skin;
import mui.core.Component;

class RangeInput extends NumberInput
{
	public function new(?skin:Skin<RangeInput>)
	{
		super(skin);
		
		singleStep = 0.1;
		pageStep = 1;
		tracking = true;
		sliderPosition = 0;
		sliderDown = false;		
		useHandCursor = true;
	}
	
	/**
		This property holds the single step.
		
		The smaller of two natural steps that an abstract sliders provides and 
		typically corresponds to the user pressing an arrow key.
		
		If the property is modified during an auto repeating key event, 
		behavior is undefined.
	**/
	public var singleStep(default, set_singleStep):Float;
	function set_singleStep(value:Float):Float { return singleStep = changeValue("singleStep", value); }
	
	/**
		This property holds the page step.
		
		The larger of two natural steps that an abstract slider provides and 
		typically corresponds to the user pressing PageUp or PageDown.
	**/
	public var pageStep(default, set_pageStep):Float;
	function set_pageStep(value:Float):Float { return pageStep = changeValue("pageStep", value); }
	
	/**
		This property holds whether slider tracking is enabled.
		
		If tracking is enabled (the default), the slider emits the 
		valueChanged() signal while the slider is being dragged. If tracking is 
		disabled, the slider emits the valueChanged() signal only when the user 
		releases the slider.
	**/
	public var tracking(default, set_tracking):Bool;
	function set_tracking(value:Bool):Bool { return tracking = changeValue("tracking", value); }
	
	/**
		This property holds the current slider position.
		
		If tracking is enabled (the default), this is identical to value.
	**/
	public var sliderPosition(default, set_sliderPosition):Float;
	function set_sliderPosition(value:Float):Float { return sliderPosition = changeValue("sliderPosition", value); }
	
	/**
		This property holds whether the slider is pressed down.
		
		The property is set by subclasses in order to let the abstract slider 
		know whether or not tracking has any effect.
	**/
	public var sliderDown(default, set_sliderDown):Bool;
	function set_sliderDown(value:Bool):Bool { return sliderDown = changeValue("sliderDown", value); }
	
	public function triggerAction(action:SliderAction):Void
	{
		switch (action)
		{
			case SliderNoAction:
			null;
			case SliderSingleStepAdd:
			data += singleStep;
			case SliderSingleStepSub:
			data -= singleStep;
			case SliderPageStepAdd:
			data += pageStep;
			case SliderPageStepSub:
			data -= pageStep;
			case SliderToMinimum:
			data = minimum;
			case SliderToMaximum:
			data = maximum;
			case SliderMove:
			null;
		}
		
		//actionTriggered.dispatch(action);
	}
	
	#if key
	override public function keyPress(key:Key)
	{
		switch (key.action)
		{
			case LEFT:
				key.capture();
				triggerAction(SliderSingleStepSub);
			case RIGHT:
				key.capture();
				triggerAction(SliderSingleStepAdd);
			default:
				super.keyPress(key);
		}
	}
	#end
}

//------------------------------------------------------------------------------ actions

enum SliderAction
{
	SliderNoAction;
	SliderSingleStepAdd;
	SliderSingleStepSub;
	SliderPageStepAdd;
	SliderPageStepSub;
	SliderToMinimum;
	SliderToMaximum;
	SliderMove;
}

//-------------------------------------------------------------------------------- change

enum SliderChange
{
	SliderRangeChange;
	SliderOrientationChange;
	SliderStepsChange;
	SliderValueChange;
}
