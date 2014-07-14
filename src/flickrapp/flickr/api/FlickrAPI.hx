package flickrapp.flickr.api;

import msignal.Signal;
import haxe.Json;
import mloader.Loader;
import mloader.JsonLoader;

class FlickrAPI
{
	inline public static var API_KEY:String="4111e112a393aefbf0a66241479722cd";
	public var signal:Signal1<Json>;

	public function new()
	{
		signal=new Signal1<Json>();
	}

    /**
    * @param queryStr 
    * @param numPerPage
    */
	public function createUrl(queryStr:String, ?numPerPage:Int=30)
	{
		return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=" +
				FlickrAPI.API_KEY + "&tags=" + queryStr + "&format=json&nojsoncallback=1&per_page="+ numPerPage;
	}

	public function makeRequest(queryStr:String, ?numPerPage:Int=30)
	{
		trace('start to call flickr service');

		var loader=new JsonLoader(this.createUrl(queryStr,numPerPage));
        //loader.loaded.add(onCompleted); 
        loader.loaded.add(onLoadedContent);
        //loader.failed.add(onFailed);
        // add the handler to process the event after the json file loaded from flickr
        loader.load();
	}

    /**
	Dispatches completed signal if JSONLoader is successful
	*/
	public function onLoadedContent(event: LoaderEvent<Json>)
	{
		trace("the json file has been loaded");
        signal.dispatch(event.target.content);//dispatch the query result (Json type)
	}

	/**
	Dispatches failed signal if JSONLoader is unsuccessful
	*/
	//function onFailed(error: LoaderError)
	//{
	//	signal.failed.dispatch(Std.string(error));
	//}


}