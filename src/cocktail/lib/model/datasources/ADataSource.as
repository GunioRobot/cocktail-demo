package cocktail.lib.model.datasources 
{
	import cocktail.Cocktail;
	import cocktail.core.Index;
	import cocktail.core.gunz.Gun;
	import cocktail.core.request.Request;
	import cocktail.lib.Model;

	public class ADataSource extends Index
	{
		/* GUNZ */
		public var gunz_load_start : Gun; 

		public var gunz_load_progress : Gun; 

		public var gunz_load_complete : Gun;

		private function _init_gunz() : void
		{
			gunz_load_start = new Gun( gunz, this, "load_start" );
			gunz_load_progress = new Gun( gunz, this, "load_progress" );
			gunz_load_complete = new Gun( gunz, this, "load_complete" );
		}

		/* XML SCHEME ATTRIBUTE / PROPERTIES */
		public var id : String; 

		public var inject : String; 

		public var locale : String; 

		public var src : String; 

		/* VARS */
		protected var _raw : *;

		protected var _request : Request;

		protected var _model : Model;

		protected var _scheme : XML; 

		protected var _binds : XMLList;

		/* BOOTING */
		override public function boot( cocktail : Cocktail ) : *
		{
			var s : *;
			
			s = super.boot( cocktail );
			_init_gunz( );
			parse( );
			
			return s;		}

		public function ADataSource(
			model : Model,
			request : Request,
			scheme : XML = null
		)
		{
			_model = model;
			_request = request;
			_scheme = scheme;
		}

		/* LOADING */
		public function load() : ADataSource
		{
			var msg : String;
			
			msg = "This method (ADataSource.load) must be overritten by ";
			msg += "superclass.";
			log.fatal( msg );
			
			return this;
		}

		/* PARSING */
		public function parse() : void
		{
			id = _scheme.@id;
			inject = _scheme.@inject;
			locale = _scheme.@locale;
			_binds = _scheme.children( );
		}
	}
}