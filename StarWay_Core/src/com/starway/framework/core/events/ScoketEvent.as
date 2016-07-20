package com.starway.framework.core.events
{
	
	/**
	 * @author Cray 
	 * @version 1.0
	 * @date Nov 4, 2014 2:42:53 PM
	 */
	public class ScoketEvent extends Event
	{
		/** 链接成功 **/		
		public static const CONNECT:String = "connect";
		/** 系统错误 **/
		public static const SYS_ERROR:String = "sys_error";
		
		public function ScoketEvent(type:String, errorText:String=null)
		{
			super(type, errorText);
		}
		
		public static function createEvent(type:String,errorText:String=null):ScoketEvent
		{
			return new ScoketEvent(type,errorText);
		}
	}
}