package com.starway.framework.utils
{
	import flash.display.LoaderInfo;
	import flash.system.Capabilities;

	public class LoaderUtil
	{
		public function LoaderUtil()
		{
		}
		/**
		 * 获得flash rootUrl 
		 * @param loaderInfo
		 * @return 
		 * 
		 */		
		public static function normalizeURL(loaderInfo:LoaderInfo):String
		{
			var url:String = loaderInfo.url;
			var index:int;
			var searchString:String;
			var urlFilter:Function;
			var n:uint = LoaderUtil.urlFilters.length;
			
			for (var i:uint = 0; i < n; i++)
			{
				searchString = LoaderUtil.urlFilters[i].searchString;
				if ((index = url.indexOf(searchString)) != -1)
				{
					urlFilter = LoaderUtil.urlFilters[i].filterFunction;
					url = urlFilter(url, index);
				}
			}
			
			if (isMac())
				return encodeURI(url);
			
			return url;
		}
		
		private static var urlFilters:Array = 
			[
				{ searchString: "/[[DYNAMIC]]/", filterFunction: dynamicURLFilter}, 
				{ searchString: "/[[IMPORT]]/",  filterFunction: importURLFilter}
			];
		

		private static function isMac():Boolean
		{
			return Capabilities.os.substring(0, 3) == "Mac";
		}
		

		private static function dynamicURLFilter(url:String, index:int):String
		{
			return url.substring(0, index);
		}
		

		private static function importURLFilter(url:String, index:int):String
		{
			var protocolIndex:int = url.indexOf("://");
			return url.substring(0,protocolIndex + 3) + url.substring(index + 12);
		}
	}
}