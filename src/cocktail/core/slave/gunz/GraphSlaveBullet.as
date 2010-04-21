package cocktail.core.slave.gunz 
{
	import flash.display.DisplayObject;

	/**
	 * Bullet for SlaveBase class.
	 * @see SlaveBase
	 * @author carlos | carlos@codeine.it
	 */
	public class GraphSlaveBullet extends ASlaveBullet
	{
		/* BULLET PROPERTIES */
		public var content : DisplayObject;

		/* INITIALIZING */
		
		/**
		 * Creates a new GraphSlaveBullet.
		 * @param loaded	File loading status.
		 * @param total	File bytes loaded.
		 * @param content The content loaded.
		 */
		public function GraphSlaveBullet(
			bytes_loaded : Number = undefined,
			bytes_total : Number = undefined,
			content : DisplayObject = null
		) : void
		{
			super( bytes_loaded, bytes_total );
			
			this.content = content;
		}
	}
}