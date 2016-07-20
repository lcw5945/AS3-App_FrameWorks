package com.starway.framework.core.events
{
	

	/** 
	 * @author Cray
	 * @version 创建时间：Nov 2, 2014 5:34:25 PM 
	 **/ 
	public class CompleteEvent extends Event
	{
		/** http配置完成  **/		
		public static const HTTP_CONF_COMPLETE:String = "httpconfcomlete";
		/** scoket配置完成  **/		
		public static const SCOKET_CONF_COMPLETE:String = "scoketconfcomplete";
		/** module配置完成  **/		
		public static const MODULE_CONF_COMPLETE:String = "moduleconfcomplete";
		/** module全部加载完成  **/		
		public static const MODULE_LOAD_COMPLETE:String = "moduleloadfcomplete";
		/** 优先加载module全部加载完成  **/		
		public static const MODULE_PRI_LOAD_COMPLETE:String = "modulepriloadfcomplete";
		
		public function CompleteEvent(type:String, errorText:String=null)
		{
			super(type, errorText);
		}
		
		/**
		 * 创建事件 
		 * @param type
		 * @param modName
		 * @return 
		 * 
		 */		
		public static function createEvent(type:String,errorText:String=null):CompleteEvent
		{
			return new CompleteEvent(type,errorText);
		}
	}
}