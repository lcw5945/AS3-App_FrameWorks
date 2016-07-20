package com.starway.framework.common
{
	import com.starway.framework.core.log.Log;
	import com.starway.framework.utils.LoaderUtil;
	
	import flash.display.DisplayObject;

	/**
	 * 
	 * @author Cray
	 * 
	 */    
	public class LoaderConfig
	{
		
		
		public function LoaderConfig()
		{
		}
		
		public static function init(root:DisplayObject):void
		{			
			_url = LoaderUtil.normalizeURL(root.loaderInfo);
			_parameters = root.loaderInfo.parameters;
			//_swfVersion = root.loaderInfo.swfVersion;
			Log.getLogger(LoaderConfig).debug("[Stage] url=" + _url + " parameters=" + JSON.stringify(_parameters));
		}
		/**
		 * root paramters
		 */		
		private static var _parameters:Object;
		public static function get parameters():Object
		{
			return _parameters;
		}
		/**
		 * 
		 */		
		private static var _swfVersion:uint;
		public static function get swfVersion():uint
		{
			return _swfVersion;
		}
		/**
		 * root url
		 */
		private static var _url:String = null;
		public static function get url():String
		{
			return _url;
		}
	}
}