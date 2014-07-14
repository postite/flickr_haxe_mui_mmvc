package mui.transition;

interface TransitionalView 
{
	/**
		To be called by an implementor when ready to transition if they have 
		returned false from either `startTranstionIn()` or 
		`startTransitionOut()`
	**/
	var readyForTransition:Void -> Void;

	/**
		Called when this view can start its transition in.
		
		If true is returned then the transition will begin.
		If false is returned then readyForTransition must be called at some 
		later date when the view is ready to transition.
		
		@param  The key which will be used to determine the transition in.
		@return True if ready to transition, false if not.
	**/
	function startTransitionIn(key:Dynamic):Bool;

	/**
		Called once the view has completed its transition in. 
	**/
	function transitionInCompleted():Void;

	/**
		Called when this view can start its transition out.
		
		If true is returned then the transition will begin.
		If false is returned then readyForTransition must be called at some 
		later date when the view is ready to transition.
		
		@param  The key which will be used to determine the transition out.
		@return True if ready to transition, false if not.
	**/
	function startTransitionOut(key:Dynamic):Bool;

	/**
		Called once the view has completed its transition out.
	**/
	function transitionOutCompleted():Void;
}
