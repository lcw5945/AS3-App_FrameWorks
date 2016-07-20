package com.starway.framework.core.controller
{
	/**
	 * @author Cray
	 * @version 1.0
	 * @date Oct 16, 2014 4:58:37 PM
	 */
	public interface IAction
	{
		/**
		 * 初始化启动 
		 * 
		 */		
		function startUp():void;
		/**
		 * 业务执行方法
		 * 每次发出request请求都会执行相对应的这个方法 
		 * @param actionName
		 * @param data
		 * @return 
		 * 
		 */		
		function execute(actionName:String,data:Object):Boolean;
		/**
		 * 模块加载完成
		 * 
		 */		
		function onModuleLoaded():void
	}
}