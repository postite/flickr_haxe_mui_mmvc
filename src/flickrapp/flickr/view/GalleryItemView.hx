package flickrapp.flickr.view;


import mui.display.Color;
import mui.display.Bitmap;
import mui.control.Button;
import mui.display.Image;
import msignal.Signal;
import flickrapp.app.ApplicationView;
import flickrapp.flickr.view.GalleryZoomView;
import mui.transition.Slide;
import mui.transition.Ease;


class GalleryItemView extends Button
{

    public var url:String;
    public var id: String;

    public var image: Image;

	public function new(imgId:String, imgUrl:String)
	{
		   super();		 

         fill = new Color(0xf6f5f1);
         stroke = new Color(0xe8e8e8);
         strokeThickness = 2;
         width = 200;
         height = 150;

         image = new Image();
         addChild(image);
        
         image.autoSize = false;
         image.width = width;
         image.height = height;
         image.scaleMode = ScaleMode.FILL;
         image.clip = true;
         image.url = imgUrl;

         url = imgUrl;
         id = imgId;

         image.loaded.add(imageLoaded);
         image.failed.add(imageFailed);  
	}

	function imageLoaded()
	{     
         this.actioned.add(showDetailedImage);
	}

	function imageFailed()
	{

	}

    public function showDetailedImage()
    {
        var galleryZoomView:GalleryZoomView = new GalleryZoomView(id, url);
        mui.Lib.display.addChild(galleryZoomView);
        Slide.to(100,50, {ease:Ease.outCubic}).from (200, 200).apply(galleryZoomView);

        //this.parent.parent.parent.addChild(galleryDetailedView);
        //this.container.parent.addChild(galleryDetailedView);
        // new mui.transition.Tween(galleryDetailedView, 10, {frames:5});

    }
}