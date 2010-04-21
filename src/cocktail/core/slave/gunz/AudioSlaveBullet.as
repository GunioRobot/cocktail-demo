package cocktail.core.slave.gunz 
{
	import flash.media.Sound;

	/**
	 * Bullet for SlaveBase class.
	 * @see SlaveBase
	 * @author carlos | carlos@codeine.it
	 */
	public class AudioSlaveBullet extends ASlaveBullet
	{
		/* BULLET PROPERTIES */
		public var sound : Sound;

		/* INITIALIZING */
		
		/**
		 * Creates a new AudioSlaveBullet.
		 * @param loaded	File loading status.
		 * @param total	File bytes loaded.
		 * @param content The content loaded.
		 */
		public function AudioSlaveBullet(
			bytes_loaded : Number = undefined,
			bytes_total : Number = undefined,
			content : Sound = null
		) : void
		{
			super( bytes_loaded, bytes_total );
			
			this.sound = content;
		}
	}
}