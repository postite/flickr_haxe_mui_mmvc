package mui.display;

import mui.core.Node;

/**
	A visual style for the fill of stroke of a `Rectangle`.
**/
interface GraphicStyle extends Changeable
{
	#if (flash || openfl)
	function beginFill(graphic:Rectangle):Void;
	function beginStroke(graphic:Rectangle):Void;
	#elseif js
	function applyFill(graphic:Rectangle):Void;
	function applyStroke(graphic:Rectangle):Void;
	#end

	#if uiml
	function setState(state:String):Void;
	#end
}