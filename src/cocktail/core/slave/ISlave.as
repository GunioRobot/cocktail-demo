package cocktail.core.slave 
{

	/**
	 * Interface for all Slaves.
	 * @author nybras | nybras@codeine.it
	 */
	public interface ISlave 
	{
		function get total() : Number;

		function get loaded() : Number;

		function get status() : String;

		function load() : ISlave;
		
		function unload() : ISlave;
		
		function close() : ISlave;
		
		function destroy() : ISlave;
	}
}
