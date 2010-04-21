package cocktail.lib 
{
	import cocktail.utils.StringUtil;
	import cocktail.Cocktail;
	import cocktail.core.gunz.Gun;
	import cocktail.core.request.Request;
	import cocktail.core.slave.Slave;
	import cocktail.lib.views.ViewStack;

	import de.polygonal.ds.DListNode;

	import flash.display.Sprite;

	public class View extends MV 
	{
		/* GUNZ */
		public var gunz_render_done : Gun;

		/* GUNZ */
		public var gunz_destroy_done : Gun;

		/** Contains and indexes all the childs **/
		private var _childs : ViewStack;

		/** The string identifier on parent's ViewStack **/
		public var identifier : String;

		/** The view node on the ViewStack DLinkedList **/
		public var node : DListNode;

		/** Reference to the parent view container **/
		public var up : View;

		/** When created trought xml, this will hold the xml node**/
		private var _xml_node : XML;

		/** View sprite **/
		public var sprite : Sprite;

		private function _init_gunz() : void 
		{
			gunz_render_done = new Gun( gunz, this, "render_done" );
			gunz_destroy_done = new Gun( gunz, this, "destroy_done" );
		}

		/* INITIALIZING */
		
		/**
		 * 
		 */
		override public function boot( cocktail : Cocktail ) : * 
		{
			var s : *;
		
			s = super.boot( cocktail );
			
			_init_gunz( );
			
			_childs = new ViewStack( this );
			_childs.boot( cocktail );
			return s;
		}

		/**
		 * Removes a view from the view stack
		 */
		public function remove( id : String ) : View 
		{
			return childs.remove( id );
		}

		/* LOAD ASSETS */

		/**
		 * Filters the loading action. If return false, load routine will
		 * pause
		 */
		public function before_load( request : Request ) : Boolean 
		{
			log.info( "Running..." );
			
			request;
			return true;
		}

		/**
		 * Load will parse all views, instantiate they, and listen for
		 * all loads to complete. After that, will trigger _after_load_assets
		 */
		public function load( request : Request ) : Boolean 
		{
			if( !before_load( request ) ) return false;

			log.info( "Running..." );
			
			var i : int;
			var assets : Array;
			var view : View;
			var src : String;
			
			//will mark all views as dead ( not in current render )
			childs.clear_render_poll( );

			//ATT: _parse assets should run after childs.clear_render_poll()			
			assets = _parse_assets( request ); 
			
			if( ( src = xml_node.attribute( "src" ).toString( ) ) )
			{
				loader.append( load_uri( StringUtil.toUnderscore( root.name ) + "/" + src, false ) );
			}
			
			if( ( this is Layout ) == false )
				up.childs.mark_as_alive( this );
			
			if( assets.length == 0 ) return true;
			
			//TODO: use a lambda to run all selected assets				
			do 
			{
				view = assets[ i ];
				view.load( request );
			} while( ++i < assets.length );

			return true;
		}

		/**
		 * Parses all necessary Datasources for given Process.
		 * @param process	Running process.
		 * @return	An array with all Datasources, properly instantiated. 
		 */
		private function _parse_assets( request : Request ) : Array 
		{
			log.info( "Running..." );
			var i : int;
			var assets : Array;
			var list : XMLList;
			var node : XML;
			var action : String;
			
			action = request.route.api.action;
			assets = [];
			
			//layout will work just if it finds 1 action.
			if( this is Layout )
			{
				list = _scheme..action.( @id == action || @id == "*" );
				
				xml_node = XML( list.toXMLString( ) );
				
				//TODO: If target isnt rendered, redirect to home
				if( !controller( name ).layout.childs.has( "" ) )
				{
					//redirect
				}
			}
			
			list = xml_node.children( );
			
			if( list == null || !list.length( ) ) return assets;
			
			do
			{
				node = list[i];
					
				assets.push( _instantiate_view( node ) );
			} while( ++i < list.length( ) );
			
			
			return assets;
		}

		/**
		 * Instantiate a view based on a xml_node, if it already exists, 
		 * will just return the reference.
		 */
		internal function _instantiate_view( xml_node : XML ) : View 
		{
			var view : View;
			
			if( !xml_node.hasOwnProperty( 'id' ) && false )
			{
				log.warn( "Your view needs to have and id" );
				//FIXME: this ['id'] is becoming a child, not a prop
				xml_node[ 'id' ] = Math.random( ) * 100000000000;
				log.warn( "Assigned a random id: " + xml_node[ 'id' ] );
			}
			
			if( ( view = childs.by_id( xml_node.attribute( 'id' ) ) ) != null ) 
			{
				return childs.by_id( xml_node.attribute( 'id' ) );
			}
			
			return childs.create( xml_node );
		}

		public function before_render( request : Request ) : Boolean 
		{
			log.info( "Running..." );
			request;
			return true;
		}

		public function render( request : Request ) : *
		{
			if( !before_render( request ) ) return false;
			
			log.info( "Running..." );
			
			_instantiate_sprite( );
			
			_apply_styles( request );

			childs.render( request );
			
			return after_render( request );
		}

		/**
		 * Creates then attachs the view sprite
		 */
		private function _instantiate_sprite() : Boolean
		{
			if( sprite ) return false;
			
			sprite = new Sprite( );
			
			if( this == root )
				root.scope.addChild( sprite );
			else
				up.sprite.addChild( sprite );
			
			set_triggers( );
			
			return true;
		}

		/**
		 * Apply the styles for the current request
		 */
		private function _apply_styles( request : Request ) : void
		{
			//FIXME: Implement a real style system
			request;
			//properties rendering
			//need to think in a good automated process to apply it
			if( xml_node.attribute( 'x' ) )
				sprite.x = Number( xml_node.attribute( 'x' ) );
				 	
			if( xml_node.attribute( 'y' ) )
				sprite.y = Number( xml_node.attribute( 'y' ) ); 	
		}

		/**
		 * Called just after the render function
		 */
		public function after_render( request : Request ) : void
		{
			log.info( "Running..." );
			request;
		}

		/**
		 * Will check if user customized some events, if so, will plug
		 * then for the user.
		 * 
		 * Called automatically once - when creating the view sprite
		 */
		public function set_triggers() : void 
		{
			if( prototype[ 'click' ] != View.prototype[ 'click' ] )
			{
				log.notice( "Naiz! You customized the click" );
			}
			
			if( prototype[ 'over' ] != View.prototype[ 'over' ] )
			{
				log.notice( "Naiz! You customized the over" );
			}
			
			if( prototype[ 'over' ] != View.prototype[ 'out' ] )
			{
				log.notice( "Naiz! You customized the out" );
			}
		}

		/**
		 * Should unset all possible triggers.
		 * 
		 * Called automatically once - when destroying the view
		 */
		public function unset_triggers() : void
		{
		}

		/**
		 * Destroy filter, if returns false, wont destroy
		 */
		public function before_destroy( request : Request ) : Boolean
		{
			log.info( "Running..." );
			request;
			return true;
		}

		public function destroy( request : Request ) : Boolean 
		{
			if( !before_destroy( request ) ) return false;
			
			log.info( "Running..." );
			
			return true;
		}

		public function after_destroy( request : Request ) : void 
		{
			log.info( "Running..." );
			request;
		}

		/** GETTERS / SETTERS **/
		public function get xml_node() : XML  
		{
			return _xml_node;
		}

		public function set xml_node( xml_node : XML ) : void 
		{
			_xml_node = xml_node;
		}

		public function get root() : Layout 
		{
			return ( up == null ) ? Layout( this ) : up.root;
		}

		public function get loader() : Slave
		{
			return root.loader;
		}

		public function get childs() : ViewStack
		{
			return _childs;
		}
	}
}