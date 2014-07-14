package flickrapp.flickr.view;


import mui.display.Color;
import mui.display.Bitmap;
import mui.core.Container;
import mui.control.Button;
import mui.display.Image;
import msignal.Signal;

enum ViewAction
{
    Next;
    Previous;
}


class GalleryZoomView extends Container
{

   public var image: Image;
   public var leftButton: Button;
   public var rightButton: Button;
   public var exitButton: Button;
   public var clickSignal:Signal1<ViewAction>;

	public function new(imgId:String, imgUrl:String)
	{
         trace("new gallerydetailed view");
		 super();

         clickSignal = new Signal1(ViewAction);

         fill = new Color(0xf6f5f1, 0.5);
         stroke = new Color(0xe8e8e8);
         strokeThickness = 2;
         width = 800;
         height = 600;
         left=right=top=bottom=100;

         image = new Image();
         addChild(image);
        
         image.autoSize = false;
         image.left=image.right=100;
         image.width = width;
         image.height = height;
         image.scaleMode = ScaleMode.FILL;
         image.clip = true;
         image.url = imgUrl;

         image.loaded.addOnce(imageLoaded);
         image.failed.addOnce(imageFailed);
		 
	}

	function imageLoaded()
	{
         leftButton = new Button();
         rightButton = new Button();
          
         exitButton = new Button();
         exitButton.width=exitButton.height=50;
         exitButton.fill = new Color (0xAA0000,0.8);
         exitButton.right=exitButton.top=5;

         leftButton.width = leftButton.height = rightButton.width = rightButton.height = 50;
         leftButton.top=leftButton.bottom=rightButton.top=rightButton.bottom=275;
         leftButton.fill = rightButton.fill = new Color (0xAA0000,0.8);
         leftButton.actioned.add(onLeftClick);
         rightButton.actioned.add(onRightClick);
         exitButton.actioned.add(onExitClick);
         
         leftButton.left=5;
         rightButton.right=5;
         addComponent(leftButton);
         addComponent(rightButton);
         addComponent(exitButton);
	}

    override function change(flag:Dynamic):Void
    {
        super.change(flag);

       // if (flag.data.GalleryItemModel)
          //  image.url = data.GalleryItemModel.url;
        
    }

	function imageFailed()
	{

	}

    function onLeftClick()
    {
         trace("left one");
         this.clickSignal.dispatch(Previous);
    }

    function onRightClick()
    {
          trace("right one");
          this.clickSignal.dispatch(Next);
    }

    function onExitClick()
    {
        mui.Lib.display.removeChild(this);
    }
}