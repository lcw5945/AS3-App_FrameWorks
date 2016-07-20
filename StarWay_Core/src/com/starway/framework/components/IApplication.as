package com.starway.framework.components
{
	import com.starway.framework.components.concsole.IConsoleAppender;
	import com.starway.framework.core.context.IApplicationContext;
	import com.starway.framework.core.controller.IController;
	import com.starway.framework.core.entity.IEntityModleManager;
	import com.starway.framework.core.events.IEventDispatcher;
	import com.starway.framework.core.inject.IInjectManager;
	import com.starway.framework.core.manager.IAppliactionManager;
	import com.starway.framework.core.manager.IEventManager;
	import com.starway.framework.core.manager.IModuleDisplayManager;
	import com.starway.framework.core.net.IServiceFactory;
	import com.starway.framework.core.objpool.IPoolObjectFactory;
	import com.starway.framework.core.queue.ITask;
	import com.starway.framework.core.ticker.ITicker;
	
	import flash.display.DisplayObject;

	/**
	 * 
	 * @author Cray
	 * 
	 */	
	public interface IApplication extends IApplicationBase
	{
		/**
		 * 设置背景 
		 * @param bg
		 * 
		 */		
		function setBackgroundDisplay(bgDisplay:DisplayObject):void;
		/**
		 * 设置主应用背景颜色 
		 * @param value
		 * 
		 */		
		function setBackgroundColor(value:uint):void;
		
		function setMeasureTop(value:int):void;
		/**
		 * 添加任务 
		 * @param task
		 * 
		 */		
		function addTask(task:ITask):void;
		/**
		 * 启动背景容器拖动
		 * 
		 */		
		function startUpDrag():void;
		/**
		 * 停止背景容器拖动 
		 * 
		 */		
		function stopDragNow():void;
		/**
		 * 返回系统管理类 
		 * @return 
		 * 
		 */
		function getApplicationManager():IAppliactionManager;
		/**
		 * 对象管理器 
		 */	
		function  getApplicationContext():IApplicationContext;
		/**
		 * 注入管理器 
		 */	
		function  getInjectManager():IInjectManager;
		/**
		 *  获得派发
		 * 注册监听事件
		 */	
		function getEventDispatcher():IEventDispatcher;
		/**
		 * 事件管理器
		 */
		function getEventManager():IEventManager
		/**
		 * 获得计时器对象 
		 * 可以通过帧或者事件进行定时
		 * @return 
		 * 
		 */	
		function  getTicker():ITicker;
		/**
		 * 获得通信管理类对象 
		 * @return 
		 * 
		 */	
		function  getServiceFactory():IServiceFactory;
		/**
		 * 获得实体管理工厂类 
		 * @return 
		 * 
		 */		
		function  getEntityModleManager():IEntityModleManager;
		/**
		 * 获得池对象管理工厂 
		 * @return 
		 * 
		 */		
		function  getPoolObjectFactory():IPoolObjectFactory;
		/**
		 * 获得控制器 
		 * @return 
		 * 
		 */		
		function getController():IController;		
		/**
		 * 获得视图显示管理 
		 * @return 
		 * 
		 */		
		function getModDisplayManager():IModuleDisplayManager;
		/**
		 * 控制台显示对象 
		 */
		function getConsoleAppender():IConsoleAppender;
	}
}