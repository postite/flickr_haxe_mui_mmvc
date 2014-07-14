---
layout: page
title: "Component Lifecycle"
footer: true
indexer: true
weight: 3
---

Component Lifecycle
-------------------


{% img ./ui-lifecycle/component-sequence.jpg Component lifecycle %}

#### Added to stage

When added to stage a `COMPONENT_ADDED` event is bubbled up the component 
display heirachy

	component.dispatcher.add(added,COMPONENT_ADDED);

	function added(message:Dynamic, target:Dynamic)
	{
		//do something
	}

#### Removed from stage

When removed from stage a `COMPONENT_REMOVED` event is bubbled up the component 
display heirachy

	component.dispatcher.add(removed,COMPONENT_REMOVED);

	function removed(message:Dynamic, target:Dynamic)
	{
		//do something
	}


> ***Warning:** It is not recommended to depend directly on added/removed 
events. In future releases, Dispatcher will be replaced with typed Signals for 
consistency.*



#### Changing data

All components have a data property. If using a typed DataCollection the type 
will be verified at compile time.

	component.data = new Foo();

When data is changed the updateData method is called immediately. This can be 
overriden in any subclass.

	function updateData(newData:TData)
	{
		//do something
	}

If using a typed DataComponent, the value will be strictly typed.
	
	override function updateData(foo:Foo)
	{
		//do something
	}

Otherwise it will be dynamic

	override function updateData(newData:Dynamic)
	{
		//do something
	}


The data property is invalidatable, so listeners can update when changed signal 
is dispatched

	component.changed.add(componentChanged);

	override function componentChanged(flag:Dynamic)
	{
		if(flag.data)
		{
			//do something with component.data
		}
	}


Skin lifecycle
---------------

{% img ./ui-lifecycle/skin-sequence.jpg Skin Lifecycle %}
