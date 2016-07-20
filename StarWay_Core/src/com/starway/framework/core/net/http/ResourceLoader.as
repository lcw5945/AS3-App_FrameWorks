package com.starway.framework.core.net.http
{
	
	import flash.display.DisplayObject;

	/**
	 * 
	 * @author Cray
	 * 
	 */	
	public class ResourceLoader
	{
		private static var _resLoader:ResourceLoader=null;
		public function ResourceLoader()
		{
		}
		
		public static function getInstance():ResourceLoader
		{
			if(_resLoader==null)
				_resLoader = new ResourceLoader();
			return _resLoader;
		}
		/**
		 * 获得显示资源 
		 * @param url
		 * @return 
		 * 
		 */		
		public function getDisplayResByUrl(url:String):DisplayObject
		{
			var resDis:DisplayObject;
			var httpService:HttpService = new HttpService();
			httpService.successFunc = function resDisLoadSuccess(disObj:DisplayObject):void{
				resDis = disObj;
			};
			httpService.loadAssets(url);
			return resDis;
		}
		
		
	}
}