package mui.display;

import mui.display.IVideo;
using Reflect;
/*
Useful links:

 - W3C http://www.w3.org/TR/html5/video.html
 - Mozilla https://developer.mozilla.org/En/Using_audio_and_video_in_Firefox
 - Safari http://developer.apple.com/library/safari/#documentation/AudioVideo/Conceptual/Using_HTML5_Audio_Video/Introduction/Introduction.html
 - Opera http://dev.opera.com/articles/view/everything-you-need-to-know-about-html5-video-and-audio/
*/
/**
	SourceElement sources for use within `sources` property.
**/
typedef VideoSource =
{
	/**
		The path to the video file
	**/
	var src:String;

	/**
		The mime type e.g. 'video/mp4' or 'video/mp4; codecs="avc1.4D401E, mp4a.40.2"'.

		If you optionally provide the codec within the mimeType then `videoElement.canPlayType()`
		is able to more accurately determine whether it supports the format by returning `probably`
		instead of `maybe`. Common values include:

		```
		video/ogg; codecs="theora, vorbis"
		video/mp4; codecs="avc1.4D401E, mp4a.40.2"
		video/webm; codecs="vp8.0, vorbis"
		```
	**/
	var mimeType:String;
};

class Video_js extends VideoBase
{
	var video:Dynamic;

	/**
		Optionally set multiple video sources instead of using the `source` property.
		This allows you to provide multuple formats (e.g. mp4/ogv/webm) of the same
		video to ensure your video will run cross platform/browser.

		When setting this property the HTML `VideoElement` has multiple `SourceElement`s
		injected within it instead of using the VideoElement's src attribute.
		Please note that if you wish to toggle between setting `sources` and `source`
		then you should first nullify `sources` before setting a new `source`.
	**/
	@:set var sources:Array<VideoSource>;

	public function new()
	{
		super();

		sources = null;

		video = js.Browser.document.createElement("video");
		element.appendChild(video);

		video.setAttribute("preload", "auto");

		video.width = 800;
		video.height = 600;

		#if ios
		video.setAttribute("controls", "");
		#end

		// http://www.w3.org/TR/html5/video.html#mediaevents

		video.addEventListener("error", onError, false);
		video.addEventListener("loadedmetadata", onMetadata, false);
		video.addEventListener("ended", playbackComplete, false);
		video.addEventListener("stalled", onBufferEmpty, false);
		video.addEventListener("canplay", onBufferFull, false);
		video.addEventListener("canplaythrough", onBufferFull, false);

		// "waiting" event only implemented in Firefox at time of writing. ms 22.9.11
		// see http://dev.opera.com/forums/topic/1051492
		video.addEventListener("waiting", onBufferEmpty, false);

		js.Browser.document.addEventListener("fullscreenchange", onFullScreenChange, false);
		js.Browser.document.addEventListener("mozfullscreenchange", onFullScreenChange, false);
		js.Browser.document.addEventListener("webkitfullscreenchange", onFullScreenChange, false);
	}

	override public function destroy()
	{
		super.destroy();

		video.removeEventListener("error", onError, false);
		video.removeEventListener("loadedmetadata", onMetadata, false);
		video.removeEventListener("ended", playbackComplete, false);
		video.removeEventListener("stalled", onBufferEmpty, false);
		video.removeEventListener("canplay", onBufferFull, false);
		video.removeEventListener("canplaythrough", onBufferFull, false);
		video.removeEventListener("waiting", onBufferEmpty, false);

		js.Browser.document.removeEventListener("fullscreenchange", onFullScreenChange, false);
		js.Browser.document.removeEventListener("mozfullscreenchange", onFullScreenChange, false);
		js.Browser.document.removeEventListener("webkitfullscreenchange", onFullScreenChange, false);
	}

	// Remove existing SourceElement's when changing source/sources
	function removeSourceElements()
	{
		var _video:js.html.VideoElement = cast video;
		var i = _video.children.length;
		while (i-- > 0)
		{
			var child = _video.children.item(i);
			if (Std.is(child, js.html.SourceElement))
				_video.removeChild(child);
		}
	}

	// Inject multiple SourceElements within the VideoElement
	function addSourceElements()
	{
		for (media in sources)
		{
			var source = js.Browser.document.createSourceElement();
			source.src = media.src;
			source.type = media.mimeType;
			video.appendChild(source);
		}
	}

	override function startVideo()
	{
		// cover the case when user selects play() directly after setting source
		if (playbackState == PLAYING)
			video.autoplay = "";

		removeSourceElements();

		if (sources == null) video.src = source;
		else addSourceElements();

		#if ios
		// bug: http://clubajax.org/ipad-bug-fix-for-dynamically-created-html5-video/
		video.load();
		#end
	}

	override function playVideo()
	{
		video.play();
	}

	override function pauseVideo()
	{
		video.pause();
	}

	override function stopVideo()
	{
		video.src = "";
	}

	override function seekVideo(time:Float)
	{
		try
		{
			video.currentTime = time;
		}
		catch(e:Dynamic)
		{
			trace("ERROR: Invalid seek time: " + time + " (currentTime: " + video.currentTime + ")");
		}
	}

	override function updateVolume(level:Float)
	{
		video.volume = Std.string(Math.round(level * 10) / 10);
	}

	override function requestFullScreen(fullScreen:Bool):Bool
	{
		var fields:Array<String>;
		var el:Dynamic;

		if (fullScreen)
		{
			el = js.Browser.document.documentElement;
			fields = ["requestFullScreen", "mozRequestFullScreen", "webkitRequestFullScreen"];
		}
		else 
		{
			el = js.Browser.document;
			fields = ["cancelFullScreen", "mozCancelFullScreen", "webkitCancelFullScreen"];
		}

		for (field in fields)
		{
			//note: not using el.hasField(field) as this returns false incorrectly
			if (untyped el[field])
				el.callMethod(el.field(field), []);
		}
		
		return fullScreen;
	}

	function onFullScreenChange(_)
	{
		var fields =  ["fullscreen", "mozFullScreen", "webkitIsFullScreen"];
		var el:Dynamic = js.Browser.document;
		var value = false;

		for (field in fields)
		{
			if (el.hasField(field))
				value = el.field(field);
		}

		fullScreen = value;
	}

	override function change(flag:Dynamic)
	{
		super.change(flag);

		if (flag.sources && sources != null)
		{
			source = "sources";
			invalidateProperty("source");
		}

		if (flag.width || flag.height || flag.videoWidth || flag.videoHeight)
		{
			var vw:Float = width;
			var vh:Float = height;

			if (videoWidth > 0 && videoHeight > 0)
			{
				vw = videoWidth;
				vh = videoHeight;
			}

			var sw = width / vw;
			var sh = height / vh;
			var s = (sw < sh ? sw : sh);

			vw *= s;
			vh *= s;

			video.style.left = Std.int((width - vw) * 0.5) + "px";
			video.style.top = Std.int((height - vh) * 0.5) + "px";

			video.width = vw;
			video.height = vh;
		}

		if (flag.autoPlay)
		{
			if (autoPlay) video.autoplay = "";
			else video.removeAttribute("autoplay");
		}

		if (flag.seeking)
		{
			// bug: https://jira.massiveinteractive.com/browse/MUI-567
			if (!seeking && bufferState == EMPTY && video.buffered.length > 0 && (video.buffered.end(0) - video.currentTime) > 3)
			{
				bufferState = changeValue("bufferState", FULL);
			}
		}
	}

	function onMetadata():Void
	{
		duration = changeValue("duration", Std.parseInt(Std.string(video.duration)));
		videoWidth = changeValue("videoWidth", Std.parseInt(Std.string(video.videoWidth)));
		videoHeight = changeValue("videoHeight", Std.parseInt(Std.string(video.videoHeight)));
		metadataLoaded = changeValue("metadataLoaded", true);
	}

	function onBufferEmpty()
	{
		// If still buffering and have less than 3 secs of buffer ahead then broadcast EMPTY
		// bug: https://jira.massiveinteractive.com/browse/MUI-566
		if (video.buffered.length == 0 || (video.networkState == 2 && (video.buffered.end(0) - video.currentTime) < 3))
			bufferState = changeValue("bufferState", EMPTY);
	}

	function onBufferFull()
	{
		bufferState = changeValue("bufferState", FULL);
	}

	// In flash we look at bytesloaded vs bytestotal. This isn't very accurate however
	// and can't be done with latest html5 video. Instead we monitor buffer windows which
	// are the blocks of loaded video content.
	//
	// See: http://code.google.com/p/chromium/issues/detail?id=41603#c2
	// See: http://www.whatwg.org/specs/web-apps/current-work/multipage/video.html#dom-media-buffered
	// See: http://hacks.mozilla.org/2010/08/html5-video-buffered-property-available-in-firefox-4/
	//
	// Note: There seems to be a bug under Chrome where the buffer windows expends to full
	//       playback duration if user pauses or interacts with stream, even though
	//       the stream is not buffered to that position. ms 16/02/11
	//
	// TODO: currently we have one window, look at supporting multiple. ms 16/02/11
	override function updateState()
	{
		super.updateState();

		currentTime = changeValue("currentTime", video.currentTime);
	}

	override function updateBufferProgress()
	{
		if (video.buffered != null)
		{
			if (video.buffered.length > 0)
			{
				bufferProgress = changeValue("bufferProgress", video.buffered.end(0) / duration);
			}
		}
		else
		{
			bufferProgress = changeValue("bufferProgress", 0);
		}
	}

	function onError(e:Dynamic)
	{
		var code = e.target.error.code;
		var id = "" + code;

		var error = null;
		if (code == e.target.error.MEDIA_ERR_ABORTED)
			error = PLAYBACK_ABORTED(id);
		else if (code == e.target.error.MEDIA_ERR_NETWORK)
			error = NETWORK_ERROR(id);
		else if (code == e.target.error.MEDIA_ERR_DECODE)
			error = DECODE_ERROR(id);
		else if (code == e.target.error.MEDIA_ERR_SRC_NOT_SUPPORTED)
			error = source != null ? UNSUPPORTED_FORMAT(id) : null;
		else error = UNKNOWN_ERROR(id);

		if (error != null)
			failure(error);
	}

	// TODO: other things to consider at some point
	// return (stream != null && stream.webkitSupportsFullscreen);
	// value ? stream.webkitEnterFullscreen() : stream.webkitExitFullscreen();
	
	override function processPlaybackRate()
	{
		if (playbackRate < 0)
		{
			// This updates every 1/2 second so we should really add (playbackRate / 2)
			// but adding the full playbackRate feels more accurate when used.
			seek(currentTime + playbackRate);
			if (video != null) video.playbackRate = 1;
		}
		else
		{
			if (video != null)  video.playbackRate = Std.int(playbackRate);
		}
	}

	override function set_playbackRate(value:Int):Int
	{
		if (value != playbackRate)
		{
			seeking = (value < 0); // enable manual seeking while scrubbing to avoid seek>play loop
			playbackRate = changeValue("playbackRate", value);
			processPlaybackRate(); // ensure to process at least one update in case invalidation prevents it
		}
		return playbackRate;
	}
}
