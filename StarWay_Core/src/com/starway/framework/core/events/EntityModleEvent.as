package com.starway.framework.core.events
{
	
	/**
	 * @author Cray 
	 * @version 1.0
	 * @date Oct 28, 2014 12:47:58 PM
	 */
	public class EntityModleEvent extends Event
	{
		public static const READY:String = "EntityModleEvent_ready";
		public static const ERROR:String = "EntityModleEvent_error";

		public function EntityModleEvent(type:String,modName:String)
		{
			super(type);
			_modName = modName;
		}
		
		private var _modName:String;
		
		public function get modName():String
		{
			return _modName;
		}
		
		/**
		 * 创建事件 
		 * @param type
		 * @param modName
		 * @return 
		 * 
		 */		
		public static function createEvent(type:String,modName:String=null):EntityModleEvent
		{
			return new EntityModleEvent(type,modName);
		}
	}
}