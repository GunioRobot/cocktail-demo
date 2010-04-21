package cocktail.core.bind 
{

	/**
	 * Touched class used by Bind / Binded.
	 * @author nybras | nybras@codeine.it
	 * @see Bind
	 */
	public class Touched 
	{
		/* VARS */
		internal var _all : Boolean;

		public var key : String;

		public var methods : *;

		/* INITIALIZING */
		
		/**
		 * Creates a new Touched instance.
		 * @param key	Key to plug.	
		 * @param methods	Methods to be touched when the key value changes, it
		 * can be just a single method or an array with many methods.
		 */
		public function Touched(
			key : String,
			methods : *
		) : void
		{
			this.key = key;
			this.methods = methods;
		}

		/* UPDATING */
		
		/**
		 * Updates the touched item.
		 */
		internal function update() : void
		{
			var method : Function;
			
			if ( methods is Function )
				( methods as Function )( );
			else if ( methods is Array )
				for each ( method in methods )
					( method as Function )( );
		}
	}
}