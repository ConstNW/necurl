package necurl;

import necurl.Necurl;


class NecurlShare
{
	// CURLSHoption
	public inline static var SHARE = 1;
	public inline static var UNSHARE = 1;
	
	var h : Dynamic;
	
	public function new( )
	{
		h = null;
		
		var ex = 'initializing curl_share failed';
		try init() catch ( e : Dynamic )
		{
			ex += ' [$e]';
		}
		
		if ( h == null )
			throw ex;
	}
	
	function init( ) : Void
	{
		h = necurl_share_init();
	}
	
	public function setopt( value : Int, unshare = false ) : Void
	{
		necurl_share_setopt(h, (unshare ? UNSHARE : SHARE), Lib.haxeToNeko(value));
	}
	
	public function close( ) : Void
	{
		necurl_share_delete(h);
	}
	
	public function add( n : Necurl ) : Void
	{
		necurl_setopt(n.handler(), CurlOpt.SHARE, h);
	}
	
	private static var necurl_share_init = Lib.load("necurl", "necurl_share_init", 0);
	private static var necurl_share_setopt = Lib.load("necurl", "necurl_share_setopt", 3);
	private static var necurl_share_delete = Lib.load("necurl", "necurl_share_delete", 1);
	
	private static var necurl_setopt = Lib.load("necurl", "necurl_setopt", 3);
}