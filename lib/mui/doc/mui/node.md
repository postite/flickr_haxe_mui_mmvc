---
title: Invalidation
path: ui/invalidation
---

# Introduction

Massivision components leverage a common set of low level validation, binding  and state management
APIs. These provide under-the-hood optimisations to  minimise screen redraw and to simplify the
component lifecycle.

These classes are contained within the `mui.core` package:

* `Changable` - base interface for invalidatable classes
* `Node` - base class for invalidation, binding and states
* `Behaviour` - base implementation for objects that observe changes in a target node
* `Validator` - manager for validating invalid nodes

# Node

`Node` is the base class for objects requiring validation and binding. By  extending or composing
it's functionality, classes gain the ability to monitor  changes in internal state and notify
observers of those changes during  validation.

Benefits:

* Minimizes component redraw/changes
* Provides a common Signal for observers to listen to changes in a component
* Ignores changes to properties that have changed back again during the same 
  invalidation cycle

Usages:

* Listening to changes after validation
* Binding properties of one node to another
* Mapping groups of property values against a 'state'
* Restoring original or previous values of a property.
* Compile time generation of getter/setter functions for your class properties


## Basic usage

Classes that extend Node (such as Component) override the internal 'change' function to update
internal state.

The changed signal dispatches a dynamic `flag` object containing boolean values for node properties
that have changed.

```haxe
override function changed(flag:Dynamic)
{
	super.changed(flag);

	if (flag.value)
	{
		this.text.value = value;
	}
}
```

**Note:** It is important to always call `super.change(flag)` to ensure changed signal is dispatched.

External objects observe changes by listening to changed signals:

```haxe
node.changed.addOnce(nodeChanged);
node.someValue = "foo";

// ...

function nodeChanged(flag:Dynamic)
{
	if (flag.someValue)
	{
		this.text.value = node.someValue;
	}
}
```

## Invalidation lifecycle

{% img ./invalidation/sequence.jpg Node invalidation %}

Setter functions add properties to the invalidation queue by calling the  internal `changeValue()`
method when updating a property's value.

```haxe
function set_foo(value:String)
{
	foo = changeValue("foo", value);
}
```

During validation, all changed properties are added to the changed flag:

```haxe
flag.foo = true;
```

This object is dispatched via the changed signal, providing a list of  properties whose values have
changed:

```haxe
function nodeChanged(flag:Dynamic)
{
	if (flag.foo)
	{
		this.text.value = node.foo;
	}
}
```
	
By default node validation occurs in the next  cycle (usually next frame, or  timer tick). 
Developers can force validation immediately when required.

```haxe
node.validate();
```

## Initial and Previous values

The first time a property is invalidated, it is added to the initialValues.  This is used to provide
a base value for each property.

```haxe
node.getInitialValue("foo");
```

Each time a property is changed, the existing value is added to the  `previousValues` hash.

This is used to ignore properties whose value hasn't actually changed (or has  changed back again)
during invalidation.

```haxe
node.getPreviousValue("foo").
```

## Binding

Node objects can bind to properties of other nodes:

```haxe
component.bindValue("x", otherNode, "x");
```

## States

Nodes can group values for multiple properties against a 'state'

```haxe
node.setValueState("default", "x", 0);
node.setValueState("default", "color", 0xFF0000);

node.setValueState("pressed", "x", 10);
node.setValueState("pressed", "color", 0xFFFFFF);
```

The current state can be then set using setState:

```haxe
node.setState("pressed");
```


# Behaviors

Behaviours are classes that bind to changes in a target node. They faciliate a 
light weight composition pattern for modularising advanced UI features.

Common examples of Behaviours include:

* Skins
* Scrolling
* Dragging, Resizing, etc.


A behaviour is dependent on a target Node.

```haxe
var behavior = new SomeBehavior();
behavior.target = someNode;
```

Custom behaviours require a typed Target that extends Node

```haxe
class SomeNode extends Node
{
	public function new()
	{
		super();
	}

	var foo:String;

	public function setFoo(value:String)
	{
		foo = changeValue("foo", value);
	}
}

class SomeBehavior extends BehaviorBase<SomeNode>
{
	public function new(?target:SomeNode)
	{
		super(target);
	}

	override function update(flag:Dynamic)
	{
		if (flag.foo)
		{
			trace(target.foo);
		}
	}
} 
```

Using this example:

```haxe
var node = new SomeNode();
var behavior = new SomeBehavior();
behavior.target = node;
node.foo = "bar";

// will trace "bar"
```
