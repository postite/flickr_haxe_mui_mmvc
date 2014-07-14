import flickrapp.app.ApplicationView;
import flickrapp.app.ApplicationContext;

class Main
{
	/**
	Instanciates the main ApplicationView and the ApplicationContext.
	This will trigger the ApplicationViewMediator and kick the application off.
	*/
	public static function main()
	{
		var view = new ApplicationView();
		new ApplicationContext(view);
		mui.Lib.display.addChild(view);
		view.initialize();
	}
}