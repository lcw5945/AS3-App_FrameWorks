package com.starway.framework.core.net.scoket
{
	/**
	 * 
	 * @author Cray
	 * 
	 */	
	public interface IScoketOperation
	{
		/**
		 * host-->主机地址
		 * port-->主机端口
		 * secPort-->策略文本端口 
		 * @param host
		 * @param port
		 * @param secPort
		 * 
		 */		
		function startUp():void;
		
		function send(type:*,data:Object):void;
			
		function reconnect():void;
		
		function closed():void;
		
		function destroy():void
		
		function get connected():Boolean;
		/**
		 * 设置回调函数 
		 * @param value
		 * 
		 */		
		function set events(value:Vector.<Object>):void;
	}
}