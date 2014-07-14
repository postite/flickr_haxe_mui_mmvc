package flickrapp.app;

import flickrapp.flickr.view.SearchBoxView;
import flickrapp.flickr.view.GalleryView;
import mui.container.Application;
import mui.display.Color;
import msignal.Signal;

/**
here application view extends Application, it is different from the View
all the view will be a display component that is added into mui application
*/

class ApplicationView extends Application
{
	var searchBoxView:SearchBoxView;
	var galleryView:GalleryView;

	public function new()
	{
		super();
		all = 0; 

		width = 1000;
		height = 700;
		scroller.enabled = true;
		left = right = 50;
		bottom = 10;
        fill = new Color(0xFFFFFFF);
        layout.enabled = true;
	}

	public function initialize()
	{
	    searchBoxView = new SearchBoxView();
		galleryView = new GalleryView();

		addComponent(searchBoxView);
		addComponent(galleryView);
	}	
}