package mui.module.widevine;

import flash.net.Socket;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;

class WvSocket extends Socket
{
	public function new()
	{
		super();
	}
	
	public function sendRequest(str:String)
	{
		writeUTFBytes(str);
		flush();
	}
}