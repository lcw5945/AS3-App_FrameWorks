package com.starway.framework.utils
{
	public class URLUtil
	{	
		/**
		 *  @private 
		 */
		private static const SQUARE_BRACKET_LEFT:String = "]";
		private static const SQUARE_BRACKET_RIGHT:String = "[";
		private static const SQUARE_BRACKET_LEFT_ENCODED:String = encodeURIComponent(SQUARE_BRACKET_LEFT);
		private static const SQUARE_BRACKET_RIGHT_ENCODED:String = encodeURIComponent(SQUARE_BRACKET_RIGHT);
		
		/**
		 *  @private
		 */
		public function URLUtil()
		{
			super();
		}
		
		public static function getServerNameWithPort(url:String):String
		{
			// Find first slash; second is +1, start 1 after.
			var start:int = url.indexOf("/") + 2;
			var length:int = url.indexOf("/", start);
			return length == -1 ? url.substring(start) : url.substring(start, length);
		}	

		public static function getServerName(url:String):String
		{
			var sp:String = getServerNameWithPort(url);
			
			// If IPv6 is in use, start looking after the square bracket.
			var delim:int = URLUtil.indexOfLeftSquareBracket(sp);
			delim = (delim > -1)? sp.indexOf(":", delim) : sp.indexOf(":");   
			
			if (delim > 0)
				sp = sp.substring(0, delim);
			return sp;
		}

		public static function getPort(url:String):uint
		{
			var sp:String = getServerNameWithPort(url);
			// If IPv6 is in use, start looking after the square bracket.
			var delim:int = URLUtil.indexOfLeftSquareBracket(sp);
			delim = (delim > -1)? sp.indexOf(":", delim) : sp.indexOf(":");          
			var port:uint = 0;
			if (delim > 0)
			{
				var p:Number = Number(sp.substring(delim + 1));
				if (!isNaN(p))
					port = int(p);
			}
			
			return port;
		}

		public static function getFullURL(rootURL:String, url:String):String
		{
			if (url != null && !URLUtil.isHttpURL(url))
			{
				if (url.indexOf("./") == 0)
				{
					url = url.substring(2);
				}
				if (URLUtil.isHttpURL(rootURL))
				{
					var slashPos:Number;
					
					if (url.charAt(0) == '/')
					{
						// non-relative path, "/dev/foo.bar".
						slashPos = rootURL.indexOf("/", 8);
						if (slashPos == -1)
							slashPos = rootURL.length;
					}
					else
					{
						// relative path, "dev/foo.bar".
						slashPos = rootURL.lastIndexOf("/") + 1;
						if (slashPos <= 8)
						{
							rootURL += "/";
							slashPos = rootURL.length;
						}
					}
					
					if (slashPos > 0)
						url = rootURL.substring(0, slashPos) + url;
				}
			}
			
			return url;
		}
		
		/**
		 * 解析url中的url参数
		 *  
		 * @param url
		 * @return 
		 */		
		public static function parseURLParams(url:String):Object {
			var p:Object = null;
			if (!url) return p;
			
			p = {};
			
			var split:Array = url.split("?");
			if (split.length > 1) {
				//取问号后面
				var paramStr:String = split[1];
				if (paramStr) {
					//按&分隔
					var params:Array = paramStr.split("&");
					for each (var pair:String in params) {
						//按=分隔
						var pairSplit:Array = pair.split("=");
						//如果分隔成功,就可以当成key=value来解析了
						if (pairSplit.length > 1) {
							p[pairSplit[0]] = pairSplit[1];
						}
					}
				}
			}
			
			return p;
		}
		

		public static function isHttpURL(url:String):Boolean
		{
			return url != null &&
				(url.indexOf("http://") == 0 ||
					url.indexOf("https://") == 0);
		}
		

		public static function isHttpsURL(url:String):Boolean
		{
			return url != null && url.indexOf("https://") == 0;
		}
		

		public static function getProtocol(url:String):String
		{
			var slash:int = url.indexOf("/");
			var indx:int = url.indexOf(":/");
			if (indx > -1 && indx < slash)
			{
				return url.substring(0, indx);
			}
			else
			{
				indx = url.indexOf("::");
				if (indx > -1 && indx < slash)
					return url.substring(0, indx);
			}
			
			return "";
		}
		

		public static function replaceProtocol(uri:String,
											   newProtocol:String):String
		{
			return uri.replace(getProtocol(uri), newProtocol);
		}
		

		public static function replacePort(uri:String, newPort:uint):String
		{
			var result:String = "";
			
			// First, determine if IPv6 is in use by looking for square bracket
			var indx:int = uri.indexOf("]");
			
			// If IPv6 is not in use, reset indx to the first colon
			if (indx == -1)
				indx = uri.indexOf(":");
			
			var portStart:int = uri.indexOf(":", indx+1);
			var portEnd:int;
			
			// If we have a port
			if (portStart > -1)
			{
				portStart++; // move past the ":"
				portEnd = uri.indexOf("/", portStart);
				//@TODO: need to throw an invalid uri here if no slash was found
				result = uri.substring(0, portStart) +
					newPort.toString() +
					uri.substring(portEnd, uri.length);
			}
			else
			{
				// Insert the specified port
				portEnd = uri.indexOf("/", indx);
				if (portEnd > -1)
				{
					// Look to see if we have protocol://host:port/
					// if not then we must have protocol:/relative-path
					if (uri.charAt(portEnd+1) == "/")
						portEnd = uri.indexOf("/", portEnd + 2);
					
					if (portEnd > 0)
					{
						result = uri.substring(0, portEnd) +
							":"+ newPort.toString() +
							uri.substring(portEnd, uri.length);
					}
					else
					{
						result = uri + ":" + newPort.toString();
					}
				}
				else
				{
					result = uri + ":"+ newPort.toString();
				}
			}
			
			return result;
		}
		


		public static const SERVER_NAME_TOKEN:String = "{server.name}";
		

		public static const SERVER_PORT_TOKEN:String = "{server.port}";
		

		public static function objectToString(object:Object, separator:String=';',
											  encodeURL:Boolean = true):String
		{
			var s:String = internalObjectToString(object, separator, null, encodeURL);
			return s;
		}
		
		private static function indexOfLeftSquareBracket(value:String):int
		{
			var delim:int = value.indexOf(SQUARE_BRACKET_LEFT);
			if (delim == -1)
				delim = value.indexOf(SQUARE_BRACKET_LEFT_ENCODED);
			return delim;
		}
		
		private static function internalObjectToString(object:Object, separator:String, prefix:String, encodeURL:Boolean):String
		{
			var s:String = "";
			var first:Boolean = true;
			
			for (var p:String in object)
			{
				if (first)
				{
					first = false;
				}
				else
					s += separator;
				
				var value:Object = object[p];
				var name:String = prefix ? prefix + "." + p : p;
				if (encodeURL)
					name = encodeURIComponent(name);
				
				if (value is String)
				{
					s += name + '=' + (encodeURL ? encodeURIComponent(value as String) : value);
				}
				else if (value is Number)
				{
					value = value.toString();
					if (encodeURL)
						value = encodeURIComponent(value as String);
					
					s += name + '=' + value;
				}
				else if (value is Boolean)
				{
					s += name + '=' + (value ? "true" : "false");
				}
				else
				{
					if (value is Array)
					{
						s += internalArrayToString(value as Array, separator, name, encodeURL);
					}
					else // object
					{
						s += internalObjectToString(value, separator, name, encodeURL);
					}
				}
			}
			return s;
		}
		
		private static function replaceEncodedSquareBrackets(value:String):String
		{
			var rightIndex:int = value.indexOf(SQUARE_BRACKET_RIGHT_ENCODED);
			if (rightIndex > -1)
			{
				value = value.replace(SQUARE_BRACKET_RIGHT_ENCODED, SQUARE_BRACKET_RIGHT);
				var leftIndex:int = value.indexOf(SQUARE_BRACKET_LEFT_ENCODED);
				if (leftIndex > -1)
					value = value.replace(SQUARE_BRACKET_LEFT_ENCODED, SQUARE_BRACKET_LEFT);
			}
			return value;
		}
		
		private static function internalArrayToString(array:Array, separator:String, prefix:String, encodeURL:Boolean):String
		{
			var s:String = "";
			var first:Boolean = true;
			
			var n:int = array.length;
			for (var i:int = 0; i < n; i++)
			{
				if (first)
				{
					first = false;
				}
				else
					s += separator;
				
				var value:Object = array[i];
				var name:String = prefix + "." + i;
				if (encodeURL)
					name = encodeURIComponent(name);
				
				if (value is String)
				{
					s += name + '=' + (encodeURL ? encodeURIComponent(value as String) : value);
				}
				else if (value is Number)
				{
					value = value.toString();
					if (encodeURL)
						value = encodeURIComponent(value as String);
					
					s += name + '=' + value;
				}
				else if (value is Boolean)
				{
					s += name + '=' + (value ? "true" : "false");
				}
				else
				{
					if (value is Array)
					{
						s += internalArrayToString(value as Array, separator, name, encodeURL);
					}
					else // object
					{
						s += internalObjectToString(value, separator, name, encodeURL);
					}
				}
			}
			return s;
		}
		
		
		public static function stringToObject(string:String, separator:String = ";",
											  decodeURL:Boolean = true):Object
		{
			var o:Object = {};
			
			var arr:Array = string.split(separator);
			
			// if someone has a name or value that contains the separator 
			// this will not work correctly, nor will it work well if there are 
			// '=' or '.' in the name or value
			
			var n:int = arr.length;
			for (var i:int = 0; i < n; i++)
			{
				var pieces:Array = arr[i].split('=');
				var name:String = pieces[0];
				if (decodeURL)
					name = decodeURIComponent(name);
				
				var value:Object = pieces[1];
				if (decodeURL)
					value = decodeURIComponent(value as String);
				
				if (value == "true")
					value = true;
				else if (value == "false")
					value = false;
				else 
				{
					var temp:Object = int(value);
					if (temp.toString() == value)
						value = temp;
					else
					{
						temp = Number(value)
						if (temp.toString() == value)
							value = temp;
					}
				}
				
				var obj:Object = o;
				
				pieces = name.split('.');
				var m:int = pieces.length;
				for (var j:int = 0; j < m - 1; j++)
				{
					var prop:String = pieces[j];
					if (obj[prop] == null && j < m - 1)
					{
						var subProp:String = pieces[j + 1];
						var idx:Object = int(subProp);
						if (idx.toString() == subProp)
							obj[prop] = [];
						else
							obj[prop] = {};
					}
					obj = obj[prop];
				}
				obj[pieces[j]] = value;
			}
			
			return o;
		}
	
		private static const SERVER_NAME_REGEX:RegExp = new RegExp("\\{server.name\\}", "g");
		private static const SERVER_PORT_REGEX:RegExp = new RegExp("\\{server.port\\}", "g");    
	}
	
}

