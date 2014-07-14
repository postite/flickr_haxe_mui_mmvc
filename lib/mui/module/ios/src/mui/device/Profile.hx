package mui.device;

class Profile
{
	public static function init()
	{
		#if js
		function addMeta(name:String, content:String)
		{
			var meta = js.Browser.document.createElement("meta");
			meta.setAttribute("name", name);
			meta.setAttribute("content", content);
			js.Browser.document.head.appendChild(meta);
		}

		addMeta("viewport", "width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no");
		addMeta("apple-mobile-web-app-capable", "yes");
		addMeta("apple-mobile-web-app-status-bar-style", "black");
		addMeta("format-detection", "telephone=no");

		js.Browser.document.ontouchstart = function(e){ e.preventDefault(); }
		js.Browser.document.ontouchmove = function(e){ e.preventDefault(); }
		#end
	}
}
