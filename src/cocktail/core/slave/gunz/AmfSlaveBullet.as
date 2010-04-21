package cocktail.core.slave.gunz 
{

	/**
	 * @author nybras | me@nybras.com
	 */
	public class AmfSlaveBullet extends ASlaveBullet 
	{
		/* BULLET PROPERTIES */
		public var result : ResultVO;

		public var fault : FaultVO;

		public function AmfSlaveBullet( result : * = null, fault : * = null )
		{
			super( undefined, undefined );
			
			if( result )
				this.result = new ResultVO( result );
			else
				this.fault = new FaultVO( fault );
		}
	}
}

class ResultVO
{
	private var _raw : *;

	public function ResultVO( raw : *  ) 
	{
		_raw = raw;
	}

	public function get data() : *
	{
		// TODO: Parse and return the raw data.
		return _raw;
	}
	
	// TODO: Implement everything else.
}

class FaultVO
{
	private var _raw : *;

	public function FaultVO( raw : *  ) 
	{
		_raw = raw;
	}

	public function get info() : *
	{
		// TODO: Parse and return the raw info.
		return _raw;
	}

	public function get code() : *
	{
		// TODO: Parse and return the raw error code.
		return _raw;
	}

	public function get message() : *
	{
		// TODO: Parse and return the raw error message.
		return _raw;
	}
	
	// TODO: Implement everything else.
}