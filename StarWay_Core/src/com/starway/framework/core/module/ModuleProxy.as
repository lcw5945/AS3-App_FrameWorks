package com.starway.framework.core.module
{
	import com.starway.framework.core.ApplicationGlobals;
	import com.starway.framework.core.events.ModuleEvent;
	import com.starway.framework.core.log.Log;
	import com.starway.framework.core.manager.IModuleBeanInfo;

	/** 
	 * @author Cray
	 * @version 创建时间：Nov 8, 2014 2:26:10 PM 
	 **/ 
	public class ModuleProxy implements IModuleProxy
	{
		public function ModuleProxy()
		{
		}		
		

		/**
		 * 设置函数和数据
		 * 如果模块未下载完，则存储数据
		 * 模块下载完成，如果数据没有执行完成，则存储
		 * @param fun
		 * @param value
		 * 
		 */		
		public function invokeFunByData(fun:String,...params):void
		{
			if(_modBeanInfo.moduleInfo && _modBeanInfo.moduleInfo.module)
			{
				if(_handlers.length!=0)
				   _handlers.push({handle:fun, data:params});
				else
				{
					if(_modBeanInfo.moduleInfo.module[fun] is Function){
						var handle:Function =  _modBeanInfo.moduleInfo.module[fun] as Function;
						handle.apply(null,params);
					}else{
						_modBeanInfo.moduleInfo.module[fun] = params;
					}
				}
			}
			else
			{ 
				if(!ApplicationGlobals.application.getEventDispatcher().hasEventListener(ModuleEvent.READY,moduleProxyReadyHandler))
				ApplicationGlobals.application.getEventDispatcher().addEventListener(ModuleEvent.READY,moduleProxyReadyHandler);
				_handlers.push({handle:fun, data:params});
			}
		}
		
		/**
		 * 调用函数 
		 * @param fun
		 * 
		 */		
		public function invokeFun(fun:String):void
		{
			if(_modBeanInfo.moduleInfo && _modBeanInfo.moduleInfo.module)
			{
				if(_handlers.length!=0)
					_handlers.push({handle:fun});
				else
					_modBeanInfo.moduleInfo.module[fun]();
			}
			else
			{ 
				if(!ApplicationGlobals.application.getEventDispatcher().hasEventListener(ModuleEvent.READY,moduleProxyReadyHandler))
					ApplicationGlobals.application.getEventDispatcher().addEventListener(ModuleEvent.READY,moduleProxyReadyHandler);
				_handlers.push({handle:fun});
			}
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function getModuleBeanInfo():IModuleBeanInfo
		{
			return _modBeanInfo;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function getModuleInfo():IModuleInfo
		{
			return _modBeanInfo.moduleInfo;
		}
		
		/**
		 * 模块加载完成 
		 * 每6帧set 一次数据，直到数据执行完成
		 * @param event
		 * 
		 */		
		private function moduleProxyReadyHandler(event:ModuleEvent):void
		{
			if(_modBeanInfo.moduleInfo && _modBeanInfo.moduleInfo.module)
			{
				ApplicationGlobals.application.getEventDispatcher().removeEventListener(ModuleEvent.READY,moduleProxyReadyHandler);
				ApplicationGlobals.application.getTicker().tick(1, executeHandler, 0, true);
			}
			
			function executeHandler():void
			{
				if(_handlers.length > 0)
				{
					var handObj:Object = _handlers.shift();
					if(handObj.hasOwnProperty("data")){
						if(_modBeanInfo.moduleInfo.module[handObj.handle] is Function){
							var handle:Function =  _modBeanInfo.moduleInfo.module[handObj.handle] as Function;
							handle.apply(null,handObj.data);
						}else{
							_modBeanInfo.moduleInfo.module[handObj.handle] = handObj.data;
						}
					}
					else{
						_modBeanInfo.moduleInfo.module[handObj.handle]();
					}
				}else
					ApplicationGlobals.application.getTicker().stop(executeHandler);
			}
		}

		/**
		 * 缓存的消息
		 */
		private var _handlers:Array = [];
		
		private var _modBeanInfo:IModuleBeanInfo;
		/**
		 * 模块名字 
		 */		
		private var _modName:String;
		public function get modName():String
		{
			return _modName;
		}
		
		public function set modName(value:String):void
		{
			_modName = value;
			_modBeanInfo = ApplicationGlobals.application.getModDisplayManager().getModuleBeanInfo(_modName);
			if(_modBeanInfo==null)
				Log.getLogger(ModuleProxy).error(" [ModuleProxy] 获得模型信息失败, 模块名称有错误 . modName = " + _modName);
		}
	}
}