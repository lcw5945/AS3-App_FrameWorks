package com.starway.framework.core.controller
{
	/**
	 * @author Cray 
	 * @version 1.0
	 * @date Oct 17, 2014 11:45:33 AM
	 */
	public class Controller implements IController
	{
		public static const CONTEXT_NAME:String = "controller";
		public function Controller()
		{
		}
		
		/**
		 * 初始化action 业务方法
		 * 
		 */		
		public function startUp():void
		{
			filterDispathcer.StartUp();
		}

		/**
		 * 注册Action
		 */
		public function registerAction(action:Class):void
		{
			_filterDispathcer.registerAction(action);
		}
		/**
		 * 模块加载完成
		 * 
		 */		
		internal function onModuleLoaded(name:String):void
		{
			filterDispathcer.onModuleLoaded(name);
		}
		
//		/**
//		 * 广播请求响应
//		 * @param actionName
//		 * 
//		 */		
//		public function request(actionName:String,data:Object=null,successFun:Function=null,failFun:Function=null):void
//		{
//			filterDispathcer.dispatcher(actionName,data,successFun,failFun);
//		}
		/**
		 * 获得转发过滤器
		 */		
		private var _filterDispathcer:FilterDispatcher;
		private function get filterDispathcer():FilterDispatcher
		{
			if(_filterDispathcer==null)
				_filterDispathcer = new FilterDispatcher();
			return _filterDispathcer;
		}
	}
}
import com.starway.framework.core.ApplicationGlobals;
import com.starway.framework.core.controller.Command;
import com.starway.framework.core.controller.IAction;
import com.starway.framework.core.inject.IInjectManager;
import com.starway.framework.core.log.Log;
import com.starway.framework.utils.ClassUtil;

import flash.utils.getQualifiedClassName;

class FilterDispatcher{
	
	private var _commandVector:Vector.<ActionBean> = new Vector.<ActionBean>;
	private var _injectManager:IInjectManager;
	public function FilterDispatcher()
	{
	}
	/**
	 * 初始化请求响应命令 
	 * 只接受实现IAction接口的类
	 * 
	 */
	private function init():void
	{		
		_injectManager = ApplicationGlobals.application.getInjectManager();
		var params:Object = Command.ACTION;
		for (var key:String in params)
		{
			var cl:Class = params[key];
			if(ClassUtil.isClassOneType(cl,IAction))
			{		
				var ia:IAction = new cl();
				_injectManager.inject(ia);
				_commandVector.push(new ActionBean(key, ia));
				//log
				Log.getLogger(FilterDispatcher).debug("[Controller] 实例化 "+ key +" 控制器 .");
			}else
				Log.getLogger(FilterDispatcher).warn("[Controller] " + params[key] + "没有实现 IAction接口，此Action不可用.");			
		}
	}
	
	/**
	 * 启动action 
	 * 业务方法 
	 * 
	 */		
	private var _start:Boolean;
	public function StartUp():void
	{
		if(_start)return;
		_start = true;
		this.init();
		
		for each(var ab:ActionBean in _commandVector)
		{
			var ia:IAction = ab.actionIns;
			ia.startUp();
			Log.getLogger(this).info("启动     "+ ab.actionName + "  业务控制.");
		}
		
	}
	/**
	 * 注册控制器
	 * 
	 * @param action
	 * 
	 */	
	public function registerAction(action:Class):void
	{
		var key:String = getQualifiedClassName(action).replace("Action","");
		Command.ACTION[key] = action;
		
		if(ClassUtil.isClassOneType(action,IAction))
		{	
			var ia:IAction = new action();
			_commandVector.push(new ActionBean(key, ia));
			//log
			Log.getLogger(FilterDispatcher).debug("[Controller] 实例化 "+ getQualifiedClassName(action) +" 控制器 .");
			
			_injectManager.inject(ia);
			ia.startUp();
			Log.getLogger(this).info("启动     "+ getQualifiedClassName(action) + "  业务控制.");
			
		}else
			Log.getLogger(FilterDispatcher).warn("[Controller] " + action + "没有实现 IAction接口，此Action不可用.");	
	}
	/**
	 * 对应action的模块加载完成 
	 * @param name
	 * 
	 */	
	public function onModuleLoaded(name:String):void
	{
		var disVor:Vector.<ActionBean> = _commandVector.filter(function (item:ActionBean, index:int, vector:Vector.<ActionBean>):Boolean{
			if(item.actionName == name)return true;
			else return false;
		});
		if(disVor.length>0)
		{
			for each(var ab:ActionBean in disVor)
			{
				var ia:IAction = ab.actionIns;
				ia.onModuleLoaded();
			}
		}
	}
	
	/**
	 * 转发请求响应 通过actionName
	 * 多个actionName 可以对应多个处理类（如果有需要的业务逻辑，不过除非必要否则不要这么做，容易出错）
	 * @param actionName
	 * 
	 */	
	public function dispatcher(actionName:String,data:Object,successFun:Function,failFun:Function):void
	{
	    var disVor:Vector.<ActionBean> = _commandVector.filter(function (item:ActionBean, index:int, vector:Vector.<ActionBean>):Boolean{
			if(item.actionName == actionName)return true;
			else return false;
		});
		if(disVor.length>0)
		{
			for each(var ab:ActionBean in disVor)
			{
				var ia:IAction = ab.actionIns;
				_injectManager.inject(ia);
				if(ia.execute(actionName,data))
				{
					if(successFun!=null)successFun.apply(null,null);
					Log.getLogger(FilterDispatcher).info("[Controller] 执行Acion  " + actionName + "请求成功. Data " + data);	
				}
				   
				else
				{
					if(failFun!=null)failFun.apply(null,null);
					Log.getLogger(FilterDispatcher).error("[Controller] 执行Acion  " + actionName + "请求失败. Data " + data);	
				}
					
			}
		}
	}
}

class ActionBean{
	public var actionName:String;
	public var actionIns:IAction;
	public function ActionBean(name:String,ins:IAction)
	{
		actionName = name;
		actionIns = ins;
	}
}