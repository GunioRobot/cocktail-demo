<?php
/**
 * Simple Amf Service.
 * @autor nybras | nybras@codeine.it
 */
class Instruments
{
	/**
	 * get_all instruments.
	 * {
	 *	    locale: string - (en|pt)
	 * }
	 */
	function get_all ( $locale )
	{
		if ( $locale == "en" )
		{
			$instruments = new stdClass ();
			$instruments->string = array(
				"harp",
				"lyre",
				"psaltery"
			);
			$instruments->wind = array(
				"horn",
				"saxophone",
				"piccolo"
			);
		}
		else if ( $locale == "pt" )
		{
			$instruments = new stdClass ();
			$instruments->string = array(
				"harpa",
				"lira",
				"saltório"
			);
			$instruments->wind = array(
				"trompa",
				"saxofone",
				"flautim"
			);
		}
		
		return $instruments;
	}
}