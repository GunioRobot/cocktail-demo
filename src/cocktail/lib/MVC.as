package cocktail.lib 
{
	import cocktail.Cocktail;
	import cocktail.core.Index;
	import cocktail.core.gunz.Gun;

	/**
	 * @author nybras | me@nybras.com
	 */
	public class MVC extends Index 
	{
		/* GUNZ */
		public var gunz_load_start : Gun; 

		public var gunz_load_progress : Gun; 

		public var gunz_load_complete : Gun; 

		/*Clean class name */
		private var _name : String;

		private function _init_gunz() : void
		{
			gunz_load_start = new Gun( gunz, this, "load_start" );
			gunz_load_progress = new Gun( gunz, this, "load_progress" );
			gunz_load_complete = new Gun( gunz, this, "load_complete" );
		}

		/* BOOTING */
		override public function boot( cocktail : Cocktail ) : *
		{
			var s : *;
			var regexp : RegExp;
			
			s = super.boot( cocktail );
			
			_init_gunz( );
			
			regexp = /(Model|View|Controller|Layout$)/;
			_name = classname.replace( regexp, '' );
			
			return s;
		}

		public function redirect( url : String, silent : Boolean = false ) : void
		{
			silent;
			router.get( url );
		}

		/*Clean class name */
		public function get name() : String
		{
			return _name;
		}
	}
}