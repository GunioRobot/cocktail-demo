package cocktail.core.slave.slaves 
{
	import cocktail.core.slave.ASlave;
	import cocktail.core.slave.ISlave;
	import cocktail.core.slave.gunz.ASlaveBullet;
	import cocktail.core.slave.gunz.TextSlaveBullet;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.System;

	/**
	 * TextSlave is the responsible for loading any kind of text request, such
	 * as xml, txt, etc.
	 * @author nybras | nybras@codeine.it
	 */
	public class TextSlave extends ASlave implements ISlave 
	{
		/* VARS */
		private var _loader : URLLoader;

		private var _request : URLRequest;

		private var _trigger_set : Boolean = false;

		/* INITIALIZING */
		
		/**
		 * Creates a new TextSlave instance.
		 */
		public function TextSlave() : void
		{			
		}

		/* LISTENERS */
		
		/**
		 * Listen for open event and pull the SlaveTrigger.STAR trigger.
		 * @param ev	Event.OPEN.
		 */
		private function _start( ev : Event ) : void
		{
			gunz_start.shoot( new TextSlaveBullet( loaded, total ) );
		}

		/**
		 * Listen for progress event and pull the SlaveTrigger.PROG trigger.
		 * @param ev	ProgressEvent.PROGRESS.
		 */
		private function _progress( ev : ProgressEvent ) : void
		{
			gunz_progress.shoot( new ASlaveBullet( loaded, total ) );
		}

		/**
		 * Listen for init event and pull the SlaveTrigger.COMP trigger.
		 * @param ev	Event.INIT.
		 */
		private function _complete( ev : Event ) : void
		{
			// updating status
			_status = ASlave._LOADED;
			
			// pull the trigger
			gunz_complete.shoot( new TextSlaveBullet( loaded, total, data ) );
		}

		/**
		 * Listen for error event and pull the SlaveTrigger.ERRO trigger.
		 * @param event	IOErrorEvent.IO_ERROR.
		 */
		private function _error( ev : IOErrorEvent ) : void
		{
			_status = ASlave._ERROR;
			gunz_error.shoot( new ASlaveBullet( 0, 0 ) );
		}

		/* TRIGGERS */
		private function _set_triggers() : void
		{
			_loader.addEventListener( Event.OPEN, _start );
			_loader.addEventListener( ProgressEvent.PROGRESS, _progress );
			_loader.addEventListener( Event.COMPLETE, _complete );
			_loader.addEventListener( IOErrorEvent.IO_ERROR, _error );
			
			_trigger_set = true;
		}

		private function _unset_triggers() : void
		{
			if( _loader == null ) return;
			
			_loader.removeEventListener( Event.OPEN, _start );
			_loader.removeEventListener( ProgressEvent.PROGRESS, _progress );
			_loader.removeEventListener( Event.COMPLETE, _complete );
			_loader.removeEventListener( IOErrorEvent.IO_ERROR, _error );
			
			_trigger_set = false;
		}

		/* GETTERS */
		
		/**
		 * Returns bytesTotal.
		 * @return	Bytes total.
		 */
		public function get total() : Number
		{
			return _loader.bytesTotal;
		}

		/**
		 * Returns bytesLoaded.
		 * @return	Bytes loaded.
		 */
		public function get loaded() : Number
		{
			return _loader.bytesLoaded;
		}

		/**
		 * Get the loaded data.
		 * @return	Loaded data.
		 */
		public function get data() : String
		{
			return String( _loader.data );
		}

		/* LOADING */
		
		/**
		 * Start the loading process.
		 * @return	Self reference for inline reuse.
		 */
		final public function load( uri : String = null ) : ISlave
		{
			if( _status != ASlave._QUEUED )
			{
				trace( "Cannot load now, execute unload()" );
				return this;
			}
			
			_uri = uri;
			
			_loader = new URLLoader( );
			_request = new URLRequest( uri );
			
			_set_triggers( );
			
			// updating status
			_status = ASlave._LOADING;
			
			// start loading
			_loader.load( _request );
			
			return this;
		}

		/* UNLOAD / DESTROY */
		
		/**
		 * Unload content.
		 */
		public function unload() : ISlave
		{
			if ( _status == ASlave._LOADING )
				_loader.close( );
			
			if ( _trigger_set )
				_unset_triggers( );
			
			_loader = null;
			_request = null;
			
			_status = _QUEUED;
			
			return this;
		}

		/**
		 * Destroy content, cannot load at this instance 
		 * after destroying.
		 * @return	ISlave.
		 */
		public function destroy() : ISlave
		{
			unload( );
			
			_status = _DESTROYED;
			
			gunz.rm_all( );
			
			System.gc( );
			
			return this;
		}
	}
}
