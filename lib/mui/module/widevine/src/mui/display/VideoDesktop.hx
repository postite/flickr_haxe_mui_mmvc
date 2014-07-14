package mui.display;

import haxe.Json;
import haxe.Timer;
import mui.display.IVideo;
import mui.display.VideoBase;
import mui.module.widevine.WidevineErrorParser;

#if flash

import flash.media.Video;
import flash.media.SoundTransform;
import flash.net.NetConnection;
import flash.net.NetStream;
import flash.errors.Error;
import flash.events.NetStatusEvent;
import flash.events.SecurityErrorEvent;
import flash.events.AsyncErrorEvent;
import flash.events.TimerEvent;

import mui.module.widevine.WvNetConnection;
import mui.module.widevine.WvNetStream;


class VideoDesktop extends VideoBase
{
	var video:flash.media.Video;
	var netConnection:WvNetConnection;
	var stream:WvNetStream;
	var targetSeekTime:Float;
	var seekingForward:Bool;

	public function new()
	{
		super();
		
		connection = STREAMING;
		playbackRate = 1;
		supportsNativeFFRWD = true;
		seekToEndForcesCompleteEvent = false;
		
		netConnection = new WvNetConnection();
		netConnection.nc.client = this;
		netConnection.nc.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
		netConnection.nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
		
		video = new flash.media.Video();
		video.smoothing = true;
		sprite.addChild(video);
	}

	override public function destroy()
	{
		netConnection.nc.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
		netConnection.nc.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
		
		closeStream();
		netConnection.close();
		
		super.destroy();
	}
	
	/**
		Connect to the NetConnection. A NetStream is instantiated once connected.
	**/
	override function startVideo()
	{
		if (netConnection.nc.connected)
		{
			closeStream();
			netConnection.close();
		}
		
		try
			netConnection.connect(source)
		catch (e:Error)
			trace(WidevineErrorParser.parse(stream.getErrorText()));
	}
	
	/**
		Once a connection is established request the media and begin playback.
	**/
	function startStream()
	{
		stream = new WvNetStream(netConnection);
		stream.ns.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
		stream.ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onError);
		stream.ns.client = this;
		stream.ns.inBufferSeek = true;
		stream.ns.bufferTime = 5;
		targetSeekTime = -1;
		
		video.attachNetStream(stream.ns);
		
		// Begin the stream. `autoPlay` is handled once connected to the media via `onMetaData`
		// under the assumption that Widevine encoded content will always have their metadata 
		// at the start of the file's header. This isn't always the case with other media.
		var filename = source.substr(source.lastIndexOf("/") + 1);
		stream.play(filename);
	}
	
	function closeStream()
	{
		if (stream != null)
		{
			stream.ns.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			stream.ns.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onError);
			stopVideo();
			reset();
			stream.close();
		}
		
		video.attachNetStream(null);
	}
	
	override function playVideo()
	{
		if (updateTimer == null) startMonitor();
		
		if (stream != null)
		{
			if (currentTime == stream.getCurrentMediaTime())
			{
				stream.resume();
			}
			else
			{
				// When exiting TrickPlay the netStream.time may be wrong so we enforce currentTime
				stream.resumeAt(currentTime);
			}
		}
	}
	
	override function pauseVideo()
	{
		if (stream != null) stream.pause();
	}

	override function stopVideo()
	{
		if (stream != null) stream.close();
		video.clear();
	}
	
	override function updateSeekingPlaybackState()
	{
		if (playbackState == PAUSED)
		{
			if (seeking)
			{
				if (seekType == Automatic)
				{
					playVideo();
				}
				else if (seekType == Manual)
				{
					playbackState = changeValue("playbackState", PLAYING);
					playbackRate = 1;
				}
			}
			else
			{
				pauseVideo();
			}
		}
	}
	
	override function seekVideo(time:Float)
	{
		seekingForward = (time > currentTime);
		targetSeekTime = time;
		stream.seek(time);
	}
	
	/**
		Widevine supports sequential FF/RWD so we adjust
		the playbackRate within the stream before assigning
		the value to ensure they're in sync.
	**/
	override function set_playbackRate(value:Int):Int
	{
		// Enforce limits
		if (value > 256) value = 256;
		else if (value < -256) value = -256;
		
		if (value != playbackRate && value != 1 && value != 0)
		{
			// Enforce a multiple of 2
			while (value % 2 != 0) value > 0 ? value++ : value--;
			
			if (value == 2) value = 4;
			else if (value == -2) value = -4;
			
			// Fast-forward or Rewind
			if (playbackRate < value)
				value = fastForward(value, playbackRate);
			else if (playbackRate > value)
				value = rewind(value, playbackRate);
		}
		
		return super.set_playbackRate(value);
	}
	
	override function processPlaybackRate()
	{
		// Intentionally left blank. We don't want It calling seek() during FF/RWD
	}
	
	override function stopMonitor()
	{
		if (updateTimer != null)
		{
			super.stopMonitor();
			updateTimer = null;
		}
	}
	
	/**
		Updates the playback rate for TrickPlay Fast-Forward.
		Supports positive 1x, 4x, 8x, 16x, 32x, 64x, 128x, 256x.
	**/
	function fastForward(rate:Int, prevRate:Int):Int
	{
		// Ensure there's sufficient time remaining to seek at this speed
		var canSeek = (stream.getCurrentMediaTime() + rate < duration) ? true : false;
		if (!canSeek)
			return prevRate;
		
		var r = stream.getPlayScale();
		if (r <= 1) r = 1 * 2; // Widevine doesn't support 2X so the '* 2' skips it.
		while (rate > r)
		{
			stream.playForward();
			r = r * 2;
		}
		
		return stream.getPlayScale();
	}
	
	/**
		Updates the playback rate for TrickPlay Rewind.
		Supports negative 1x, 4x, 8x, 16x, 32x, 64x, 128x, 256x.
	**/
	function rewind(rate:Int, prevRate:Int)
	{
		// Ensure there's sufficient time remaining to seek at this speed
		var canSeek = (!stream.isLiveStream() && stream.getCurrentMediaTime() - (rate * -1) > 0) ? 
			true : false;
		if (!canSeek)
			return prevRate;
		
		var r = stream.getPlayScale();
		if (r >= 1) r = -1 * 2; // Widevine doesn't support 2X so the '* 2' skips it.
		while (rate < r)
		{
			stream.playRewind();
			r = r * 2;
		}
		
		return stream.getPlayScale();
	}
	
	override function updateVolume(level:Float)
	{
		stream.ns.soundTransform = new SoundTransform(level);
	}

	override function updateBufferProgress()
	{
		var progress:Float = (stream.ns.bytesLoaded > 0 && stream.ns.bytesTotal > 0) ?
									stream.ns.bytesLoaded / stream.ns.bytesTotal : 0;
			
		bufferProgress = changeValue("bufferProgress", progress);
	}
	
	override function updateStreamingBufferProgress()
	{
		var progress:Float = (stream.getCurrentMediaTime() + stream.ns.bufferLength) / duration;
		bufferProgress = changeValue("bufferProgress", progress);
	}

	override function updateState()
	{
		if (stream == null) return;
		
		super.updateState();
		
		var mediaTime = stream.getCurrentMediaTime();
		
		// Prevents seekbar/time from flickering during seek operations between old and new times.
		if (targetSeekTime != -1)
		{
			if ((seekingForward && mediaTime >= targetSeekTime) || // When seeking ahead
				(!seekingForward && mediaTime <= targetSeekTime) || // When seeking behind
				targetSeekTime == 0) // When seeking/restarting to beginning
			{
				targetSeekTime = -1;
			}
			else
			{
				mediaTime = targetSeekTime;
			}
		}
		
		currentTime = changeValue("currentTime", mediaTime);
		
		var limit = stream.ns.bufferTime - 0.8;
		if (limit < 0) limit = 0;

		// Bug workaround:	Buffer empty is sometimes not fired, so we check here to ensure
		//  				that every buffer full is matched with a buffer empty
		if (stream.ns.bufferLength >= limit)
		{
			if (bufferState == EMPTY) // this is called a lot so do check here instead of during invalidation
				bufferState = changeValue("bufferState", FULL);
		}
		else if (bufferState == FULL)
		{
			bufferState = changeValue("bufferState", EMPTY);
		}
	}
	
	override function playbackComplete()
	{
		targetSeekTime = -1;
		stopMonitor();
		playbackState = PLAYING;
		
		if (playbackRate == 1)
		{
			// Handles situation where playback naturally hits the end or you click/release
			// right at the end of the seekbar.
			super.playbackComplete();
		}
		else
		{
			// Handles situation where Fastforwarding to the end
			playbackRate = 1;
			stateChange(PLAYBACK_COMPLETED);
			seekVideo(duration - VideoBase.END_TIME_TOLERANCE_SECS);
		}
	}
	
	override function checkPlaybackComplete(time:Float)
	{
		if (duration > 0 && time + playbackRate >= duration - VideoBase.END_TIME_TOLERANCE_SECS)
		{
			if (seeking && seekType == Manual)
			{
				seeking = false;
			}
			
			playbackComplete();
		}
	}
	
	override function change(flag:Dynamic)
	{	
		super.change(flag);
		
		if (flag.duration)
		{
			stream.duration = duration - VideoBase.END_TIME_TOLERANCE_SECS;
		}
		
		if (flag.seeking)
		{
			if (playbackState == PAUSED && !seeking)
			{
				updateSeekingPlaybackState();
			}
		}
		
		if (flag.playbackRate)
		{
			if (seeking && playbackState == PLAYING)
			{
				playbackState = changeValue("playbackState", PAUSED);
			}
		}
		
		if (flag.width || flag.height || flag.videoWidth || flag.videoHeight)
		{
			if (videoWidth == 0 && videoHeight == 0)
			{
				video.x = video.y = 0;
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
				
				video.width = Math.round(videoWidth * s);
				video.height = Math.round(videoHeight * s);
			}
		}
	}
	
	function updateDimensions(width:Int, height:Int)
	{
		videoWidth = changeValue("videoWidth", width);
		videoHeight = changeValue("videoHeight", height);
	}


	// event handlers

	function onMetaData(meta:Dynamic)
	{
		if (meta.duration > 0)
		{
			duration = changeValue("duration", meta.duration);
		}
		
		// Handle `autoPlay` preference set within the base class source change handler.
		if (playbackState == PAUSED)
		{
			pauseVideo();
		}
		else
		{
			playbackState = changeValue("playbackState", PLAYING);
		}
		
		/**
			WideVine videos don't return dimensions within the metadata.
			Instead we call `updateDimensions()` once `NetStream.Video.DimensionChange` triggers.
		**/
		if (meta.width > 0 && meta.height > 0)
			updateDimensions(meta.width, meta.height);

		metadataLoaded = changeValue("metadataLoaded", true);
	}
	
	function onNetStatus(event:NetStatusEvent)
	{
		var code = event.info.code;
		if (event.info.level == "status")
		{
			switch (code)
			{
				// WIDEVINE SPECIFIC
				case "NetStream.Wv.EmmSuccess":
					//
				case "NetStream.Wv.EmmFailed", 
						"NetStream.Wv.EmmError",
						"NetStream.Wv.EmmExpired",
						"NetStream.Wv.DcpStop":
					trace(WidevineErrorParser.parse(event.info.details));
					// close stream
				case "NetStream.Wv.DcpAlert":
					//
				case "NetStream.Wv.SwitchUp", "NetStream.Wv.SwitchDown":
					//if (stream != null)
					//{
						// prev quality = stream.getCurrentQualityLevel();
						// new quality = event.info.description;
					//}
				// NETCONNECTION SPECIFIC
				case "NetConnection.Connect.Success":
					
					trace("02. onNetStatus() - NetConnection.Connect.Success");
					trace("\tcurrent playbackState = " + playbackState);
					startStream();
					
				// NETSTREAM SPECIFIC
				case "NetStream.Video.DimensionChange":
					updateDimensions(video.videoWidth, video.videoHeight);
				case "NetStream.Buffer.Empty":
					
					if (duration == 0) return;
					
					var playScale = stream.getPlayScale();
					var currentMediaTime = stream.getCurrentMediaTime();
					
					// Fast-forwarding?
					if (playScale > 1)
					{
						if (currentMediaTime + playScale * 2 >= duration) {
							seeking = false;
							playbackComplete();
						}
					}
					
					// Rewinding?
					else if (playScale < 0)
					{
						if (currentMediaTime - Math.abs(playScale * 3) <= 0) {
							seeking = false;
							seek(0);
						}
					}
					
					bufferState = changeValue("bufferState", EMPTY);

				case "NetStream.Buffer.Full":
					bufferState = changeValue("bufferState", FULL);
				case "NetStream.Pause.Notify":
					// change pause state to show play icon
				case "NetStream.Unpause.Notify":
					// change pause state to show pause icon or actually pause
				case "NetStream.Play.Stop":
					playbackComplete();
				case "NetStream.Play.Complete":
					
					// Due to latency there are drastic inconsistencies between the netstream.time
					// and the Widevine plugin's stream.getCurrentMediaTime() values.
					// This event triggers early when fastforwarding via TrickPlay.
					if (seeking)
					{
						// During TrickPlay the netstream.time ir more accurate.
						checkPlaybackComplete((playbackRate > 1) ? stream.ns.time : currentTime);
					}
					else
					{
						// This will trigger during realtime playback, during trickplay fastforward
						// or when click/releasing at the end of the seekbar
						// (because VideoBase.updateState() sets seeking to false before this triggers).
						playbackComplete();
					}
					
				case "NetStream.Seek.Notify":
					//
				case "NetStream.Seek.Complete":
					// This is the most accurate time in this context
					checkPlaybackComplete(stream.getCurrentMediaTime());
				case "NetStream.Play.AudioChange":
					// Update & show language options
			}
		}
		else if (event.info.level == "error")
		{
			var error = switch (code)
			{
				case "NetStream.Seek.InvalidTime":
					trace("NetStream.Seek.InvalidTime. targetSeekTime = " + targetSeekTime);
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
				case "NetStream.Play.Failed",
					 "NetStream.Play.StreamNotFound",
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
