---
title: "Asset Management"
---

## Overview

**Assets are 'compiled' resource libraires that are used by an application at runtime.**

They ensure a consistent experience across different platforms when working with bitmap data.

Asset libraries enables bitmaps to be pre-cached/loaded before use to ensure they are all 
immediately available.

For **HTML** targets, assets are loaded via a queue and cached in the browser. This helps avoid the 
distracting 'pop in' synonymous with loading images on websites and ensures an application feels 
like an app rather than a website

For **Flash** targets, assets are precompiled into a single asset SWF (dramatically reducing the 
number of http request required)

For **C++** targets, assets are compiled into the executable application


## Creating Asset Libraries

Each top level folder in the **asset** directory is treated as an asset 'library'.

	asset/startup
	asset/application

Individual assets can be added to them

	asset/startup/image.png
	asset/startup/foo/bar.jpg 


At compilation time the files inside these directories are converted into target specific packages 
based on the target platform.

Generated Library manifest:

	build/HelloWorld.web/pc/startup.xml

Generated library resources
	
	build/HelloWorld.web/pc/startup.swf
	build/HelloWorld.web/pc/image.png
	build/HelloWorld.web/pc/foo/bar.jpg

## Loading an Asset Library

To load an asset library at runtime in your application refer to the 
following code.

	var loader = m.asset.AssetDisplay.library.load("startup");
 
	loader.completed.addOnce(function(library:m.asset.AssetLibrary)
	{
	    trace("The 'startup' AssetLibrary loaded successully.");
	});
 
	loader.failed.addOnce(function(library:mloader.Loader.LoaderError)
	{
	    trace("There was an error loading the 'startup' AssetLibrary.");
	});


## Using Assets

To create a basic asset, place the file in the library

	asset/startup/image.png

To use the asset at run time (once the library is loaded)

	var image = new m.asset.AssetDisplay("image.png");


## Defining a Sprite Sheet

To define a sprite sheet, place an XML descriptor next to the image asset.

	asset/application/button.png
	asset/application/button.xml

The XML descriptor identifies areas of the image to be used as sprite. Each 
"part" consists of an identifier and it's co-ordinates on the sprite sheet.

	<image>
	    <parts>
	        <part id="focused" x="0" y="0" width="100" height="50"/>
	        <part id="default" x="0" y="50" width="100" height="50"/>
	    </parts>
	</image>


To use the sprite in your application, create an AssetDisplay and set the 
"part" property to the desired part ID.

	var button = new m.asset.AssetDisplay("button.png", "default");
 
To change the sprite:

	button.setPart("focused");


## Defining a Sprite Animation

Simple sprite sheet animations can also be defined using the XML descriptors.

	asset/startup/spinner.png
	asset/startup/spinner.xml

Animations are currently restricted to horizontal sprite sheets evenly divided 
into frames.

	<image>
	    <parts>
	        <part id="spin" frames="8"/>
	    </parts>
	</image>

To use the sprite animation in your application.

	var spinner = new m.asset.AssetDisplay("spinner.png", "spin");
 
To pause the animation
	
	spinner.pause();
 
To resume the animation
	
	spinner.resume();
 
To control the number of application frames between sprite frame updates
	
	spinner.frameRate = 2;


## Defining Multi-resolution Assets

Asset libraries can also support multiple resolutions for different device 
targets (e.g. pc, tablets, mobiles, etc).

To specify custom variants use the '@' symbol

	asset/startup/spinner.png
	asset/startup/spinner@tablet.png
	asset/startup/spinner@mobile.png

At build time, each target looks up the best matching variant (based on 
cascading rules). If none are found then the default version (no '@') is used. 
The copy added to the runtime asset library strips out the additional @... 
metadata.

At run time, each target uses the default path to access the asset (so )

	var image = new m.asset.AssetDisplay("spinner.png");

### Configuring asset rules

To customise these rules add asset to the target args. In the following 
example, both the pc and tv targets fall back to 'large' if no tv/pc variant exists. 

	web
	{
		devices:
		[
			"pc",
			"tv",
			"tablet",
			"mobile"
		],
		assets:
		[
			["pc", "large"],
			["tv", "large"],
			["tablet", "medium"],
			["mobile", "small"]
		]
	}

The first value for each asset is used to associate the asset rules with a 
specific target.

As both the devices and asset flags are abitrary strings, they can be 
configured on a project by project basis.

In the following example, the first three targets have overlapping asset rules, 
while the pc defaults to just the device flag ('pc')

	web
	{
		devices:
		[
			"samsungtv",
			"lgtv",
			"ipad",
			"pc"
		],
		assets:
		[
			["samsungtv", "tv540", "medium"],
			["lgtv", "tv720", "large"],
			["ipad", "ios", "tablet", "medium"]
				
		]
	}
