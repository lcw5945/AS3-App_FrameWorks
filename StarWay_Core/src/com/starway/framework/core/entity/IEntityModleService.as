package com.starway.framework.core.entity
{
	/**
	 * @author Cray
	 * @version 1.0
	 * @date Oct 24, 2014 4:36:17 PM
	 */
	public interface IEntityModleService
	{
		/**
		 * 获得并持久化实体模型 
		 * @param url
		 * @param params
		 * @param resultFormat
		 * @param entityModle
		 * 
		 * resultFormat 返回格式 定义在类  HTTPResponseMessage
		 * 静态属性可以直接使用
		 */		
		function persistEntityModle(url:String,params:Object,resultFormat:String,entityModle:IEntityModle):void;
	}
}