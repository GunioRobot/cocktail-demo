package cocktail.core.router.gunz 
{
	import cocktail.core.gunz.Bullet;
	import cocktail.core.request.Request;

	/**
	 * TODO: add class description
	 * @author hems | hems@codeine.it
	 */
	public class RouterBullet extends Bullet
	{
		/* BULLET PROPERTIES */
		public var request : Request;

		/* INITIALIZING */
		
		/**
		 * Creates a new RouterBullet.
		 * @param request	Request instance.
		 */
		public function RouterBullet( request : Request ) : void
		{
			super( );
			this.request = request;
		}
	}
}