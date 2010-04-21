package cocktail.lib.model.datasources 
{
	import cocktail.core.request.Request;
	import cocktail.lib.Model;
	import cocktail.lib.model.datasources.gunz.InlineDataSourceBullet;
	import cocktail.lib.model.datasources.interfaces.IDataSource;
	import cocktail.utils.Timeout;

	public class InlineDataSource extends ADataSource implements IDataSource 
	{
		/* INITIALIZING */
		public function InlineDataSource(
			model : Model,
			request : Request,
			scheme : XML = null
		)
		{
			super( model, request, scheme );
			_raw = _scheme.children( ).toString( );
		}

		/* LOADING */
		override public function load() : ADataSource
		{
			new Timeout( _after_load, 1 );
			return this;
		}

		private function _after_load() : void
		{
			bind( );
			gunz_load_complete.shoot( new InlineDataSourceBullet( ) );
		}

		/* BINDING */
		public function bind() : void
		{
			for each ( var node : XML in _binds )
				_model.bind.s( node.localName( ), node.text( ) );
		}
	}
}