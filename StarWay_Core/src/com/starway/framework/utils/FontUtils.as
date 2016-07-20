package com.starway.framework.utils
{
	import flash.system.Capabilities;
	
	/**
	 * @author Cray 
	 * @version 1.0
	 * @date Nov 5, 2014 4:11:02 PM
	 */
	public class FontUtils
	{
		/**
		 * 当前系统所使用的默认字体 
		 */		
		private static var _defaultFontName:String = "";
		/**
		 * 微软雅黑 
		 */		
		public static const FONT_WRYH:String = "Microsoft YaHei,微软雅黑";
		
		public static const FONT_ARIAL:String = "Arial, Arial 常规";
		
		/**
		 * 苹果丽黑 
		 */		
		public static const FONT_PGLZH:String = "Hiragino Sans GB,苹果丽黑";
		
		private static var _os:String = "";
		public function FontUtils()
		{
		}
		
		/**
		 * 获取默认的非系统默认字体 
		 * @return 
		 */		
		public static function getDefaultFontNotSysFont():String {
			if (!_defaultFontName) {
				switch (os) {
					case "Windows" : 
						return _defaultFontName = FONT_WRYH;
						break;
					case "Mac" : 
						return _defaultFontName = FONT_PGLZH;
						break;
					case "Linux" : 
						return _defaultFontName = FONT_WRYH;
						break;
					default : 
						return _defaultFontName = FONT_WRYH;
						if (os.indexOf("iphone")) {
							
						} else {
							
						}
						break;
				}
				_defaultFontName = null;
			}
			return _defaultFontName;
		}
		
		/**
		 * 获取默认的非系统默认数字类型字体(底部控制栏用)
		 * @return 
		 */		
		public static function getDefaultNumberFontNotSysFont():String {
			var re:String = null;
			switch (os) {
				case "Windows" : 
					return re = FONT_ARIAL;
					break;
				case "Mac" : 
					return re = null;
					break;
				case "Linux" : 
					return re = null;
					break;
				default : 
					return re = null;
					if (os.indexOf("iphone")) {
						
					} else {
						
					}
					break;
			}
			re = null;
			return re;
		}
		
		/**
		 * 获取当前播放器所处的操作系统
		 *  
		 * @return 如: "Windows", "Mac"
		 * 
		 */		
		public static function get os():String {
			if (!validateStr(_os)) {
				_os = Capabilities.os.split(" ")[0];
			}
			return _os;
		}
		
		/**
		 * 验证字符串是否可用.一般用于判断时检验字符串是否合法.
		 *  
		 * @param s
		 * @return 
		 */		
		public static function validateStr(s:String):Boolean {
			return s != null && trimStr(s) != "";
		}
		
		/**
		 * 去除字符串空格
		 *  
		 * @param s
		 * @return 
		 */		
		public static function trimStr(s:String):String {
			return s.replace(/([ ]{1})/g, "");
		}
	}
}