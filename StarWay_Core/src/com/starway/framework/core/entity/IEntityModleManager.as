package com.starway.framework.core.entity
{
	/**
	 * @author Cray
	 * @version 1.0
	 * @date Oct 15, 2014 1:59:50 PM
	 */
	public interface IEntityModleManager
	{
		/**
		 * 持久化实体模型
		 * @param name
		 * @param entityModle
		 * 
		 */		
		function persist(entityModle:IEntityModle):void;
		/**
		 * 删除实体模型 
		 * @param entityModle
		 * @return 
		 * 
		 */		
		function remove(entityModle:IEntityModle):Boolean;
		/**
		 * 判断是否包含实体管理器 
		 * @param entityModle
		 * @return 
		 * 
		 */		
		function contains(entityModle:IEntityModle):Boolean;
		/**
		 * 检索实体模型
		 * @param name
		 * @return 
		 * 
		 */					 
		function getEntityModle(name:String):*;
	}
}