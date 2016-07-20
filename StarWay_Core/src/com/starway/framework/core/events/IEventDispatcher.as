package com.starway.framework.core.events
{
	/**
	 * @author Cray
	 * @version 1.0
	 * @date Oct 23, 2014 3:31:42 PM
	 */
	public interface IEventDispatcher
	{
		/**
		 * 添加监听器 
		 * @param type
		 * @param listener
		 * 
		 */		
		function addEventListener(type:String, listener:Function):void;
		/**
		 * 转发事件 
		 * @param event
		 * @return 
		 * 
		 */		
		function dispatchEvent(event:Event):Boolean;
		/**
		 * 是否有监听器 
		 * @param type
		 * @param listener
		 * @return 
		 * 
		 */		
		function hasEventListener(type:String, listener:Function):Boolean;
		/**
		 * 移除监听器 
		 * @param type
		 * @param listener
		 * 
		 */		
		function removeEventListener(type:String, listener:Function):void;
	}
}