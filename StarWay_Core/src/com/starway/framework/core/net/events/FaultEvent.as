package com.starway.framework.core.net.events
{
	import flash.events.Event;
	
	/**
	 * 
	 * @author Cray
	 * 
	 */	
	public class FaultEvent extends Event
	{
		public static const FAULT:String = "fault";
		
		private var _fault:Error;

		public function get fault():Error
		{
			return _fault;
		}

		
		public function FaultEvent(type:String,fault:Error, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			_fault = fault;
		}
		/**
		 * 创建一个错误时间实例 
		 * @param fault
		 * @return 
		 * 
		 */		
		public static function createEvent(fault:Error):FaultEvent
		{
			return new FaultEvent(FaultEvent.FAULT, fault,false, true);
		}
		
		override public function clone():Event
		{
			return new FaultEvent(type, fault, bubbles, cancelable);
		}
		
		override public function toString():String
		{
			return formatToString("type", "bubbles", "cancelable", "eventPhase");
		}
	}
}