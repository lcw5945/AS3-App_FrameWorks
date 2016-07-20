package com.starway.framework.core.entity
{
	import com.starway.framework.core.ApplicationGlobals;
	import com.starway.framework.core.events.EntityModleEvent;
	import com.starway.framework.core.log.Log;
	import com.starway.framework.core.net.http.HTTPRequestMessage;
	import com.starway.framework.core.net.http.HttpService;
	
	/**
	 * @author Cray 
	 * @version 1.0
	 * @date Oct 24, 2014 4:44:36 PM
	 */
	public class EntityModleService implements IEntityModleService
	{
		private static var _entityModleService:EntityModleService;
		public function EntityModleService()
		{
		}
		
		public static function getInstance():EntityModleService
		{
			if(_entityModleService==null)_entityModleService=new EntityModleService();
			return _entityModleService;
		}
		/**
		 * 
		 * @param url
		 * @param params
		 * @param resultFormat
		 * @param entityModle
		 * 请求成功转发模型 事件 EntityModleEvent
		 */		
		public function persistEntityModle(url:String, params:Object, resultFormat:String, entityModle:IEntityModle):void
		{
			var httpService:HttpService = new HttpService();
			httpService.send(url,params,function requestSuccess(data:Object):void
			{
				//解析数据
				entityModle.analysis(data);
				//持久化到容器
				ApplicationGlobals.application.getEntityModleManager().persist(entityModle);
				//模型请求成功实践派发
				ApplicationGlobals.application.getEventDispatcher().dispatchEvent(EntityModleEvent.createEvent(EntityModleEvent.READY,entityModle.name));
				//log
				Log.getLogger(EntityModleService).info("实体 " + entityModle.name + " 模型请求成功.");
			},function requestFail(error:Error):void{
				//模型请求成功实践派发
				ApplicationGlobals.application.getEventDispatcher().dispatchEvent(EntityModleEvent.createEvent(EntityModleEvent.ERROR,entityModle.name));
				//log
				Log.getLogger(EntityModleService).error("实体 " + entityModle.name + " 模型请求失败.");
			},HTTPRequestMessage.POST_METHOD,resultFormat);
		}
	}
}