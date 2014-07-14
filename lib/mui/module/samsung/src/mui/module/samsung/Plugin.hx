package mui.module.samsung;

/**
	Object that is wrapped for convenient use of plugins
**/
#if !browser
@:native("Common.API.Plugin") extern
#end
class Plugin
{
	public function new():Void {}

	/**
		Turns on the Watch dog function.
	**/
	public function setOnWatchDog():Void {}

	/**
		Turns off the Watch dog function.
	**/
	public function setOffWatchDog():Void {}

	/**
		Lets the Application Manager register specific key
		
		Registration/Unregistration of keys should be done after window.onshow event.
		Refer to Chap. 6.4 How to use keys on remote control for more details.

		Example usage:

			var pluginAPI = new Common.API.Plugin();
			pluginAPI.registKey(tvKey.KEY_	);

		@param pNumKeyCode key code
	**/
	public function registKey(pNumKeyCode:Int):Void {}

	/**
		Lets the Application Manager unregister specific key
		
		Registration/Unregistration of keys should be done after window.onshow event.
		Refer to Chap. 6.4 How to use keys on remote control for more details.

		Example usage:

			var pluginAPI = new Common.API.Plugin();
			pluginAPI.unregistKey(tvKey.KEY_	);

		@param pNumKeyCode key code
	**/
	public function unregistKey(pNumKeyCode:Int):Void {}

	/**
		Lets the Application Manager register IME key
		
		Registers number keys from 0 to 9, `-` (hyphen), and previous channel key used in entering IME.
		Registration/Unregistration of keys should be done after window.onshow event.
		Refer to Chap. 6.4 How to use keys on remote control for more details.
	**/
	public function registIMEKey():Void {}

	/**
		Lets the Application Manager unregister IME key
		
		Unregisters number keys from 0 to 9, ã-ã(hyphen), previous channel key used in entering IME.
		Registration/Unregistration of keys should be done after window.onshow event.
		Refer to Chap. 6.4 How to use keys on remote control for more details.
	**/
	public function unregistIMEKey():Void {}

	/**
		Lets the Application Manager register all keys
		
		Registers all keys Registration/Unregistration of keys should be done after
		window onshow event. Refer to Chap. 6.4 How to use keys on remote control for more details.
	**/
	public function registAllKey():Void {}

	/**
		Lets the Application Manager unregister all keys
		
		Unregisters all keys Registration/Unregistration of keys should be done after window onshow event.
		Refer to Chap. 6.4 How to use keys on remote control for more details.
	**/
	public function unregistAllKey():Void {}

	/**
		Lets the Application Manager register specific key group
		
		Registers keys for fullwidget Registration/Unregistration of keys should be done after
		window onshow event. Refer to Chap. 6.4 How to use keys on remote control for more details.
	**/
	public function registFullWidgetKey():Void {}

	/**
		Lets the Application Manager register specific key group
		
		Registers keys for part widget Registration/Unregistration of keys should be done after window
		onshow event. Refer to Chap. 6.4 How to use keys on remote control for more details.
	**/
	public function registPartWidgetKey():Void {}
	
	/**
		Sets the area where OSD is protected.
		
		@param left left coordinate of the area
		@param top top coordinate of the area
		@param width width of the area
		@param height height of the area
	**/
	public function setOnOSDState(left:Int, top:Int, width:Int, height:Int):Void {}

	/**
		Cancels the previously set OSD area.
		
		object id: requires pluginObjectVideo
		
		@param left left coordinate of the area
		@param top top coordinate of the area
		@param width width of the area
		@param height height of the area
	**/
	public function setOffOSDState(left:Int, top:Int, width:Int, height:Int):Void {}

	/**
		A function using when you want to put volume and channel OSD with the application.
		
		When you intend to bring up volume OSD on the screen, volume key value should be registered.
		So does channels.
		
		Example usage:
		
			var PL_NNAVI_STATE_BANNER_NONE = 0;
			var PL_NNAVI_STATE_BANNER_VOL = 1;
			var PL_NNAVI_STATE_BANNER_VOL_CH = 2;
			
			var pluginAPI = new Common.API.Plugin();
			var tvKey = new Common.API.TVKeyValue();
			
			pluginAPI.unregistKey(tvKey.KEY_VOL_UP);
			pluginAPI.unregistKey(tvKey.KEY_VOL_DOWN);
			pluginAPI.SetBannerState(PL_NNAVI_STATE_BANNER_VOL);
		
		@param nState Defined value on OSD you want to bring with the application.
				PL_NNAVI_STATE_BANNER_NONE = 0;
				PL_NNAVI_STATE_BANNER_VOL = 1;
				PL_NNAVI_STATE_BANNER_VOL_CH = 2;
	**/
	public function SetBannerState(nState:Int):Void {}

	/**
		A function to bring popup windows for screen and sound adjustment.
		
		You can see the point when the popup window is closed by signing up for 
		curWidget.onWidgetEvent.
		
		object id: requires pluginObjectNNavi
		
		Example usage:
		
			curWidget.onWidgetEvent = function(){
					// a code that will be executed after closing the popup window
			}
			var pluginAPI = new Common.API.Plugin();
			pluginAPI.ShowTools(1);
		
		@param nTool Defined value on a popup window you want to bring.
					0 : Sound Setting popup
					1 : Picture Setting popup
	**/
	public function ShowTools(nTool:Int):Void {}

	/**
		The function to set idle on to close the application in case that there 
		is no input for a certain time
		
		1. Default is set as 'Idle ON'.
		2. Recall the function when idle process is required after calling 
		   setOffIdleEvent method.(ex. When closing image playing)
	**/
	public function setOnIdleEvent():Void {}

	/**
		The function to set idle off in order not to close the application 
		despite no input for a certain time
		
		1. Default is set as 'idle ON'.
		2. Setting Idle off is needed in case of watching clips for a long time
	**/
	public function setOffIdleEvent():Void {}

	/**
		The function to set on screen saver
		
		Screensaver is off when the application is closed.
	**/
	public function setOnScreenSaver():Void {}

	/**
		The function to set off screen saver
		
		Available after calling setOnScreenSaver
	**/
	public function setOffScreenSave():Void {}

	/**
		The function to set on full screen.
		
		In case of `<fullwidget>y</fullwidget>`, it is not necessary 
		to call this function.
	**/
	public function setOnFullScreen():Void {}

	/**
		The function to set off full screen.
		
		Available after calling setOnFullScreen.
	**/
	public function setOffFullScreen():Void {}

	/**
		The function to decide whether the key value currently entered is for 
		TV View or application
		
		When the TV viewer needs to proceed the entered remote control keys, 
		the inputted value in TV viewer is automatically transferred
		
		@param pKeyCode entered remote control key value at present
		
		@return True - Key processing by TV Viewer
				False - Key processing by Application
	**/
	public function isViewerKey(pKeyCode:Int):Bool
	{
		return false;
	}
}
