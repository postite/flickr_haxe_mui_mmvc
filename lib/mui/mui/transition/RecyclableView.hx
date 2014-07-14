package mui.transition;

/**
	Views which are managed by a `ViewTransitioner` and wish to be notified of 
	an appropriate time to clear their internal state should implement this 
	interface.

	If the `ViewTransitioner` is being driven by a `Stack` then `reset` will be 
	called only when the data backing the view has been popped from the stack.

	If the `ViewTransitioner` is being driven by a `mdata.SelectableList` then 
	`reset` will be called when the data backing the view has been unselected.
**/
interface RecyclableView
{
	/**
		Called when the view should reset its internal state. 
	**/
	function reset():Void;
}
