package  
{
	import cocktail.Cocktail;

	import demo.boot.Routes;
	import demo.boot.Embedder;

	import flash.display.Sprite;

	/**
	 * Document class.
	 * @author nybras | nybras@codeine.it
	 */
	public class CocktailDemo extends Sprite 
	{
		/* 	VARS */
		private var _cocktail : Cocktail;

		/* 	INITIALIZING */
 
		/**
		 * Initializes App & Cocktail.
		 */
		public function CocktailDemo()
		{
			var embedder : Embedder;
			var routes : Routes;
			var app_id : String;
			var url : String;
			
			embedder = new Embedder( );
			routes = new Routes( );
			app_id = "demo";
			url = "/main/home";
			
			_cocktail = new Cocktail( this, embedder, routes, app_id, url );
			
			_cocktail.log_level  = 6;
			_cocktail.log_detail = 2;
		}
	}
}