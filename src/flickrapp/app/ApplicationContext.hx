package flickrapp.app;

import mmvc.api.IViewContainer;

import flickrapp.flickr.signal.LoadFlickrData;
import flickrapp.flickr.command.LoadFlickrDataCommand;
import flickrapp.flickr.model.GalleryModel;
import flickrapp.flickr.model.GalleryItemModel;
import flickrapp.flickr.view.SearchBoxView;
import flickrapp.flickr.view.SearchBoxViewMediator;
import flickrapp.flickr.view.GalleryView;
import flickrapp.flickr.view.GalleryViewMediator;
import flickrapp.flickr.view.GalleryItemView;
import flickrapp.flickr.view.GalleryItemViewMediator;
import flickrapp.flickr.view.GalleryZoomView;
import flickrapp.flickr.view.GalleryZoomViewMediator;
import flickrapp.flickr.api.FlickrAPI;
/**
Application wide context.
<p>Provides mapping of following classes:
<ul>
	<li>Signals to commands</li>
	<li>Models</li>
	<li>Views to ViewMediators</li>
</ul> 
</p>
@see mmvc.impl.Context
*/
class ApplicationContext extends mmvc.impl.Context
{
	public function new(?contextView:IViewContainer=null)
	{
		super(contextView);
	}

	/**
	Overrides startup to configure all context commands, models and mediators
	@see mmvc.impl.Context
	*/
	override public function startup()
	{
		// wiring for gallery model

        mediatorMap.mapView(GalleryZoomView, GalleryZoomViewMediator);
		//mediatorMap.mapView(GalleryDetailedView, GalleryDetailedViewMediator);
		mediatorMap.mapView(SearchBoxView, SearchBoxViewMediator);
		mediatorMap.mapView(GalleryView, GalleryViewMediator);
		mediatorMap.mapView(GalleryItemView, GalleryItemViewMediator);

		commandMap.mapSignalClass(LoadFlickrData, LoadFlickrDataCommand);

        injector.mapSingleton(FlickrAPI);
		injector.mapSingleton(GalleryModel); 
		injector.mapSingleton(GalleryItemModel);
	}

	/**
	Overrides shutdown to remove/cleanup mappings
	@see mmvc.impl.Context
	*/
	override public function shutdown()
	{
		
	}
}