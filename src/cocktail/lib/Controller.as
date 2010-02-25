package cocktail.lib 
{
	import cocktail.Cocktail;
	import cocktail.core.bind.Bind;
	import cocktail.core.gunz.Bullet;
	import cocktail.core.gunz.Gun;
	import cocktail.core.gunz.GunzGroup;
	import cocktail.core.process.Process;
	import cocktail.core.request.Request;
	import cocktail.lib.base.MVCL;
	import cocktail.lib.gunz.ControllerBullet;
	import cocktail.lib.gunz.LayoutBullet;
	import cocktail.lib.gunz.ModelBullet;

	/**
	 * @author hems
	 * @author nybras
	 */
	public class Controller extends MVCL
	{
		/* GUNZ */
		private var gunz_load_change_phase : Gun;

		private function _init_gunz() : void
		{
			log.info( "Running..." );
			gunz_load_change_phase = new Gun( gunz, this, "load_change_phase" );
		}

		/* VARS */
		private var _model : Model;
		private var _layout : Layout;
		private var _group : GunzGroup;
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
			_bind = new Bind();
			
			_model.boot( cocktail );
			_layout.boot( cocktail );
			
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
			log.info( "Running..." );
			if( before_run( request ) )
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
		 * @param process	Process to load. 
		 */
		private function _load( request : Request ) : void
		{
			log.info( "Running..." );
			
			if( !before_load( request ) )
				return;
			
			if( !_is_scheme_loaded ) 
			{
				_load_scheme( request );
				gunz_load_start.shoot( new ControllerBullet( ) );
				return;
			}
			
			_load_model( request );
		}

		/**
		 * Called after loading needed data to render the request.
		 */
		private function _after_load( bullet : Bullet ) : void
		{
			log.info( "Running..." );
			gunz_load_complete.shoot( new ControllerBullet( ) );
			render( bullet.params ) ;
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
			var bullet : Bullet;
			
			log.info( "Running..." );
			
			if( _layout.load( request ) )
				_layout.gunz_load_complete.add( _after_load_layout, request );
			else
			{
				bullet = new LayoutBullet( );
				bullet.params = request;
				_after_load( bullet );
			}
		}

		private function _after_load_layout( bullet : LayoutBullet ) : void
		{
			log.info( "Running..." );
			if( _layout.load( bullet.params ) )
				_layout.gunz_load_complete.add( _after_load );
		}

		/* RENDERING */
		
		/**
		 * Rendering filter. If returns false, wont render.
		 */
		public function before_render( process : Process ) : Boolean
		{
			log.info( "Running..." );
			process;
			return true;
		}

		/**
		 * Called after render process completes.
		 */
		public function render( process : Process ) : void
		{
			log.info( "Running..." );
			if( before_render( process ) )
			{
				_layout.gunz_render_complete.add( after_render, process );
				_layout.render( process );
			}
		}

		/**
		 * Called after render process completes.
		 */
		public function after_render( process : Process ) : void
		{
			log.info( "Running..." );
			process;
		}
	}
}