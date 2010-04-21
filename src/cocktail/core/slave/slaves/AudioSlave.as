package cocktail.core.slave.slaves 
{
	import cocktail.core.slave.ASlave;
	import cocktail.core.slave.ISlave;
	import cocktail.core.slave.gunz.ASlaveBullet;
	import cocktail.core.slave.gunz.AudioSlaveBullet;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.system.System;

	/**
	 * @author rafael cordoba | rafael@rafaelcordoba.com
	 */
	public class AudioSlave extends ASlave implements ISlave
	{
		/* VARS */
		private var _request : URLRequest;

		private var _sound : Sound;

		private var _trigger_set : Boolean = false;

		/**
		 * Creates a new AudioSlave instance.
		 */
		public function AudioSlave() : void
		{
		}

		/* LISTENERS */
		
		/**
		 * Listen for open event and pull the SlaveTrigger.STAR trigger.
		 * @param ev	Event.OPEN.
		 */
		private function _start( ev : Event ) : void
		{
			gunz_start.shoot( new AudioSlaveBullet( loaded, total, sound ) );
		}

		/**
		 * Listen for progress event and pull the SlaveTrigger.PROG trigger.
		 * @param ev	ProgressEvent.PROGRESS.
		 */
		private function _progress( ev : ProgressEvent ) : void
		{
			gunz_progress.shoot( new AudioSlaveBullet( loaded, total, sound ) );
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
			gunz_complete.shoot( new AudioSlaveBullet( loaded, total, sound ) );
			
			_unset_triggers( );
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

		/* TRIGGERS */
		private function _set_triggers() : void
		{
			_sound.addEventListener( Event.OPEN, _start );
			_sound.addEventListener( ProgressEvent.PROGRESS, _progress );
			_sound.addEventListener( IOErrorEvent.IO_ERROR, _error );
			_sound.addEventListener( Event.COMPLETE, _complete );
			
			_trigger_set = true;
		}

		private function _unset_triggers() : void
		{
			_sound.removeEventListener( Event.OPEN, _start );
			_sound.removeEventListener( ProgressEvent.PROGRESS, _progress );
			_sound.removeEventListener( Event.INIT, _complete );
			_sound.removeEventListener( IOErrorEvent.IO_ERROR, _error );
			
			_trigger_set = false;
		}

		/* GETTERS */
		
		/**
		 * Returns bytesTotal.
		 * @return	Bytes total.
		 */
		public function get total() : Number
		{
			return _sound.bytesTotal;
		}

		/**
		 * Returns bytesLoaded.
		 * @return	Bytes loaded.
		 */
		public function get loaded() : Number
		{
			return _sound.bytesLoaded;
		}

		/**
		 * Get the loaded sound.
		 * @return	Loaded sound.
		 */
		public function get sound() : Sound
		{
			return _sound;
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
			
			// Change _uri with new value
			if ( uri != null)
				_uri = uri;
			
			// Lock loading if _uri is null
			if ( _uri == null )
			{
				trace( "Set the uri param before loading." );
				return this;
			}
			
			// updating status
			_status = ASlave._LOADING;
            
			_request = new URLRequest( _uri );
			_sound = new Sound( );
			
			// start loading
			_sound.load( _request );
			
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
			if ( _status == ASlave._LOADING )
				_sound.close( );
			
			if ( _trigger_set )
				_unset_triggers( );
							
			_sound = null;
			_request = null;
			
			_status = ASlave._QUEUED;
			
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
