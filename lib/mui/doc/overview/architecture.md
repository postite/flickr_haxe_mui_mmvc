---
title: Application Architecture
path: overview/architecture
---

# Introduction 

Massive MVC is a light but powerful IOC framework utilizing Signals and macro enhanced 
dependency injection. It provides a robust, modular, testable pattern for the model view 
controller design pattern.

Massive MVC is a port of the excellent AS3 [RobotLegs](robotlegs) framework, optimised to better 
leverage features of the Haxe language like generics and macros. It also does away with event 
based command mapping, instead favouring signal based mapping based on Joel Hook's 
[SignalCommandMap](signal-command-map) concept. This enables portability away from the Flash 
platform.

It's recommended to first read the above RobotLegs documentation if you are unfamiliar with the 
concepts outlined below.

* Injectors
* Context
* Actors and Models
* Signals 
* Commands
* View Mediators

For more information on dependency injection see the [Massive Inject Documentation](injection.md).

# Context

The context provides a central wiring/mapping of common instances within a contextual scope 
(eg. application).

## Creating a Context 

Contexts must extend mmvc.impl.Context and override the startup method to map the appropriate 
actors, commands and mediators.

Generally a context is defined at an application level

```haxe
class ApplicationContext extends mmvc.impl.Context
{
	public function new(?contextView:IViewContainer=null, ?autoStartup:Bool=true)
	{
		super(contextView, autoStartup);
	}

	override public function startup():Void
	{
		//map commands/models/mediators here
	}
}
```

## Wiring the Context

Models are mapped via the injector:

```haxe
injector.mapSigleton(DanceModel);
```

Commands are mapped to actions (Signals) using the commandMap in the Context:

```haxe
commandMap.mapSignalClass(Dance, DanceCommand);
```

Standalone actions (Signals) without a corresponding Command can also be mapped via the injector:

```
injector.mapSingleton(ClapHands);
```

Mediators are mapped to Views via the mediatorMap:

```haxe
mediatorMap.mapView(DanceView, DanceViewMediator);
```

## Initializing the Context

Usually an application context is instanciated within the main view of an application:

```haxe
class ApplicationView implements mmvc.api.IViewContainer
{
	static var context:ApplicationContext;

	public function new()
	{
		context = new ApplicationContext(this, true);
	}
}
```

Or externally in the Main haxe file:

```haxe	
class Main
{
	public static function main()
	{
		var view = new ApplicationView();
		var context = new ApplicationContext(view);
	}
}
```
	

**Important Caveat**

The `IViewContainer` (ApplicationView) should be the last mapping in the Context.startup function 
otherwise other mappings may not be configured:

```haxe
function startup()
{
	// map everything else
	mediatorMap.mapView(ApplicationView, ApplicationViewMediator);
}
```


# Models and Services

`Actor` is a generic term for an application class that is wired into the Context. Generally these 
take the form of **models** or **services**

## Mapping Actors

Actors are mapped via the injector:

```haxe
injector.mapSigleton(DanceModel);
```

## Example

By default actors don't require any interface or inheritance to be mapped in the context.

However if an actor requires references to other application parts it should extend 
`mmvc.impl.Actor`

```haxe
class DanceModel extends mmvc.impl.Actor
{
	public inline static var STYLE_WALTZ = "waltz";
	public inline static var STYLE_FOXTROT = "foxtrot";

	@inject public var something:Something;

	public var dancer:String;
	public var style:String;

	public function new()
	{
		// ...
	}
}
```

# Signals

Signals are performant and lightweight alternative to Events. Massive Signal leverages Haxe 
generics to provide a strictly typed contract between dispatcher (Signal) and its listeners.

In Massive MVC signals represent unique actions or events within an application.

For more information about signals see the [Massive Signal documentation](signals.md)

## Mapping Signals

A `Signal` can be mapped to an associated `Command` via the `Context`:

```haxe
commandMap.mapSignalClass(Dance, DanceCommand);
```

They can also be mapped as a standalone action or event:

```haxe
injector.mapSingleton(DoSomething);
```

## Example

A simple example Signal with a signal dispatcher argument:

```haxe
class Dance extends msignal.Signal1<String>
{
	inline static public var FOX_TROT = "foxtrot";
	inline static public var WALTZ = "waltz";

	public function new()
	{
		super(String);
	}
}
```

> Note: it is important to pass the runtime type of the `Signal` argument to the super 
> constructor. This information is used by the dependency injector to inject signal arguments into 
> the recieving `Command`.

And to dispatch the signal:

```haxe
dance.dispatch(Dance.FOX_TROT);
```

To add a listener to the signal:

```haxe
dance.add(danceHandler);

// ...

function danceHandler(style:String)
{
	trace("Dance style: " + style);
}
```

## Responder Signals

Within an application is is often useful to be able to receive callbacks once a signal has 
finished or completed.

A good way to achieve this is through child signals.

This example adds a completed signal to dispatch once the dance has been completed.

```haxe
class Dance extends msignal.Signal1<String>
{
	public var completed:Signal1<String>;

	inline static public var FOX_TROT = "foxtrot";
	inline static public var WALTZ = "waltz";

	public function new()
	{
		super(String);
		completed = new Signal1<String>();
	}
}
```

To listen for completion of the Dance:

```haxe
dance.completed.addOnce(this.danceCompleted);
dance.dispatch();
```



# Commands

Commands represent the controller tier of the Application. Commands are generally stateless, short 
lived objects that provide a single, granular activity within an application.

## Mapping Commands

Commands are mapped to actions (Signals) using the `commandMap` in the Context

```haxe
commandMap.mapSignalClass(Dance, DanceCommand);
```

## Triggering Commands


Commands are triggered by dispatching the associated Signal from elsewhere within the application 
(generally a `Mediator` or other `Command`)

```haxe
dance.dispatch(Dance.FOX_TROT);
```

## Example

```haxe
class DanceCommand extends mmvc.impl.Command
{
	@inject public var danceModel:DanceModel;

	@inject public var dance:Dance;

	@inject public var style:String;

	public function new()
	{
		super();
	}

	override public function execute():Void
	{
		//some application logic here

		//dispatch completed once done
		dance.completed.dispatch(style);
	}
}
```


# Views & Mediators

Mediators are used to handle framework interaction with specific View classes, and decouple views from other application components.

This includes:

* listening and responding to application Signals
* listening to the view instance and dispatching application signals in response to user input
* injecting external actors and models into the view during registration  


## Mapping Mediators

Mediators are mapped to Views via the mediatorMap

```haxe
mediatorMap.mapView(DanceView, DanceViewMediator);
```

## Mediating Views

Mediator instances are created automatically when the IViewContainer (generally an 
ApplicationView) calls the added handler.

Generally a base view class will handle bubbling of added and removed events from the target 
platform's display heirachy.

See the examples for a reference implementation.

To manually do this call the handler directly

```haxe
applicationView.added(viewInstance);
```

The associated view instance can be accesed view the 'view' property

```haxe
view.doSomething(); 
```

## Example

This is an example demonstrating integration with both application and view events within a mediator

```haxe
class DanceViewMediator extends mmvc.impl.Mediator<DanceView>
{
	@inject public var model:DanceModel;

	@inject public var dance:Dance;

	public function new()
	{
		super();
	}

	override function onRegister()
	{
		super.onRegister();
		
		view.changeStyle.add(styleChanged);
		
		view.start(model.style);
	}

	override public function onRemove():Void
	{
		super.onRemove();
		view.changeStyle.remove(styleChanged);
	}


	function styleChanged(style:String)
	{
		dance.completed.addOnce(danceCompleted);
		dance.dispatch(style);
	}

	function danceCompleted(newStyle:String)
	{
		view.start(newStyle);
	}
}
```

And the view class:

```haxe
class DanceView
{
	public var changeStyle:Signal1<String>

	var style:String;
	
	public function new()
	{
		changeStyle = new Signal1<String>();
	}

	public function start(style:String)
	{
		this.style = style;
		//do something
	}

	public function restart()
	{
		start(style);
	}

	function internallyChangeStyle(newStyle:String)
	{
		changeStyle.dispatch(newStyle);
	}
}
```

[robotlegs]: https://github.com/robotlegs/robotlegs-framework/tree/master
[signal-command-map]: http://joelhooks.com/2010/02/14/robotlegs-as3-signals-and-the-signalcommandmap-example/
