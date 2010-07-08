package demo.views.main 
{
	import cocktail.core.request.Request;
	import cocktail.lib.views.SwfView;

	/**
	 * @author hems | henrique@cocktail.as
	 */
	public class BallView extends SwfView 
	{
		public function BallView()
		{
		}

		override public function after_render(request : Request) : void 
		{
			super.after_render( request );
			
			log.info( "Running..." );
			
			sprite.graphics.beginFill( 0xFF0000 );
			sprite.graphics.drawCircle( 0, 0, 50 );
			sprite.graphics.endFill( );
			
			//cocktail.app.addChild( sprite );
		}
	}
}
