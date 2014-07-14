package mui.display;

#if netcast_20
typedef Video = VideoNetcast20;
#else
typedef Video = VideoNetcast30;
#end
