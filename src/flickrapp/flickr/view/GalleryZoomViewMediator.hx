package flickrapp.flickr.view;

import flickrapp.flickr.view.GalleryZoomView;
import flickrapp.flickr.model.GalleryModel;
import flickrapp.flickr.model.GalleryItemModel;

class GalleryZoomViewMediator extends mmvc.impl.Mediator<GalleryZoomView>
{

    @inject 
    public var screenList:GalleryModel;

    public function new()
	{
		super();
	}

	override function onRegister()
	{
		trace("zoom view mediator");
		super.onRegister();
	}

	/*function onRegister()
	{
		//when mapped, it will call its view to create views
		trace("mediated gallerydetailview to mediator");
		super.onRegister();
		//add listerner for the signal of botton view

		view.data = screenList;
		mediate(view.clickSignal.add(viewActioned));
	}*/

	override public function onRemove():Void
	{
		super.onRemove();
	}

	function viewActioned(action:ViewAction)
	{
			navigateList(action);
	}

    /*
	function onClick(id:String, type:String)
	{

        var galleryItem:Dynamic = new GalleryItemModel();
		trace("-------id:"+id+" type:"+type);
		if(type==GalleryDetailedView.LEFT)
		{
           galleryItem =  galleryModel.findByImgIndex(galleryModel.getPreImageIndex(id));
           
		}else if(type==GalleryDetailedView.RIGHT)
		{
		   galleryItem =  galleryModel.findByImgIndex(galleryModel.getAfterImageIndex(id));
		}

		view.id = galleryItem.id;
		view.image.url = galleryItem.url;
	}*/

	function navigateList(action:ViewAction)
	{

		trace("start to change the selected index of screenlist view");
		var index = switch (action)
		{
			case Next: screenList.selectedIndex + 1;
			case Previous: screenList.selectedIndex - 1;	
		}

		if (index >= 0 && index < screenList.size)
			screenList.selectedIndex = index;
	}
}