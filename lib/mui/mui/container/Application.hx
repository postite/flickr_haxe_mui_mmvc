package mui.container;

import mui.core.Container;
import mui.core.Component;
import mui.core.Skin;
import mui.util.Param;

/**
	A specialized Container which sits at the root of an application's 
	`Component` tree.
**/
class Application extends Container
#if mmvc
	implements mmvc.api.IViewContainer
#end
{
	public function new(?skin:Skin<Dynamic>)
	{
		super(skin);
		
		if (Param.isAvailable)
		{
			width = Param.get("width");
			height = Param.get("height");
			if (width == 0 || height == 0) all = 0;
		}
		else all = 0;
		
		scroller.enabled = false;
		focus();

		#if mmvc
		dispatcher.add(addView, COMPONENT_ADDED);
		dispatcher.add(removeView, COMPONENT_REMOVED);
		#end
	}

	#if mmvc
	public var viewAdded:Dynamic -> Void;
	public var viewRemoved:Dynamic -> Void;

	function addView(?message:Dynamic, view:Dynamic)
	{
		if (viewAdded != null) viewAdded(view);
	}

	function removeView(?message:Dynamic, view:Dynamic)
	{
		if (viewRemoved != null) viewRemoved(view);
	}

	public function isAdded(view:Dynamic)
	{
		return true;
	}
	#end
}
