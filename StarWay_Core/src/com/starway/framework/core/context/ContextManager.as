package com.starway.framework.core.context
{
	import com.starway.framework.core.controller.Controller;
	import com.starway.framework.core.entity.EntityModleManager;
	import com.starway.framework.core.events.EventDispatcher;
	import com.starway.framework.core.inject.InjectManager;
	import com.starway.framework.core.log.Log;
	import com.starway.framework.core.manager.EventManager;
	import com.starway.framework.core.manager.ModuleDisplayManager;
	import com.starway.framework.core.net.ServiceFactory;
	import com.starway.framework.core.objpool.PoolObjectFactory;
	import com.starway.framework.core.queue.QueueControl;
	import com.starway.framework.core.ticker.Ticker;

	/**
	 * 
	 * @author Cray
	 * 
	 */	
	public class ContextManager 
	{
		private static var _instance:ContextManager = new ContextManager();
		private var _ctf:IApplicationContext; 
		public function ContextManager()
		{
		}
		/**
		 * 管理类实例 
		 * @return 
		 * 
		 */		
		public static function get getInstance():ContextManager
		{
			if(_instance==null)
				_instance = new ContextManager();
			return _instance;
		}
		/**
		 * 启动对象管理工厂 
		 * @return 
		 * 
		 */		
		public function startUp():IApplicationContext
		{			
			if(_ctf)return _ctf;
			_ctf = new ApplicationContext();
			//log
			Log.getLogger(ContextManager).info("[Context] 启动对象管理器.");
			
			var clsObj:Object = getManagerClass;
			for (var clsName:String in clsObj)
			{
				_ctf.registerContext(clsName,clsObj[clsName]);
			}
			return _ctf;
		}
		/**
		 * 启动时加载所有管理器 new QueueControl().startUp();
		 * @return 
		 * 
		 */		
		private function get getManagerClass():Object
		{
			var obj:Object = new Object();
			obj[InjectManager.CONTEXT_NAME] = InjectManager;
			obj[EventDispatcher.CONTEXT_NAME] = EventDispatcher;
			obj[Ticker.CONTEXT_NAME] = Ticker;
			obj[ServiceFactory.CONTEXT_NAME] = ServiceFactory;
			obj[EntityModleManager.CONTEXT_NAME] = EntityModleManager;
			obj[Controller.CONTEXT_NAME] = Controller;
			obj[PoolObjectFactory.CONTEXT_NAME] = PoolObjectFactory;
			obj[ModuleDisplayManager.CONTEXT_NAME] = ModuleDisplayManager;
			obj[EventManager.CONTEXT_NAME] = EventManager;
			obj[QueueControl.CONTEXT_NAME] = QueueControl;
			return obj;
		}
	}
}