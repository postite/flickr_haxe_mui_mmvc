package mui.display;

/**
	Widevine Video Playback
**/
#if (flash && widevine && desktop)
typedef Video = VideoDesktop;
#else
#if (flash || openfl)
typedef Video = Video_flash;
#elseif js
typedef Video = Video_js;
#else
typedef Video = VideoBase;
#end
#end
