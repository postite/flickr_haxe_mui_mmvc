package mui.module.widevine;

import flash.errors.Error;
import flash.external.ExternalInterface;
import flash.net.SharedObject;

typedef WidevineAudioTrack = {trackid:Int, ?identifier:String}
typedef WidevineSubtitle = {src:String, identifier:String, ?begin:String}

/**
	A bridge between the companion WidevineMediaOptimizer.js to allow 
	decoded playback of DRM (digital rights management) video content.
**/
class WidevineAPI
{
	/**
		Widevine License URLs and settings.
		
		Ensure you set these to your own values before calling `init()`.
		Specifically the emmUrl and portal.
	**/
	public static var signOnUrl:String = "https://license.uat.widevine.com/widevine/cypherpc/cgi-bin/SignOn.cgi";
	public static var logUrl:String = "https://license.uat.widevine.com/widevine/cypherpc/cgi-bin/LogEncEvent.cgi";
	
	// EMM URL (Entitlement Management Message) responsible for determining video playback rights
	public static var licenseProxyUrl:String = "https://license.uat.widevine.com/widevine/cypherpc/cgi-bin/GetEMMs.cgi";
	
	// A unique Portal ID to pass to the license proxy URL.
	public static var portal:String = "OEM";
	
	// The unique name your SharedObject will use
	public static var cookieName:String = "Massive";
	
	/**
		Embeds the Widevine Optimizer Plugin within the provided div id.
		The plugin is required to decode encrypted media. If the plugin
		is not installed a prompt will instead be displayed directing the
		user to download and install the optimizer.
		
		Note: Ensure you set your own license URLs and portal before calling init
	**/
	public static function init(pluginDivId:String):Bool
	{
		if (isAvailable()) return true;
		
		var embedded:Bool = call("WVEmbedPlugin", [pluginDivId, signOnUrl, logUrl, licenseProxyUrl, portal]);
		return embedded;
	}
	
	/**
		Checks whether the Widevine Optimizer plugin is embedded and
		available. If false you should call the `init` function below.
	**/
	public static function isAvailable():Bool
	{
		var available:Bool = call("WVPluginAvailable");
		return available;
	}
	
	/**
		Sets the current audio track. This is an asynchronous call
		and a `NetStream.Play.AudioChange` event will occur when the
		transition is complete.
	**/
	public static function setAudioTrack(trackId:String):Bool
	{
		var success:Bool = call("WVSetAudioTrack", [trackId]);
		return success;
	}
	
	/**
		Updates the playback rate for TrickPlay Fast-Forward/Rewind.
		Supports +/- 1x, 4x, 8x, 16x, 32x, 64x, 128x, 256x.
	**/
	public static function setPlayScale(scale:Int):Int
	{
		var rate:Int = call("WVSetPlayScale", [scale]);
		return rate;
	}
	
	/**
		Returns all available Audio Tracks.
	**/
	public static function getAudioTracks():Array<WidevineAudioTrack>
	{
		var json = call("WVGetAudioTracks");
		return parse(json);
	}
	
	/**
		Returns the current `WidevineAudioTrack`.
	**/
	public static function getCurrentAudioTrack():WidevineAudioTrack
	{
		var json = call("WVGetCurrentAudioTrack");
		return parse(json);
	}
	
	/**
		Returns all available Subtitle Tracks
	**/
	public static function getSubtitles():Array<WidevineSubtitle>
	{
		var json = call("WVGetSubtitles");
		return parse(json);
	}
	
	/**
		Returns the Server URL split from the Media URL to pass
		to the NetConnection.
	**/
	public static function getServerUrl(mediaUrl:String):String
	{
		if (mediaUrl == null) return null;
		
		var url:String = call("WVGetURL", [mediaUrl]);
		
		if (url.toLowerCase().indexOf("error:") != -1)
			return null;
		
		return url;
	}
	
	/**
		Returns the Widevine Optimizer Plugin's host URL
		e.g. "http://localhost:20001/cgi-bin/"
	**/
	public static function getWidevineOptimizerPluginUrl():String
	{
		var url:String = call("WVGetCommURL");
		
		if (url.toUpperCase() == "ERROR" || url == "") return null;
		
		return url;
	}
	
	/**
		Returns the DRM decoded playhead position time from the Widevine
		Optimizer plugin which is more accurate than the NetStream.time
		value especially after seek operations.
	**/
	public function getMediaTime(netStreamTime:Float):Float
	{
		var time:String = call("WVGetMediaTime", [netStreamTime]);
		
		if (time.toUpperCase() == "ERROR") return 0.0;
		
		return Std.parseFloat(time);
	}
	
	/**
		Returns the license status
	**/
	public static function getLicenseStatus(currentContentUrl:String):String
	{
		var response:String = call("WVGetQueryLicenseValue", [currentContentUrl, "AssetRegistryKey_AssetStatus"]);
		
		return translateLicenseStatus(response);
	}
	
	/**
		Returns the time remaining until the media's license expires.
		You'll likely want to format this Int into a timecode string.
	**/
	public static function getLicenseTimeRemaining(currentContentUrl:String):Int
	{
		var response:String = call("WVGetQueryLicenseValue", [currentContentUrl, "AssetInfoKey_LicenseTimeRemaining"]);
		
		return Std.parseInt(response);
	}
	
	public static function updateLicense(contentUrl:String):String
	{
		var response:String = call("WVUpdateLicense", [contentUrl]);
		return response;
	}
	
	public static function canPlayOffline(contentUrl:String):Bool
	{
		var response:String = call("WVQueryAsset", [contentUrl]);
		var registered = (response.indexOf("undefined") != -1 || response == "") ? false : true;
		
		return registered;
	}
	
	/**
		Aborts all progressive downloads
	**/
	public static function cancelDownloads():Void
	{
		call("WVCancelAllDownloads");
	}
	
	public static function registerAsset(contentUrl:String, ?requestLicense:Bool = false):String
	{
		var result = call("WVRegisterAsset", [contentUrl, requestLicense]);
		return result;
	}
	
	public static function unregisterAsset(contentUrl:String):String
	{
		var result = call("WVUnregisterAsset", [contentUrl]);
		return result;
	}
	
	public static function saveDownload(desc:String, path:String):String
	{
		var cookie = SharedObject.getLocal(cookieName);
		if (cookie.size == 0)
			cookie.data.downloads = "";
		
		cookie.data.downloads = cookie.data.downloads + (cookie.size > 0 ? "\r" : "") + desc + "::" + path;
		cookie.flush();
		
		return registerAsset(path, true);
	}
	
	public static function deleteDownload(path:String):String
	{
		var cookie = SharedObject.getLocal(cookieName);
		if (cookie.size > 0)
		{
			var downloads:Array<String> = cookie.data.downloads.split("\r");
			var items = "";
			var parts:Array<String>;
			var download:String;
			for (i in 0...downloads.length)
			{
				download = downloads[i];
				parts = download.split("::");
				if (parts[1] != path)
					items += (items != "" ? "\r" : "") + download;
			}
			
			if (items == "")
			{
				cookie.clear();
			}
			else
			{
				cookie.data.downloads = items;
				cookie.flush();
			}
		}
		
		return unregisterAsset(path);
	}
	
	/**************** Progressive Downloads *****************/
	
	public static function initDownload(remotePath:String, localPath:String):String
	{
		var path:String = call("WVPDLNew", [remotePath, localPath]);
		return path;
	}
	
	public static function startDownload(localPath:String, trackNumber:Int, trickPlay:Bool):Bool
	{
		var result:Bool = call("WVPDLStart", [localPath, trackNumber, trickPlay]);
		return result;
	}
	
	public static function resumeDownload(localPath:String):Bool
	{
		var result:Bool = call("WVPDLResume", [localPath]);
		return result;
	}
	
	public function pauseDownload(localPath:String):Bool
	{
		var result:Bool = call("WVPDLStop", [localPath]);
		return result;
	}
	
	public function stopDownload(localPath:String):Bool
	{
		var result:Bool = call("WVPDLCancel", [localPath]);
		return result;
	}
	
	public function getProgress(localPath:String):Int
	{
		var value:Int = call("WVPDLGetProgress", [localPath]);
		return value;
	}
	
	
	public function getTotalSize(localPath:String):Int
	{
		var size:Int = call("WVPDLGetTotalSize", [localPath]);
		return size;
	}
	
	public function finalizeDownload(localPath:String):String
	{
		var result:String = call("WVPDLFinalize", [localPath]);
		return result;
	}
	
	public function getLastErrorMessage(localPath:String):String
	{
		var error:String = call("WVGetLastError", [localPath]);
		return error;
	}
	
	public function hasTrickPlay(localPath:String):Bool
	{
		var toogle:Bool = call("WVPDLCheckHasTrickPlay", [localPath]);
		return toogle;
	}
	
	public function getTrackBitrate(localPath:String, trackNumber:Int):Int
	{
		var num:Int = call("WVPDLGetTrackBitrate", [localPath, trackNumber]);
		return num;
	}
	
	public function getTrackCount(localPath:String):Int
	{
		var num:Int = call("WVPDLGetTrackCount", [localPath]);
		return num;
	}
	
	public function getDownloadMap(localPath:String):String
	{
		var map:String = call("WVPDLGetDownloadMap", [localPath]);
		return map;
	}
	
	/**************** Credentials ****************/
	
	public static function setJson(enabled:Bool)
	{
		call("WVSetJSON", [enabled ? "1" : "0"]);
	}
	
	public static function setDeviceId(deviceId:String)
	{
		call("WVSetDeviceId", [deviceId]);
	}
	
	public static function setStreamId(streamId:String)
	{
		call("WVSetStreamId", [streamId]);
	}
	
	public static function setIPAddress(ip:String)
	{
		call("WVSetClientIp", [ip]);
	}
	
	/**
		Set the License Proxy Url
	**/
	public static function setEmmUrl(url:String)
	{
		call("WVSetEmmURL", [url]);
	}
	
	public static function setEmmAckUrl(url:String)
	{
		call("WVSetEmmAckURL", [url]);
	}
	
	public static function setHeartbeatUrl(url:String)
	{
		call("WVSetHeartbeatUrl", [url]);
	}
	
	public static function setHeartbeatPeriod(period:String)
	{
		call("WVSetHeartbeatPeriod", [period]);
	}
	
	public static function setOptData(data:String)
	{
		call("WVSetOptData", [data]);
	}
	
	public static function setPortal(portal:String)
	{
		call("WVSetPortal", [portal]);
	}
	
	/**************** Options ****************/
	
	public static function getClientId():String
	{
		var id:String = call("WVGetClientId", [null]);
		return id;
	}
	
	public static function getDeviceId():String
	{
		var id:String = call("WVGetDeviceId", [null]);
		return id;
	}
	
	public static function getStreamId():String
	{
		var id:String = call("WVGetStreamId", [null]);
		return id;
	}
	
	public static function getIPAddress():String
	{
		var ip:String = call("WVGetClientIp", [null]);
		return ip;
	}
	
	public static function getEmmUrl():String
	{
		var url:String = call("WVGetEmmURL", [null]);
		return url;
	}
	
	public static function getEmmAckUrl():String
	{
		var url:String = call("WVGetEmmAckURL", [null]);
		return url;
	}
	
	public static function getHeartbeatUrl():String
	{
		var url:String = call("WVGetHeartbeatUrl", [null]);
		return url;
	}
	
	public static function getHeartbeatPeriod():String
	{
		var period:String = call("WVGetHeartbeatPeriod", [null]);
		return period;
	}
	
	public static function getOptData():String
	{
		var response:String = call("WVGetOptData", [null]);
		return response;
	}
	
	public static function getPortal():String
	{
		var portal:String = call("WVGetPortal", [null]);
		return portal;
	}
	
	/**************** Internal ****************/
	
	static function call(command:String, ?params:Array<Dynamic> = null):Dynamic
	{
		var response:Dynamic = null;
		if (!ExternalInterface.available)
		{
			handleError("ExternalInterface Unavailable");
			return response;
		}
		
		if (params != null)
		{
			var cmd:Array<Dynamic> = [];
			cmd.push(command);
			cmd = cmd.concat(params);
			try response = untyped ExternalInterface.call.apply(null, cmd)
			catch (e:Error) handleError(e.message);
		}	
		else
		{
			try response = ExternalInterface.call(command)
			catch (e:Error) handleError(e.message);
		}
		
		return response;
	}
	
	static function handleError(error:String)
	{
		#if debug
		trace("WidevineAPI::ExternalInterface Error:\n" + error);
		#end
	}
	
	static function parse(json:String):Dynamic
	{
		return haxe.Json.parse(json);
	}
	
	static function translateLicenseStatus(code:String):String
	{
		if (code == null || code == "")
			return "Unregistered";
		
		var codeNum = Std.parseInt(code);
		return switch (codeNum){
			case 0: "Registered";
			case 1: "Requesting License";
			case 2: "Have License";
			case 3: "Updating License";
			case 4: "Refused License";
			case 5: "Expired";
			case 6: "Clear Media";
			case 7: "Error";
			default: "Unknown";
		}
	}
}
