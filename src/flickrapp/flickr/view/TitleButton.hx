package flickrapp.flickr.view;

import mui.control.Button;
import mui.display.Text;
import mui.display.Color;


class TitleButton extends DataButton<String>
{
	var title:Text;
	
	public function new()
	{
		super();
		
		fill = new Color(0xbbbbbb);   //white
		
		title = new Text();
		title.centerX = title.centerY = 0.5;   //align to center
		addChild(title);
	}
	
	override private function updateData(newData:String) 
	{
		super.updateData(newData);
		title.value = newData;
	}
}