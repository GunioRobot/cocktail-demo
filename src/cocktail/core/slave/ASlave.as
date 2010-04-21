package cocktail.core.slave 
{
	import cocktail.core.gunz.Gun;
	import cocktail.core.gunz.Gunz;

	import de.polygonal.ds.DLinkedList;
	import de.polygonal.ds.DListNode;

	/**
	 * Slavery extends the SlaveBase and adds some functionality to it, becoming
	 * the base class for every slave in this package.
	 * @author nybras | nybras@codeine.it
	 */
	public class ASlave 
	{
		/** GUNZ **/
		public var gunz : Gunz;

		public var gunz_start : Gun;

		public var gunz_progress : Gun;

		public var gunz_complete : Gun;

		public var gunz_error : Gun;

		/**  CONSTANTS **/
		protected static const _QUEUED : String = "queued";

		protected static const _LOADING : String = "loading";

		protected static const _LOADED : String = "loaded";

		protected static const _ERROR : String = "error";

		protected static const _DESTROYED : String = "destroyed";

		/** VARS **/
		protected var _uri : String;

		protected var _node : DListNode;

		protected var _status : String;

		public var dlist : DLinkedList;

		/* INITIALIZING */
		
		/**
		 * Creates a new Slavery instance.
		 * @param uri	Uniform Resource Identifier to be loaded.
		 */
		public function ASlave( uri : String = null )
		{
			_init_gunz( );
			_uri = uri;
			_status = _QUEUED;
		}

		private function _init_gunz() : void
		{
			gunz = new Gunz( this );
			gunz_start = new Gun( gunz, this, "start" );
			gunz_progress = new Gun( gunz, this, "progress" );
			gunz_complete = new Gun( gunz, this, "complete" );
			gunz_error = new Gun( gunz, this, "error" );
		}

		/* GETTERS */
		
		/**
		 * Get the item status, that could be:
		 * 	1- queued
		 * 	2- loading
		 * 	3- loaded
		 * 	4- error
		 * 	5- destroyed
		 * @return	Item status.
		 */
		final public function get status() : String
		{
			return _status;
		}

		/**
		 * Returns the slave node, in the linked list.
		 * @param	Slave node.
		 */
		final public function get node() : DListNode
		{
			return _node;
		}

		/**
		 * Returns the slave node, in the linked list.
		 * @param	Slave node.
		 */
		final public function set node( node : DListNode ) : void
		{
			_node = node;
		}

		/**
		 * Returns the slave prev node, in the linked list.
		 * @param	Slave prev node.
		 */
		final public function get prev() : DListNode
		{
			return _node.prev;
		}

		/**
		 * Returns the slave next node, in the linked list.
		 * @param	Slave next node.
		 */
		final public function get next() : DListNode
		{
			return _node.next;
		}

		public function get uri() : String 
		{
			return _uri;
		}

		public function set uri(uri : String) : void 
		{
			_uri = uri;
		}
	}
}