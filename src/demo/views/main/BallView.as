package demo.views.main 
{
	import cocktail.core.request.Request;

	import demo.AppView;

	/**
	 * @author hems | henrique@cocktail.as
	 */
	public class BallView extends AppView 
	{
		public function BallView()
		{
		}

		override public function after_render( request : Request ) : void 
		{
			request;
			log.info( "Running..." );
			
			sprite.graphics.beginFill( 0xFF0000 );
			sprite.graphics.drawCircle( 0, 0, 50 );
			sprite.graphics.endFill( );
		}
	}
}
