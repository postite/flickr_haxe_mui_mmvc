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
import msignal.Signal;
import flickrapp.flickr.view.TitleButton;


class SearchBoxView extends Container
{

	public var clickSignal:Signal2<String, String>;// signal with 2 arguments
	
	public var form(default, null):Form;

	inline public static var DO_SEARCH = "do search";

	//typedef queryStr = {keywords:String, number:Int}

	public function new()
	{
		super();
		//all = 0;
         width = 1000;
		 height = 300;
		 left = right = 0;

         this.clickSignal=new Signal2<String, String>();
		// ok, setup the views for search box
		 
         form = new Form();
         //form.enabled = true;
         addComponent(form);
         
         form.strokeThickness = 2;
         form.left = form.right = 0;
		 form.fill = new Color(0xf6f5f1);
		 form.stroke = new Color(0xe8e8e8);
		 form.height = 300;
		 form.width = 1000;
		 
		 
		 var errors = new Component();
		 addComponent(errors);
		 errors.width = 700;
		 errors.height = 0;
		 errors.clip = true;
		 errors.fill = new Color(0xAA0000);

		 var errorText = new Text();
		 errors.addChild(errorText);
		 errorText.color = 0xFFFFFF;
		 errorText.multiline = true;
		 errorText.left = errorText.right = 80;
		 errorText.y = 18;
		 errorText.size = 16;

		 var theme = new mui.input.Theme();
		 var builder = new mui.input.ThemeFormBuilder(theme);
		 builder.build(form)
			.group("Search filter")
				.text("Keywords", "Keywords: cat/camera/car")
					.required("Please enter the keywords")
				.text("NumberPerPage", "Numbers per page: 10/50/100")
					.required("Please enter the numbers");

		 var submit = new TitleButton();
		 submit.width = 200;
		 submit.height = 50;
		 submit.updateData("Search");
	
		 form.addComponent(submit);

		 submit.actioned.add(onSubmit);
	}

	function onSubmit()
	{
		  trace("submit button clicked");
		  var keywords = form.getInputData("Keywords");
		  var num = form.getInputData("NumberPerPage");
          //queryStr={keywords,num};

          this.clickSignal.dispatch(keywords, num);

	}

}