package flickrapp.flickr.command;

import flickrapp.flickr.api.FlickrAPI;
import flickrapp.flickr.model.GalleryModel;
import flickrapp.flickr.model.GalleryItemModel;
import haxe.Json;
import mmvc.impl.Command;
import flickrapp.flickr.signal.LoadFlickrData;

//typedef FlickrResponse = 
//{
//	var stat:String;
//	var photos:Array<FlickrPhoto>;
//}

//typedef FlickrPhoto =
//{

//}

/**
Loads the flickr data from flickr server and 
Dispatches LoadFlickrData.completed or failed signal based on result of loader.
*/
class LoadFlickrDataCommand extends mmvc.impl.Command
{
	@inject
	public var flickr:FlickrAPI;   //inject the object without new it

	@inject
	public var galleryModel:GalleryModel; //inject the object without new it

	@inject 
	public var queryStr:String;

	@inject
	public var numPerPage:Int;

	public function new()
	{
		super();
	}

	/**
	loads a json file from flickr server, it is triggered by the dispatch from LoadFlickrData signal
	*/
	override public function execute():Void
	{

		trace("execute the loading of flickr images");
		flickr.makeRequest(this.queryStr, this.numPerPage);
		//flickr.signal.addOnce(completed);
		flickr.signal.addOnce(completed);
		//flickr.signal.addOnce(failed);
	}

	/**
	Converts the raw json object into gallery items
	Dispatches completed signal on completion.

	@param resp 	raw json object
	*/
	function completed(resp:Json)
	{
		trace("search started.");
		if(galleryModel.length>0)
		{
			galleryModel.clear();
		}

		if(Reflect.field(resp,'stat')=='ok')
		{
			var resultArray=[];

			var photos = cast(Reflect.field(Reflect.field(resp, 'photos'), 'photo'), Array<Dynamic>);
			for( photo in photos )
			{
				var farm = Reflect.field(photo, 'farm');
				var server = Reflect.field(photo, 'server');
				var id = Reflect.field(photo, 'id');
				var secret = Reflect.field(photo, 'secret');
				//generate the url for the image 
				var url = "http://farm" + farm + ".staticflickr.com/" + server + "/" + id + "_" + secret + "_n.jpg";
				
				resultArray.push(new GalleryItemModel(id, url));
			}

			//add resultArray to the gallery model
			galleryModel.addAll(resultArray);

			trace("search done.");
		}
	      	
	}
}