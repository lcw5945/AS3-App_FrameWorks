package com.starway.framework.core.net
{
	import com.starway.framework.core.entity.EntityModleService;
	import com.starway.framework.core.entity.IEntityModleService;
	import com.starway.framework.core.net.http.HttpService;
	import com.starway.framework.core.net.http.IHttpService;
	import com.starway.framework.core.net.scoket.IScoketManager;
	import com.starway.framework.core.net.scoket.IScoketService;
	import com.starway.framework.core.net.scoket.ScoketManager;

	/**
	 * 
	 * @author Cray
	 * 
	 */	
	public class ServiceFactory implements IServiceFactory
	{
		public static const CONTEXT_NAME:String = "serviceFactory";
		
		public function ServiceFactory()
		{
		}
		
		public function getHttpService():IHttpService
		{
			return new HttpService();
		}
		
		public function getScoketService():IScoketService
		{
			//return ScoketManagerGlobals.managerSingleton.getScoketService();
			return (ScoketManager.getSingleton() as IScoketManager).getScoketService();
		}
		
		public function getEntityModleService():IEntityModleService
		{
			return EntityModleService.getInstance();
		}
	}
}
