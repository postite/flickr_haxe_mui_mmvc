package flickrapp.flickr.view;

import flickrapp.flickr.view.SearchBoxView;
import flickrapp.flickr.signal.LoadFlickrData;
import flickrapp.flickr.model.GalleryModel;

class SearchBoxViewMediator extends mmvc.impl.Mediator<SearchBoxView>
{

	@inject 
	public var loadFlickrData:LoadFlickrData;

	@inject 
	public var galleryModel: GalleryModel;

	public function new()
	{
		super();
	}

	override function onRegister()
	{
		trace("----first register -------");
		//when mapped, it will call its view to create views
		super.onRegister();
		//add listerner for the signal of botton view, here we just add handler for the signal, 
		//if the signal dispatched, it will call the handler to process it
		mediate(view.clickSignal.add(searchHandler));
	}

	override public function onRemove():Void
	{
		super.onRemove();
	}

	function searchHandler(searchTerm:String, num:String)  //two arguments signal
	{
		
			// use the signal to dispatch search operation to fetch images from flickr
		loadFlickrData.dispatch(searchTerm, Std.parseInt(num));
		galleryModel.num=Std.parseInt(num);
	}
}