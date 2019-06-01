package necurl;

import necurl.Necurl;

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