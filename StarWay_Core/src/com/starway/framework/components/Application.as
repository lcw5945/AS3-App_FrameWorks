package com.starway.framework.components
{
	import com.starway.framework.common.LoaderConfig;
	import com.starway.framework.components.concsole.ConsoleAppender;
	import com.starway.framework.components.concsole.IConsoleAppender;
	import com.starway.framework.components.concsole.PropertyConfigurator;
	import com.starway.framework.core.ApplicationGlobals;
	import com.starway.framework.core.context.IApplicationContext;
	import com.starway.framework.core.controller.ControllerManager;
	import com.starway.framework.core.controller.IController;
	import com.starway.framework.core.entity.IEntityModleManager;
	import com.starway.framework.core.events.IEventDispatcher;
	import com.starway.framework.core.inject.IInjectManager;
	import com.starway.framework.core.log.Log;
	import com.starway.framework.core.manager.AMGlobals;
	import com.starway.framework.core.manager.ApplicationContainManager;
	import com.starway.framework.core.manager.IAppliactionManager;
	import com.starway.framework.core.manager.IApplicationContainManager;
	import com.starway.framework.core.manager.IEventManager;
	import com.starway.framework.core.manager.IModuleDisplayManager;
	import com.starway.framework.core.net.IServiceFactory;
	import com.starway.framework.core.net.http.HttpManager;
	import com.starway.framework.core.net.scoket.ScoketManager;
	import com.starway.framework.core.objpool.IPoolObjectFactory;
	import com.starway.framework.core.queue.ITask;
	import com.starway.framework.core.queue.QueueControl;
	import com.starway.framework.core.ticker.ITicker;
	import com.starway.framework.utils.LoaderUtil;
	import com.starway.framework.utils.ObjectUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.utils.Timer;
	
	
	/**
	 * 
	 * @author Cray
	 * 
	 */     

	
	/**
	 * 基础入口类.应作为入口类的基类进行使用.
	 * 负责监听舞台初始化,和js可用性检测.
	 */	
	public class Application extends ApplicationBase implements IApplication
	{
		public function Application()
		{
			if (!ApplicationGlobals.application)
				ApplicationGlobals.application = this;
			//检测是否添加到舞台
			addEventListener(Event.ADDED_TO_STAGE, addToStage);
		}
		
		
		/**
		 * 重载舞台对象 
		 * @return 
		 * 
		 */		
		override public function get stage():Stage
		{
			return getApplicationManager().stage;
		}
		
		private var _appContainerManager:IApplicationContainManager;
		/**
		 * 设置背景 
		 * @param bgDisplay
		 * 
		 */		
		public function setBackgroundDisplay(bgDisplay:DisplayObject):void
		{
			_appContainerManager.setBackgroundDisplay(bgDisplay);
		}
		
		/**
		 * 设置背景颜色 
		 * @param value
		 * 
		 */        
		public function setBackgroundColor(value:uint):void
		{		
			_appContainerManager.setBackgroundColor(value);
		}
		/**
		 * 设置 背景可拖动容器top
		 * @param value
		 * 
		 */		
		public function setMeasureTop(value:int):void
		{
			_appContainerManager.setMeasureTop(value);
		}
		
		/**
		 * 添加任务 
		 * @param task
		 * 
		 */		
		public function addTask(task:ITask):void
		{
			_appProxy.getQueueControl().addTask(task);
		}
		/**
		 * 
		 * 
		 */		
		public function startUpDrag():void
		{
			_appContainerManager.startUpDrag();
		}
		/**
		 * 
		 * 
		 */		
		public function stopDragNow():void
		{
			_appContainerManager.stopDragNow();
		}
		/**
		 * 系统管理类
		 * 存储root pramaters 
		 */		
		private var _applicationManager:IAppliactionManager;
		public function getApplicationManager():IAppliactionManager
		{
			if(!_applicationManager)
				_applicationManager = AMGlobals.sm;
			return _applicationManager;
		}
		
		/**
		 * 对象管理器 
		 */		
		public function getApplicationContext():IApplicationContext
		{
			return _appProxy.getApplicationContext();
		}
		
		/**
		 * 注入管理器 
		 */	
		public function  getInjectManager():IInjectManager
		{
			return _appProxy.getInjectManager();
		}

		/**
		 * 获得派发
		 * 注册监听事件
		 */			
		public function getEventDispatcher():IEventDispatcher
		{
			
			return _appProxy.getEventDispatcher();
		}
		
		/**
		 * 事件管理器
		 * **/
		public function getEventManager():IEventManager
		{
			return _appProxy.getEventManager();
		}
		/**
		 * 获得计时器对象 
		 * 可以通过帧或者事件进行定时
		 * @return 
		 * 
		 */		
		public function getTicker():ITicker
		{
			return _appProxy.getTickerLaunch();
		}
		
		/**
		 * 获得通信管理类对象 
		 * @return 
		 * 
		 */		
		public function getServiceFactory():IServiceFactory
		{
			return _appProxy.getServiceFactory();
		}
		/**
		 * 获得实体管理工厂类  
		 * @return 
		 * 
		 */		
		public function getEntityModleManager():IEntityModleManager
		{
			return _appProxy.getEntityModleManager();
		}
		/**
		 * 获得控制器 
		 * @return 
		 * 
		 */
		public function getController():IController
		{
			return _appProxy.getController();
		}
		/**
		 * 获得池对象管理工厂 
		 * @return 
		 * 
		 */		
		public function getPoolObjectFactory():IPoolObjectFactory
		{
			return _appProxy.getPoolObjectFactory();
		}
		/**
		 * 获得视图显示管理 
		 * @return 
		 * 
		 */	
		public function getModDisplayManager():IModuleDisplayManager
		{
			return _appProxy.getModuleDisplayManager();
		}
		/**
		 * 控制台显示对象 
		 */	
		private var _consloeAppender:ConsoleAppender=null;
		public function getConsoleAppender():IConsoleAppender
		{
			if(_consloeAppender==null)
				_consloeAppender = new ConsoleAppender();
			return _consloeAppender;
		}
		
		/********************************舞台加载完成初始化******************************/
		/**
		 * 舞台已初始化.
		 *  
		 * @param
		 */		
		final private function addToStage(e:Event = null):void {
			if (hasEventListener(Event.ADDED_TO_STAGE)) {
				removeEventListener(Event.ADDED_TO_STAGE, addToStage);
			}
			//log
			Log.getLogger(this).info("[Application] App已成功加载到舞台.");
			//舞台初始化完成
			init();
			
			var retry:int=0;
			var timer:Timer = new Timer(30);
			timer.addEventListener(TimerEvent.TIMER,function timerHandler(event:TimerEvent):void
			{
				retry++;
				if(ExternalInterface.available)
				{
					//log
					Log.getLogger(this).info("[Application] JS已可用.");
					//删除监听器
					removeTimerEvent(timer,timerHandler);
					//创建完成
					createComplete();
				}else if(retry==3)
				{
					removeTimerEvent(timer,timerHandler);
					//log
					Log.getLogger(this).error("[Application] 尝试3次验证,JS不可用.");
				}
			});
			timer.start();		
		}
		/**
		 * 删除JS监听器 
		 * @param timer
		 * @param timerHandler
		 * 
		 */		
		private function removeTimerEvent(timer:Timer,timerHandler:Function):void
		{
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER,timerHandler);
			timer = null;
		}

		
		/**
		 * 调用初始化
		 * 启动应用上下文代理
		 */		
		private var _appProxy:ApplicationProxy;
		private function init():void 
		{
			initialize();
			//启动对象管理器
			_appProxy = new ApplicationProxy();
			
			ObjectUtil.each(AMGlobals.info, function(key:String, data:*):void{
				switch(key){
					case "logPath":{
						PropertyConfigurator.configure(data);//读取日志配置文件
						break;
					}
					case "scoketPath":{
						ScoketManager.loadConfigXml(data);//读取日志配置文件
						break;
					}
					case "httpPath":{
						HttpManager.loadConfigXml(data);//读取http配置文件
						break;
					}
					case "modulePath":{
						_appProxy.getModuleDisplayManager().startUp(data);//读取modulePath配置文件
						break;
					}
				}
			});
		}
		
		/**
		 * 舞台加载完成，并且页面js初始化完成 
		 * 重载 createComplete() 函数
		 */		
		protected function createComplete():void{
			/** 启动队列控制器 **/
			_appProxy.getQueueControl().startUp();
		}
		
		
		
		/**
		 * 舞台加载完成开始初始化
		 * 你可以监听initialize 事件
		 * 也可以重载 initialize() 函数
		 */	
		
		public function initialize():void
		{
			_url = LoaderUtil.normalizeURL(getApplicationManager().stage.loaderInfo);
			_parameters = getApplicationManager().loaderInfo.parameters; 
			//舞台参数存储
			LoaderConfig.init(stage);
			//初始化容器管理器
			_appContainerManager = new ApplicationContainManager(this);
			stage.addEventListener(Event.RESIZE,stageResizeHandler);
		}
		
		/**
		 * 舞台大小改变 
		 * @param event
		 * 
		 */		
		private function stageResizeHandler(event:Event):void
		{
			//更新容器显示
			_appContainerManager.updateDisplay();
			//更新模块显示
			if(this.getModDisplayManager())
				getModDisplayManager().updateModuleDisplay();
		}
	}
}
import com.starway.framework.core.context.ContextManager;
import com.starway.framework.core.context.IApplicationContext;
import com.starway.framework.core.controller.Controller;
import com.starway.framework.core.controller.ControllerManager;
import com.starway.framework.core.controller.IController;
import com.starway.framework.core.entity.EntityModleManager;
import com.starway.framework.core.entity.IEntityModleManager;
import com.starway.framework.core.events.EventDispatcher;
import com.starway.framework.core.events.IEventDispatcher;
import com.starway.framework.core.inject.IInjectManager;
import com.starway.framework.core.inject.InjectManager;
import com.starway.framework.core.manager.EventManager;
import com.starway.framework.core.manager.IEventManager;
import com.starway.framework.core.manager.IModuleDisplayManager;
import com.starway.framework.core.manager.ModuleDisplayManager;
import com.starway.framework.core.net.IServiceFactory;
import com.starway.framework.core.net.ServiceFactory;
import com.starway.framework.core.objpool.IPoolObjectFactory;
import com.starway.framework.core.objpool.PoolObjectFactory;
import com.starway.framework.core.queue.QueueControl;
import com.starway.framework.core.ticker.ITicker;
import com.starway.framework.core.ticker.Ticker;

class ApplicationProxy
{
	/**
	 * 对象管理器 
	 */		
	private var _applicationContext:IApplicationContext;
	public function ApplicationProxy()
	{
		/** 启动对象管理，注册管理类 **/
		_applicationContext = ContextManager.getInstance.startUp();
		/** 启动控制器 **/
		if(_applicationContext)
			ControllerManager.controllerIns =  getController() as Controller;
	}
	/**
	 * 对象管理器 
	 * @return 
	 * 
	 */    
	public function getApplicationContext():IApplicationContext
	{
		return _applicationContext;
	}
	
	public function getQueueControl():QueueControl
	{
		return getApplicationContext().getContext(QueueControl.CONTEXT_NAME);
	}
	
	/**
	 * 注入管理器 
	 */	
	public function  getInjectManager():IInjectManager
	{
		return getApplicationContext().getContext(InjectManager.CONTEXT_NAME);
	}
	
	/**
	 * 获得事件派发器
	 * 注册监听事件
	 */			
	public function getEventDispatcher():IEventDispatcher
	{
		
		return getApplicationContext().getContext(EventDispatcher.CONTEXT_NAME);
	}
	
	/**
	 * 获得事件管理器 
	 * 注册监听事件
	 */			
	public function getEventManager():IEventManager
	{
		
		return getApplicationContext().getContext(EventManager.CONTEXT_NAME);
	}
	/**
	 * 获得计时器对象 
	 * 可以通过帧或者事件进行定时
	 * @return 
	 * 
	 */		
	public function getTickerLaunch():ITicker
	{
		return getApplicationContext().getContext(Ticker.CONTEXT_NAME);
	}
	
	/**
	 * 获得通信管理类对象 
	 * @return 
	 * 
	 */		
	public function getServiceFactory():IServiceFactory
	{
		return getApplicationContext().getContext(ServiceFactory.CONTEXT_NAME);
	}
	/**
	 * 获得实体管理工厂类  
	 * @return 
	 * 
	 */		
	public function getEntityModleManager():IEntityModleManager
	{
		return getApplicationContext().getContext(EntityModleManager.CONTEXT_NAME);
	}
	/**
	 * 获得控制器 
	 * @return 
	 * 
	 */
	public function getController():IController
	{
		return getApplicationContext().getContext(Controller.CONTEXT_NAME);
	}
	/**
	 * 获得池对象管理工厂 
	 * @return 
	 * 
	 */		
	public function getPoolObjectFactory():IPoolObjectFactory
	{
		return getApplicationContext().getContext(PoolObjectFactory.CONTEXT_NAME); 
	}
	/**
	 * 获得视图显示管理 
	 * @return 
	 * 
	 */	
	public function getModuleDisplayManager():IModuleDisplayManager
	{
		return getApplicationContext().getContext(ModuleDisplayManager.CONTEXT_NAME); 
	}
}
