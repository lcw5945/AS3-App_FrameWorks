package com.starway.framework.components.concsole
{
	import com.starway.framework.core.ApplicationGlobals;
	import com.starway.framework.core.log.Log;

	/**
	 * 
	 * @author Cray
	 * 
	 */	
	public class PropertyConfigurator
	{
		public static var logConf:Object=null;
		
		public function PropertyConfigurator()
		{
		}
		
		public static function configure(url:String):void
		{
			ApplicationGlobals.application.getServiceFactory().getHttpService().loadFile(url,loadSuccess,loadFail);
		}
		
		/**
		 * 加载成功 
		 * @param data
		 * 
		 */		
		private static function loadSuccess(data:*):void
		{
			logConf = JSON.parse(String(data));		
			Log.getLogger(PropertyConfigurator).info("[Log] log.json 文件读取成功.");
		}
		
		private static function loadFail(error:Error):void
		{
			Log.getLogger(PropertyConfigurator).error("[Log] 读取项目配置文件失败.");
		}
	}
}