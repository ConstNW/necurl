/**
 * ...
 * @author Const
 */
package necurl;

import haxe.ds.StringMap;
import necurl.NecurlException.NecurlExecException;
import neko.Lib;
import neko.NativeString;

class CurlAuth
{
	public static inline var NONE      =      0;
	public static inline var BASIC     = 1 << 0;
	public static inline var DIGEST    = 1 << 1;
	public static inline var NEGOTIATE = 1 << 1;
}

class CurlLock
{
	public static inline var CURL_LOCK_DATA_SHARE       = 1;
	public static inline var CURL_LOCK_DATA_COOKIE      = 2;
	public static inline var CURL_LOCK_DATA_DNS         = 3;
	public static inline var CURL_LOCK_DATA_SSL_SESSION = 4;
	public static inline var CURL_LOCK_DATA_CONNECT     = 5;
}

class CurlInfo
{
	public static inline var CURLINFO_STRING = 0x100000;
	public static inline var CURLINFO_LONG   = 0x200000;
	public static inline var CURLINFO_DOUBLE = 0x300000;
	public static inline var CURLINFO_SLIST  = 0x400000;
	
	public static inline var EFFECTIVE_URL = CURLINFO_STRING + 1;
	public static inline var RESPONSE_CODE = CURLINFO_LONG   + 2;
	public static inline var TOTAL_TIME = CURLINFO_DOUBLE + 3;
	public static inline var NAMELOOKUP_TIME = CURLINFO_DOUBLE + 4;
	public static inline var CONNECT_TIME = CURLINFO_DOUBLE + 5;
	public static inline var PRETRANSFER_TIME = CURLINFO_DOUBLE + 6;
	public static inline var SIZE_UPLOAD = CURLINFO_DOUBLE + 7;
	public static inline var SIZE_DOWNLOAD = CURLINFO_DOUBLE + 8;
	public static inline var SPEED_DOWNLOAD = CURLINFO_DOUBLE + 9;
	public static inline var SPEED_UPLOAD = CURLINFO_DOUBLE + 10;
	public static inline var HEADER_SIZE = CURLINFO_LONG   + 11;
	public static inline var REQUEST_SIZE = CURLINFO_LONG   + 12;
	public static inline var SSL_VERIFYRESULT = CURLINFO_LONG   + 13;
	public static inline var FILETIME = CURLINFO_LONG   + 14;
	public static inline var CONTENT_LENGTH_DOWNLOAD = CURLINFO_DOUBLE + 15;
	public static inline var CONTENT_LENGTH_UPLOAD = CURLINFO_DOUBLE + 16;
	public static inline var STARTTRANSFER_TIME = CURLINFO_DOUBLE + 17;
	public static inline var CONTENT_TYPE = CURLINFO_STRING + 18;
	public static inline var REDIRECT_TIME = CURLINFO_DOUBLE + 19;
	public static inline var REDIRECT_COUNT = CURLINFO_LONG   + 20;
	public static inline var PRIVATE = CURLINFO_STRING + 21;
	public static inline var HTTP_CONNECTCODE = CURLINFO_LONG   + 22;
	public static inline var HTTPAUTH_AVAIL = CURLINFO_LONG   + 23;
	public static inline var PROXYAUTH_AVAIL = CURLINFO_LONG   + 24;
	public static inline var OS_ERRNO = CURLINFO_LONG   + 25;
	public static inline var NUM_CONNECTS = CURLINFO_LONG   + 26;
	public static inline var SSL_ENGINES = CURLINFO_SLIST  + 27;
	public static inline var COOKIELIST = CURLINFO_SLIST  + 28;
	public static inline var LASTSOCKET = CURLINFO_LONG   + 29;
	public static inline var FTP_ENTRY_PATH = CURLINFO_STRING + 30;
	public static inline var REDIRECT_URL = CURLINFO_STRING + 31;
	public static inline var PRIMARY_IP = CURLINFO_STRING + 32;
	public static inline var APPCONNECT_TIME = CURLINFO_DOUBLE + 33;
	public static inline var CERTINFO = CURLINFO_SLIST  + 34;
	public static inline var CONDITION_UNMET = CURLINFO_LONG   + 35;
	public static inline var RTSP_SESSION_ID = CURLINFO_STRING + 36;
	public static inline var RTSP_CLIENT_CSEQ = CURLINFO_LONG   + 37;
	public static inline var RTSP_SERVER_CSEQ = CURLINFO_LONG   + 38;
	public static inline var RTSP_CSEQ_RECV = CURLINFO_LONG   + 39;
	public static inline var PRIMARY_PORT = CURLINFO_LONG   + 40;
	public static inline var LOCAL_IP = CURLINFO_STRING + 41;
	public static inline var LOCAL_PORT = CURLINFO_LONG   + 42;
	public static inline var TLS_SESSION = CURLINFO_SLIST  + 43;
}

class CurlOpt
{
	private static inline var TYPE_LONG = 0;
	private static inline var TYPE_OBJECTPOINT = 10000;
	
	public static inline var WRITEDATA = TYPE_OBJECTPOINT + 1;
	public static inline var URL = TYPE_OBJECTPOINT + 2;
	public static inline var PORT = TYPE_LONG + 3;
	public static inline var PROXY = TYPE_OBJECTPOINT + 4;
	public static inline var USERPWD = TYPE_OBJECTPOINT + 5;
	public static inline var PROXYUSERPWD = TYPE_OBJECTPOINT + 6;
	public static inline var RANGE = TYPE_OBJECTPOINT + 7;
	public static inline var READDATA = TYPE_OBJECTPOINT + 9;
	public static inline var ERRORBUFFER = TYPE_OBJECTPOINT + 10;
	public static inline var TIMEOUT = TYPE_LONG + 13;
	public static inline var INFILESIZE = TYPE_LONG + 14;
	public static inline var POSTFIELDS = TYPE_OBJECTPOINT + 15;
	public static inline var REFERER = TYPE_OBJECTPOINT + 16;
	public static inline var FTPPORT = TYPE_OBJECTPOINT + 17;
	public static inline var USERAGENT = TYPE_OBJECTPOINT + 18;
	public static inline var LOW_SPEED_LIMIT = TYPE_LONG + 19;
	public static inline var LOW_SPEED_TIME = TYPE_LONG + 20;
	public static inline var RESUME_FROM = TYPE_LONG + 21;
	public static inline var COOKIE = TYPE_OBJECTPOINT + 22;
	public static inline var HTTPHEADER = TYPE_OBJECTPOINT + 23;
	public static inline var HTTPPOST = TYPE_OBJECTPOINT + 24;
	public static inline var SSLCERT = TYPE_OBJECTPOINT + 25;
	public static inline var KEYPASSWD = TYPE_OBJECTPOINT + 26;
	public static inline var CRLF = TYPE_LONG + 27;
	public static inline var QUOTE = TYPE_OBJECTPOINT + 28;
	public static inline var HEADERDATA = TYPE_OBJECTPOINT + 29;
	public static inline var COOKIEFILE = TYPE_OBJECTPOINT + 31;
	public static inline var SSLVERSION = TYPE_LONG + 32;
	public static inline var TIMECONDITION = TYPE_LONG + 33;
	public static inline var TIMEVALUE = TYPE_LONG + 34;
	public static inline var CUSTOMREQUEST = TYPE_OBJECTPOINT + 36;
	public static inline var STDERR = TYPE_OBJECTPOINT + 37;
	public static inline var POSTQUOTE = TYPE_OBJECTPOINT + 39;
	public static inline var OBSOLETE40 = TYPE_OBJECTPOINT + 40;
	public static inline var VERBOSE = TYPE_LONG + 41;
	public static inline var HEADER = TYPE_LONG + 42;
	public static inline var NOPROGRESS = TYPE_LONG + 43;
	public static inline var NOBODY = TYPE_LONG + 44;
	public static inline var FAILONERROR = TYPE_LONG + 45;
	public static inline var UPLOAD = TYPE_LONG + 46;
	public static inline var POST = TYPE_LONG + 47;
	public static inline var DIRLISTONLY = TYPE_LONG + 48;
	public static inline var APPEND = TYPE_LONG + 50;
	public static inline var NETRC = TYPE_LONG + 51;
	public static inline var FOLLOWLOCATION = TYPE_LONG + 52;
	public static inline var TRANSFERTEXT = TYPE_LONG + 53;
	public static inline var PUT = TYPE_LONG + 54;
	public static inline var PROGRESSDATA = TYPE_OBJECTPOINT + 57;
	public static inline var AUTOREFERER = TYPE_LONG + 58;
	public static inline var PROXYPORT = TYPE_LONG + 59;
	public static inline var POSTFIELDSIZE = TYPE_LONG + 60;
	public static inline var HTTPPROXYTUNNEL = TYPE_LONG + 61;
	public static inline var INTERFACE = TYPE_OBJECTPOINT + 62;
	public static inline var KRBLEVEL = TYPE_OBJECTPOINT + 63;
	public static inline var SSL_VERIFYPEER = TYPE_LONG + 64;
	public static inline var CAINFO = TYPE_OBJECTPOINT + 65;
	public static inline var MAXREDIRS = TYPE_LONG + 68;
	public static inline var FILETIME = TYPE_LONG + 69;
	public static inline var TELNETOPTIONS = TYPE_OBJECTPOINT + 70;
	public static inline var MAXCONNECTS = TYPE_LONG + 71;
	public static inline var OBSOLETE72 = TYPE_LONG + 72;
	public static inline var FRESH_CONNECT = TYPE_LONG + 74;
	public static inline var FORBID_REUSE = TYPE_LONG + 75;
	public static inline var RANDOM_FILE = TYPE_OBJECTPOINT + 76;
	public static inline var EGDSOCKET = TYPE_OBJECTPOINT + 77;
	public static inline var CONNECTTIMEOUT = TYPE_LONG + 78;
	public static inline var HTTPGET = TYPE_LONG + 80;
	public static inline var SSL_VERIFYHOST = TYPE_LONG + 81;
	public static inline var COOKIEJAR = TYPE_OBJECTPOINT + 82;
	public static inline var SSL_CIPHER_LIST = TYPE_OBJECTPOINT + 83;
	public static inline var HTTP_VERSION = TYPE_LONG + 84;
	public static inline var FTP_USE_EPSV = TYPE_LONG + 85;
	public static inline var SSLCERTTYPE = TYPE_OBJECTPOINT + 86;
	public static inline var SSLKEY = TYPE_OBJECTPOINT + 87;
	public static inline var SSLKEYTYPE = TYPE_OBJECTPOINT + 88;
	public static inline var SSLENGINE = TYPE_OBJECTPOINT + 89;
	public static inline var SSLENGINE_DEFAULT = TYPE_LONG + 90;
	public static inline var DNS_USE_GLOBAL_CACHE = TYPE_LONG + 91;
	public static inline var DNS_CACHE_TIMEOUT = TYPE_LONG + 92;
	public static inline var PREQUOTE = TYPE_OBJECTPOINT + 93;
	public static inline var DEBUGDATA = TYPE_OBJECTPOINT + 95;
	public static inline var COOKIESESSION = TYPE_LONG + 96;
	public static inline var CAPATH = TYPE_OBJECTPOINT + 97;
	public static inline var BUFFERSIZE = TYPE_LONG + 98;
	public static inline var NOSIGNAL = TYPE_LONG + 99;
	public static inline var SHARE = TYPE_OBJECTPOINT + 100;
	public static inline var PROXYTYPE = TYPE_LONG + 101;
	public static inline var ACCEPT_ENCODING = TYPE_OBJECTPOINT + 102;
	public static inline var PRIVATE = TYPE_OBJECTPOINT + 103;
	public static inline var HTTP200ALIASES = TYPE_OBJECTPOINT + 104;
	public static inline var UNRESTRICTED_AUTH = TYPE_LONG + 105;
	public static inline var FTP_USE_EPRT = TYPE_LONG + 106;
	public static inline var HTTPAUTH = TYPE_LONG + 107;
	public static inline var SSL_CTX_DATA = TYPE_OBJECTPOINT + 109;
	public static inline var FTP_CREATE_MISSING_DIRS = TYPE_LONG + 110;
	public static inline var PROXYAUTH = TYPE_LONG + 111;
	public static inline var FTP_RESPONSE_TIMEOUT = TYPE_LONG + 112;
	public static inline var IPRESOLVE = TYPE_LONG + 113;
	public static inline var MAXFILESIZE = TYPE_LONG + 114;
	public static inline var NETRC_FILE = TYPE_OBJECTPOINT + 118;
	public static inline var USE_SSL = TYPE_LONG + 119;
	public static inline var TCP_NODELAY = TYPE_LONG + 121;
	public static inline var FTPSSLAUTH = TYPE_LONG + 129;
	public static inline var IOCTLDATA = TYPE_OBJECTPOINT + 131;
	public static inline var FTP_ACCOUNT = TYPE_OBJECTPOINT + 134;
	public static inline var COOKIELIST = TYPE_OBJECTPOINT + 135;
	public static inline var IGNORE_CONTENT_LENGTH = TYPE_LONG + 136;
	public static inline var FTP_SKIP_PASV_IP = TYPE_LONG + 137;
	public static inline var FTP_FILEMETHOD = TYPE_LONG + 138;
	public static inline var LOCALPORT = TYPE_LONG + 139;
	public static inline var LOCALPORTRANGE = TYPE_LONG + 140;
	public static inline var CONNECT_ONLY = TYPE_LONG + 141;
	public static inline var FTP_ALTERNATIVE_TO_USER = TYPE_OBJECTPOINT + 147;
	public static inline var SOCKOPTDATA = TYPE_OBJECTPOINT + 149;
	public static inline var SSL_SESSIONID_CACHE = TYPE_LONG + 150;
	public static inline var SSH_AUTH_TYPES = TYPE_LONG + 151;
	public static inline var SSH_PUBLIC_KEYFILE = TYPE_OBJECTPOINT + 152;
	public static inline var SSH_PRIVATE_KEYFILE = TYPE_OBJECTPOINT + 153;
	public static inline var FTP_SSL_CCC = TYPE_LONG + 154;
	public static inline var TIMEOUT_MS = TYPE_LONG + 155;
	public static inline var CONNECTTIMEOUT_MS = TYPE_LONG + 156;
	public static inline var HTTP_TRANSFER_DECODING = TYPE_LONG + 157;
	public static inline var HTTP_CONTENT_DECODING = TYPE_LONG + 158;
	public static inline var NEW_FILE_PERMS = TYPE_LONG + 159;
	public static inline var NEW_DIRECTORY_PERMS = TYPE_LONG + 160;
	public static inline var POSTREDIR = TYPE_LONG + 161;
	public static inline var SSH_HOST_PUBLIC_KEY_MD5 = TYPE_OBJECTPOINT + 162;
	public static inline var OPENSOCKETDATA = TYPE_OBJECTPOINT + 164;
	public static inline var COPYPOSTFIELDS = TYPE_OBJECTPOINT + 165;
	public static inline var PROXY_TRANSFER_MODE = TYPE_LONG + 166;
	public static inline var SEEKDATA = TYPE_OBJECTPOINT + 168;
	public static inline var CRLFILE = TYPE_OBJECTPOINT + 169;
	public static inline var ISSUERCERT = TYPE_OBJECTPOINT + 170;
	public static inline var ADDRESS_SCOPE = TYPE_LONG + 171;
	public static inline var CERTINFO = TYPE_LONG + 172;
	public static inline var USERNAME = TYPE_OBJECTPOINT + 173;
	public static inline var PASSWORD = TYPE_OBJECTPOINT + 174;
	public static inline var PROXYUSERNAME = TYPE_OBJECTPOINT + 175;
	public static inline var PROXYPASSWORD = TYPE_OBJECTPOINT + 176;
	public static inline var NOPROXY = TYPE_OBJECTPOINT + 177;
	public static inline var TFTP_BLKSIZE = TYPE_LONG + 178;
	public static inline var SOCKS5_GSSAPI_SERVICE = TYPE_OBJECTPOINT + 179;
	public static inline var SOCKS5_GSSAPI_NEC = TYPE_LONG + 180;
	public static inline var PROTOCOLS = TYPE_LONG + 181;
	public static inline var REDIR_PROTOCOLS = TYPE_LONG + 182;
	public static inline var SSH_KNOWNHOSTS = TYPE_OBJECTPOINT + 183;
	public static inline var SSH_KEYDATA = TYPE_OBJECTPOINT + 185;
	public static inline var MAIL_FROM = TYPE_OBJECTPOINT + 186;
	public static inline var MAIL_RCPT = TYPE_OBJECTPOINT + 187;
	public static inline var FTP_USE_PRET = TYPE_LONG + 188;
	public static inline var RTSP_REQUEST = TYPE_LONG + 189;
	public static inline var RTSP_SESSION_ID = TYPE_OBJECTPOINT + 190;
	public static inline var RTSP_STREAM_URI = TYPE_OBJECTPOINT + 191;
	public static inline var RTSP_TRANSPORT = TYPE_OBJECTPOINT + 192;
	public static inline var RTSP_CLIENT_CSEQ = TYPE_LONG + 193;
	public static inline var RTSP_SERVER_CSEQ = TYPE_LONG + 194;
	public static inline var INTERLEAVEDATA = TYPE_OBJECTPOINT + 195;
	public static inline var WILDCARDMATCH = TYPE_LONG + 197;
	public static inline var CHUNK_DATA = TYPE_OBJECTPOINT + 201;
	public static inline var FNMATCH_DATA = TYPE_OBJECTPOINT + 202;
	public static inline var RESOLVE = TYPE_OBJECTPOINT + 203;
	public static inline var TLSAUTH_USERNAME = TYPE_OBJECTPOINT + 204;
	public static inline var TLSAUTH_PASSWORD = TYPE_OBJECTPOINT + 205;
	public static inline var TLSAUTH_TYPE = TYPE_OBJECTPOINT + 206;
	public static inline var TRANSFER_ENCODING = TYPE_LONG + 207;
	public static inline var CLOSESOCKETDATA = TYPE_OBJECTPOINT + 209;
	public static inline var GSSAPI_DELEGATION = TYPE_LONG + 210;
	public static inline var DNS_SERVERS = TYPE_OBJECTPOINT + 211;
	public static inline var ACCEPTTIMEOUT_MS = TYPE_LONG + 212;
	public static inline var TCP_KEEPALIVE = TYPE_LONG + 213;
	public static inline var TCP_KEEPIDLE = TYPE_LONG + 214;
	public static inline var TCP_KEEPINTVL = TYPE_LONG + 215;
	public static inline var SSL_OPTIONS = TYPE_LONG + 216;
	public static inline var MAIL_AUTH = TYPE_OBJECTPOINT + 217;
	public static inline var SASL_IR = TYPE_LONG + 218;
	public static inline var XOAUTH2_BEARER = TYPE_OBJECTPOINT + 220;
	public static inline var DNS_INTERFACE = TYPE_OBJECTPOINT + 221;
	public static inline var DNS_LOCAL_IP4 = TYPE_OBJECTPOINT + 222;
	public static inline var DNS_LOCAL_IP6 = TYPE_OBJECTPOINT + 223;
	public static inline var LOGIN_OPTIONS = TYPE_OBJECTPOINT + 224;
	public static inline var SSL_ENABLE_NPN = TYPE_LONG + 225;
	public static inline var SSL_ENABLE_ALPN = TYPE_LONG + 226;
	public static inline var EXPECT_100_TIMEOUT_MS = TYPE_LONG + 227;
	public static inline var PROXYHEADER = TYPE_OBJECTPOINT + 228;
	public static inline var HEADEROPT = TYPE_LONG + 229;
	public static inline var PINNEDPUBLICKEY = TYPE_OBJECTPOINT + 230;
}

class NecurlCase
{
	public static function request(method:String, url:String, ?data:Dynamic, ?headers:Array<String>) : String
	{
		var curl = new Necurl();
		
		if (data != null && method.toLowerCase() == "get")
		{
			url += url.indexOf("?") >= 0 ? "&" : "?" + Lambda.map(Reflect.fields(data), function(fieldName) { 
				var fieldValue = Reflect.field(data, fieldName);
				return StringTools.urlEncode(fieldName) + "=" + StringTools.urlEncode(fieldValue);
			}).join("&");
		}
		
		curl.setopt(CurlOpt.URL, url);
		
		//curl.setopt(CurlOpt.SSL_VERIFYPEER, false);
		
		curl.setopt(CurlOpt.SSL_VERIFYPEER, false);
		curl.setopt(CurlOpt.VERBOSE, false);
		curl.setopt(CurlOpt.NOPROGRESS, true);
		curl.setopt(CurlOpt.USERAGENT, 'Necurl');
		
		
		curl.setopt(CurlOpt.ACCEPT_ENCODING, 'gzip');
		
		if (data != null && method.toLowerCase() == "post")
		{
			curl.setopt(CurlOpt.POST, true);
			curl.setopt(CurlOpt.POSTFIELDS, data);
		}
		
		if (headers != null)
		{
			curl.setopt(CurlOpt.HTTPHEADER, headers);
		}
		
		#if debug
		curl.setopt(CurlOpt.PROXY, '192.168.1.2');
		curl.setopt(CurlOpt.PROXYPORT, 8888);
		#end
		
		var response = curl.exec();
		
		curl.close();
		
		return response;
	}
	
	public static function get(url:String, ?data:Dynamic, ?headers:Array<String>) : String
	{
		return request("get", url, data, headers);
	}
	
	public static function post(url:String, ?data:Dynamic, ?headers:Array<String>) : String
	{
		return request("post", url, data, headers);
	}
}

class Necurl
{
	public static var DEBUG_INFO = ['TEXT', 'HEADER_IN', 'HEADER_OUT', 'DATA_IN', 'DATA_OUT', 'SSL_DATA_IN', 'SSL_DATA_OUT', 'END'];
	
	var h : Dynamic;
	var buf : StringBuf;
	public var head : StringMap<String>;
	
	public function new( )
	{
		h = null;
		
		var ex = 'initializing curl failed';
		try init() catch ( e : Dynamic )
		{
			ex += ' [$e]';
		}
		
		if ( h == null )
			throw ex;
	}
	
	function init( ) : Void
	{
		h = hxcurl_init();
		
		/*
		hxcurl_set_cb_base(h, readCb, writeCb);
		hxcurl_set_cb_ext(h, headerCb, progressCb);
		hxcurl_set_cb_debug(h, debugCb);
		*/
		
		#if debug
		setopt(CurlOpt.VERBOSE, 1);
		setopt(CurlOpt.NOPROGRESS, 0);
		#end
		
		setopt(CurlOpt.USERAGENT, 'Necurl');
		setopt(CurlOpt.NOSIGNAL, 1);
	}
	
	public function exec( ) : String
	{
		if ( h == null ) throw new NecurlException('Not initialized');
		
		buf = new StringBuf();
		head = new StringMap();
		var s : String = null;
		
		try s = NativeString.toString(hxcurl_exec(h)) catch ( e : Dynamic )
		{
			throw new NecurlExecException(Std.string(e));
		}
		
		/*
		var code = hxcurl_exec(h);
		if ( code != 0 )
		{
			// error happen
		}
		*/
		return buf.length > 0 ? buf.toString() : s;
	}
	
	function readCb( max_len : Int ) : NativeString return NativeString.ofString(onUpload(max_len));
	function writeCb( ns : NativeString ) : Void onDownload(NativeString.toString(ns));
	function headerCb( ns : NativeString ) : Void onHeader(NativeString.toString(ns));
	function progressCb( down_total : Int, down_now : Int, up_total : Int, up_now : Int ) : Void onProgress(down_total, down_now, up_total, up_now);
	function debugCb( info : Int, ns : NativeString ) : Void onDebug(info, NativeString.toString(ns));
	
	public dynamic function onUpload( len : Int ) : String
	{
		/*
		i++;
		if ( i == 10 ) return '';
		return 'TEST';
		*/
		return '';
	}
	
	public dynamic function onHeader( s : String ) : Void
	{
		s = s.substr(0, s.length - 2); // \r\n?
		
		if ( s.length < 1 )
			return;
		
		var p = s.indexOf(':');
		if ( p < 0 )
		{
			//trace('Response status: [$s]');
			return;
		}
		
		var key = s.substr(0, p);
		var val = StringTools.ltrim(s.substr(p + 1));
		//trace('Exist: [$key] [$val]');
		head.set(key, val);
	}
	public dynamic function onDownload( s : String ) : Void
	{
		buf.add(s);
	}
	
	public dynamic function onProgress( down_total : Int, down_now : Int, up_total : Int, up_now : Int ) : Void
	{
		// trace([down_total, down_now, up_total, up_now]);
	}
	public dynamic function onDebug( info : Int, s : String ) : Void
	{
		// trace([DEBUG_INFO[info], s]);
	}
	
	
	public function close( ) : Void
	{
		if ( h == null ) return;
		hxcurl_close(h);
		h = null;
	}
	
	public function setheader( s : String ) : Void
	{
		if ( h == null ) throw new NecurlException('Not initialized');
		hxcurl_setheader(h, NativeString.ofString(s));
	}
	public function setopt( option : Int, value : Dynamic ) : Void
	{
		if ( h == null ) throw new NecurlException('Not initialized');
		var v = Lib.haxeToNeko(value);
		hxcurl_setopt(h, option, v);
	}
	public function getinfo<A>( info : Int ) : A
	{
		if ( h == null ) throw new NecurlException('Not initialized');
		
		return Lib.haxeToNeko(hxcurl_getinfo(h, info));
	}
	
	public function error( ) : String
	{
		if ( h == null ) throw new NecurlException('Not initialized');
		
		return Lib.nekoToHaxe(hxcurl_error(h));
	}
	
	public function escape( s : String ) : String
	{
		if ( h == null ) throw new NecurlException('Not initialized');
		
		return NativeString.toString(hxcurl_escape(h, NativeString.ofString(s)));
	}
	
	public function encodeParams( p : Dynamic ) : String
	{
		var fn = function( n : String ) : String {
			var v : String = Std.string(Reflect.field(p, n));
			return StringTools.urlEncode(n) + "=" + StringTools.urlEncode(v);
			//return escape(n) + "=" + escape(v);
		};
		
		return Lambda.map(Reflect.fields(p), fn).join("&");
	}
	
	public function escapeParams( p : Dynamic ) : String
	{
		var out = new List();
		for ( f in Reflect.fields(p) )
		{
			var v : String = Std.string(Reflect.field(p, f));
			out.add(escape(f) + "=" + escape(v));
		}
		return out.join("&");
		/*
		var fn = function( n : String ) : String {
			var v : String = Std.string(Reflect.field(p, n));
			return escape(n) + "=" + escape(v);
		};
		return Lambda.map(Reflect.fields(p), fn).join("&");
		*/
	}
	
	inline public function handler( ) return h;
	
	private static var hxcurl_init = Lib.load("curl", "hxcurl_init", 0);
	private static var hxcurl_close = Lib.load("curl", "hxcurl_close", 1);
	private static var hxcurl_setopt = Lib.load("curl", "hxcurl_setopt", 3);
	private static var hxcurl_exec = Lib.load("curl", "hxcurl_exec", 1);
	
	private static var hxcurl_setheader = Lib.load("curl", "hxcurl_setheader", 2);
	
	private static var hxcurl_error = Lib.load("curl", "hxcurl_error", 1);
	private static var hxcurl_escape = Lib.load("curl", "hxcurl_escape", 2);
	private static var hxcurl_getinfo = Lib.load("curl", "hxcurl_getinfo", 2);
	
	private static var hxcurl_set_cb_base = Lib.load("curl", "hxcurl_set_cb_base", 3);
	private static var hxcurl_set_cb_ext = Lib.load("curl", "hxcurl_set_cb_ext", 3);
	private static var hxcurl_set_cb_debug = Lib.load("curl", "hxcurl_set_cb_debug", 2);
}

// Share

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
		h = hxcurl_share_init();
	}
	
	public function setopt( value : Int, unshare = false ) : Void
	{
		hxcurl_share_setopt(h, (unshare ? UNSHARE : SHARE), Lib.haxeToNeko(value));
	}
	
	public function close( ) : Void
	{
		hxcurl_share_delete(h);
	}
	
	public function add( n : Necurl ) : Void
	{
		hxcurl_setopt(n.handler(), CurlOpt.SHARE, h);
	}
	
	private static var hxcurl_share_init = Lib.load("curl", "hxcurl_share_init", 0);
	private static var hxcurl_share_setopt = Lib.load("curl", "hxcurl_share_setopt", 3);
	private static var hxcurl_share_delete = Lib.load("curl", "hxcurl_share_delete", 1);
	
	private static var hxcurl_setopt = Lib.load("curl", "hxcurl_setopt", 3);
}