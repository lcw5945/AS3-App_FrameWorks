package com.starway.framework.core.ticker
{
	public interface ITicker
	{
		/**
		 * 时间(s)计时器
		 * @param delay
		 * @param repeatCount
		 * @param callback
		 * @param frame 为true表示是帧计时器
		 */			
		function tick(delay:Number, callback:Function = null,  repeatCount:int = 1, frame:Boolean=false):void;
		/**
		 * 
		 * @param callback
		 * @return 
		 * 
		 */		
		function have(callback:Function = null):Boolean;
		/**
		 * 移除监听器 
		 * @param callback
		 * 
		 */			
		function stop(callback:Function = null):void;	
	}
}