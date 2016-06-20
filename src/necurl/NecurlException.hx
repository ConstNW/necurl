/**
 * ...
 * @author Const
 */
package necurl;


class NecurlException
{
	public var msg : String;

	public function new( msg : String )
	{
		this.msg = msg;
	}
	
	public function toString( ) : String
	{
		var clsName = Type.getClassName(Type.getClass(this));
		return 'Exception [$clsName]: $msg';
	}	
}

class NecurlExecException extends NecurlException
{
	
}