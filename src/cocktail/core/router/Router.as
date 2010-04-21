package cocktail.core.router 
{
	import cocktail.Cocktail;
	import cocktail.core.Index;
	import cocktail.core.gunz.Gun;
	import cocktail.core.gunz.Gunz;
	import cocktail.core.request.Request;
	import cocktail.core.request.RequestAsync;
	import cocktail.core.router.gunz.RouterBullet;

	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;

	/**
	 * Handles all routing operations.
	 * @author nybras | nybras@codeine.it
	 */
	public class Router extends Index
	{
		/* VARS */
		private var _initialized : Boolean;

		private var _history : Array;

		private var _index : Number;

		/* GUNZ */
		public var gunz_update : Gun; 

		private function _init_gunz() : void
		{
			gunz = new Gunz( this );
			gunz_update = new Gun( gunz, this, "update" );
		}

		/* BOOTING */
		
		/**
		 * Creates a new Router instance.
		 * @param cocktail	Cocktail reference.
		 */
		override public function boot( cocktail : Cocktail ) : *
		{
			var s : *;
			
			s = super.boot( cocktail );
			
			_init_gunz( );
			
			_history = new Array( );
			_index = -1;
			
			return s;
		}

		/**
		 * Initializes the router, listening for SWFAddress.
		 */
		public function init() : void
		{
			if( _initialized )
				return;
			
			_initialized = true;
			
			if( config.plugin )
				SWFAddress.addEventListener( SWFAddressEvent.CHANGE, _addressbar_change );
		}

		/* HISTORY HANDLERS */
		
		/**
		 * Check if theres external pages enough to perform a "back" operation.
		 * @return <code>true</code> if yes, <code>false</code> otherwise.
		 */
		public function get has_back() : Boolean
		{
			return( index > 0 );
		}

		/**
		 * Check it theres external pages enough to perform a "forward"
		 * operation.
		 * * @return <code>true</code> if yes, <code>false</code> otherwise.
		 */
		public function get has_forward() : Boolean
		{
			return( index < history.length );
		}

		/**
		 * Go forward one page.
		 */
		public function forward() : void
		{
			_index++;
			SWFAddress.forward( );
		}

		/**
		 * Go back one page.
		 */
		public function prev() : void
		{
			_index--;
			SWFAddress.back( );
		}

		/**
		 * Gets the history.
		 * @return	The history array.
		 */
		public function get history() : Array
		{
			return _history;
		}

		/**
		 * Gets the current history index.
		 * @return	The current history index.
		 */
		public function get index() : Number
		{
			return _index;
		}

		/* REQUEST HANDLERS */
		
		/**
		 * Redirects the application to the given request.
		 * @param request	Request to redirect the application to. 
		 */
		public function get( uri : String ) : void
		{
			var request : Request;
			
			request = new Request( Request.GET, uri ).boot( _cocktail );
			history.push( request );
			_index++;
			
			if( config.plugin )
			{
				if( request.route.mask != SWFAddress.getValue( ) )
					SWFAddress.setValue( request.route.mask );
			}
			else
				gunz_update.shoot( new RouterBullet( request ) );
		}

		/*
		 * TODO: write docs
		 */
		public function post( uri : String, data : * ) : RequestAsync
		{
			// TODO: implement method
			return new RequestAsync( uri, data ).boot( _cocktail ).s;
		}

		/* LOCATION HANDLERS */
		
		/**
		 * Gets the current external url location.
		 * @return	The current external url location.
		 */
		public function get location() : String
		{
			return SWFAddress.getValue( );
		}

		/**
		 * Listen the browser url changes( SWFAddress ).
		 * @param event	SWFAddressEvent.
		 */
		private function _addressbar_change( event : SWFAddressEvent ) : void 
		{
			var request : Request;
			var uri : String;
			
			uri = (event.value == "/" ? config.default_uri : event.value );
			request = new Request( Request.GET, uri ).boot( _cocktail );
			
			gunz_update.shoot( new RouterBullet( request ) );
		}
	}
}