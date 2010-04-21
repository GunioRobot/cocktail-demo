package cocktail.core.logger.interfaces 
{
	import cocktail.core.logger.Logger;				

	/**
	 * Interface for Loggers.
	 * @author nybras | nybras@codeine.it
	 */
	public interface ILogger 
	{
		/* LOG METHODS */
		
		/**
		 * Shows/log every kind of message, following a common template.
		 */
		function log( ...params ) : void;

		/**
		 * Show/log info's messages.
		 * @param params	FATAL message to be logged.
		 */
		function fatal( ...params ) : Logger;

		/**
		 * Show/log info's messages.
		 * @param params	ERROR message to be logged.
		 */
		function error( ...params ) : Logger;

		/**
		 * Show/log debugs's messages.
		 * @param params	DEBUG message to be logged.
		 */
		function debug( ...params ) : Logger;

		/**
		 * Show/log info's messages.
		 * @param params	WARN message to be logged.
		 */
		function warn( ...params ) : Logger;

		/**
		 * Show/log notice's messages.
		 * @param params	NOTICE message to be logged.
		 */
		function notice( ...params ) : Logger;

		/**
		 * Show/log info's messages.
		 * @param params	INFO message to be logged.
		 */
		function info( ...params ) : Logger;
	}
}