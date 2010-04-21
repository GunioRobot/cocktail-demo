package cocktail.core.slave.gunz 
{
	import cocktail.core.gunz.Bullet;

	/**
	 * Bullet for ASlave class.
	 * @see ASlave
	 * @author nybras | nybras@codeine.it
	 */
	public class ASlaveBullet extends Bullet
	{
		/* BULLET PROPERTIES */
		public var bytes_loaded : Number;

		public var bytes_total : Number;

		/* INITIALIZING */
		
		/**
		 * Creates a new SlaveBullet.
		 * @param loaded	File loading status.
		 * @param total	File bytes loaded.
		 */
		public function ASlaveBullet(
			bytes_loaded : Number = undefined,
			bytes_total : Number = undefined
		) : void
		{
			super( );
			
			this.bytes_loaded = bytes_loaded;
			this.bytes_total = bytes_total;
		}

		/* COMPUTING PROGRESS */
		
		 /**
		 * Computes the progress ammount from 0 to 1 and return it.
		 * @return	The progress ammount.
		 */
		public function get bytes_progress() : Number
		{
			return ( ( bytes_loaded / bytes_total ) || 0 );
		}
	}
}