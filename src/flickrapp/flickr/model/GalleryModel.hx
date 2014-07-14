package flickrapp.flickr.model;

import flickrapp.flickr.model.GalleryItemModel;
import msignal.Signal;
import mdata.ArrayList;

class GalleryModel extends mdata.SelectableList<GalleryItemModel>
{

	public var num:Int;

	public function new(?values:ArrayList<GalleryItemModel>=null)
	{
		super(values);
	}

	public function getAll()
	{
		return this.source;
	}

	public function findByImgId(id: String):GalleryItemModel
	{
		for( model in this.source ) 
		{
			if( model.id == id ) 
			{
				return model;
			}
		}

		return null;
	}

    /*
	public function getPreImageIndex(id: String): Int
	{
	   var index=0;

       for( model in this.source ) 
		{
			if( model.id == id ) 
			{
				if(index<1)
				{
					return 0;
				} else
				{
					return index-1;
				}
			}
			index++;
		}

		return index;
	}

	public function getAfterImageIndex(id: String): Int
	{
	   var index=0;

       for( model in this.source ) 
		{
			if( model.id == id ) 
			{
				if(index==this.source.length-1)
				{
					return this.source.length-1;
				} else
				{
					return index+1;
				}
			}
			index++;
		}

		return index;
	}

	public function findByImgIndex(index: Int):GalleryItemModel
	{
		return this.source[index];
	}
	*/
}