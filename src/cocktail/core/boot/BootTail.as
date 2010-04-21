package cocktail.core.boot 
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;	

	/**
	 * Boots the framework, initializing the main preloader, and loading
	 * the 'core.swf' file.
	 * @author nybras | nybras@codeine.it
	 */
	public class BootTail extends Sprite 
	{
		/* VARS */
		private var _loader : Loader;

		/* INITIALIZING */
		
		/**
		 * Creates a new BootTail instance.
		 */
		public function BootTail()
		{
			stage.scaleMode = "noScale";
			stage.align = "LT";
			_load( );
		}

		/* BOOTING APPLICATION */
		
		/**
		 * Loader application.
		 */
		private function _load( ) : void
		{
			_loader = new Loader( );
			_loader.contentLoaderInfo.addEventListener( "complete", _render );
			_loader.load( new URLRequest( _app_path ) );
		}

		/**
		 * Render/Start application. 
		 * @param event	Event.COMPLETE
		 */
		private function _render( event : Event ) : void
		{
			addChild( _loader.content );
			_loader.contentLoaderInfo.removeEventListener( "complete", _render );
			_loader = null;
		}

		/* APPLICATION PATH */
		
		/**
		 * Returns the computed application 'core.swf' path, adding a random
		 * string to avoid cache.
		 */
		private function get _app_path() : String
		{
			return	root.loaderInfo.parameters[ "app" ] + "?cocktail=" + Math.random( );
		}
	}
}