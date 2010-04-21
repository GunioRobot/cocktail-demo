package cocktail.lib.views.assets 
{
	import cocktail.Cocktail;
	import cocktail.core.Index;
	import cocktail.core.gunz.Gun;

	/**
	 * Every tag on layout's xml, will be parsed and become an AAsset
	 */
	public class AAsset extends Index
	{
		/* GUNZ */
		public var gunz_load_start : Gun; 

		public var gunz_load_progress : Gun; 

		public var gunz_load_complete : Gun; 

		private function _init_gunz() : void
		{
			gunz_load_start = new Gun( gunz, this, "load_start" );
			gunz_load_progress = new Gun( gunz, this, "load_progress" );
			gunz_load_complete = new Gun( gunz, this, "load_complete" );
		}

		/* VARS */
		public var raw : *;

		/* BOOTING */
		override public function boot( cocktail : Cocktail ) : *
		{
			var s : *;
			
			s = super.boot( cocktail );
			_init_gunz( );
			
			return s;
		}

		public function load() : AAsset
		{
			_after_load( );
			return this;
		}

		private function _after_load() : void
		{
			//
		}
	}
}