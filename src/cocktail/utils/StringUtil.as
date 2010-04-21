package cocktail.utils 
{

	/**
	 * Utilities for string manipuation.
	 * @author nybras | nybras@codeine.it
	 */
	public class StringUtil 
	{
		/**
		 * Returns the given string in lowercase, except the first char that 
		 * becomes uppercase.
		 * @param string	String source.
		 */
		public static function ucasef( string : String ) : String
		{
			return string.substr( 0, 1 ).toUpperCase( ) + string.substr( 1 ).toLowerCase( );
		}

		/**
		 * Returns the first and last char of the given string.
		 * @param string	String source.
		 */
		public static function outerb( string : String ) : String
		{
			return string.substr( 0, 1 ) + string.substr( -1 );
		}

		/**
		 * Returns the given string, excluding the first and last char.
		 * @param string	String source.
		 */
		public static function innerb( string : String ) : String
		{
			return string.slice( 1, -1 );
		}

		/**
		 * Search the given string for every ocurrency surrounded by the given 
		 * opening/close chars and return a array with all found occurrencies.
		 */
		public static function enclosure( 
			string : String, 
			opening : String, 
			closing : String 
		) : Array
		{
			var r : RegExp;
			
			opening = escapeRegExpChar( opening );
			closing = escapeRegExpChar( closing );
			
			r = new RegExp( opening + ".+?" + closing, "g" );
			
			return string.match( r );
		}

		/**
		 * Escapes the given char to be used into a RegExp.
		 * @param char	Chars to be escaped.
		 */
		private static function escapeRegExpChar( char : String ) : String
		{
			return char.replace( /([{}\(\)\^$&.\*\?\/\+\|\[\\\\]|\]|\-)/g, "\\$1" );
		}

		/**
		 * Removes all blank spaces on the left and right side of the given 
		 * string.
		 * @param string	String source.
		 */
		public static function trim( string : String ) : String
		{
			return StringUtil.ltrim( StringUtil.rtrim( string ) );
		}

		/**
		 * Removes all blank spaces on the left side of the given string.
		 * @param string	String source.
		 */
		public static function ltrim( string : String ) : String
		{
			var obj : RegExp = /^(\s*)([\W\w]*$)/;
			if ( obj.test( string ) )
				string = string.replace( obj, '$2' );
			return string;		
		}

		/**
		 * Removes all blank spaces on the right side of the given string.
		 * @param string	String source.
		 */
		public static function rtrim( string : String ) : String
		{
			var obj : RegExp = /^([\W\w]*)(\b\s*$)/;
			if ( obj.test( string ) )
				string = string.replace( obj, '$1' );
			return string;
		}

		/**
		 * Replaces all found occurencies.
		 * @param string	String source.
		 * @param search	String search entry.
		 * @param replace	String replacement.
		 */
		public static function replace_all( 
			string : String, 
			search : *, 
			replace : * 
		) : String
		{
			return string.split( search ).join( replace ); 
		}

		/**
		 * Capitalizes the given string according or no the given separator.
		 * @param string	String to capitalize.
		 * @param sep	Word separator (optional).
		 * @return	The capitalized string.
		 */
		public static function cap( 
			string : String, 
			sep : String = "-" 
		) : String
		{
			var output : String;
			var word : String;
			
			output = "";
			for each( word in [].concat( string.split( sep ) ) )
				output += ucasef( word );
			
			return output;
		}

		/**
		 * lowercase_underscored to CamelCase
		 */
		public static function toCamel( string : String ) : String
		{
			var parts : Array;
			var result : String;
			var i : int;
			
			//TODO: check if i need really 
			result = '';
			parts = string.split( '_' );
			do
			{
				result += ucasef( parts[ i ] );
			}while( ++i < parts.length );
			
			return result;
		}

		/**
		 * Convert camel cases string ( CamelCased ) 
		 * to underscoded ( camel_case )
		 */
		public static function toUnderscore( string : String ) : String
		{
			string = string.replace( /(.)([A-Z])/, '$1_$2' );
			string = string.toLowerCase( );
			
			return string;
		}
	}
}