package cocktail.core 
{
	import cocktail.Cocktail;
	import cocktail.core.config.Config;
	import cocktail.core.gunz.Gunz;
	import cocktail.core.logger.Logger;
	import cocktail.core.router.Router;
	import cocktail.core.router.RoutesTail;

	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;

	/**
	 * Index class is the base class for almost every class inside cocktail.
	 * @author nybras | nybras@codeine.it
	 */
	public class Index 
	{
		/* GUNZ */
		public var gunz : Gunz; 

		private function _init_gunz() : void
		{
			gunz = new Gunz( this );
		}

		/* VARS */
		protected var _cocktail : Cocktail;

		private var _log : Logger;

		/* INITIALIZING */
		
		/**
		 * Boots the Index base class.
		 * @param cocktail	Cocktail reference.
		 * @return	Self reference for reuse.
		 */
		public function boot( cocktail : Cocktail ) : *
		{
			_init_gunz( );
			
			_cocktail = cocktail;
			_log = new Logger( classpath );
			
			_cocktail.bind.plug( "log-level", _log, "level" );
			_cocktail.bind.plug( "log-detail", _log, "detail" );
			
			return this;
		}

		/* GETTERS */
		
		/**
		 * Get the application config.
		 * @return	The application config.
		 */
		final public function get config() : Config
		{
			return _cocktail.config;
		}

		/**
		 * Get the application router.
		 * @return	The application router.
		 */
		final public function get router() : Router
		{
			return _cocktail.router;
		}

		/**
		 * Get the application routes.
		 * @return	The application routes.
		 */
		final public function get routes() : RoutesTail
		{
			return _cocktail.routes;
		}

		/**
		 * Get the application logger.
		 * @return	The application logger.
		 */
		final public function get log() : Logger
		{
			return _log;
		}

		/* FUNCTION & DEBUG UTILS */
		
		/**
		 * Creates a proxy function holding default params.
		 * @param method	Method to be handled.
		 * @param params	Default params to be passed to method, these params
		 * will be added in *first* place.
		 * @return	The proxy function with the given params.
		 */
		final public function proxy( method : Function, ...params ) : Function
		{
			return( function( ...innerParams ):void
			{
				method.apply( method.prototype, params.concat( innerParams ) );
			} );
		}

		/* CLASS DETAILS */
		
		/**
		 * Gets the classname.
		 * @return	The class name, without the package notation.
		 */
		final public function get classname() : String 
		{
			return classpath.split( "." ).pop( );
		}

		/**
		 * Gets the classpath.
		 * @return	The class path, with the package notation.
		 */
		final public function get classpath() : String 
		{
			return getQualifiedClassName( this ).replace( "::", "." );
		}

		/* UTILS */
		
		/**
		 * Describes the given item as XML.
		 * @return	Item described to XML. 
		 */
		final public function describe( name : String ) : XML
		{
			var described : XML;
			
			try
			{
				described = describeType( this[ name ] );
			}
			catch( e : Error )
			{
				_log.warn( "Cannot describe item " + name + "''." );
				_log.warn( e );
			}
			
			return described;
		}

		/**
		 * Check if some property/method/variabel is defined in the given scope.
		 * @param scope	Scope to evaluate.
		 * @param property	Property/Method/Variable to evaluate.
		 * @return	<code>true</code> 'if scope[ property ]' is defined,
		 * otherwise return <code>false</code>. 
		 */
		final public function is_defined( property : String, scope : * = null ) : Boolean
		{
			var result : Boolean;

			scope = ( scope == null ) ? this : scope;
						
			try
			{
				scope[ property ];
				result = true;
			}
			catch( e : Error ) 
			{
				if( e.errorID == 1006 )
					result = false;
			}
			
			return result;
		}

		/**
		 * Tries to execute some method, omitting the possible error results.
		 * @param scope	Method scope.
		 * @param method	Method name.
		 * @param params	Method params
		 */
		final public function exec(
			scope : *,
			method : String,
			params : * = null
		) : void
		{
			if( is_defined( scope, method ) )
				Function( scope[ method ] ).apply( scope, (
					params != null ? [].concat( params ) : []
				) );
		}

		final public function isN( number : Number ) : Boolean
		{
			return !isN( number );
		}

		/* CASTING VALUES */
		
		/**
		 * Cast the given value as <code>Number</code>.
		 * @param value	Value to be casted.
		 * @return	Value as <code>Number</code>.
		 */
		final protected function n( value : * ) : uint
		{
			return Number( value );
		}

		/**
		 * Cast the given value as <code>int</code>.
		 * @param value	Value to be casted.
		 * @return	Value as <code>int</code>.
		 */
		final protected function i( value : * ) : int
		{
			return int( value );
		}

		/**
		 * Cast the given value as <code>uint</code>.
		 * @param value	Value to be casted.
		 * @return	Value as <code>uint</code>.
		 */
		final protected function u( value : * ) : uint
		{
			return uint( value );
		}

		/**
		 * Cast the given value as <code>Boolean</code>.
		 * @param value	Value to be casted.
		 * @return	Value as <code>Boolean</code>.
		 */
		final protected function b( value : * ) : Boolean
		{
			return Boolean( value );
		}

		public function get cocktail() : Cocktail
		{
			return _cocktail;
		}
	}
}