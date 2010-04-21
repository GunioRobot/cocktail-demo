package cocktail.core.slave.gunz 
{

	/**
	 * Bullet for SlaveBase class.
	 * @see SlaveBase
	 * @author carlos | carlos@codeine.it
	 */
	public class TextSlaveBullet extends ASlaveBullet
	{
		/* BULLET PROPERTIES */
		public var data : *;

		/* INITIALIZING */
		
		/**
		 * Creates a new GraphSlaveBullet.
		 * @param loaded	File loading status.
		 * @param total	File bytes loaded.
		 * @param data The loaded data.
		 */
		public function TextSlaveBullet(
			bytes_loaded : Number,
			bytes_total : Number,
			data : * = null
		) : void
		{
			super( bytes_loaded, bytes_total );
			
			if( data )
				this.data = data.toString( );
		}
	}
}