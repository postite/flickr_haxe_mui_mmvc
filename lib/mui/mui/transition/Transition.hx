package mui.transition;

import msignal.Signal;
import mui.display.Display;

typedef AnyTransition = Transition<Dynamic>;

interface Transition<T:Dynamic>
{
	/**
		Dispatched when this transition has completed.
	**/
	var completed:Signal0;

	/**
		Called prior to transition start
	**/
	var pre(default, set_pre):Display->Void;

	/**
		Called after transition, prior to dispatching completed signal
	**/
	var post(default, set_post):Display->Void;

	/**
		Apply this transition to the specified view.
	**/
	function apply(view:Display):T;

	/**
		Return a copy of this transition.
	**/
	function copy():T;
}
