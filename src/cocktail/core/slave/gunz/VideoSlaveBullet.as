package cocktail.core.slave.gunz 
{

	/**
	 * Bullet for SlaveBase class.
	 * @see SlaveBase
	 * @author carlos | carlos@codeine.it
	 */
	public class VideoSlaveBullet extends ASlaveBullet
	{
		/* BULLET PROPERTIES */
		public var msg : String;

		/* INITIALIZING */
		
		/**
		 * Creates a new GraphSlaveBullet.
		 * @param loaded	File loading status.
		 * @param total	File bytes loaded.
		 * @param data The loaded data.
		 */
		public function VideoSlaveBullet(
			bytes_loaded : Number,
			bytes_total : Number,
			msg : String = ""
		) : void
		{
			super( bytes_loaded, bytes_total );
			this.msg = msg;
		}
	}
}