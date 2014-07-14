package flickrapp.flickr.signal;

import msignal.Signal;
import flickrapp.flickr.model.GalleryModel;

/**
Application signal for loading json file from flickr server.

Includes sub signals for completed/failed handlers once list is loaded.
*/
class LoadFlickrData extends Signal2<String, Int>
{
	/**
	dispatched once galleryModel has been loaded
	*/
	//public var completed:Signal1<GalleryModel>;

	/**
	Dispatched if application unable to load galleryModel
	*/
	//public var failed:Signal1<Dynamic>;
	
	public function new()
	{
		super(String, Int);
	//	completed = new Signal1<GalleryModel>(GalleryModel);
	//	failed = new Signal1<Dynamic>(Dynamic);
	}
}