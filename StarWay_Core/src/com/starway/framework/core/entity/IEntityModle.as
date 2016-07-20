package com.starway.framework.core.entity
{
	/**
	 * @author Cray
	 * @version 1.0
	 * @date Oct 15, 2014 2:00:55 PM
	 */
	public interface IEntityModle
	{
		/**
		 * 实体name 作为唯一区分实体标志 
		 * @return 
		 * 
		 */		
		function get name():String;
		/**
		 * 解析请求返回数据 并对实体属性赋值 
		 * @param data
		 * 
		 */		
		function analysis(data:Object):void;
	}
}