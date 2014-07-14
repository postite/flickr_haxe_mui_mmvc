package mui.display;

import mui.display.IVideo;

#if openfl

class Video_flash extends VideoBase
{
	public function new()
	{
		super();
	}
}

#elseif flash

import flash.media.Video;
import flash.media.SoundTransform;
import flash.net.NetConnection;
import flash.net.NetStream;
import flash.events.NetStatusEvent;
import flash.events.SecurityErrorEvent;
import flash.events.AsyncErrorEvent;
import flash.events.TimerEvent;
import flash.events.FullScreenEvent;
import flash.display.Stage;
import flash.display.StageDisplayState;
import mui.display.VideoBase;
import haxe.Timer;

class Video_flash extends VideoBase
{
	var video:flash.media.Video;
	var netConnection:NetConnection;
	var stream:NetStream;
	var targetSeekTime:Float;

	public function new()
	{
		super();

		netConnection = new NetConnection();
		netConnection.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
		netConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
		netConnection.connect(null);

		stream = new NetStream(netConnection);
		stream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
		stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onError);
		stream.client = this;
		stream.inBufferSeek = true;
		stream.bufferTime = 5;
		targetSeekTime = -1;

		video = new flash.media.Video();
		sprite.addChild(video);

		video.attachNetStream(stream);
		video.smoothing = true;
	}

	override public function destroy()
	{
		netConnection.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
		netConnection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
		netConnection.close();

		stream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
		stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onError);
		stream.close();

		video.attachNetStream(null);
		super.destroy();
	}

	override function startVideo()
	{
		stream.play(source);
	}

	override function playVideo()
	{
		stream.resume();
	}

	override function pauseVideo()
	{
		stream.pause();
	}

	override function stopVideo()
	{
		stream.close();
		video.clear();
	}

	override function seekVideo(time:Float)
	{
		stream.seek(time);
		targetSeekTime = time;
	}

	override function updateVolume(level:Float)
	{
		stream.soundTransform = new SoundTransform(level);
	}

	override function requestFullScreen(fullScreen:Bool):Bool
	{
		if (!sprite.stage.allowsFullScreen) return false;

		if (fullScreen)
		{
   			sprite.stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullScreenChange);
			sprite.stage.displayState = StageDisplayState.FULL_SCREEN;
		}
		else
			sprite.stage.displayState = StageDisplayState.NORMAL;

		return fullScreen;
	}

	function onFullScreenChange(event:FullScreenEvent) 
	{
		if (!event.fullScreen) 
			fullScreen = false;
	} 

	override function updateBufferProgress()
	{
		if (stream.bytesLoaded > 0 && stream.bytesTotal > 0)
		{
			bufferProgress = changeValue("bufferProgress", stream.bytesLoaded / stream.bytesTotal);
		}
		else
		{
			bufferProgress = changeValue("bufferProgress", 0);
		}
	}

	override function updateState()
	{
		super.updateState();
		currentTime = changeValue("currentTime", stream.time);
		
		
		var limit = stream.bufferTime - 0.8;
		if (limit < 0)
			limit = 0;

		// Bug workaround:	Buffer empty is sometimes not fired, so we check here to ensure
		//  				that every buffer full is matched with a buffer empty
		if (stream.bufferLength >= limit)
		{
			if (bufferState == EMPTY) // this is called a lot so do check here instead of during invalidation
				bufferState = changeValue("bufferState", FULL);
		}
		else if (bufferState == FULL)
		{
			bufferState = changeValue("bufferState", EMPTY);
		}
	}

	override function change(flag:Dynamic)
	{
		super.change(flag);

		if (flag.width || flag.height || flag.videoWidth || flag.videoHeight)
		{
			if (videoWidth == 0 && videoHeight == 0)
			{
				video.x = 0;
				video.y = 0;

				video.width = width;
				video.height = height;
			}
			else
			{
				var sw = width / videoWidth;
				var sh = height / videoHeight;
				var s = (sw < sh ? sw : sh);

				video.x = (width - videoWidth * s) * 0.5;
				video.y = (height - videoHeight * s) * 0.5;

				video.width = videoWidth * s;
				video.height = videoHeight * s;
			}
		}
	}

	// event handlers

	function onMetaData(meta:Dynamic)
	{
		if (meta.duration > 0)
			duration = changeValue("duration", meta.duration);

		if (meta.width > 0 && meta.height > 0)
		{
			videoWidth = changeValue("videoWidth", meta.width);
			videoHeight = changeValue("videoHeight", meta.height);
		}

		// Handy when wanting to see regularity of seek points
		// if (meta.seekpoints != null)
		// {
		// 	for (p in cast(meta.seekpoints, Array<Dynamic>))
		// 		trace(p.time);
		// }

		metadataLoaded = changeValue("metadataLoaded", true);
	}

	function onNetStatus(event:NetStatusEvent)
	{
		var code = event.info.code;

		if (event.info.level == "status")
		{
			switch (code)
			{
				case "NetStream.Buffer.Empty":
					bufferState = changeValue("bufferState", EMPTY);
				case "NetStream.Buffer.Full":
					bufferState = changeValue("bufferState", FULL);
				case "NetStream.Play.Stop":
					playbackComplete();

				// this doesn't work because of
				// bug: https://bugbase.adobe.com/index.cfm?event=bug&id=2927873
				// see also: https://jira.massiveinteractive.com/browse/MUI-569
				// leaving in case it gets fixed
				case "NetStream.Seek.Notify":
					targetSeekTime = -1;
					currentTime = changeValue("currentTime", stream.time);
			}
		}
		else if (event.info.level == "error")
		{
			var error = switch (code)
			{
				case "NetStream.Seek.InvalidTime":
					// If we're in streaming mode but downloading as progressive, and user has seeked
					// past buffered content then we may get this error. If that's the case, try seek again.
					// Eventually the seek will be successful when enough content has loaded.
					if (connection == STREAMING && targetSeekTime >= 0)
						seekVideo(targetSeekTime);
					return;
				case "NetConnection.Call.Failed",
					 "NetConnection.Call.Prohibited",
					 "NetConnection.Connect.Failed",
					 "NetConnection.Connect.Rejected",
					 "NetConnection.Connect.AppShutdown",
					 "NetStream.Connect.Failed",
					 "NetStream.Connect.Rejected":
					NETWORK_ERROR(code);
				case "NetStream.Play.StreamNotFound",
					 "NetStream.Play.NoSupportedTrackFound":
					UNSUPPORTED_FORMAT(code);
				case "NetConnection.Call.BadVersion":
					DECODE_ERROR(code);
				default:
					UNKNOWN_ERROR(code);
			}
			failure(error);
		}
	}

	function onError(event:Dynamic)
	{
		failure(NETWORK_ERROR(event.toString()));
	}
}

#end
