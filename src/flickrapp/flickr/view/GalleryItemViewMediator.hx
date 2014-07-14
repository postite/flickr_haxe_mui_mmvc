package flickrapp.flickr.view;

import flickrapp.flickr.view.GalleryItemView;


class GalleryItemViewMediator extends mmvc.impl.Mediator<GalleryItemView>
{
	

	public function new()
	{
		super();
	}

	override function onRegister()
	{
		//when mapped, it will call its view to create views

        trace("mediated itemview to its mediator");
		super.onRegister();
		//mediate(view.actioned)
		
	}

	override public function onRemove():Void
	{
		super.onRemove();
	}
	
}