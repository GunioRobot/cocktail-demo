package cocktail 
{
	import cocktail.core.bind.Bind;
	import cocktail.core.config.Config;
	import cocktail.core.embedder.EmbedderTail;
	import cocktail.core.factory.Factory;
	import cocktail.core.process.Process;
	import cocktail.core.router.Router;
	import cocktail.core.router.RoutesTail;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * Cocktail class is the framework first class to be initialized. It's
	 * itended to be instantiated by your application main entry class (or your
	 * document class, if you like), and so the fun starts. :-)
	 * @author nybras | nybras@codeine.it
	 */
	public class Cocktail
	{
		/* VARS */
		private var _app : Sprite;

		private var _app_id : String;

		private var _embedder : EmbedderTail;

		private var _default_uri : String; 

		private var _config : Config;

		private var _router : Router;

		private var _routes : RoutesTail;

		private var _process : Process;

		private var _bind : Bind;

		private var _factory : Factory;

		/* INITIALIZING */
		
		/**
		 * Creates a new Cocktail instance.
		 * @param app	The application reference (document_class:Sprite).
		 * @param embedder	Application embedder.
		 * @param routes	Application routes.
		 * @param app_id Application identifier (MUST be the the application
		 * folder name).
		 * @param default_uri	Application default URI.
		 */
		public function Cocktail(
			app : Sprite,
			embedder : EmbedderTail,
			routes : RoutesTail,
			app_id : String,
			default_uri : String = null
		)
		{
			_app = app;
			_app_id = app_id;
			
			_embedder = embedder;
			_routes = routes;
			_default_uri = default_uri;
			
			_bind = new Bind( );
			_factory = new Factory( ).boot( this );
			
			log_detail = 1;
			log_level = 3;
			
			if( !_app.stage )
				_app.addEventListener( Event.ADDED_TO_STAGE, _init );
			else
				_init( );
		}

		/**
		 * Initializes the cocktail.
		 * @param event	Event.ADDED_TO_STAGE.
		 */
		public function _init( event : Event = null ) : void
		{
			if ( event != null )
				_app.removeEventListener( Event.ADDED_TO_STAGE, _init );
			
			_config = new Config( ).boot( this );
			_router = new Router( ).boot( this );
			_process = new Process( ).boot( this );
		}

		/* LOGGER LEVEL and DETAIL */
		
		/**
		 * Returns the Bind reference.
		 * @return	The bind reference.
		 */
		public function get bind() : Bind
		{
			return _bind;
		}

		/**
		 * Returns the application log level.
		 * @return	The application log level.
		 */
		public function get log_level() : int
		{
			return _bind.g( "log-level" );
		}

		/**
		 * Sets the application log level.
		 * @param level	Application log level (default=3).
		 * 		<br/># 0=disable
		 * 		<br/># 1=fatal
		 * 		<br/># 2=fatal,error
		 * 		<br/># 3=fatal,error,debug
		 * 		<br/># 4=fatal,error,debug,warn
		 * 		<br/># 5=fatal,error,debug,warn,notice
		 * 		<br/># 6=fatal,error,debug,warn,notice,info
		 */
		public function set log_level( level : int ) : void
		{
			_bind.s( "log-level", level );
		}

		/**
		 * Returns the application log detail.
		 * @return	The application log detail.
		 */
		public function get log_detail() : int
		{
			return _bind.g( "log-detail" );
		}

		/**
		 * Sets the log detail.
		 * @param logDetail	Application default log detail (default=1).
		 * <br/># 0=Doesnt add any extra prefix besides the log level.
		 * <br/># 1=Adds the 'ClassName' prefix to all log calls.
		 * <br/># 2=Adds a 'packace.a.b.c..ClassName' prefix to all log calls.
		 */
		public function set log_detail( detail : int ) : void
		{
			_bind.s( "log-detail", detail );
		}

		/* GENERAL GETTERS */
		
		/**
		 * Get the reference for the app (document_class:Sprite) instance.
		 * @param	Reference to the app instance.
		 */
		public function get app() : Sprite
		{
			return _app;
		}

		/**
		 * Get the app id.
		 * @param	The app id.
		 */
		public function get app_id() : String
		{
			return _app_id;
		}

		/**
		 * Get the app default URI.
		 * @param	The app default URI.
		 */
		public function get default_uri() : String
		{
			return _default_uri;
		}

		/**
		 * Get the reference for the Config instance.
		 * @param	Reference to the Config instance.
		 */
		public function get config() : Config
		{
			return _config;
		}

		/**
		 * Get the reference for the Router instance.
		 * @param	Reference to the Router instance.
		 */
		public function get router() : Router
		{
			return _router;
		}

		/**
		 * Get the reference for the Routes instance.
		 * @param	Reference to the Routes instance.
		 */
		public function get routes() : RoutesTail
		{
			return _routes;
		}

		/**
		 * Get the reference for the Proces instance.
		 * @param	Reference to the Proces instance.
		 */
		public function get process() : Process
		{
			return _process;
		}

		/**
		 * Get the reference for the Factory instance.
		 * @param	Reference to the Factory instance.
		 */
		public function get factory() : Factory
		{
			return _factory;
		}
	}
}