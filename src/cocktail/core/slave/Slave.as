package cocktail.core.slave 
{
	import cocktail.core.slave.gunz.ASlaveBullet;
	import cocktail.core.slave.slaves.AudioSlave;
	import cocktail.core.slave.slaves.GraphSlave;
	import cocktail.core.slave.slaves.TextSlave;
	import cocktail.core.slave.slaves.VideoSlave;

	import de.polygonal.ds.DLinkedList;
	import de.polygonal.ds.DListIterator;
	import de.polygonal.ds.DListNode;
	import de.polygonal.ds.Iterator;

	/**
	 * Slave is a loading library.
	 * @author nybras | nybras@codeine.it
	 */
	public class Slave extends ASlave implements ISlave
	{
		/* VARS */	
		private var _auto_load : Boolean;

		private var _parallelized : Boolean;

		private var _started : int;

		private var _completed : int;

		/* INITIALIZING */
		
		/**
		 * Creates a new Slave.
		 * @param auto_load	If <code>true</code> all subsequent loading calls
		 * will start loading immediatelly, otherwise <code>false</code> you'll
		 * need to call the "load" method to start the loading process.
		 * @param parallelized	If <code>true</code> all queue objects are 
		 * started to load in the same time, otherwise <code>false</code> the 
		 * loading process is sequentially managed, where the object is started
		 * only when the prev object is quite and done.
		 */
		public function Slave( 	auto_load : Boolean = false, 
								parallelized : Boolean = false )
		{
			super( );
			_auto_load = auto_load;
			_parallelized = parallelized;
			dlist = new DLinkedList( );
		}

		/* LOADING */
		
		/**
		 * Start the loading process.
		 * 
		 * @return Self return;
		 */
		public function load( uri : String = null ) : ISlave
		{
			//			trace( "Slave#load " + _status );
			
			//if the loading is started, lets keep safe from new inputs;
			if ( _status == _LOADING )
			{
				trace( "Cannot load now, execute unload()" );
				return this;
			}
			
			return _load( );
		}

		/**
		 * Really start the loading process.
		 * Set as private to keep the loading proccess safe.
		 * 
		 * @return Self return;
		 */
		private function _load() : ISlave
		{
			//			trace( "Slave#_load " + uri );
			_status = _LOADING;
			
			var i : DListIterator;
			
			if( _auto_load )
				return this;
			
			if ( !_parallelized )
			{
				( dlist.head.data as ASlave )[ "load" ]( );
				return this; 
			}
			
			i = DListIterator( dlist.getIterator( ) );
			while( i.hasNext( ) )
				DListNode( i.next( ) ).data[ "load" ]( );
			
			return this;
		}

		/* SHORTCUTS */
		
		/**
		 * Loads any binary graphic asset, such as jpg, gif, png, swf etc.
		 * @param uri	Uniform Resource Identifier to be loaded.
		 * @return	The created and appended GraphSlave instance.
		 */
		public function graph( uri : String ) : GraphSlave
		{
			var slave : GraphSlave = new GraphSlave( );
			slave.uri = uri;
			return _queue( slave );
		}

		/**
		 * Loads any text request, such as xml, txt, etc.
		 * @param uri	Uniform Resource Identifier to be loaded.
		 * @return	The created and appended TextSlave instance.
		 */
		public function text( uri : String ) : TextSlave
		{
			var slave : TextSlave = new TextSlave( );
			slave.uri = uri;
			return _queue( slave );
		}

		/**
		 * Loads any video request (.flv .mov).
		 * @param uri	Uniform Resource Identifier to be loaded.
		 * @return	The created and appended VideoSlave instance.
		 */
		public function video( uri : String ) : VideoSlave
		{
			var slave : VideoSlave = new VideoSlave( );
			slave.uri = uri;
			return _queue( slave );
		}

		/**
		 * Loads any audio request (.mp3 .wav).
		 * @param uri	Uniform Resource Identifier to be loaded.
		 * @return	The created and appended AudioSlave instance.
		 */
		public function audio( uri : String ) : AudioSlave
		{
			var slave : AudioSlave = new AudioSlave( );
			slave.uri = uri;
			return _queue( slave );
		}

		/* QUEUE */
		
		/**
		 * Enqueue the given slave item.
		 * @param slave	Slave item to be queued.
		 */
		private function _queue( slave : ASlave ) : *
		{
			slave.gunz_start.add( _start );
			slave.gunz_progress.add( _progress );
			slave.gunz_complete.add( _complete );
			slave.gunz_error.add( _error );
			
			slave.node = dlist.append( slave );
			
			return slave;
		}

		/* LISTENERS */
		
		/**
		 * Listen for loading start and repass the event.
		 * @param bullet	SlaveBullet.STAR
		 */
		private function _start( bullet : ASlaveBullet ) : void
		{
			ASlave( bullet.owner ).gunz_start.rm( _start );
			if( !_started++ )
				gunz_start.shoot( new ASlaveBullet( loaded, total ) );
		}

		/**
		 * Listen for loading progress and repass the event.
		 * @param bullet	SlaveBullet.PROG
		 */
		private function _progress( bullet : ASlaveBullet ) : void
		{
			bullet;
			gunz_progress.shoot( new ASlaveBullet( loaded, total ) );
		}

		/**
		 * Listen for loading complete and repass the event.
		 * @param bullet	SlaveBullet.COMP
		 */
		private function _complete( bullet : ASlaveBullet ) : void
		{
			ASlave( bullet.owner ).gunz_progress.rm( _progress );
			ASlave( bullet.owner ).gunz_complete.rm( _progress );
			
			if ( _parallelized )
			{
				if ( ++_completed == length )
					gunz_complete.shoot( new ASlaveBullet( loaded, total ) );
			}
			else
			{
				if( ( bullet.owner as ASlave ).node.next )
					( ( bullet.owner as ASlave ).node.next.data as ISlave ).load( );
				else
					gunz_complete.shoot( new ASlaveBullet( loaded, total ) );
			}
		}

		/**
		 * Listen for loading error and repass the event.
		 * @param bullet	SlaveBullet.ERRO
		 */
		private function _error( bullet : ASlaveBullet ) : void
		{
			ASlave( bullet.owner ).gunz_error.rm( _error );
			gunz_error.shoot( new ASlaveBullet( loaded, total ) );
		}

		/* APPENDING ANOTHERS SLAVES */
		
		/**
		 * Append the given slave into this one.
		 * @param slave	Slave instance to be appended.
		 * @return	A self reference for inline reuse.
		 */
		public function append( slave : ASlave ) : ASlave
		{
			//if the loading is started, lets keep safe from new inputs;
			if ( _status == _LOADING )
			{
				return this;
			}
			
			if( !slave.dlist )
				_queue( slave );
			else
			{
				var i : Iterator;
				var node : ASlave;
				i = slave.dlist.getIterator( );
				
				while( i.hasNext( ) )
				{
					node = i.next( );
					_queue( slave );
				}
			}
			
			return this;
		}

		/* GETTERS - items */
		
		/**
		 * Computes the childs length and return it.
		 * @return	The childs length.
		 */
		public function get length() : int
		{
			return dlist.size;
		}

		/**
		 * Counts the total of items already loaded.
		 * @return	The number of items already loaded.
		 */
		public function get loaded_items() : int
		{
			return _completed;
		}

		/**
		 * Counts the total of items being loaded.
		 * @return	The number of items being loaded.
		 */
		public function get loading_items() : int
		{
			return ( _started - _completed );
		}

		/* GETTERS - bytes */
		
		/**
		 * Computes the bytes total and return it.
		 * @return	Bytes total.
		 */
		public function get total() : Number
		{
			var i : DListIterator;
			var slave : ISlave;
			var total : Number;
			  
			i = DListIterator( dlist.getIterator( ) );
			total = 0;
			
			while( i.hasNext( ) )
			{
				slave = i.next( );
				if( slave.status != ASlave._QUEUED )
					total += slave.total;
			}
			
			return total;
		}

		/**
		 * Computes the bytes total and return it.
		 * @return	Bytes total.
		 */
		public function get loaded() : Number
		{
			var i : DListIterator;
			var slave : ISlave;
			var loaded : Number;
			  
			i = DListIterator( dlist.getIterator( ) );
			loaded = 0;
			
			while( i.hasNext( ) )
			{
				slave = i.next( );
				if( slave.status != ASlave._QUEUED )
					loaded += slave.loaded;
			}
			
			return loaded;
		}

		public function stop_loading() : void
		{
			if ( _status == _LOADING )
			{
				dlist.clear( );
			}
		}

		public function unload() : ISlave
		{
			var i : DListIterator;
			
			i = DListIterator( dlist.getIterator( ) );
			while( i.hasNext( ) )
				( i.next( ) as ISlave ).unload( );
			
			_status = _QUEUED;
			
			return this;
		}

		public function destroy() : ISlave
		{
			unload( );
			
			var i : DListIterator;
			
			i = DListIterator( dlist.getIterator( ) );
			while( i.hasNext( ) )
				( i.next( ) as ISlave ).unload( );
				
			gunz.rm_all( );	
			
			return this;
		}
	}
}