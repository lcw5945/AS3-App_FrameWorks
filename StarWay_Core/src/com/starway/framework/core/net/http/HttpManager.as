package com.starway.framework.core.net.http
{
	import com.starway.framework.core.manager.AMGlobals;

	/**
	 * @author Cray 
	 * @version 1.0
	 * @date Nov 1, 2014 1:09:23 PM
	 */
	public class HttpManager
	{
		public function HttpManager()
		{
		}
		
		/**
		 * 加载http path 文件
		 * @param params
		 * 
		 */		
		public static function loadConfigXml(httpPath:String=null):void
		{
			if(httpPath==null)
				httpPath = AMGlobals.info["httpPath"];
			if(httpPath && httpPath.indexOf("xml")!=-1)
				ClassPathXmlHttp.getInstence().classPathXml(httpPath);
		}
		/**
		 * 通过name 返回地址 
		 * @param name
		 * @return 
		 * 
		 */		
		public static function getUrlByName(name:String):String
		{
			return ClassPathXmlHttp.getInstence().getUrlByName(name);
		}
	}
}