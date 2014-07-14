package flickrapp.flickr.view;


import mui.display.Color;
import mui.display.Text;
import mui.input.Form;
import mui.input.FormGroup;
import mui.input.*;
import mui.validator.*;
import mui.input.SelectInput;
import mui.core.Container;
import mui.core.Component;
import mui.control.Button;
import mui.layout.GridLayout;
import msignal.Signal;

class GalleryView extends Container
{

	public var gridLayout:GridLayout;

	public function new()
	{
		 super();	
		 left = right = 0;
		 height = 400;
		 width = 1000;
         fill = new Color(0xf6f5f1);
		 stroke = new Color(0xe8e8e8);
         strokeThickness = 2;
        
         gridLayout= new GridLayout();

         gridLayout.cellWidth = 200;
         gridLayout.cellHeight = 150;

         layout=set_layout(gridLayout);
         layout.enabled = true;
         layout.spacingX = layout.spacingY = 10;
	}

	public function addImage(id:String, url:String)
	{
		var itemView = new GalleryItemView(id, url);
		addComponent(itemView);
	}

	public function removeImages()
	{
		if(numComponents > 0)
		removeComponents();
	}

}