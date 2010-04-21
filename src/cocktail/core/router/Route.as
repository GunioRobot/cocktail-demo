package cocktail.core.router 
{
	import cocktail.Cocktail;
	import cocktail.core.Index;
	import cocktail.utils.ArrayUtil;

	/**
	 * Stores URI and resolve it's route.
	 * @author nybras | nybras@codeine.it
	 */
	public class Route extends Index 
	{
		/* VARS */
		private var _api : API;

		private var _uri : String;

		private var _mask : String;

		private var _target : String;

		private var _locale : String;

		/* INITIALIZING */
		
		/**
		 * Creates a new Route instance.
		 * @param uri	Request URI.
		 */
		public function Route( uri : String )
		{
			_uri = uri;
		}

		/* BOOTING */
		
		/**
		 * Boots the Index base class.
		 * @param cocktail	Cocktail reference.
		 */
		override public function boot( cocktail : Cocktail ) : *
		{
			var s : *;
		
			s = super.boot( cocktail );
			_resolve( );
			return s;
		}

		/* RESOLVING */
		
		/**
		 * Resolves the route.
		 */
		private function _resolve() : void
		{
			_locale = _get_locale( _uri );
			_mask = routes.wrap( _purge_locale( _uri ) );
			_target = routes.unwrap( _purge_locale( _uri ) );
			( _api = new API( _target ) ).boot( _cocktail );
		}

		/**
		 * Extracts the locale from the given URI.
		 * @return	The extracted locale.
		 */
		private function _get_locale( uri : String ) : String
		{
			var locale : String;
			
			locale = uri.split( "/" ).shift( );
			
			// If URI hasn't a locale string prefix, then the current
			// or default locale is used.
			if ( !ArrayUtil.has( config.locales, locale )  )
				locale = ( config.current_locale || config.default_locale );
			
			return locale;
		}

		/**
		 * Extracts the locale from the given URI.
		 * @param uri	The URI without the locale prefix.
		 */
		private function _purge_locale( uri : String ) : String
		{
			return ArrayUtil.del( uri.split( "/" ), _locale ).join( "/" );
		}

		/* GETTERS */
		
		/**
		 * Returns the route mask.
		 * @return	Route mask.
		 */
		public function get mask() : String
		{
			return _mask;
		}

		/**
		 * Returns the route target.
		 * @return	Route target.
		 */
		public function get target() : String
		{
			return _target;
		}

		/**
		 * Returns the route locale.
		 * @return	Route locale.
		 */
		public function get locale() : String
		{
			return _locale;
		}

		/**
		 * Returns the route API.
		 * @return	Route API.
		 */
		public function get api() : API
		{
			return _api;
		}
	}
}

import cocktail.Cocktail;
import cocktail.core.Index;
import cocktail.lib.Controller;
import cocktail.utils.StringUtil;

/**
 * Route API - stores system execution infos (controller, action, params).
 * @author nybras | nybras@codeine.it 
 */
internal class API extends Index
{
	/* ---------------------------------------------------------------------
	VARS
	--------------------------------------------------------------------- */
	private var _uri : String;

	private var _index : Index;

	public var controller : String;

	public var action : String;

	public var params : *;

	public var folder : String;

	/* ---------------------------------------------------------------------
	INITIALIZING
	--------------------------------------------------------------------- */
	
	/**
	 * Translates the given uri to an API call.
	 * @param uri	URI to be translated.
	 */
	public function API( uri : String )
	{
		_uri = uri;
	}

	/* ---------------------------------------------------------------------
	BOOTING
	--------------------------------------------------------------------- */
	
	/**
	 * Boots the Index base class.
	 * @param cocktail	Cocktail reference.
	 */
	override public function boot( cocktail : Cocktail ) : *
	{
		var parts : Array;
		var s : *;
		
		s = super.boot( cocktail );
		
		parts = _uri.split( "/" );
		
		controller = StringUtil.toCamel( parts[ 0 ] );
		folder = StringUtil.toUnderscore( controller );
		action = parts[ 1 ];
		params = [].concat( parts.slice( 2 ) );
		
		return s;
	}

	/* ---------------------------------------------------------------------
	RUNNING
	--------------------------------------------------------------------- */
	
	/**
	 * Runs the API call into the given controller.
	 * @param controller	Controller to run the API call.
	 */
	public function run( controller : Controller ) : void
	{
		_index.exec( controller, action, params );
	}
}