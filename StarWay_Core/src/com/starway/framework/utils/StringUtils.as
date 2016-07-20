package com.starway.framework.utils
{
	import flash.utils.ByteArray;
		
	/**
	 *  
	 * @author Cray
	 * 
	 */
	public class StringUtils
	{
		public function StringUtils()
		{
		}
		
		/**
		 * 转化字符串 
		 * @param bytes
		 * @return 
		 * 
		 */		
		public static function byteToHexStr(bytes:ByteArray):String
		{
			var str:String="";
			if(bytes)
			{
				for(var i:int;i<bytes.length;i++)
				{
					str+=bytes[i].toString("X2");
				}
			}
			return str;
		}
		
		/**
		 * 是否含有中文字符
		 * @param aStr
		 * @return
		 *
		 */
		public static function isHaveChina(value:String):Boolean
		{
			var result:Boolean = false;
			var reg:RegExp = /[\u4e00-\u9fa5]/g;
			var array:Array = value.split("");
			for each (var str:String in array)
			{
				if (reg.test(String(str)))
					result = true;
			}
			
			return result;
			
//			return escape(value).indexOf("%u") > 0 ; 
		}
		
		public static function getByteLength(value:String):Number
		{
			var len:int = 0;
			var val:Array = value.split("");
			for (var i:int = 0; i < val.length; i++) {
				if (val[i].search(/[^\x00-\xff]/ig) != -1) //全角 或者 大写字母
					len += 2;
				else if(val[i].search(/[A-Z]/g) != -1)
					len += 1.5;
				else if(val[i] == "@")
					len += 3;
				else
					len += 1;
			};
			return len;
		}
		
		public static function getSubByByte(value:String, byte:Number):String
		{
			var len:int = 0;
			var res:String = "";
			var val:Array = value.split("");
			for (var i:int = 0; i < val.length; i++) {
				if (val[i].search(/[^\x00-\xff]/ig) != -1) //全角 或者 大写字母
					len += 2;
				else if(val[i].search(/[A-Z]/g) != -1)
					len += 1.5;
				else if(val[i] == "@")
					len += 3;
				else
					len += 1;
				
				res += val[i];
				
				if(len >= byte){
					break;
				}

			};
			return res;
		}
		
		/**
		 * 去掉首位空格 
		 * @param str
		 * @return 
		 * 
		 */		
		public static function trim(str:String):String
		{
			if (str == null) return '';
			
			var startIndex:int = 0;
			while (isWhitespace(str.charAt(startIndex)))
				++startIndex;
			
			var endIndex:int = str.length - 1;
			while (isWhitespace(str.charAt(endIndex)))
				--endIndex;
			
			if (endIndex >= startIndex)
				return str.slice(startIndex, endIndex + 1);
			else
				return "";
		}
		
		/**
		 * 验证字符串是否可用.一般用于判断时检验字符串是否合法.
		 *  
		 * @param s
		 * @return 
		 */		
		public static function isEmpty(s:String):Boolean {
			return s == null || deletSpace(s) == "";
		}
		
		/**
		 * 去除字符串空格
		 *  
		 * @param s
		 * @return 
		 */		
		public static function deletSpace(s:String):String {
			return s.replace(/([ ]{1})/g, "");
		}
		

		/**
		 * 是否含有空格 ，换行，回车等特殊字符 
		 * @param character
		 * @return 
		 * 
		 */		
		public static function isWhitespace(character:String):Boolean
		{
			switch (character)
			{
				case " ":
				case "\t":
				case "\r":
				case "\n":
				case "\f":
					return true;
					
				default:
					return false;
			}
		}
		
		/**
		 * 字符重复增加
		 * @param str
		 * @param n
		 * @return 
		 * 
		 */		
		public static function repeat(str:String, n:int):String
		{
			if (n == 0)
				return "";
			
			var s:String = str;
			for (var i:int = 1; i < n; i++)
			{
				s += str;
			}
			return s;
		}
		
		/**
		 * 删除不被允许的字符
		 *  restrict --> 0-9A-Z
		 * @param str
		 * @param restrict
		 * @return 
		 * 
		 */		
		public static function restrict(str:String, restrict:String):String
		{

			if (restrict == null)
				return str;

			if (restrict == "")
				return "";

			var charCodes:Array = [];
			
			var n:int = str.length;
			for (var i:int = 0; i < n; i++)
			{
				var charCode:uint = str.charCodeAt(i);
				if (testCharacter(charCode, restrict))
					charCodes.push(charCode);
			}
			
			return String.fromCharCode.apply(null, charCodes);
		}
		
		private static function testCharacter(charCode:uint,
											  restrict:String):Boolean
		{
			var allowIt:Boolean = false;
			
			var inBackSlash:Boolean = false;
			var inRange:Boolean = false;
			var setFlag:Boolean = true;
			var lastCode:uint = 0;
			
			var n:int = restrict.length;
			var code:uint;
			
			if (n > 0)
			{
				code = restrict.charCodeAt(0);
				if (code == 94) // caret
					allowIt = true;
			}
			
			for (var i:int = 0; i < n; i++)
			{
				code = restrict.charCodeAt(i)
				
				var acceptCode:Boolean = false;
				if (!inBackSlash)
				{
					if (code == 45) // hyphen
						inRange = true;
					else if (code == 94) // caret
						setFlag = !setFlag;
					else if (code == 92) // backslash
						inBackSlash = true;
					else
						acceptCode = true;
				}
				else
				{
					acceptCode = true;
					inBackSlash = false;
				}
				
				if (acceptCode)
				{
					if (inRange)
					{
						if (lastCode <= charCode && charCode <= code)
							allowIt = setFlag;
						inRange = false;
						lastCode = 0;
					}
					else
					{
						if (charCode == code)
							allowIt = setFlag;
						lastCode = code;
					}
				}
			}
			
			return allowIt;
		}
		
		/**
		 * 给点字符串变色
		 * */
		public static function formatString(value:String):String
		{
			//var reg:RegExp = /\[.*?\]/gi;
			var bReg:RegExp=/\[/g;
			var eReg:RegExp=/\]/g;
			var begin:String="<font color='#0099FF'>";
			var end:String="</font>";
			
			value=value.replace(bReg, begin).replace(eReg, end);
			
			return value;
		}
	}
}