package com.starway.framework.core.queue
{
	public interface ITask
	{
		/**
		 *启动 
		 * 
		 */		
		function startUp():void;
		/**
		 * 
		 * @param value
		 * 
		 */		
		function set percent(value:int):void;
		/**
		 * 任务百分比 
		 * @return 
		 * 
		 */		
		function get percent():int;
		/**
		 * 完成，
		 */		
		function complete():void;
	}
}