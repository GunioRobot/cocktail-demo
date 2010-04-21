package cocktail.core.slave.slaves 
{
	import cocktail.core.slave.ASlave;
	import cocktail.core.slave.gunz.AmfSlaveBullet;

	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;

	/**
	 * @author nybras | nybras@codeine.it
	 */
	public class AmfSlave extends ASlave 
	{
		/* VARS */
		private var _conn : NetConnection;

		private var _gateway : String;

		private var _service : String;

		/* INITIALIZING */
		
		/**
		 * Creates a new Amf instance.
		 * @param gateway	Service gateway.
		 * @param service	Service name.
		 * @param objectEncoding	Service encoding (default=AMF3).
		 */
		public function AmfSlave(
			gateway : String,
			service : String,
			objectEncoding : uint = undefined
		)
		{
			_service = service;
			_conn = new NetConnection( );
			_conn.objectEncoding = ( objectEncoding || ObjectEncoding.AMF3 );
			_conn.connect( _gateway = gateway );
		}

		/**
		 * Invokes the given method on the server.
		 * @param method	Method to be invoked.
		 * @param params	Method's params.
		 */
		public function load( method : String, params : * = null ) : void
		{
			var stuff : Array;
			var result : Function;
			var fault : Function;
			
			result = _result;
			fault = _fault;
			
			stuff = [ _service + "." + method ];
			stuff.push( new Responder( _result, _fault ) );
			
			_conn.call.apply( _conn, stuff.concat( params ) );
			gunz_start.shoot( new AmfSlaveBullet( ) );
		}

		/* DEFAULT RESPONDER AND FAULT */
		
		/**
		 * Default result callback, to handle server result.
		 * @param result	Result from server.
		 */
		private function _result( result : * ) : void
		{
			gunz_complete.shoot( new AmfSlaveBullet( result ) );
		}

		/**
		 * Default fault callback, to handle server fault.
		 * @param fault	Fault info message, from server.
		 */
		private function _fault( fault : * ) : void
		{
			gunz_error.shoot( new AmfSlaveBullet( fault ) );
		}
	}
}