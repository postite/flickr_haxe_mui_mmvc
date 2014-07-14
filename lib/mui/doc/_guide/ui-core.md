---
layout: page
title: "Component Fundamentals"
footer: true
indexer: true
weight: 2
---


The `m.ui` package contains the interactive user interface components.

Overview
--------

The core inheritance chain for all UI components is:

	Rectangle > Component > Container > Collection


The diagram below illustrates the structure or the core classes

{% img ./images/ui_package.jpg UI Package %}


Component
----------

The base class for any focusable object on screen, such as a button or input.

Each Component presents its visual assets on screen through the use of a 
specific `m.ui.core.Skin`. This keeps the logic around the presentation of a 
Component detached from its inner workings, allowing skins to be easily swapped 
at runtime and increasing the reusability of a Component's core.

A Component also sits as the base class for m.ui.core.Container, a 
specialized Component which supports the nesting of other Components inside 
it.


	var component = new Component();


### Typed Components

Component is actually just an alias for an untyped DataComponent.

	typedef Component = DataComponent<Dynamic>;

Typed Data Components enable compile time verification of the data property of a component. 

Using typed DataComponents simplifies working with components, and generally reduces the amount of sub classing, casting and type checking required by dynamic data sources

To create a typed data component

	var component = new DataComponent<Foo>();
	component.data = new Foo();

	trace(component.data.bar);//compile time checking against contents of Foo





Container
----------

Container is the base class for a Component containing Component children.

Each Container is responsible for managing the focus, selection and navigation
between it's children.

### Container display list

Component children are managed seperately from other Display children. Components can be inserted, removed and located within the their parents array of components.


Adding a component:

	container.addComponent(component);
	container.addComponentAt(component, 0);

Removing a component:

	container.removeComponent(component);
	container.removeComponentAt(0);

Locating a component:

	container.getComponentAt(0);
	container.getComponentIndex(component);

Non-component children are added below Component children by default. To ad a non-component child above the components:

	container.addChildInfront(display);


### Selection

The currently selected component in a Container will recieve focus when the container gains focus, and will be the default reciever for key events while focused.

To access (or set) the selected index:

	container.selectedIndex;

To access (or set) the selected component:

	container.selectedComponent;




**Note:** A container can only have one selected component at a time.


### Navigation

Unless captured by a child, the Container is responsible for navigation between children.

By default a Container will listen to directional buttons to select the next or previous component in the display list

	override public function keyPress(key:Key)
	{
		...
		switch (key.action)
		{
			case UP: navigator.next(selected, Direction.up);
			case DOWN: navigator.next(selected, Direction.down);
			case LEFT: navigator.next(selected, Direction.left);
			case RIGHT: navigator.next(selected, Direction.right);
			default: null;
		}
	}

This can be overriden in a number of ways. The most common is by defining a Layout that takes responsibility for managing position and navigation within a container.

	container.layout = new LinearLayout();
	container.layout.vertical = false;


In advanced use cases, a custom Navigator can be defined to modify the rules for next/previous selection.


### Masking components

Under the hood, components are added to the container's component display

	trace(container.components.numChildren);

By default the components within a container are clipped to the size of the parent. To disable this

	container.components.clip = false;


### Position

To set the margin on a Container (i.e. the internal space around the children components)

	container.margin = 10;
	container.marginLeft = container.marginRight = 5; 



Collection
----------

A Container responsible for creating/managing its own children based on external data source 

Skin
-----------

Skins are responsible for managing the visual state of a target Component.

	component.skin = new CustomComponentSkin();

A custom skin overides the update method that gets executed when the target's properties change
	
	override function update(flag:Dynamic)
	{
		if(flag.selected || flag.focused)
		{
			trace(target.selected)
		}
	}

Children added to the skin are automatically attached/removed from the host target when the target is set
	
	text = new Text();
	addChild(text);

Properties are applied to the host Component when attached

	properties.fill = new Color(0xFF00FF);


### Skin Example

	typedef LabelButton = DataButton<String>;

	class MyButtonSkin extends Skin<LabelButton>
	{
		var text:Text;

		public function new(?target:LabelButton)
		{
			super(target);

			defaultWidth = 100;
			defaultHeight = 30;

			text = new Text();
			addChild(text);

			properties.fill = new Color(0xFF00FF);
		}

		override function update(flag:Dynamic)
		{
			if(flag.focused || flag.pressed)
			{
				if(target.pressed) text.color = 0xFF0000;
				else if(target.selected) text.color = 0x00FF00;
				else text.color = 0x000000;
			}
			if(flag.data)
			{
				text.value = target.data;
			}
		}

	}

