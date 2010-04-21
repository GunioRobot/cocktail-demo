package cocktail.lib.model.datasources
{
	import cocktail.core.request.Request;
	import cocktail.core.slave.gunz.TextSlaveBullet;
	import cocktail.lib.Model;
	import cocktail.lib.model.datasources.gunz.InlineDataSourceBullet;
	import cocktail.lib.model.datasources.interfaces.IDataSource;
	import cocktail.utils.StringUtil;

	import net.digitalprimates.utils.E4XParser;

	public class XmlDataSource extends HttpDataSource implements IDataSource
	{
		/* VARS */
		protected var _result : *;

		/* INITIALIZING */
		public function XmlDataSource(
			model : Model,
			request : Request,
			scheme : XML = null
		)
		{
			super( model, request, scheme );
		}

		override protected function _after_load( bullet : TextSlaveBullet ) : void
		{
			_result = new XML( bullet.data );
			bind( );
			gunz_load_complete.shoot( new InlineDataSourceBullet( ) );
		}

		/* PARSING */
		override public function parse() : void
		{
			var folder : String;
			
			super.parse( );
			
			
			
			if ( StringUtil.outerb( src ) == "[]" )
				src = StringUtil.innerb( src );
			else
			{
				folder = _request.route.api.folder + "/";
				src = config.path( "xml" ) + "models/" + folder + src;
			}
		}

		/* BINDING */
		override public function bind() : void
		{
			var name : String;
			var value : String;
			var result : String;
			var e4x_exp : String;
			var bind_exps : Array;
			
			for each ( var node : XML in _binds )
			{
				name = node.localName( );
				value = node.text( );
				
				bind_exps = StringUtil.enclosure( value, "{", "}" );
				for each ( e4x_exp in bind_exps )
				{
					if( e4x_exp == "{RAW}" )
						result = new XML( _result.toXMLString( ) );
					else
						result = _query( StringUtil.innerb( e4x_exp ) );
					
					value = value.replace( e4x_exp, result );
				}
				
				_model.bind.s( node.localName( ), value );
			}
		}

		/* QUERING */
		protected function _query( e4x : String ) : String
		{
			return E4XParser.evaluate( _result, e4x );
		}
	}
}