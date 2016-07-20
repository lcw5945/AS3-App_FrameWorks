package com.starway.framework.core.net.scoket.events
{
	import flash.events.Event;
	
	/**
	 * 
	 * @author Cray
	 * 
	 */	
	public class UnpackEvent extends Event
	{
		public static const RESULT:String = "result";
		
		private var _result:Object;
		
		public function get result():Object
		{
			return _result;
		}
		
		
		public function UnpackEvent(type:String, result:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			_result = result;
		}
		
		/**
		 * 创建成功处理函数 
		 * @param result
		 * @return 
		 * 
		 */		
		public static function createEvent(result:Object = null):UnpackEvent
		{
			return new UnpackEvent(UnpackEvent.RESULT,result, false, true);
		}
		
		override public function clone():Event
		{
			return new UnpackEvent(type, result ,bubbles, cancelable);
		}
		
		override public function toString():String
		{
			return formatToString("type", "bubbles", "cancelable", "eventPhase");
		}
	}
}

