package cocktail.core.request 
{
	import cocktail.Cocktail;
	import cocktail.core.Index;
	import cocktail.core.router.Route;	

	/**
	 * Handle all possible kind of requests.
	 * @author nybras | nybras@codeine.it
	 */
	public class Request extends Index
	{
		/* CONSTANTS (+public getters) */
		private static const _GET : String = "get";

		private static const _POST : String = "post";

		/**
		 * Returns a GET request type.
		 */
		public static function get GET() : String
		{
			return _GET;
		}

		/**
		 * Returns a GET request type.
		 */
		public static function get POST() : String
		{
			return _POST;
		}

		/* VARS */
		private var _type : String;

		private var _uri : String;

		private var _route : Route;

		private var _title : String;

		private var _data : String;

		/* INITIALIZING */
		
		/**
		 * TODO: write docs
		 */
		public function Request(
			type : String,
			uri : String,
			data : * = null
		) : void
		{
			_uri = uri;
			this.type = type;
			this.data = data;
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
			uri = _uri;
			return s;
		}

		/* GETTERS / SETTERS */
		
		/*
		 * TODO: write docs
		 */
		public function get uri() : String
		{
			return _uri;
		}

		/*
		 * TODO: write docs
		 */
		public function set uri( uri : String ) : void
		{
			_uri = routes.clean_uri( uri );
			( _route = new Route( _uri ) ).boot( _cocktail );
		}

		/*
		 * TODO: write docs
		 */
		public function get title() : String
		{
			return _title;
		}

		/*
		 * TODO: write docs
		 */
		public function set title( title : String ) : void
		{
			_title = title;
		}

		/*
		 * TODO: write docs
		 */
		public function get type() : String
		{
			return _type;
		}

		/*
		 * TODO: write docs
		 */
		public function set type( type : String ) : void
		{
			_type = type;
		}

		/*
		 * TODO: write docs
		 */
		public function get data() : String
		{
			return _data;
		}

		/*
		 * TODO: write docs
		 */
		public function set data( data : String ) : void
		{
			_data = data;
		}

		/*
		 * TODO: write docs
		 */
		public function get route() : Route
		{
			return _route;
		}
	}
}