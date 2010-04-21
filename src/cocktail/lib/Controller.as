package cocktail.lib 
{
	import cocktail.Cocktail;
	import cocktail.core.bind.Bind;
	import cocktail.core.gunz.Bullet;
	import cocktail.core.gunz.Gun;
	import cocktail.core.gunz.GunzGroup;
	import cocktail.core.request.Request;
	import cocktail.lib.gunz.ControllerBullet;
	import cocktail.lib.gunz.ModelBullet;
	import cocktail.lib.gunz.ViewBullet;

	/**
	 * @author hems
	 * @author nybras
	 */
	public class Controller extends MVC
	{
		/* GUNZ */
		private var gunz_load_change_phase : Gun;

		/** Each render, this flag turns true.
		 * If your action turns this to false, _layout_render wont occur
		 */
		private var _auto_render : Boolean;

		/**
		 * Last runned _request. 
		 * ATTENTION: Doesnt means the request is rendered
		 */
		private var _request : Request;

		private function _init_gunz() : void
		{
			log.info( "Running..." );
			gunz_load_change_phase = new Gun( gunz, this, "load_change_phase" );
		}

		/* Quite explainatory name, huh? */
		private var _model : Model;

		/* Quite explainatory name, huh? */
		private var _layout : Layout;

		private var _group : GunzGroup;

		/** Has model and view loaded theirs schemes? **/
		private var _is_scheme_loaded : Boolean;

		internal var _bind : Bind;

		/* BOOTING */
		override public function boot( cocktail : Cocktail ) : *
		{
			var name : String;
			var s : *;
		
			s = super.boot( cocktail );
			log.info( "Running..." );
			
			_init_gunz( );
			
			name = classname.replace( "Controller", "" );
			
			_model = new ( _cocktail.factory.model( name ) )( );
			_layout = new ( _cocktail.factory.layout( name ) )( );
			_bind = new Bind( );
			
			_model.boot( cocktail );
			_layout.boot( cocktail );
			
			_model._controller = _layout._controller = this;
			
			return s;
		}

		/* RUNNING */
		
		/**
		 * Run filtering. If returns false, wont run the action.
		 */
		public function before_run( request : Request ) : Boolean
		{
			log.info( "Running..." );
			request;
			return true;
		}

		/**
		 * Run the desired request.
		 */
		final public function run( request : Request ) : void
		{
			if( !before_run( request ) ) return;
			
			log.info( "Running..." );
			
			_request = request;
			
			_load( request );
		}

		/* LOADING */
		
		/**
		 * Load filtering. If returns false, wont load anything.
		 */
		public function before_load( request : Request ) : Boolean
		{
			log.info( "Running..." );
			request;
			return true;
		}

		/**
		 * Load Model and Layout.
		 * @param request	Process to load. 
		 */
		private function _load( request : Request ) : void
		{
			if( !before_load( request ) ) return;
			
			log.info( "Running..." );
			
			if( !_is_scheme_loaded ) 
			{
				_load_scheme( request );
				gunz_load_start.shoot( new ControllerBullet( ) );
				return;
			}
			
			/*
			 * 
			_layout.load( request );
			return;
			 * 	
			 */
			_load_model( request );
		}

		/* LOADING - SCHEME */
		
		/**
		 * Load Model and Layout scheme.
		 * @param request	Request that will be loaded after load scheme. 
		 */
		private function _load_scheme( request : Request ) : void
		{
			_group = new GunzGroup( );
			_group.add( _layout.gunz_scheme_load_complete );
			_group.add( _model.gunz_scheme_load_complete );
			_group.gunz_complete.add( _after_load_scheme, request );
			
			_model.load_scheme( request );
			_layout.load_scheme( request );
		}

		/**
		 * Triggered after load  model and layout scheme.
		 */
		private function _after_load_scheme( bullet : Bullet ) : void
		{
			log.info( "Running..." );
			bullet;
			_is_scheme_loaded = true;
			gunz_load_change_phase.shoot( new ControllerBullet( ) );
			_load( bullet.params );
		}

		/* LOADING - MODEL */
		private function _load_model( request : Request ) : void
		{
			log.info( "Running..." );
			
			if( _model.load( request ) )
				_model.gunz_load_complete.add( _after_load_model, request );
			else
				_load_layout( request );
		}

		private function _after_load_model( bullet : ModelBullet ) : void
		{
			log.info( "Running..." );
			
			_load_layout( bullet.params );
		}

		/* LOADING - LAYOUT */
		private function _load_layout( request : Request ) : void
		{
			log.info( "Running..." );
			
			_layout.gunz_load_complete.add( _after_load_layout, request );
			
			_layout.load( request );
		}

		private function _after_load_layout( bullet : ViewBullet ) : void
		{
			log.info( "Running..." );
			
			render( bullet.params );
		}

		/* RENDERING */
		
		/**
		 * Rendering filter. If returns false, wont render.
		 */
		public function before_render( request : Request ) : Boolean
		{
			log.info( "Running..." );
			request;
			return true;
		}

		/**
		 * Called after render request completes.
		 */
		public function render( request : Request ) : void
		{
			if( !before_render( request ) ) return;
			
			log.info( "Running..." );
			
			_auto_render = true;
			
			//_auto_render
			if( is_defined( request.route.api.action ) )
			{
				this[ request.route.api.action ]( ); 
			}
			
			if( _auto_render == false ) return;
			_layout.gunz_render_done.add( after_render, request ).once( );
			_layout.render( request );
		}

		/**
		 * Called after render request completes.
		 */
		public function after_render( request : Request ) : void
		{
			log.info( "Running..." );
			request;
		}

		/** GETTERS **/
		public function get layout() : Layout
		{
			return _layout;
		}
	}
}