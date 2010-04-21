package cocktail.utils 
{
	import flash.net.LocalConnection;

	/**
	 * Some System usefull standalone tweaks.
	 * @author nybras | me@nybras.com
	 */
	public class SystemUtil 
	{
		/**
		 * Perform a forced SystemUtil.gc that actually works.
		 */
		public static function gc() : void
		{
			try 
			{
				// the GC will perform a full mark/sweep on the second call.
				new LocalConnection( ).connect( 'foo' );
				new LocalConnection( ).connect( 'foo' );
			} catch (e : *) 
			{
				// just silences the error.
			}
		}
	}
}
