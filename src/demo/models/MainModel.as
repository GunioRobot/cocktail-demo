package demo.models 
{
	import demo.AppModel;

	/**
	 * Handles the main Model behaviors.
	 * @author nybras | nybras@codeine.it
	 */
	public class MainModel extends AppModel
	{
		override public function after_load() : void
		{
			log.debug( "========================================" );
			log.debug( "[InlineDataSource] binds:" );
			log.debug( "song: " + bind.g( "song" ) );
			log.debug( "year: " + bind.g( "year" ) );
			log.debug( "duration: " + bind.g( "duration" ) );			
			log.debug( "========================================" );
			log.debug( "[XmlDataSource] binds:" );
			log.debug( "artist: " + bind.g( "artist" ) );
			log.debug( "decade: " + bind.g( "decade" ) );
			
			log.debug( "========================================" );
			log.debug( "[AmfDataSource] binds:" );
			log.debug( "instrument-wind-1: " + bind.g( "instrument-wind-1" ) );
			log.debug( "instrument-wind-2: " + bind.g( "instrument-wind-2" ) );
			
			log.debug( "========================================" );
			log.debug( "[HttpDataSource] binds:" );
			log.debug( "instrument-string: " + bind.g( "instrument-string" ) );
			
			log.debug( "========================================" );
			log.debug( "[JsonDataSource] binds:" );
			log.debug( "Checking JSONDataSource binds..." );
			log.debug( "songs-num: " + bind.g( "songs-num" ) );
		}
	}
}