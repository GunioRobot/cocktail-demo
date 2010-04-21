package cocktail.core.process 
{
	import cocktail.Cocktail;
	import cocktail.core.Index;
	import cocktail.core.router.gunz.RouterBullet;
	import cocktail.lib.Controller;

	/**
	 * Manage all processes.
	 * @author nybras | nybras@codeine.it
	 */
	public class Process extends Index 
	{
		/* VARS */
		private var _controllers : Object;

		private var _current_controller : Controller;

		/* BOOTING */
		
		/**
		 * Creates a new Processes instance.
		 * @param cocktail	Cocktail reference.
		 */
		override public function boot( cocktail : Cocktail ) : *
		{
			var s : *;
		
			s = super.boot( cocktail );
			_controllers = {};
			router.gunz_update.add( _route );
			return s;
		}

		/* ROUTING ADDRESS BAR CALLS */
		
		/**
		 * Route the application according the Router.UPDATE trigger.
		 * @param bullet	RouterBullet.
		 */
		private function _route( bullet : RouterBullet ) : void
		{
			/*
			log.debug( "@@ Request" );
			log.debug( "---------------" );
			log.debug( "uri => " + bullet.request.uri );
			log.debug( "type => " + bullet.request.type );
			log.debug( "data => " + bullet.request.data );
			log.debug( "title => " + bullet.request.title );
				 
			log.debug( "@@ Route" );
			log.debug( "---------------" );
			log.debug( "route.locale => " + bullet.request.route.locale );
			log.debug( "route.mask => " + bullet.request.route.mask );
			log.debug( "route.target => " + bullet.request.route.target );
				 
			log.debug( "@@ API" );
			log.debug( "---------------" );
			log.debug( "route.api.controller => " + bullet.request.route.api.controller );
			log.debug( "route.api.action => " + bullet.request.route.api.action );
			log.debug( "route.api.params => " + bullet.request.route.api.params );
			 */
			_current_controller = _controller( bullet.request.route.api.controller );
			_current_controller.run( bullet.request );
		}

		/* CONTROLLERS */
		
		/**
		 * Instantiate the requested Controller, or just return it if it was
		 * already instatiated. In other words, its unique.
		 * @param name	Controller name (CamelCased)
		 */
		internal function _controller( name : String ) : Controller
		{
			var controller : Controller;
			
			if( _controllers.hasOwnProperty( name ) )
				controller = _controllers[ name ];
			else
				_controllers[ name ] = ( controller = new (
					_cocktail.factory.controller( name )
				)( ) ).boot( _cocktail );
			
			
			return controller;
		}

		public function controller( name : String ) : Controller
		{
			return _controller( name );
		}
	}
}