package flickrapp.flickr.view;

import flickrapp.flickr.view.SearchBoxView;
import flickrapp.flickr.signal.LoadFlickrData;
import flickrapp.flickr.model.GalleryModel;

class GalleryViewMediator extends mmvc.impl.Mediator<GalleryView>
{

	@inject 
	public var galleryModel:GalleryModel;

	public function new()
	{
		super();
	}

	override function onRegister()
	{
		trace("mediated galleryview to its mediator");
		super.onRegister();
		//listen to the cnhange of galleryModel
		mediate(galleryModel.changed.add(onGalleryModelUpdate));
	}

	override public function onRemove():Void
	{
		super.onRemove();
	}

	function onGalleryModelUpdate(event:Dynamic)  //two arguments signal
	{
		switch(event.type[0])
		{
			case "Add":
			{
				view.gridLayout.wrapIndex = Math.round(galleryModel.num/5)+1;
				var galleryItemModels = galleryModel.getAll();
				for( galleryItemModel in galleryItemModels )
				{
					view.addImage(galleryItemModel.id, galleryItemModel.url);
				}
			}

			case "Remove":
			{
				view.removeImages();
			}
		}
	}
}