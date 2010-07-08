package demo.views.main 
{
	import cocktail.core.request.Request;
	import cocktail.lib.views.SwfView;

	/**
	 * This class is a "custom swf loader".
	 * 
	 * @author hems | henrique@cocktail.as
	 */
	public class SwfLoaderView extends SwfView
	{
		override public function before_render( request : Request ) : Boolean 
		{
			if( !super.before_render( request ) ) return false;

			return true;
		}

		override public function after_render(request : Request) : void 
		{
			super.after_render( request );
		}
	}
}