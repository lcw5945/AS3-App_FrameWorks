package com.starway.framework.core.queue
{
	import com.starway.framework.core.ApplicationGlobals;

	public class Task implements ITask
	{
		private var _percent:int = 1;
		
		protected var _that:ITask;
		public function Task()
		{
			_that = this;
		}
		/**
		 * 开始
		 * 
		 */		
		public function startUp():void
		{
			
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */		
		public function set percent(value:int):void
		{
			_percent = value;
		}
		/**
		 * 任务百分比 
		 * @return 
		 * 
		 */		
		public function get percent():int
		{
			return _percent;
		}
		/**
		 *完成 
		 * 
		 */		
		public function complete():void
		{
			ApplicationGlobals.application.getEventManager().send("queuecomplete",null,null,true);
		}
	}
}