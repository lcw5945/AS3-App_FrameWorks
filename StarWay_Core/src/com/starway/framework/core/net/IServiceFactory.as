package com.starway.framework.core.net
{
	import com.starway.framework.core.entity.IEntityModleService;
	import com.starway.framework.core.net.http.IHttpService;
	import com.starway.framework.core.net.scoket.IScoketService;

	/**
	 * @author Cray
	 * 
	 */	
	public interface IServiceFactory
	{
		/**
		 * 获得HTTP 通信服务 
		 * @return 
		 * 
		 */		
		function getHttpService():IHttpService;
		/**
		 *  获得Scoket 通信服务
		 * @return 
		 * 
		 */		
		function getScoketService():IScoketService;
		/**
		 * 获得实体管理器 通信服务
		 * @return 
		 * 
		 */		
		function getEntityModleService():IEntityModleService;
	}
}