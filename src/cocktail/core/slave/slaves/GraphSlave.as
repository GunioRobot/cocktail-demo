package cocktail.core.slave.slaves 
{
	import flash.system.System;

	import cocktail.core.slave.gunz.GraphSlaveBullet;
	import cocktail.core.slave.ASlave;
	import cocktail.core.slave.ISlave;
	import cocktail.core.slave.gunz.ASlaveBullet;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;

	/**
	 * GraphSlave is the responsible for loading any binary graphic asset, such
	 * as jpg, gif, png, swf etc. 
	 * @author nybras | nybras@codeine.it
	 */
	public class GraphSlave extends ASlave implements ISlave
	{
		/* VARS */
		private var _loader : Loader;

		private var _loader_info : LoaderInfo;

		private var _request : URLRequest;

		private var _target : DisplayObjectContainer;

		private var _trigger_set : Boolean = false;

		/* INITIALIZING */
		
		/**
		 * Creates a new GraphSlave instance.
		 */
		public function GraphSlave() : void
		{
		}

		/* LISTENERS */
		
		/**
		 * Listen for open event and pull the SlaveTrigger.STAR trigger.
		 * @param ev	Event.OPEN.
		 */
		private function _start( ev : Event ) : void
		{
			gunz_start.shoot( new ASlaveBullet( loaded, total ) );
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
			gunz_complete.shoot( new GraphSlaveBullet( loaded, total, content ) );
			
			// putting
			if( _target != null )
				_target.addChild( content );
			
			_unset_triggers( );
		}

		/* TRIGGERS */
		private function _set_triggers() : void
		{
			_loader_info.addEventListener( Event.OPEN, _start );
			_loader_info.addEventListener( ProgressEvent.PROGRESS, _progress );
			_loader_info.addEventListener( Event.INIT, _complete );
			_loader_info.addEventListener( IOErrorEvent.IO_ERROR, _error );
		}

		private function _unset_triggers() : void
		{
			_loader_info.removeEventListener( Event.OPEN, _start );
			_loader_info.removeEventListener( ProgressEvent.PROGRESS, _progress );
			_loader_info.removeEventListener( Event.INIT, _complete );
			_loader_info.removeEventListener( IOErrorEvent.IO_ERROR, _error );
		}

		/**
		 * Listen for error event and pull the SlaveTrigger.ERRO trigger.
		 * @param event	IOErrorEvent.IO_ERROR.
		 */
		private function _error( ev : IOErrorEvent ) : void
		{
			_status = ASlave._ERROR;
			gunz_error.shoot( new ASlaveBullet( -1, -1 ).inject( ev ) );
		}

		/* GETTERS */
		
		/**
		 * Returns bytesTotal.
		 * @return	Bytes total.
		 */
		public function get total() : Number
		{
			return _loader_info.bytesTotal;
		}

		/**
		 * Returns bytesLoaded.
		 * @return	Bytes loaded.
		 */
		public function get loaded() : Number
		{
			return _loader_info.bytesLoaded;
		}

		/**
		 * Get the loaded content.
		 * @return	Loaded content.
		 */
		public function get content() : DisplayObject
		{
			return _loader_info.content;
		}

		/**
		 * Get the loader reference.
		 * @return	Loader reference.
		 */
		public function get loader() : Loader
		{
			return _loader;
		}

		/* PUTTING */
		
		/**
		 * Puts the loaded content into the given target, right after the
		 * loading process is completed.
		 * @param target	Target to put the loaded content into.
		 */
		public function put( target : DisplayObjectContainer ) : GraphSlave
		{
			_target = target;
			return this;
		}

		/* LOADING */
		
		/**
		 * Start the loading process.
		 * @return	Self reference for inline reuse.
		 */
		final public function load( uri : String = null) : ISlave
		{
			if( _status != ASlave._QUEUED )
			{
				trace( "Cannot load now, execute unload()" );
				return this;
			}
			
			// Change _uri with new value
			if ( uri != null)
				_uri = uri;
			
			// Lock loading if _uri is null
			if ( _uri == null )
			{
				trace( "Set the uri param before loading." );
				return this;
			}
			
			_loader = new Loader( );
			_loader_info = _loader.contentLoaderInfo;
			_request = new URLRequest( _uri );
			
			// updating status
			_status = ASlave._LOADING;
			
			// start loading
			_loader.load( _request );
			
			// listeners
			_set_triggers( );
			
			return this;
		}

		/* UNLOAD / DESTROY */
		
		/**
		 * Unload content.
		 * @return	ISlave.
		 */
		public function unload() : ISlave
		{
			if ( _loader )
				_loader.unloadAndStop( true );
				
			if ( _status == ASlave._LOADING )
				_loader.close( );
			
			if ( _trigger_set )
				_unset_triggers( );
				
			_loader = null;
			_loader_info = null;
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