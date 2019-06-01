/**
 * ...
 * @author Const
 */
import necurl.*;


class Main
{
	function new( )
	{
		
	}
	
	function run( ) : Void
	{
		//var n = new Necurl()
		var s = NecurlCase.get('http://google.com');
		trace(s);
	}
	
	static function main() new Main().run();
}