package flickrapp.flickr.model;

import msignal.Signal;

using mdata.Collections;

class GalleryItemModel 
{
	public var id:String;
	public var url:String;


	public function new(?id: String=null, ?url:String=null)
	{
		this.id = id;
		this.url = url;
	}
}