---
title: Display Fundamentals
path: ui/display
---

# Introduction

The `mui.display` package contains cross platform display APIs and graphics primitives, including 
shapes, bitmaps, fills and gradients, display list management and text and video.

# Overview

The display classes illustrated below represent the core components that all user interface 
elements are based off across the framework. 

<img src="display/package.jpg"/>

The diagram above provides the high level inheritance chain between display 
components.


## Platform specific implementations

Under the hood the primary display classes are split into two parts. 

* a base class (e.g. `src/core/m/display/DisplayBase`) defining the common properties/methods 
  available across all platforms
* a concrete implementation per platform (e.g. `src/js/m/display/Display`) that implements the 
  common api against the native display heirachy and element properties.

At compile time a single concrete class is included, ensuring that developers never need to 
reference the 'base' class directly

```haxe
var rectangle = new Rectangle(); 
```

The diagram below illustrates this relationship between core and platform 
specific classes.

<img src="display/package-detail.jpg" />

The display classes containing base and platform specific implementations are:

* DisplayBase
* DisplayRootBase
* RectangleBase
* TextBase
* VideoBase

Additional platforms or device variants can extend, customise or replace these plaform 
implementations to provide a consistant display representation.


# Display

The base primitive used for all visual elements.

* Touch and mouse events
* Position (x, y) and dimensions (width, height)
* display list APIs for adding/removing children

The core api for Display is defined in `mui.display.DisplayBase` (see src/core).

Each platform provides a concrete implementation of `Display` for that platform (see src/js, 
src/flash, etc)

# Rectangle

A rectangle is a visible area on screen. It has position (x,y), dimension (width/height) and 
style (fill,stroke,radius). It also has a display list API (parent,children) and constraints 
(left, top, right, bottom, centerX, centerY).

## Position

```haxe
var rect = new mui.display.Rectangle();

rect.x = 100;
rect.y = 300;
```

## Dimension

```haxe	
var rect = new mui.display.Rectangle();

rect.width = 100;
rect.height = 300;
rect.width = -100; // dimensions must be positive, width becomes 0
```

## Style

Rectangles can have basic styles applied to their fill and stroke. These can be solid colors, 
gradients or bitmaps. Rectangles can also have rounded corners, specified using the 'radius' 
property.

```haxe
var rect = new mui.display.Rectangle();

// color
rect.fill = new mui.display.Color(0xFF, 0.5);

// gradient
rect.fill = new mui.display.Gradient([
	new mui.display.GradientColor(0xFFFFFF, 1.0, 0,0),
	new mui.display.GradientColor(0x000000, 1.0, 1.0)], 90)

// bitmap
rect.fill = new mui.display.Bitmap("puppies.png");

// stroke
rect.strokeThickness = 2;
rect.stroke = new mui.display.Color(0xFF);

// radius
rect.radius = 10; // sets all corners
rect.topRightRadius = 5;
```

## Display list

The display list API is used to manage hierarchies of UI objects. Displays can have an ordered 
array of children, and each child maintains a reference to its parent. Children can be inserted, 
removed and located within the their parents array of children.

```haxe
var parentRect = new Rectangle();
var child1Rect = new Rectangle();
var child2Rect = new Rectangle();

parentRect.addChild(child1Rect);
trace(child1Rect.parent == parentRect); // true
trace(parentRect.getChildAt(0) == child1Rect); // true
trace(parentRect.numChildren); // 1

parentRect.addChildAt(child2Rect, 0);
trace(parentRect.getChildAt(0) == child2Rect); // true
trace(parentRect.getChildAt(1) == child1Rect); // true
trace(parentRect.numChildren); // 2

parentRect.removeChild(child2Rect);
trace(parentRect.numChildren); // 1
trace(parentRect.getChildIndex(child2Rect)); // 0
```

## Constraints

Constraints are used to position and resize children relative to their parents without writing 
additional layout logic. Vertical constrains behave in the same way as horizontal constraints, 
explained below.

```haxe
var parent = new Rectangle();
var child = new Rectangle();
parent.addChild(child);
parent.width = 200;
child.width = 100;

// centerX
child.centerX = 0;		// x == 0
child.centerX = 0.5;	// x == 50
child.centerX = 1;		// x == 100

// setting left alone sets x
child.left = 10;		// x = 10

// setting left and right constrains size and position
child.left = child.right = 10; // x == 10, width == 180

// setting right alone aligns to right
child.right = 10;		// x == 90
```

# Text

The `Text` primitive provides common apis for working with text

```
var text = new mui.display.Text();
text.value = "Hello World";
addChild(text);
```

## Text properties

Common text attribtues can be set on an instance. For a full list of properties see 
`mui.display.TextBase`.

```haxe
text.size = 24;
text.font = "Ubuntu";
text.color = 0x000000;
```

Default values:

```haxe
text.value = "";
text.font = "Ubuntu";
text.size = 24;
text.color = 0x000000;
text.selectable = false;
text.bold = false;
text.italic = false;
text.html = false;
text.leading = 0;
text.wrap = false;
text.autoSize = true;
text.multiline = false;
text.editable = false;
text.letterSpacing = 0;
text.align = "left";
```

## Multiline text

By default text is set to single line and autosize. To configure a text 
instance differently:

```haxe
text.wrap = true;
text.multiline = true;
text.autoSize = false;
text.align = "right";
```

# Image

To create an image:

```haxe
var image = new mui.display.Image();
addChild(image);
```

## Loading Bitmaps

Loading is triggered when the url property changes

```haxe
image.url = "path/to/image.png";
```

Other classes can listen to changes when an image has loaded or failed:

```haxe
image.loaded.addOnce(imageLoaded);
image.failed.addOnce(imageFailed);

function imageLoaded()
{
	//do something
}

function imageFailed()
{
	//do something else
}
```

## Sizing and Scaling

By default, autosize is set to true, which will resize the image object to the size of the loaded 
bitmap.

```haxe
trace(image.width); // 0
trace(image.height); // 0
image.url = example.jpg;

// ...

function imageLoaded()
{
	trace(image.width); // 100
	trace(image.imageWidth); // 100
	trace(image.height); // 100
	trace(image.imageHeight); // 100
}
```

To lock the size of the image:

```haxe
image.autoSize = false;
image.width = 50;
image.height = 50;
image.url = "example.jpg";

// ...

function imageLoaded()
{
	trace(image.width); // 50
	trace(image.imageWidth); // 100
	trace(image.height); // 50
	trace(image.imageHeight); // 100
}	
```

By default an image will not scale. To change the scaleMode use `ScaleMode` (imported via 
mui.display.Bitmap)

```haxe
image.scaleMode = FIT | FILL | STRETCH | NONE;
```

# Video

Provides a base video object in the native platform (e.g. html5 video, flash Video, etc)

```haxe
var video = new Video();
video.source = "http://domain.com/path/to/video.mp4";
```

The Video class provides comprehensive API for working with video playback. See the API docs for 
detailed usage.

* duration, currentTime
* buffering, seeking, refreshRate
* autoPlay, looping
* volume and muting
