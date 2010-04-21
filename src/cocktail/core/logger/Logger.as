package cocktail.core.logger
{
	import flash.utils.getTimer;

	/**
	 * Log class is only a simple class for tracing messages, and nothing more.
	 * @author nybras | nybras@codeine.it
	 */
	public class Logger
	{
		/* VARS */
		protected var _target_class : String;

		protected var _target_class_name : String;

		protected var _level : uint;

		protected var _detail : uint;

		/* INITIALIZING */
		
		/**
		 * Creates a new Logger instance.
		 * @param class_name	Class name to be logged with all log calls.
		 */
		public function Logger( class_name : String )
		{
			_target_class = class_name;
			_target_class_name = _target_class.split( "." ).pop( );
		}

		/* TREE UTIL */
		
		/**
		 * Sweep the entire object, return a formated-string with all object
		 * levels and values.
		 * @param params	Data to be sweeped.
		 * @param level	Sweep cycle.
		 * @param buffer	Sweep buffer.
		 */
		public function tree(
			params : *,
			cycle : int = 0,
			buffer : String = ""
		) : *
		{
			var output : String;
			var tabs : String;
			var data : *;
			var i : int;
			
			i = 0;
			tabs = "";
			
			while ( i++ < cycle )
				tabs += "\t";
			
			for ( var child : * in params )
			{
				data = params[ child ];
				buffer += tabs + "[" + child + "] => ";
				buffer += ( data is Array ? "[object Array]" : data );
				output = tree( data, ( cycle + 1 ) );
				
				if ( output != "" )
			    	buffer += " {\n" + output + tabs + "}";
				
				buffer += "\n";
			}
			
			return buffer;
		}

		/* LEVEL AND DETAIL (getter / setter ) */
		 
		/**
		 * Sets the log level.
		 * @param logLevel	Application default log level (default=5).
		 * 		<br/># 0=disable
		 * 		<br/># 1=fatal
		 * 		<br/># 2=fatal,error
		 * 		<br/># 3=fatal,error,debug
		 * 		<br/># 4=fatal,error,debug,warn
		 * 		<br/># 5=fatal,error,debug,warn,notice
		 * 		<br/># 6=fatal,error,debug,warn,notice,info
		 */
		public function set level( log_level : uint ) : void
		{
			_level = log_level;
		}

		/**
		 * Returns the log level.
		 */
		public function get level() : uint
		{
			return _level;
		}

		/**
		 * Sets the log detail.
		 * @param logDetail	Application default log detail (default=1).
		 * <br/># 0=Doesnt add any extra prefix besides the log level.
		 * <br/># 1=Adds the 'ClassName' prefix to all log calls.
		 * <br/># 2=Adds a 'packace.a.b.c..ClassName' prefix to all log calls.
		 */
		public function set detail( logDetail : uint ) : void
		{
			_detail = logDetail;
		}

		/**
		 * Returns the log detail.
		 */
		public function get detail() : uint
		{
			return _detail;
		}

		/* MAIN LOG ( template ) */
		
		/**
		 * Shows/log every kind of message, following a common template.
		 */
		public function log( ...params ) : void
		{
			var base : String;
			var tmpl1 : String;
			var tmpl2 : String;
			var msg : String;
			
			base = "[" + params[ 0 ] + "] ";
			tmpl1 = base + "{$class} ~: ";
			tmpl2 = base + "#$line {$class} => $method ~: ";
			
			msg = "";
			if ( detail == 1 )
				msg = tmpl1.replace( "$class", _target_class_name );
			else if ( detail > 1 )
			{
				msg = tmpl2.replace( "$method", _find_method_name );
				msg = msg.replace( "$line", _find_method_line );
				
				if( detail == 2 )
					msg = msg.replace( "$class", _target_class_name );
				else if( detail == 3 )
					msg = msg.replace( "$class", _target_class );
			}
			else
				msg += "~: ";
			
			trace( msg + params.slice( 1 ) );
		}

		/* FINDER UTILS */
		
		/**
		 * Gets the caller method name
		 */
		private function get _find_method_name() : String
		{
			var reg : RegExp;
			var name : String;
			
			reg = /[$a-zA-Z_]+\(/g;
			
			try
			{
				this[ getTimer( ) ].length;
			}
			catch( e : Error )
			{
				name = e.getStackTrace( ).match( reg )[ 3 ].match( reg );
				return name.substr( 0, -1 );
			}
			
			return "";
		}

		/**
		 * Gets the caller method line
		 */
		private function get _find_method_line() : String
		{
			var reg1 : RegExp;
			var reg2 : RegExp;
			var line : String;
			
			reg1 = /\.as\:([0-9]+)\]/g;
			reg2 = /[0-9]+/g;
			
			try
			{
				this[ getTimer( ) ].length;
			}
			catch( e : Error )
			{
				line = e.getStackTrace( ).match( reg1 )[ 3 ].match( reg2 );
				line += " " + ( ".....".substr( 0, ( 5 - line.length ) ) );
				return line; 
			}
			
			return "";
		}

		/* LOG METHODS */
		
		/**
		 * Show/log info's messages.
		 * @param params	FATAL message to be logged.
		 */
		public final function fatal( ...params ) : Logger
		{
			if ( _level > 0 )
			{
				log( "FATAL", params );
				throw new Error( "Check the errors described above." );
			}
			
			return this;
		}

		/**
		 * Show/log info's messages.
		 * @param params	ERROR message to be logged.
		 */
		public final function error( ...params ) : Logger
		{
			if ( _level > 1 )
				log( "ERROR", params );
			
			return this;
		}

		/**
		 * Show/log debugs's messages.
		 * @param params	DEBUG message to be logged.
		 */
		public final function debug( ...params ) : Logger
		{
			if ( _level > 2 )
				log( "DEBUG", params );
			
			return this;
		}

		/**
		 * Show/log info's messages.
		 * @param params	WARN message to be logged.
		 */
		public final function warn( ...params ) : Logger
		{
			if ( _level > 3 )
			{
				log( "WARN", params );
			}
			
			return this;
		}

		/**
		 * Show/log notice's messages.
		 * @param params	NOTICE message to be logged.
		 */
		public final function notice( ...params ) : Logger
		{
			if ( _level > 4 )
				log( "NOTICE", params );
			
			return this;
		}

		/**
		 * Show/log info's messages.
		 * @param params	INFO message to be logged.
		 */
		public final function info( ...params ) : Logger
		{
			if ( _level > 5 )
				log( "INFO", params );
			
			return this;
		}
	}
}
