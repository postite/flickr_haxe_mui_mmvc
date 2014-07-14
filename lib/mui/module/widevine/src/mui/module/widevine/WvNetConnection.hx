package mui.module.widevine;

#if flash

import flash.external.ExternalInterface;
import flash.net.Responder;
import flash.net.NetConnection;
import flash.errors.Error;
// events

class WvNetConnection //extends flash.net.NetConnection
{
	@:isVar
	public var nc(get, null):NetConnection;
	function get_nc():NetConnection
	{
		return nc;
	}
	
	
	// URL passed in by swf
	var myOrigURL:String;
	// URL used during connect() call.
	var myNewURL:String;
	var myMovie:String;
	var myErrorText:String;
	var myIsConnected:Bool;
	var myMediaTime:Int;
	var myPlayScale:Int;
	// bypass Widevine client
	var myIsBypassMode:Bool;
	// progressive download
	var myIsPdl:Bool;
		
	public function new()
	{
		nc = new NetConnection();
		nc.objectEncoding = flash.net.ObjectEncoding.AMF0;
		
		myIsConnected 	= false;
		myIsBypassMode 	= false;
		myIsPdl	   		= true;
		myMediaTime 	= 0;
		myPlayScale 	= 1;
	}
	
	public function connect(command:String)
	{
		if (command == null)
		{
			throw "connect() failed - null url";
		}
		
		// handle RTMP streaming, not supported in Widevine yet
		if (command.substr(0, 4) == "rtmp") {
			myIsPdl = false;
		}

		if (IsBypassMode()) {
			try {
				if (IsPdl()) {
					//trace("(bypass) Handling HTTP stream:" + command);
					nc.connect(null);
					myNewURL = command;
				}
				else {
					// RTMP streaming
					//trace("(bypass) Handling RTMP stream:" + command);
					myNewURL = command.substring(0, command.lastIndexOf("/")+1);
					nc.connect(myNewURL);
				}
			}
			catch (e:Error) {
				//dispatchEvent(new NetStatusEvent("onNetStatus", obj));
				//trace("WvNetStream.connect() error:" + e.message);
				throw "wvConnect() failed";
			}
			return;
		}
		
		// Widevine encrypted stream only 
		if (IsPdl()) {
			//trace("(Handling Wv HTTP stream:" + command);
		}
		else {
			command = command.substring(0, command.lastIndexOf("/")+1);
			//trace("(Handling Wv RTMP stream:" + command);
		}
		if (doConnect(command) != 0) {
			//dispatchEvent(new NetStatusEvent("netStatus", obj));
			throw "doConnect() failed";
		}
	}
	
	public function close()
	{
		myIsConnected = false;
		nc.close();
	}
	
	function doConnect(theURL:String):Int
	{
		myOrigURL = theURL;
		if (myOrigURL == null) {
			myErrorText = "url passed in connect() is null";
			return 1;
		}
		
		try {
			myMovie = theURL.substr(myOrigURL.lastIndexOf("/")+1);
			myNewURL = Std.string(ExternalInterface.call("WVGetURL", myOrigURL));

			if (myNewURL.toLowerCase().indexOf("error:") != -1) {
				myErrorText = myNewURL;
				return 2;
			}
		}
		catch (errObject:Error) {
			myErrorText = "WVGetURL() failed. " + errObject.message;
		}
		try {
			//trace("Calling super.connect()");
			nc.connect(myNewURL);
		}
		catch (errObject:Error) {
			myErrorText = "super.connect() failed. " + errObject.message;
		}
		myIsConnected = true;
		return 0;
	}
	
	public function getErrorText():String
	{
		return myErrorText;
	}
	
	public function getNewURL():String
	{
		return myNewURL;
	}
	
	public function isConnected():Bool
	{
		return myIsConnected;
	}
	
	public function setBypassMode(flag:Bool):Void
	{
		myIsBypassMode = flag;
	}
	
	public function IsBypassMode():Bool
	{
		return myIsBypassMode;
	}
	
	public function IsPdl():Bool
	{
		return myIsPdl;
	}
}

#end
