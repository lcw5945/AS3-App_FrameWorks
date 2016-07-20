package com.starway.framework.core.controller
{
	import com.starway.framework.core.entity.IEntityModleManager;
	import com.starway.framework.core.events.IEventDispatcher;
	import com.starway.framework.core.net.IServiceFactory;
	import com.starway.framework.core.objpool.IPoolObjectFactory;
	import com.starway.framework.core.ticker.ITicker;
	
	
	/**
	 * @author Cray 
	 * @version 1.0
	 * @date Oct 16, 2014 5:08:45 PM
	 */
	public class Action implements IAction
	{
		/**成功返回**/
		protected const SUCCESS:Boolean=true;
		/**失败返回**/
		protected const FAIL:Boolean = false;
		
		[InjectContext]
		public var em:IEntityModleManager;
		[InjectContext]
		public var po:IPoolObjectFactory;
		[InjectContext]
		public var c:IController;
		[InjectContext]
		public var e:IEventDispatcher;
		[InjectContext]
		public var sf:IServiceFactory;
		[InjectContext]
		public var t:ITicker;

		/**
		 * 注入Injdect对象实例
		 * [InjectModel]
		 * [InjectIModuleProxy(name="模块名字")]
		 * public var mod:IModuleProxy;
		 * [InjectContext]
		 * [InjectKeyVO(key="")]
		 * 
		 * example：
		 * 注入模型：
		 * [InjectModel]
		 * public var liveInfo:ILiveInfo;
		 * 
		 * 注入ApplicationContext 容器对象
		 * [InjectContext]
		 * public var sfac:IServiceFactory;
		 * 
		 * 注入KeyVO对象
		 * [InjectKeyVO(key="Flashvars")]
		 * public var flashvas:IFlashVars;
		 * 
		 * 注入模块代理对象
		 * [InjectIModuleProxy(name="SimpleVideoModule")]
		 * public var mod:IModuleProxy;
		 * 
		 * 
		 * ApplicationContext 框架包含的接口类型：IEventDispatcher,ITickerLaunch,IServiceFactory,IEntityModleManager
		 * IController,IPoolObjectFactory,IModuleDisplayManager
		 * 
		 */		
		public function Action()
		{
		}
		
		/**
		 * 初始化业务
		 * 启动方法 
		 * 
		 */		
		public function startUp():void
		{
			
		}
		/**
		 * 业务方法
		 * @param actionName
		 * @param data
		 * @return 
		 * 
		 */		
		public function execute(actionName:String,data:Object):Boolean
		{
			return SUCCESS;
		}
		/**
		 * 
		 * 
		 */		
		public function onModuleLoaded():void
		{
			
		}
	}
}