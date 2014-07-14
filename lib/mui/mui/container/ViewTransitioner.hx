package mui.container;

import mui.event.Key;
import mui.transition.TransitionalView;
import mui.transition.RecyclableView;
import mdata.Collection;
import mdata.Stack;
import mdata.SelectableList;
import mui.core.Skin;
import mui.layout.Direction;
import mui.transition.Transition;
import mui.core.ComponentFactory;
import mui.core.Container;
import mui.core.Component;

import mui.event.Focus;
import msignal.Signal;
import mui.display.Display;

import mcore.exception.Exception;
import mui.transition.ViewTransition;
import msignal.EventSignal;

typedef TransitionEvent = Event<ViewTransitioner, TransitionEventType>;

/**
	The enumerated values of possible transition events.
**/
enum TransitionEventType
{
	InStarted;
	InCompleted;
	OutStarted;
	OutCompleted;
	Idle;
}

/**
	The enumerated values of `DataViewTransitioner.mode`.
**/
enum TransitionMode
{
	Parallel;
	Sequential;
}

typedef ViewTransitioner = DataViewTransitioner<Dynamic, Dynamic>;

/**
	A `Container` that transitions between automatically constructed children 
	in response to changes in selection.
**/
class DataViewTransitioner<TData, TChildData> extends DataContainer<TData, TChildData>
{
	@:isVar public var transitioned(default, null):EventSignal<ViewTransitioner, TransitionEventType>;
	@:isVar public var transitionMap(get_transitionMap, set_transitionMap):TransitionMap;

	@:isVar public var forwardTransition(get_forwardTransition, set_forwardTransition):ViewTransition;
	@:isVar public var backwardTransition(get_backwardTransition, set_backwardTransition):ViewTransition;

	@:isVar public var isTransitioning(get_isTransitioning, null):Bool;
	@:isVar public var mode(get_mode, set_mode):TransitionMode;
	@:isVar public var autoFocus(get_autoFocus, set_autoFocus):Bool;

	@:isVar public var factory(default, set_factory):ComponentFactory;
	@:isVar public var activeView(get_activeView, null):Component;
	@:isVar public var activeViewData(get_activeViewData, null):Dynamic;	
	@:isVar public var deactivatingView(get_deactivatingView, null):Component;
	
	@:isVar var stateContext:TransitionStateContext;
	@:set var lastCollectionEvent:CollectionEvent<Dynamic>;
	@:set var lastSelectedIndex:Int;
	
	public function new(?skin:Skin<Dynamic>)
	{
		super(skin);
		
		factory = new ComponentFactory(Container);
		transitioned = new EventSignal(this);
		transitionMap = new TransitionMap();

		lastCollectionEvent = null;
		lastSelectedIndex = -1;

		// we move all core transition state logic to the stateContext as its api
		// must be public for the various states to manipulate it, but we don't want
		// to expose all those methods to users of the ViewTransitioner.
		stateContext = new TransitionStateContext(this);

		// Set default transitions
		forwardTransition = ViewTransition.slide(Direction.left);
		backwardTransition = ViewTransition.slide(Direction.right);
		transitionMap.set(0, ViewTransition.visibility());
	}

	public function moveBack(viewData:TChildData):Void
	{
		moveTo(viewData, Direction.previous);
	}

	public function moveForward(viewData:TChildData):Void
	{
		moveTo(viewData, Direction.next);
	}

	public function moveTo(viewData:TChildData, ?transitionKey:Dynamic = 0):Void
	{
		stateContext.transitionTo(viewData, transitionKey);
	}

	public function moveOutActiveView(?transitionKey:Dynamic = null):Void
	{
		stateContext.transitionOutActiveView(transitionKey);
	}
	
	function activateView(view:Component)
	{
		addComponent(view);
	}
	
	function deactivateView(view:Component)
	{
		removeComponent(view);
		resetView(view);
	}
	
	function resetView(view:Component)
	{
		if (Std.is(view, RecyclableView))
		{
			var recyclableView:RecyclableView = cast view;
			if (data == null || Std.is(data, SelectableList))
			{
				recyclableView.reset();
			}
			else if (Std.is(data, Stack))
			{
				// Potential here to reset a view in stack that's been pushed 
				// multiple times. This view would probably need reset anyway, 
				// but placing note here in case this needs some further work 
				// in future.
				var stack:Stack<Dynamic> = cast data;
				if (!stack.contains(stateContext.deactivatingViewData))
				{
					recyclableView.reset();
				}
			}
		}
	}
	
	public function getTransition(transitionKey:Dynamic):ViewTransition
	{
		return transitionMap.get(transitionKey);
	}
	
	/**
		For quick wiring we automatically listen from changes in a data model 
		which is a Stack or SelectableList.
	**/
	override function updateData(newData:TData)
	{
		removeListeners();
		addListeners(newData);
		presentView(newData);
	}

	override public function addedToStage():Void
	{
		super.addedToStage();
		addListeners(data);
		presentView(data);
	}

	override public function removedFromStage():Void
	{
		removeListeners();
		super.removedFromStage();
	}
	
	function removeListeners()
	{
		if (Std.is(data, Stack))
			untyped data.changed.remove(stackChanged);
		else if (Std.is(data, SelectableList))
			untyped data.selectionChanged.remove(selectionChanged);
	}

	function addListeners(data:TData)
	{
		if (Std.is(data, Stack))
		{
			var stack:Stack<Dynamic> = cast data;
			stack.changed.add(stackChanged);
		}
		else if (Std.is(data, SelectableList))
		{
			var list:SelectableList<Dynamic> = cast data;
			list.selectionChanged.add(selectionChanged);
		}
	}
	
	function presentView(data:TData)
	{
		if (Std.is(data, Stack))
		{
			Reflect.setField(this, "lastCollectionEvent", null);
			var stack:Stack<Dynamic> = cast data;
			if (!stack.isEmpty())
				moveTo(stack.peek());
		}
		else if (Std.is(data, SelectableList))
		{
			var list:SelectableList<Dynamic> = cast data;
			Reflect.setField(this, "lastSelectedIndex", list.previousSelectedIndex);
			if (list.selectedIndex != -1)
				moveTo(list.selectedItem);
		}
	}
	
	function stackChanged(e:CollectionEvent<Dynamic>)
	{
		// we invalidate this to avoid uneccassary transitions, for example 
		// when doing a stack.pushAtDepth which removes and adds in one
		lastCollectionEvent = e;
	}

	function selectionChanged(list:SelectableList<Dynamic>)
	{
		// again we invalidate to avoid unceccassary transitions.
		lastSelectedIndex = list.previousSelectedIndex;
	}

	override function change(flag:Dynamic)
	{
		super.change(flag);
		
		if (flag.data && data == null)
		{
			reset();
		}
		
		if (flag.lastCollectionEvent && data != null)
		{
			var stack:Stack<Dynamic> = cast data;
			switch(lastCollectionEvent.type)
			{
				case Add(d): moveForward(stack.peek());
				case Remove(d):
					if (!stack.isEmpty())
						moveBack(stack.peek());
					else
						moveOutActiveView();
				default:
					throw new Exception("Stack event type not supported " + lastCollectionEvent.type);
				
			}
		}
		
		if (flag.lastSelectedIndex && data != null)
		{
			var list:SelectableList<TChildData> = cast data;
			if (list.selectedIndex == -1)
				moveOutActiveView();
			else if (list.selectedIndex > list.previousSelectedIndex)
				moveForward(list.selectedItem);
			else
				moveBack(list.selectedItem);
		}
	}

	function reset():Void
	{
		lastSelectedIndex = -1;

		for (transition in transitionMap)
		{
			transition.transitionInCompleted.removeAll();
			transition.transitionOutCompleted.removeAll();
		}

		stateContext.reset();
		removeListeners();
	}
	
	function get_transitionMap():TransitionMap { return transitionMap; }
	function set_transitionMap(value:TransitionMap):TransitionMap { return transitionMap = changeValue("transitionMap", value); }

	function get_forwardTransition():ViewTransition { return transitionMap.get(Direction.next); }
	function set_forwardTransition(value:ViewTransition):ViewTransition { transitionMap.set(Direction.next, value); return value; }
	function get_backwardTransition():ViewTransition { return transitionMap.get(Direction.previous); }
	function set_backwardTransition(value:ViewTransition):ViewTransition { transitionMap.set(Direction.previous, value); return value; }

	function get_isTransitioning():Bool { return stateContext.isTransitioning; }
	function get_mode():TransitionMode { return stateContext.mode; }
	function set_mode(value:TransitionMode):TransitionMode { return stateContext.mode = changeValue("mode", value); }
	function get_autoFocus():Bool { return stateContext.autoFocus; }
	function set_autoFocus(value:Bool):Bool { return stateContext.autoFocus = changeValue("autoFocus", value); }

	function set_factory(value:ComponentFactory):ComponentFactory { return factory = changeValue("factory", value); }
	function get_activeView():Component { return stateContext.activeView; }
	function get_activeViewData():Dynamic { return stateContext.activeViewData; }
	function get_deactivatingView():Component { return stateContext.deactivatingView; }
}

/**
	Maintains the current state of a `ViewTransitioner`.
**/
class TransitionStateContext
{	
	@:isVar public var state(get_state, set_state):TransitionState;
	@:isVar public var mode(default, set_mode):TransitionMode;
	public var isTransitioning:Bool;
	public var activeView:Component;
	public var activeViewData:Dynamic;
	public var deactivatingView:Component;
	public var deactivatingViewData:Dynamic;
	public var host:ViewTransitioner;
	public var autoFocus:Bool;
	public var transitionKey:Dynamic;

	static var NULL_PENDING_DATA:Dynamic = {};
	
	var pendingViewData:Dynamic;
	
	public function new(transitioner:ViewTransitioner)
	{
		host = transitioner;
		isTransitioning = false;
		autoFocus = false;
		mode = Parallel;
	}
	
	function set_mode(value:TransitionMode):TransitionMode
	{
		if (value == mode)
			return value;
		
		if (state != null && !state.inactive)
			throw new mcore.exception.Exception("Attempting to change transition mode while transitioning.");
		
		mode = value;
		var inactiveState:TransitionState;
		if (mode == Parallel)
		{
			inactiveState = new ParallelInactiveState(this);
			var transitioningState = new TransitioningState(this);
			
			cast(inactiveState, ParallelTransitionState).setStates(inactiveState, transitioningState);
			transitioningState.setStates(inactiveState, transitioningState);
		}
		else
		{
			inactiveState = new SequentialInactiveState(this);
			var inState = new TransitionInState(this);
			var outState = new TransitionOutState(this);
			
			cast(inactiveState, SequentialTransitionState).setStates(inactiveState, inState, outState);
			inState.setStates(inactiveState, inState, outState);
			outState.setStates(inactiveState, inState, outState);
		}
		
		state = inactiveState;
		return mode;
	}
	
	public function transitionTo(viewData:Dynamic, transitionKey:Dynamic)
	{
		if (viewData == activeViewData)
			return;
		
		#if debug
		if (host.transitionMap == null)
			throw new mcore.exception.Exception("Attempting to transition a view without specifying a transition map.");
		#end
			
		if (viewData == null)
		{
			transitionOutActiveView();
		}
		else
		{
			this.pendingViewData = viewData;
			this.transitionKey = transitionKey;
			
			if (state.inactive)
				state.transition();
		}
	}
	
	public function transitionOutActiveView(?transitionKey:Dynamic)
	{
		if (!hasActiveView())
			return;
		
		pendingViewData = NULL_PENDING_DATA;

		if (transitionKey != null)
			this.transitionKey = transitionKey;

		if (state.inactive)
			state.transition();
	}
	
	function set_state(newState:TransitionState):TransitionState
	{
		if (newState != state)
		{
			state = newState;
			
			if (state != null) 
				state.transition();
		}

		return state;
	}

	function get_state():TransitionState
	{
		return state;
	}
	
	public function reset():Void
	{
		if (deactivatingView != null)
		{
			removeDeactivatedView();
		}
		
		if (activeView != null)
		{
			deactivateActiveView();
			removeDeactivatedView();
		}

		isTransitioning = false;
	}

	public function hasNullViewPending():Bool
	{
		return pendingViewData == NULL_PENDING_DATA;
	}
	
	public function clearPendingView()
	{
		pendingViewData = null;
		transitionKey = null;
	}
	
	public function activatePendingView()
	{
		activeViewData = pendingViewData;
		pendingViewData = null;

		activeView = host.factory.create(activeViewData);
		host.factory.setData(activeView, activeViewData);
		
		activeView.visible = false;
		// we re-enable here as we need to disable when deactivating to avoid view taking focus
		activeView.enabled = true;
		untyped host.activateView(activeView);
		host.selectedComponent = activeView;
		
		if (Std.is(activeView, TransitionalView))
			untyped activeView.readyForTransition = viewReadyForTransitionNullHandler;	
		
		if (autoFocus)
			activeView.focus();
	}
	
	public function deactivateActiveView()
	{
		deactivatingView = activeView;
		deactivatingViewData = activeViewData;
		activeView = null;
		activeViewData = null;
		// Disable to avoid deactivating view taking focus again
		untyped deactivatingView.enabled = false;
		
		if (Focus.current == untyped deactivatingView)
			host.focus();
	}
	
	public function clearViewReadyHandlers()
	{
		if (Std.is(activeView, TransitionalView))
			untyped activeView.readyForTransition = viewReadyForTransitionNullHandler;
		
		if (Std.is(deactivatingView, TransitionalView))
			untyped deactivatingView.readyForTransition = viewReadyForTransitionNullHandler;
	}
	
	public function viewReadyForTransitionNullHandler()
	{
		throw new Exception("TransitionalView called readyForTransition() when ViewTransitioner wasn't expecting it.");
	}
	
	public function removeDeactivatedView()
	{
		untyped host.deactivateView(deactivatingView);
		
		if (Std.is(deactivatingView, TransitionalView))
			untyped deactivatingView.readyForTransition = null;
		
		deactivatingView = null;
		deactivatingViewData = null;
	}
	
	public function hasPendingView():Bool
	{
		return pendingViewData != null;
	}
	
	public function hasActiveView():Bool
	{
		return activeViewData != null;
	}
	
	public function animateActiveViewIn(completeHandler:Dynamic)
	{
		if (activeView == null)
			return;
		activeView.visible = true;

		var transition = host.getTransition(transitionKey);
		transition.transitionInCompleted.addOnce(completeHandler);
		transition.transitionIn(activeView);
	}
	
	public function animateDeactivatingViewOut(completeHandler:Dynamic)
	{
		if (deactivatingView == null)
			return;
		
		var transition = host.getTransition(transitionKey);
		transition.transitionOutCompleted.addOnce(completeHandler);
		transition.transitionOut(deactivatingView);
	}
}

/**
	Maintains the current state of a transition.
**/
class TransitionState
{
	public var inactive(get_inactive, null):Bool;
	
	var transitioner:TransitionStateContext;
	var inactiveState:TransitionState;

	public function new(transitioner:TransitionStateContext)
	{
		this.transitioner = transitioner;
	}
	
	public function transition()
	{
		// abstract	
	}
	
	function get_inactive():Bool
	{
		return inactiveState == this;
	}

	public function toString()
	{
		return Type.getClassName(Type.getClass(this));
	}

}

/**
	The state of a sequential transition.
**/
class SequentialTransitionState extends TransitionState
{
	var inState:TransitionState;
	var outState:TransitionState;	

	public function new(transitioner:TransitionStateContext)
	{
		super(transitioner);
	}
	
	public function setStates(inactiveState:TransitionState, inState:TransitionState, outState:TransitionState)
	{
		this.inactiveState = inactiveState;
		this.inState = inState;
		this.outState = outState;
	}
}

/**
	The state of a inactive transition.
**/
class SequentialInactiveState extends SequentialTransitionState
{
	public function new(transitioner:TransitionStateContext)
	{
		super(transitioner);
	}
	
	override public function transition() 
	{
		if (transitioner.hasPendingView())
		{
			if (transitioner.hasActiveView())
			{
				transitioner.state = outState;
			}
			else if (transitioner.hasNullViewPending())
			{
				transitioner.clearPendingView();
				allDone();
			}
			else
			{
				transitioner.state = inState;
			}
		}
		else
		{
			allDone();
		}
	}
	
	function allDone()
	{
		transitioner.host.transitioned.dispatchType(Idle);	
	}
}

/**
	The state of a incoming transition.
**/
class TransitionInState extends SequentialTransitionState
{
	var waitingForView:Bool;
	
	public function new(transitioner:TransitionStateContext)
	{
		super(transitioner);
		waitingForView = false;
	}
	
	override public function transition()
	{
		transitioner.activatePendingView();
		transitioner.isTransitioning = true;
		var isViewReady = true;
		
		if (Std.is(transitioner.activeView, TransitionalView))
		{
			untyped transitioner.activeView.readyForTransition = viewReadyToTransitionHandler;
			isViewReady = untyped transitioner.activeView.startTransitionIn(transitioner.transitionKey);
		}
			
		transitioner.host.transitioned.dispatchType(InStarted);
		
		if (isViewReady)
			transitionViewIn();
		else
			waitForViewToBeReadyToTransition();
	}
	
	function transitionViewIn()
	{
		transitioner.clearViewReadyHandlers();
		transitioner.animateActiveViewIn(transitionInCompleteHandler);
	}
	
	function transitionInCompleteHandler()
	{	
		transitioner.isTransitioning = false;

		if (Std.is(transitioner.activeView, TransitionalView))
			untyped transitioner.activeView.transitionInCompleted();
		
		transitioner.host.transitioned.dispatchType(InCompleted);
		transitioner.state = inactiveState;
	}
	
	function waitForViewToBeReadyToTransition()
	{
		waitingForView = true;
	}
	
	function viewReadyToTransitionHandler()
	{
		if (!waitingForView)
			return;
		
		waitingForView = false;
		transitionViewIn();
	}
}

/**
	The state of a outgoing transition.
**/
class TransitionOutState extends SequentialTransitionState
{
	var waitingForView:Bool;
	
	public function new(transitioner:TransitionStateContext)
	{
		super(transitioner);
		waitingForView = false;
	}
	
	override public function transition()
	{
		transitioner.deactivateActiveView();
		transitioner.isTransitioning = true;
		var isViewReady = true;
		
		if (Std.is(transitioner.deactivatingView, TransitionalView))
		{
			untyped transitioner.deactivatingView.readyForTransition = viewReadyToTransitionHandler;
			isViewReady = untyped transitioner.deactivatingView.startTransitionOut(transitioner.transitionKey);
		}
		
		transitioner.host.transitioned.dispatchType(OutStarted);
		
		if (isViewReady)
			transitionViewOut();
		else
			waitForViewToBeReadyToTransition();
	}
	
	function transitionViewOut()
	{
		transitioner.clearViewReadyHandlers();
		transitioner.animateDeactivatingViewOut(transitionOutCompleteHandler);
	}
	
	function transitionOutCompleteHandler()
	{
		transitioner.isTransitioning = false;

		if (Std.is(transitioner.deactivatingView, TransitionalView))
			untyped transitioner.deactivatingView.transitionOutCompleted();
		
		transitioner.removeDeactivatedView();
		transitioner.host.transitioned.dispatchType(OutCompleted);
		transitioner.state = inactiveState;
	}

	function waitForViewToBeReadyToTransition()
	{
		waitingForView = true;
	}
	
	function viewReadyToTransitionHandler()
	{
		if (!waitingForView)
			return;
		
		waitingForView = false;
		transitionViewOut();
	}
}

/**
	The state of a parallel transition.
**/
class ParallelTransitionState extends TransitionState
{
	var transitioningState:TransitioningState;
	
	public function new(transitioner:TransitionStateContext)
	{
		super(transitioner);
	}
	
	public function setStates(inactiveState:TransitionState, transitioningState:TransitioningState)
	{
		this.inactiveState = inactiveState;
		this.transitioningState = transitioningState;
	}
}

/**
	The state of an inactive parallel transition.
**/
class ParallelInactiveState extends ParallelTransitionState
{
	public function new(transitioner:TransitionStateContext)
	{
		super(transitioner);
	}
	
	override public function transition()
	{
		if (transitioner.hasPendingView())
		{
			if (transitioner.hasNullViewPending() && !transitioner.hasActiveView())
			{
				transitioner.clearPendingView();
				allDone();
			}
			else
			{
				transitioner.state = transitioningState;
			}
		}
		else
		{
			allDone();
		}
	}
	
	function allDone()
	{
		transitioner.host.transitioned.dispatchType(Idle);
	}
}

/**
	The state of a parallel transition.
**/
class TransitioningState extends ParallelTransitionState
{
	var waitingForActive:Bool;
	var waitingForDeactivating:Bool;
	var transitionCount:Int;
	
	public function new(transitioner:TransitionStateContext)
	{
		super(transitioner);
	}
	
	override public function transition()
	{
		waitingForActive = false;
		waitingForDeactivating = false;
		transitionCount = 0;
			
		if (transitioner.hasActiveView())
		{
			transitionCount++;
			transitioner.isTransitioning = true;
			transitioner.deactivateActiveView();
			
			var isViewReady = true;
			if (Std.is(transitioner.deactivatingView, TransitionalView))
			{
				untyped transitioner.deactivatingView.readyForTransition = viewReadyToTransitionHandler;
				isViewReady = untyped transitioner.deactivatingView.startTransitionOut(transitioner.transitionKey);
			}
			
			transitioner.host.transitioned.dispatchType(OutStarted);	
			
			if (!isViewReady)
				waitingForDeactivating = true;
		}
		
		if (transitioner.hasPendingView() && !transitioner.hasNullViewPending())
		{
			transitionCount++;
			transitioner.isTransitioning = true;
			transitioner.activatePendingView();

			var isViewReady = true;
			if (Std.is(transitioner.activeView, TransitionalView))
			{
				untyped transitioner.activeView.readyForTransition = viewReadyToTransitionHandler;
				isViewReady = untyped transitioner.activeView.startTransitionIn(transitioner.transitionKey);
			}
			
			transitioner.host.transitioned.dispatchType(InStarted);
			
			if (!isViewReady)
				waitingForActive = true;
		}
		
		if (!waitingForDeactivating && !waitingForActive)
			transitionViews();
	}
	
	function viewReadyToTransitionHandler()
	{
		if (waitingForDeactivating)
			waitingForDeactivating = false;
		else if (waitingForActive)
			waitingForActive = false;
		
		if (!waitingForDeactivating && !waitingForActive)
			transitionViews();
	}

	function transitionViews()
	{
		transitioner.clearViewReadyHandlers();
		
		transitioner.animateDeactivatingViewOut(transitionOutCompleteHandler);
		transitioner.animateActiveViewIn(transitionInCompleteHandler);
	}
	
	function transitionOutCompleteHandler()
	{
		if (Std.is(transitioner.deactivatingView, TransitionalView))
			untyped transitioner.deactivatingView.transitionOutCompleted();
		
		transitioner.removeDeactivatedView();
		transitioner.isTransitioning = (--transitionCount > 0);
		transitioner.host.transitioned.dispatchType(OutCompleted);
		
		if (!transitioner.isTransitioning)
			transitioner.state = inactiveState;
	}
	
	function transitionInCompleteHandler()
	{
		if (Std.is(transitioner.activeView, TransitionalView))
			untyped transitioner.activeView.transitionInCompleted();
		
		transitioner.isTransitioning = (--transitionCount > 0);
		transitioner.host.transitioned.dispatchType(InCompleted);

		if (!transitioner.isTransitioning)
			transitioner.state = inactiveState;
	}
}
