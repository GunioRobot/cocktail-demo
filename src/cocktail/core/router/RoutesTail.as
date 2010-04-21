package cocktail.core.router
{
	import cocktail.utils.ArrayUtil;																																																									

	/**
	 * Handles all Routes translations.
	 * @author nybras | nybras@codeine.it
	 */
	public class RoutesTail 
	{
		/* VARS */
		private var _mappings : Array = [];

		/* CLEANING UP DIRTY URI */
		
		/**
		 * Do a soft clean up on the given URI removing useless slashes.
		 * @return	Clean URI.
		 */
		public function clean_uri( uri : String ) : String
		{
			if ( uri.substr( 0, 1 ) == "/" )
				uri = uri.substr( 1 );
			
			if ( uri.substr( -1 ) == "/"  )
				uri = uri.substr( 0, -1 );
			
			return uri;
		}

		/* MAPPING */
		
		/**
		 * Adds a mapping routine.
		 * @param mask	Url mask.
		 * @param target	Url target.
		 */
		public function map( mask : String, target : String ) : void
		{
			ArrayUtil.del( _mappings, mask, "mask" );
			_mappings.push( new MapVO( clean_uri( mask ), clean_uri( target ) ) );
		}

		/* WRAP / UNWRAP / LOCALE */
		
		/**
		 * Wraps a target URI into it's mask URI.
		 * @param target	Target URI to wrap.
		 * @return	The mask URI for the given target URI.
		 */
		public function wrap( uri : String ) : String
		{
			var map : MapVO;
			
			for each( map in _mappings )
				if( map.target_rgx.test( uri ) )
					return _mask( map, uri );
			
			return uri;
		}

		/**
		 * Unwraps a mask URI into it's target URI.
		 * @param target	Mask URI to unwrap.
		 * @return	The target URI for the given mask URI.
		 */
		public function unwrap( uri : String ) : String
		{
			var map : MapVO;
			
			for each( map in _mappings )
				if( map.mask_rgx.test( uri ) )
					return _target( map, uri );
			
			return uri;
		}

		/* COMPARISON */
		
		/**
		 * Computes the mask URI for the given target URI.
		 * @param map	MapVO instance.
		 * @param uri	Target URI to masked.
		 */
		private function _mask( map : MapVO, uri : String ) : String
		{
			var ids : Array;
			var params : Array;
			
			ids = clean_uri( uri.replace( map.target_rgx, "" ) ).split( "/" );
			params = [];
			
			for each( var a : String in map.target.match( /\$[0-9]+/g ) )
				params.push( ids[ a.match( /[0-9]+/ ) ] );
			
			return map.mask.replace( "*", params.join( "/" ) );
		}

		/**
		 * Computes the target URI for the given mask URI.
		 * @param map	MapVO instance.
		 * @param uri	Mask URI to be targeted.
		 */
		private function _target( map : MapVO, uri : String ) : String
		{
			var id : String;
			var params : Array;
			var output : String;
			
			output = map.target;
			params = clean_uri( uri.replace( map.mask_rgx, "" ) ).split( "/" );
			
			for each( id in output.match( /\$[0-9]+/g ) )
				output = output.replace( id, params[ id.match( /[0-9]+/ ) ] );
			
			return output;
		}
	}
}

/**
 * VO to store mappings objects.
 * @author nybras | nybras@codeine.it
 */
internal class MapVO
{
	public var mask : String;

	public var target : String;

	public var target_rgx : RegExp;

	public var mask_rgx : RegExp;

	/**
	 * Creates a new MapVO instance.
	 * @param mask	Url mask.
	 * @param target	Url target.
	 */
	public function MapVO( mask : String, target : String )
	{
		this.mask = mask;
		this.target = target;
		
		target_rgx = new RegExp( target.replace( /\/\$[0-9]+/g, "" ), "" );
		mask_rgx = new RegExp( mask, "" );
	}
}