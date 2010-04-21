package cocktail.core.request 
{
	import cocktail.Cocktail;
	import cocktail.core.request.Request;

	/**
	 * Handles all async requests.
	 * @author nybras | nybras@codeine.it
	 */
	public class RequestAsync extends Request 
	{
		/* INITIALIZING */
		
		/**
		 * TODO: write docs
		 */
		public function RequestAsync(
			uri : String,
			data : *
		)
		{
			super( Request.POST, uri, data );
		}

		/* BOOTING */
		
		/**
		 * Boots the Index base class.
		 * @param cocktail	Cocktail reference.
		 */
		override public function boot( cocktail : Cocktail ) : *
		{
			var s : *;
			
			s = super.boot( cocktail );
			return s;
		}
	}
}
