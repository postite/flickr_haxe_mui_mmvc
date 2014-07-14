package mui.module.samsung;

/**
	Object having functions needed for desirable operation of an application.
**/
#if !browser
@:native("Common.API.Widget") extern
#end
class Widget
{
	public function new():Void {}

	/**
		Notifies the Application Manager that the application is ready to be 
		displayed. This event should be passed to display and run the 
		application on the screen.
	*/
	public function sendReadyEvent():Void {}

	/**
		Has the same effect as pressing the exit key. Stops the application 
		and goes back to the TV screen.
	**/
	public function sendExitEvent():Void {}

	/**
		Has the same effect of pressing the Return key. Finishes the 
		application and takes you to the Application Manager.
	**/
	public function sendReturnEvent():Void {}

	/**
		Prevents a key event (RETURN or EXIT) from closing the application.
	**/
	public function blockNavigation(keyEvent:Dynamic):Void {}

	/**
		Works around a memory leak in the implementation of `innerHTML` on the 
		Samsung implementation of WebKit.
		
		@param div Div Element to use innerHTML
		@param contents Things to insert in innerHTML
	**/
	public function putInnerHTML(divElement:Dynamic, contents:String):Void {}

	/**
		Returns the path of xml file having the child application list of the 
		current channel bound application. This method is used when the channel 
		bound application needs information on the currently installed child 
		application.

		@return xml file path
	**/
	public function getChannelWidgetListPath():String { return ""; }

	/**
		Returns the path of xml file having the list of applications related. 
		This method is used when a search tag in config.xml requires 
		information on an application whose search tag is set as "y".

		@return xml file path
	 */
	public function getSearchWidgetListPath():String { return ""; }

	/**
		Launches another SmartHub application.

		@param appID The application ID to launch.
		@param extraInfo Additional information passed to the application.
	**/
	public function runSearchWidget(appID:String, extraInfo:String):Void {}

	/**
		Method called when checking to have the valid ticket for current 
		logged-in user. You should register event handler for passing the 
		return value. If you have valid ticket, the return value is 
		"stat=ok&ticket=686a8281-e952-4dcc- a67b-57e8f92e5530" 
		Otherwise, it is "stat=fail&ticket=null".
		
		example usage:
		<code>
		// Register Event Handler
		curWidget.onWidgetEvent = AAAA;
		
		var widgetAPI = new Common.API.Widget();
		widgetAPI.checkSapTicket();
 		
		AAAA (event) {
				if( event.type == Common.API.EVENT_ENUM.PNS_CHECK_TICKET) {
					// The return value is event.data.
					// TODO
				}
		}
		</code>
	**/
	public function checkSapTicket():Void {}

	/**
		Method called when requesting new Sap Ticket for Application Server.
		
		You should register event handler for passing the return value. If new 
		ticket is generated normally, the return value is 
		“stat=ok&ticket=686a8281- e952-4dcc-a67b-57e8f92e5530” Otherwise, 
		it is “stat=fail&ticket=null”.
		
		<code>
		/// Register Event Handler
		curWidget.onWidgetEvent = AAAA;
		
		var widgetAPI = new Common.API.Widget();
		widgetAPI.requestSapTicket();
		
		function AAAA(event) {
				if( event.type == Common.API.EVENT_ENUM.PNS_REQUEST_TICKET){
					// The return value is event.data.
					// TODO
				}
		}
		</code>
	**/
	public function requestSapTicket():Void {}
}

