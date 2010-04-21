package cocktail.core.bind 
{
	import cocktail.utils.ArrayUtil;																														

	/**
	 * Simple bind class.
	 * @author nybras | nybras@codeine.it
	 */
	public class Bind 
	{
		/* VARS */
		private var _binded : Array;

		private var _touched : Array;

		private var _data : Object;

		private var _length : uint;

		private var _all : Boolean;

		/* INITIALIZING */
		
		/**
		 * Creates a new Bind instance.
		 */
		public function Bind()
		{
			_binded = new Array( );
			_touched = new Array( );
			_data = new Object( );
			_length = 0;
		}

		/* GETTER & SETTER */
		
		/**
		 * Set the key value.
		 * @param key	Key to be setted.
		 * @param value	Value to the given key.
		 */
		public function s( key : String, value : * ) : void
		{
			if ( _data[ key ] == undefined )
				_length++;
			
			if ( _data[ key ] == value )
				return;
			
			_data[ key ] = value;
			update( key, value );
		}

		/**
		 * Get the key value.
		 * @param key	Key to get the value.
		 * @return	The key value.
		 */
		public function g( key : String ) : *
		{
			return _data[ key ];
		}

		/**
		 * Delete the key entry.
		 * @param key	Key to be deleted.
		 */
		public function d( key : String ) : void
		{
			if ( _data[ key ] != undefined )
			{
				_data[ key ] = null;
				delete _data[ key ];
				_length--;
			}
		}

		/* GETTER & SETTER */
		
		/**
		 * Updates some key and "ping" all plugged items.
		 * @param key	Updated key.
		 * @param value	Updated value.
		 */
		private function update( key : String, value : * ) : void
		{
			var binded : Binded;
			var touched : Touched;
			
			// binded
			for each ( binded in _binded )
				if ( binded.key == key || binded._all )
					binded.update( value );
			
			// touched
			for each ( touched in _touched )
				if ( touched.key == key || touched._all )
					touched.update( );
		}

		/* PLUG / UNPLUG & TOUCH / UNTOUCH */
		
		/**
		 * Plug some key.
		 * @param key	Key to be plugged.
		 * @param change		The listener method or the setter's scope.
		 * @param setter	If informed, the <code>change</code> param is
		 * handled as a scope, otherwise its handled as a method.
		 */
		public function plug(
			key : String,
			change : *,
			setter : String = null
		) : Binded
		{
			var item : Binded;
			
			unplug( key, change, setter );
			_binded.push( item = new Binded( key, change, setter ) );
			
			if ( _data[ key ] != undefined )
				item.update( _data[ key ] );
			
			return item;
		}

		/**
		 * Unplug some key.
		 * @param key	Key to be unplugged.
		 * @param change		The listener method or the setter's scope.
		 * @param setter	If informed, the <code>change</code> param is
		 * handled as a scope, otherwise its handled as a method.
		 * @return	<code>true</code> if the key is unplugged successfully,
		 * <code>false</code> otherwise.
		 */
		public function unplug(
			key : String,
			change : *,
			setter : String = null
		) : Boolean
		{
			var item : Binded;
			
			for each ( item in _binded )
			{
				if (	item.key == key && item.change == change && item.setter == setter	)
				{
					ArrayUtil.del( _binded, item );
					return true;
				}
			}
			
			return false;
		}

		/**
		 * Touch some key.
		 * @param key	Key to be touched.	
		 * @param methods	Methods to be touched when the key value changes, it
		 * can be just a single method or an array with many methods.
		 */
		public function touch(
			key : String,
			methods : *
		) : void
		{
			var item : Touched;
			
			untouch( key, methods );
			_touched.push( item = new Touched( key, methods ) );
			
			if ( _data[ key ] != undefined )
				item.update( );
		}

		/**
		 * Untouch some key.
		 * @param key	Key to untouched.
		 * @param methods	Methods to be untouched, it can be just a single
		 * method or an array with many methods.
		 * @return	<code>true</code> if the key is untouched successfully,
		 * <code>false</code> otherwise.
		 */
		public function untouch(
			key : String,
			methods : *
		) : Boolean
		{
			var item : Touched;
			
			for each ( item in _touched )
			{
				if ( item.key != key || ( _all && !item._all ) )
					continue;
				
				if ( methods is Array && item.methods is Array )
				{
					if ( ArrayUtil.compare( methods, item.methods ) )
					{
						ArrayUtil.del( _touched, item );
						return true;
					}
				}
				else if ( methods is Function && item.methods is Function )
				{
					if ( methods == item.methods )
					{
						ArrayUtil.del( _touched, item );
						return true;
					}
				}
			}
			
			return false;
		}
		
		
		
		/* 	PLUG / UNPLUG & TOUCH / UNTOUCH - ALL */
		
//		IMPROVE THE IDEA AND THINK ABOUT THE IMPROVEMENTS BEFORE IMPLEMENT
//		
//		public function plug_all () : void
//		{
//			// ...
//		}
//		
//		public function touch_all ( methods : * ) : void
//		{
//			var item : Touched;
//			
//			untouch_all ( methods );
//			
//			item = new Touched( "none", methods );
//			item._all = true;
//			
//			_touched.push( item );
//			
//			if ( _length > 0 )
//				item.update();
//		}
//		
//		
//		
//		public function unplug_all () : void
//		{
//			// ...
//		}
//		
//		public function untouch_all ( methods : Array ) : void
//		{
//			_all = true;
//			untouch ( "none", methods );
//			_all = false;
//		}
	}
}