---
title: Animation and Transitions
path: overview/animation
---

# Introduction

A transition is a change in one or more properties of a `Display`, instantly (`Visibility`) or over 
a defined duration (`Animation`).

```
interface Transition<T:Transition<Dynamic>>
{
	/**
		Dispatched when this transition has completed.
	**/
	var completed:Signal0;

	/**
		Apply this transition to the specified view.
	**/
	function apply(view:Display):T;
	
	/**
		Return a copy of this transition.
	**/
	function copy():T;
}
```

# Visibility

The `Visibility` Transition simply moves a `Display` between its visible and invisible states.

```haxe
Visibility.on().apply(view);
Visibility.off().apply(view);
Visibility.toggle().apply(view);
```

# Animation


An `Animation` Transition progresses one or more properties of a Display towards a target value over a defined
duration using one of a number of easing equations.

```haxe
Animation.create({x:30, alpha:0.5, width:100}, {duration:1000, ease:Ease.outQuad, delay:100}).apply(view);
```

For convenience there are a number of concrete Animations you can use.

##Fade

Animates the alpha value of a display.

```haxe
Fade.up({delay:100}).apply(view);
Fade.to(0.8, {duration:500, delay:100}).from(0.1).apply(view);
Fade.down().apply(view);
```

## Scale 

Animates the xscale/yscale of a Display.

```haxe
Scale.to(0.2, 0.2).apply(view);
Scale.to(0.2, 0.2, {delay:100, ease:Ease.inBounce}}.from(1.5, 1.5).apply(view);
```

You can also adjust xscale and yscale independently.

```haxe
Scale.x(1.4).apply(view);
Scale.y(0.4, {duration:200}).apply(view);
```

## Slide

Animates the x/y of a Display.

```haxe
Slide.to(100, 50).apply(view);
Slide.to(100, 50, {ease:Ease.outCubic}).from(200, 200).apply(view);
```

You are also free to adjust x and y independently.

```haxe
Slide.x(20, {duration:400}).apply(view);
Slide.y(50).apply(view);
```

When wishing to slide a view on or off screen you can use the directional api.

```haxe
Slide.on(Direction.right, {ease:Ease.outCubic}).apply(view);
Slide.off(Direction.right).apply(view);
```

By default this will bring a view from just outside the bounds of its parent to position 0,0. The direction
specified is where the view will slide to. So Slide.on(Direction.right) would slide the view from outside
of its parents left hand bounds, right (-->) to position 0,0.

You can also specify the target end position for a directional `Slide`.

```haxe
Slide.on(Direction.left).position(10, 20).apply(view);
```

Directional slides become useful when used with `ViewTransitioner`s (see below).

# Sequential and Parallel

A single transition is useful in many cases but restrictive when wanting to build more complex transitions.
A `Composite` Transition allows for the grouping of a number of transitions in either sequential or parallel 
ordering.

To build parallel or sequential transitions use the static methods by the same name on the Animation class. 

```haxe
var p1 = Animation.parallel()
	.add(Scale.up(2.0, 2.0, {duration:500}))
	.add(Fade.down({duration:500});
	
var s1 = Animation.sequential()
	.add(Visibility.on())
	.add(Slide.to(100, 100, {duration:500}))
```

And of course you can add `Composite` Transitions to one another.

```haxe
Animation.sequential()
	.add(p1)
	.add(s2)
	.apply(view);
```

# Cancelling

To cancel an Animation simply pass the view to the cancel function.

```haxe
var fade = Fade.out({duration:500}).apply(view);
fade.cancel(view);
```

## Applying The Same Transitions

If you have the same transition you wish to apply to multiple views you can do that too.

```haxe
Fade.in().from(0)
	.apply(view1)
	.apply(view2)
	.apply(view3);
```

Remember that the `completed` signal will only be dispatched when all Displays transitioned with the
same Transitioner have finished. This helps keep the API simple and lightweight. 

If you wish to listen for the completion of each Display applied to the same Transitioner you can either
assign a handler to the `post` callback of each, or alternatively you can create a Transition for each.


## ViewTransitioner

When needing to transition from one view to another (e.g. moving between `Screens`) we need a specialized
container responsible for triggering the appropriate view transition (in/out) at the appropriate time.

The `ViewTransitioner`, which extends `Container` does just this, using its configured `transitionMap` to 
cherry pick the correct inword and outword transitions given the key (usually a `Direction`) provided.

# Basic Example

Lets look at a simple example based on a stack of screens.

```haxe
class ScreenContainerView extends ViewTransitioner
{
	public function new()
	{
		mode = Sequential;
		forwardTransition = ViewTransition.fade();
		backwardTransition = ViewTransition.slide(Direction.left, {duration:800});
		
		factory.component = ScreenView;
	}
}
```

First we define how we want the transitions to play out in the constructor of our custom 
`ViewTransitioner` named `ScreenContainerView`. Note how we define how a view should transition in 
and out when moving forward through our stack, as we as in and out when moving back. That's four 
different transitions all together. See the `ViewTransition` section for more details on this.

We also define the transition mode as `Sequential` rather than `Parallel` and `ScreenView` as the 
`Component` which will render a Screen inside the `ScreenContainerView`.

```haxe
class ScreenContainerViewMediator extends Mediator<ScreenContainerView>
{
	@inject public var screenStack:ScreenStack;
	
	override public function onRegister()
	{
		mediate(screenStack.changed.add(stackChanged));
	}
	
	public function stackChanged(e:CollectionEvent)
	{
		switch (e.type)
		{
			case Add: view.moveForward(screenStack.peek());
			case Remove: view.moveBack(screenStack.peek());
		}
	}
}
```

Next we mediate this view and listen to changes in the `ScreenStack`, our model of `Screen` data 
objects. When the `ScreenStack` is changed we let the view know the new `Screen` at the top of the 
`Stack` which it should render, and which direction it should transition this screen in from.

For clarity the `ScreenStack` simply extends the `Stack` from our Collections library.

```haxe
class ScreenStack extends mdata.Stack<Screen> {}
```

# ViewTransition

As you've seen in the previous section a `ViewTransition` defines how a view should transition when 
activated and deactivated.

Lets look at a few examples of creating a ViewTransition.

Here we define one which will fade a view in when activated and out when deactivated.

```haxe
new ViewTransition(Fade.in(), Fade.out());
```

For convenience this is equivalent to:

```haxe
ViewTransition.fade();
```

We could also slide a view in from the left when activated and out to the right when deactivated.

```haxe
new ViewTransition(Slide.on(Direction.right), Slide.off(Direction.right));
```

And again for convenience this is equivalent to:

```haxe
ViewTransition.slide(Direction.right);
```

You're free to define more complex transitions for each stage too.

```haxe
var slideIn = Animation.parallel()
	.add(Fade.in().from(0))
	.add(Slide.on(Direction.right);

var slideOut = Animation.parallel()
	.add(Fade.out())
	.add(Slide.on(Direction.right);
							
new ViewTransition(slideIn, slideOut);
```

# TransitionalView

In our ScreenStack example the `ScreenView` was a simple Component. While this is often fine, 
sometimes you want your view's (ScreenView's in this case) to be notified of changes in their 
transition state.

The TransitionalView interface provides an API for the `ViewTransitioner` to communicate with a 
view its responsible for transitioning.

```haxe
interface TransitionalView 
{
	/**
		To be called by an implementor when ready to transition if they have returned
		false from either startTranstionIn() or startTransitionOut().
	**/
	var readyForTransition:Void -> Void;

	/**
		Called when this view can start its transition in.
		
		If true is returned then the transition will begin.
		If false is returned then readyForTransition must be called at some later date when
		the view is ready to transition.
		
		@return True if ready to transition, false if not.
	**/
	function startTransitionIn():Bool;

	/**
		Called once the view has completed its transition in. 
	**/
	function transitionInCompleted():Void;

	/**
		Called when this view can start its transition out.
		
		If true is returned then the transition will begin.
		If false is returned then readyForTransition must be called at some later date when
		the view is ready to transition.
		
		@return True if ready to transition, false if not.
	**/
	function startTransitionOut():Bool;

	/**
		Called once the view has completed its transition out.
	**/
	function transitionOutCompleted():Void;
}
```
