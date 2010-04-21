package cocktail.core.slave.slaves 
{
	import cocktail.core.slave.ASlave;
	import cocktail.core.slave.ISlave;
	import cocktail.core.slave.gunz.VideoSlaveBullet;

	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.system.System;
	import flash.utils.Timer;

	/**
	 * @author nybras | nybras@codeine.it
	 */
	public class VideoSlave extends ASlave implements ISlave
	{
		/* VARS */
		private var _netconn : NetConnection;

		private var _netstream : NetStream;

		private var _target : Video;

		private var _progress_timer : Timer;

		private var _trigger_set : Boolean = false;

		private const DEFAULT_TIMER_DELAY : Number = 10;

		/**
		 * Creates a new VideoSlave instance.
		 */
		public function VideoSlave() : void
		{
		}

		/* TRIGGERS */
		private function _set_triggers() : void
		{
			_netconn.addEventListener( NetStatusEvent.NET_STATUS, _on_net_status );
			_netconn.addEventListener( SecurityErrorEvent.SECURITY_ERROR, _on_security_error );
			
			_netstream.addEventListener( NetStatusEvent.NET_STATUS, _on_net_status );
			_netstream.addEventListener( AsyncErrorEvent.ASYNC_ERROR, _on_net_status );
			
			_progress_timer.addEventListener( TimerEvent.TIMER, _pull_time );
			_progress_timer.start( );
			
			_trigger_set = true;
		}

		private function _unset_triggers() : void
		{
			_netconn.removeEventListener( NetStatusEvent.NET_STATUS, _on_net_status );
			_netconn.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, _on_security_error );
			
			_netstream.removeEventListener( NetStatusEvent.NET_STATUS, _on_net_status );
			_netstream.removeEventListener( AsyncErrorEvent.ASYNC_ERROR, _on_net_status );
			
			_progress_timer.stop( );
			_progress_timer.removeEventListener( TimerEvent.TIMER, _pull_time );
			
			_trigger_set = false;
		}

		/* LISTENERS */
		
		/**
		 * Invoked by the timer to calc the buff progress and shoot the gun.
		 * 
		 * @param event TimerEvent.
		 */
		private function _pull_time( event : TimerEvent ) : void
		{
			if ( loaded >= total )
			{
				_status = ASlave._LOADED;
				_unset_triggers( );
				
				gunz_complete.shoot( new VideoSlaveBullet( loaded, total ) );
			}
			
			gunz_progress.shoot( new VideoSlaveBullet( loaded, total ) );
		}

		/**
		 * Handler to all th connection/status event types.
		 * 
		 * @param event NetStatusEvent.
		 */
		private function _on_net_status( event : NetStatusEvent ) : void
		{
			switch ( event.info[ "code" ] ) 
			{
				case "NetStream.Play.StreamNotFound":
					gunz_error.shoot( new VideoSlaveBullet( loaded, total, "Unable to locate video: " + _uri ) );
					break;
			}
		}

		/**
		 * Handler to the security or IO possible errors on the stream.
		 * 
		 * @param event NetStatusEvent
		 */
		private function _on_security_error( event : NetStatusEvent ) : void
		{
			gunz_error.shoot( new VideoSlaveBullet( loaded, total, "Security error." ) );
		}

		/* GETTERS */
		
		/**
		 * Computes the bytes total and return it.
		 * @return	Bytes total.
		 */
		public function get total() : Number
		{
			return _netstream.bytesTotal;
		}

		/**
		 * Computes the bytes loaded and return it.
		 * @return	Bytes loaded.
		 */
		public function get loaded() : Number
		{
			return _netstream.bytesLoaded;
		}

		/**
		 * Return the NetStream object used to load and controll the video 
		 * stream.
		 * 
		 * @return NetStream object.
		 */
		public function get net_stream() : NetStream
		{
			return _netstream;
		}

		/* PUTTING */
		
		/**
		 * Puts the loaded content into the given target.
		 * @param target	Target to put the loaded content into.
		 * @return Self reference for inline reuse.
		 */
		public function put( target : Video ) : VideoSlave
		{
			_target = target;
			return this;
		}

		/* LOADING */
		
		/**
		 * Start the loading process.
		 * @return	Self reference for inline reuse.
		 */
		public function load( uri : String = null ) : ISlave
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
				
			_progress_timer = new Timer( DEFAULT_TIMER_DELAY );
			
			_netconn = new NetConnection( );
			_netconn.connect( null );
			
			// updating status
			_status = ASlave._LOADING;
			
			// start connection
			_netstream = new NetStream( _netconn );
			_netstream.client = new StatusHandler( );
			
			if( _target )
				_target.attachNetStream( _netstream );
				
			_netstream.play( _uri );
			_netstream.pause( );
			
			_set_triggers( );
			
			gunz_start.shoot( new VideoSlaveBullet( loaded, total ) );
			
			return this;
		}

		/**
		 * Unload content.
		 * @return	ISlave.
		 */
		public function unload() : ISlave
		{
			if ( _netconn )
				_netconn.close( );
			
			if ( _netstream )
				_netstream.close( );
			
			if ( _trigger_set )
				_unset_triggers( );
				
			if( _target )
				_target.clear( );
			
			_progress_timer = null;
			_netconn = null;
			_netstream = null;
			_target = null;
			
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

internal class StatusHandler 
{
	public var duration : Number;

	public function onMetaData( info : Object ) : void 
	{
		this.duration = Math.round( info[ "duration" ] * 100 ) / 100;
	}

	public function onXMPData(infoObject : Object) : void 
	{ 
	}
}