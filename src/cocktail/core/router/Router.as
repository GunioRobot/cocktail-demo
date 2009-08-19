/*	****************************************************************************
		Cocktail ActionScript Full Stack Framework. Copyright(C) 2009 Codeine.
	****************************************************************************
   
		This library is free software; you can redistribute it and/or modify
	it under the terms of the GNU Lesser General Public License as published
	by the Free Software Foundation; either version 2.1 of the License, or
	(at your option) any later version.
		
		This library is distributed in the hope that it will be useful, but
	WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
	or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public
	License for more details.

		You should have received a copy of the GNU Lesser General Public License
	along with this library; if not, write to the Free Software Foundation,
	Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

	-------------------------
		Codeine
		http://codeine.it
		contact@codeine.it
	-------------------------
	
*******************************************************************************/

package cocktail.core.router 
{
	import cocktail.Cocktail;
	import cocktail.core.Index;
	import cocktail.core.gunz.Trigger;
	import cocktail.core.request.Request;
	import cocktail.core.router.gunz.RouterBullet;
	import cocktail.core.router.gunz.RouterTrigger;
	
	import swfaddress.SWFAddress;
	import swfaddress.SWFAddressEvent;	

	/**
	 * Handles all routing operations.
	 * @author nybras | nybras@codeine.it
	 */
	public class Router extends Index
	{
		/* ---------------------------------------------------------------------
			VARS
		--------------------------------------------------------------------- */
		
		private var _trigger : RouterTrigger;
		
		private var _initialized : Boolean;
		private var _first_uri : Boolean;
		
		private var _history : Array;
		private var _index : Number;
		
		
		
		/* ---------------------------------------------------------------------
			INITIALIZING
		--------------------------------------------------------------------- */
		
		/**
		 * Creates a new Router instance.
		 * @param cocktail	Cocktail reference.
		 */
		public function Router( cocktail : Cocktail )
		{
			super( cocktail );
			
			_trigger = new RouterTrigger( this );
			
			_history = new Array();
			_index = -1;
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
			{
				SWFAddress.addEventListener(
					SWFAddressEvent.CHANGE, _set_location
				);
				return;
			};
		}
		
		
		/* ---------------------------------------------------------------------
			BULLET/TRIGGER IMPLEMENTATION( listen/unlisten )
		--------------------------------------------------------------------- */
		
		/**
		 * Trigger reference.
		 * @return	The <code>RouterTrigger</code> reference.
		 */
		public function get trigger() : RouterTrigger
		{
			return _trigger;
		}
		
		
		
		/**
		 * Start listening.
		 * @return	The <code>UserTrigger</code> reference.
		 */
		public function get listen() : RouterTrigger
		{
			return RouterTrigger( _trigger.listen );
		}
		
		/**
		 * Stop listening.
		 * @return	The <code>UserTrigger</code> reference.
		 */
		public function get unlisten() : RouterTrigger
		{
			return RouterTrigger( _trigger.unlisten );
		}
		
		
		
		
		/* ---------------------------------------------------------------------
			HISTORY HANDLERS
		--------------------------------------------------------------------- */
		
		/**
		 * Check if theres external pages enough to perform a "back" operation.
		 * @return <code>true</code> if yes, <code>false</code> otherwise.
		 */
		public function get has_back() : Boolean
		{
			return( this.index > 0 );
		}

		/**
		 * Check it theres external pages enough to perform a "forward"
		 * operation.
		 * * @return <code>true</code> if yes, <code>false</code> otherwise.
		 */
		public function get has_forward() : Boolean
		{
			return( this.index < this.history.length );
		}
		
		
		
		/**
		 * Go forward one page.
		 */
		public function forward() : void
		{
			_index++;
			SWFAddress.forward();
		}
		
		/**
		 * Go back one page.
		 */
		public function prev() : void
		{
			_index--;
			SWFAddress.back();
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
		
		
		
		/* ---------------------------------------------------------------------
			REQUEST HANDLERS
		--------------------------------------------------------------------- */
		
		/**
		 * Redirects the application to the given request.
		 * @param request	Request to redirect the application to. 
		 */
		public function get( uri : String ) : void
		{
			var request : Request = new Request( _cocktail, uri );
			
			trace ( "--------" );
			
			trace ( request.uri );
			trace ( request.route.mask );
			trace ( request.route.target );
			trace ( request.data );
			trace ( request.type );
			
			trace ( "--------" );
			
//			TODO: implement method
//			var dao : ProcessDAO;
//			
//			dao = new ProcessDAO( url, false, freeze );
//			lastUrlFreeze = freeze;
//			
//			if( ! silentMode && config.plugin ) {
//				this.history.push( dao.url );
//				this.index++;
//				
//				if( url != SWFAddress.getValue() )
//					SWFAddress.setValue( dao.url );
//			}
//			else
//			{
//				trigger.pull( new RouterBullet( 
//					RouterTrigger.UPDATE, dao.url, lastUrlFreeze
//				) );
//			}
		}
		
		public function post( uri : String, data : * ) : void
		{
			
		}
		
		
		
		/* ---------------------------------------------------------------------
			LOCATION HANDLERS
		--------------------------------------------------------------------- */
		
		/**
		 * Gets the current external url location.
		 * @return	The current external url location.
		 */
		public function get location() : String
		{
			return SWFAddress.getValue();
		}
		
		/**
		 * Listen the browser url changes( SWFAddress ).
		 * @param event	SWFAddressEvent.
		 */
		private function _set_location( event : SWFAddressEvent ) : void 
		{
			var url : String;
			var bullet : RouterBullet;
			
			if( ! _first_uri )
			{
				_first_uri = true;
				
				url = event.value;
				if( url == "/" )
				{
					if( config.default_uri != "/" )
					{
						bullet = new RouterBullet (
							RouterTrigger.UPDATE, config.default_uri
						);
						_trigger.pull( bullet );
						// SWFAddress.setTitle( xyz... );
					}
				}
				else
				{
					bullet = new RouterBullet( RouterTrigger.UPDATE, url );
					_trigger.pull( bullet );
				
				}
				return;
			}
			
			url = ( event.value == "/" ? config.default_uri : event.value );
			bullet = new RouterBullet ( RouterTrigger.UPDATE, url );
			_trigger.pull( bullet );
		}
		
	}
}