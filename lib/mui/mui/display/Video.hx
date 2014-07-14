package mui.display;

/**
	The current platform video implemention.
**/
#if (flash || openfl)
typedef Video = Video_flash;
#elseif js
typedef Video = Video_js;
#else
typedef Video = VideoBase;
#end