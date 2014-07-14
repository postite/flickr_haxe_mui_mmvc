package mui.module.widevine;

import flash.errors.*;
import flash.utils.ByteArray;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.events.Event;

class WvChapter
{
	var myBitmap:Bitmap;
	var myIndex:Float;
	var myName:String;
	var myChapterNum:Int;
	var myLoader:Loader;
	
	public var myByteArray:ByteArray;
		
	public function new(chapterNum:Int)
	{
		myChapterNum 	= chapterNum;
		myLoader 		= new Loader();
		myLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler);
		myByteArray 	= new ByteArray();
	}
	
	///////////////////////////////////////////////////////////////////////////
	// Read chapterData from the socket. 
	// Parameters:
	//		[in]	socket to read data from
	// Returns:
	//		false if no chapterData is available
	//
	public function loadData(src:String):Bool
	{
		myName 	= getStringFromMsg("Title=", src);
		if (myName == null) {
			return false;
		}
		myIndex = Std.parseFloat(getStringFromMsg("TimeIndex=", src));
		if (myName.length == 0) {
			myName = "Chapter " + (myChapterNum + 1);
		}

		//trace("Chapter#" + myChapterNum + ", Title:" + myName + ", Index:" + myIndex);
		return true;
	}
	///////////////////////////////////////////////////////////////////////////
	public function loadImage():Bool
	{
		try {
			myLoader.loadBytes(myByteArray);
		}
		catch (e:Error) {
			//trace("WVChapter::loadImage() error:" + e.message);
			return false;
		}
		return true;
	}
	///////////////////////////////////////////////////////////////////////////
	private function loaderCompleteHandler(event:Event):Void
	{
		var loaderInfo:LoaderInfo = cast event.target;
		var loader:Loader = loaderInfo.loader;
		myBitmap = cast(loader.content, Bitmap);
		//trace("loaded " + myName + " image. Width:" + myBitmap.width + ", Height:" + myBitmap.height
		//	  			+ ", bytes:" + loader.contentLoaderInfo.bytesLoaded);
	}		
	///////////////////////////////////////////////////////////////////////////
	// Paramters:
	//		[out]	image as a bitmap  
	//	Returns:	
	//		0
	//
	public function getBitmapData():BitmapData
	{
		return myBitmap.bitmapData;
	}
	public function getBitmap():Bitmap
	{
		return myBitmap;
	}
	///////////////////////////////////////////////////////////////////////////
	public function getIndex():Float
	{
		return myIndex/1000000;
	}
	///////////////////////////////////////////////////////////////////////////
	public function getName():String
	{
		return myName;
	}	
	///////////////////////////////////////////////////////////////////////////
	public function hasBitmap():Bool
	{
		if (myBitmap == null) {
			return false;
		}
		return true;
	}	
	///////////////////////////////////////////////////////////////////////////
	private function getStringFromMsg(key:String, msg:String):String
	{
		var loc1:Int = msg.indexOf(key);
		if (loc1 == -1) {
			//trace("Did not find \"" + key + "\" in:" + msg);
			return null;
		}
		loc1 += key.length; 
		// find <CR>
		var loc2:Int = msg.indexOf("\n", loc1);
		if (loc2 == -1) {
			//trace("Did not find <CR> starting in:" + msg.substr(loc1));
			return msg.substr(loc1);
		}
		return msg.substr(loc1, loc2-loc1);
	}
	///////////////////////////////////////////////////////////////////////////
	public function getNumber():Int
	{
		return myChapterNum;
	}
	///////////////////////////////////////////////////////////////////////////
	public function close():Void 
	{
		myBitmap = null;
		myByteArray = null;
		myLoader = null;
	}
}