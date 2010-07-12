package demo.views.main 
{
	import cocktail.core.gunz.Bullet;
	import cocktail.core.request.Request;

	import demo.AppView;

	/**
	 * @author hems | henrique@cocktail.as
	 */
	public class RectView extends AppView
	{
		override public function after_render(request : Request) : void 
		{
			super.after_render( request );
			
			sprite.graphics.beginFill( 0xccff00 );
			sprite.graphics.drawRect( 0, 0, 500, 500 );
			sprite.graphics.endFill( );
			
			sprite.useHandCursor = true;
			sprite.buttonMode = true;
		}

		public function click( bullet : Bullet ) : void
		{
			trace( 'on click' );
			
			go( "/main/internal/" );
			
			bullet;
		}
	}
}
