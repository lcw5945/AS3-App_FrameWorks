package com.starway.framework.core.module
{
	/**
	 * 模块管理类
	 * 加载模块，返回模块实例化信息
	 * @author Cray
	 * 
	 */    
	public class ModuleManager
	{	
		public function ModuleManager()
		{
		}
		/**
		 * 加载模块
		 * 返回模块信息接口对象 
		 * @param url
		 * @return 
		 * 
		 */		
		public static function getModule(url:String):IModuleInfo
		{
			return getSingleton().getModule(url);
		}
		/**
		 * 返回一个全局模块管理类对象 
		 * @return 
		 * 
		 */		
		private static function getSingleton():Object
		{
			if (!ModuleManagerGlobals.managerSingleton)
				ModuleManagerGlobals.managerSingleton = new ModuleManagerImpl();
			
			return ModuleManagerGlobals.managerSingleton;
		}
	}
}
/**
 * 模块管理实现类 
 * @author Cray
 * 
 */	
import com.starway.framework.common.LoaderConfig;
import com.starway.framework.core.ApplicationGlobals;
import com.starway.framework.core.events.ModuleEvent;
import com.starway.framework.core.log.Log;
import com.starway.framework.core.module.IModuleInfo;
import com.starway.framework.utils.URLUtil;

import flash.display.DisplayObject;
import flash.display.Loader;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.system.Security;
import flash.system.SecurityDomain;
import flash.utils.ByteArray;
import flash.utils.Dictionary;

class ModuleManagerImpl extends EventDispatcher
{
	private var moduleDictionary:Dictionary = new Dictionary(true);
	
	public function ModuleManagerImpl()
	{
		super();
	}
	
	public function getModule(url:String):IModuleInfo
	{
		var info:ModuleInfo = null;
		
		for (var m:Object in moduleDictionary)
		{
			var mi:ModuleInfo = m as ModuleInfo;
			if (moduleDictionary[mi] == url)
			{
				info = mi;
				break;
			}
		}
		
		if (!info)
		{
			info = new ModuleInfo(url);
			moduleDictionary[info] = url;
		}
		
		return info;
	}
}

/**
 * 模块信息类
 * @author Cray
 * 
 */	

class ModuleInfo extends EventDispatcher implements com.starway.framework.core.module.IModuleInfo
{
	public function ModuleInfo(url:String)
	{
		super();
		
		_url = url;
	}
	
	private var loader:Loader;
	
	private var _data:Object;
	public function get data():Object
	{
		return _data;
	}
	
	public function set data(value:Object):void
	{
		_data = value;
	}
	
	private var _name:String;

	public function get name():String
	{
		return _name;
	}

	public function set name(value:String):void
	{
		_name = value;
	}

	
	private var _loaded:Boolean = false;
	public function get loaded():Boolean
	{
		return _loaded;
	}
	
	private var _ready:Boolean = false;
	public function get ready():Boolean
	{
		return _ready;
	}
	
	private var _url:String;
	public function get url():String
	{
		return _url;
	}
	
	private var _error:Boolean = false;
	public function get error():Boolean
	{
		return _error;
	}
	
	private var _module:DisplayObject;
	public function get module():DisplayObject
	{
		return _module;
	}
	
	private var _rootURL:String;
	public function get rootURL():String
	{
		if (_rootURL == null)
		{
			_rootURL = LoaderConfig.url;
		}
		return _rootURL;
	}
	
	public function load(applicationDomain:ApplicationDomain = null,
						 securityDomain:SecurityDomain = null,
						 bytes:ByteArray = null):void
	{
		if (_loaded)
			return;
		
		_loaded = true;
		
		//如果bytes数据存在则加载二进制数据而不加载URL
		if (bytes)
		{
			loadBytes(applicationDomain, bytes);
			return;
		}
		
		//返回模块全路径地址
		_url = URLUtil.getFullURL(rootURL,url); //通信地址
		
		var urlReq:URLRequest = new URLRequest(_url);
		
		var c:LoaderContext = new LoaderContext();
		c.applicationDomain =
			applicationDomain ?
			applicationDomain :
			new ApplicationDomain(ApplicationDomain.currentDomain);
		
		// 设置安全域 不允许不在沙箱下运行
		// remote (Security.REMOTE)：此文件来自 Internet URL，并在基于域的沙箱规则下运行
		if (securityDomain != null && Security.sandboxType == Security.REMOTE)
			c.securityDomain = securityDomain;
		
		loader = new Loader();
		
		loader.contentLoaderInfo.addEventListener(
			Event.INIT, initHandler);
		loader.contentLoaderInfo.addEventListener(
			Event.COMPLETE, completeHandler);
		loader.contentLoaderInfo.addEventListener(
			ProgressEvent.PROGRESS, progressHandler);
		loader.contentLoaderInfo.addEventListener(
			IOErrorEvent.IO_ERROR, errorHandler);
		loader.contentLoaderInfo.addEventListener(
			SecurityErrorEvent.SECURITY_ERROR, errorHandler);
		
		loader.load(urlReq, c);
	}
	
	/**
	 * 加载二进制数据 
	 * @param applicationDomain
	 * @param bytes
	 * 
	 */		
	private function loadBytes(applicationDomain:ApplicationDomain, bytes:ByteArray):void
	{
		var c:LoaderContext = new LoaderContext();
		c.applicationDomain =
			applicationDomain ?
			applicationDomain :
			new ApplicationDomain(ApplicationDomain.currentDomain);
		
		loader = new Loader();
		
		loader.contentLoaderInfo.addEventListener(
			Event.INIT, initHandler);
		loader.contentLoaderInfo.addEventListener(
			Event.COMPLETE, completeHandler);
		loader.contentLoaderInfo.addEventListener(
			IOErrorEvent.IO_ERROR, errorHandler);
		loader.contentLoaderInfo.addEventListener(
			SecurityErrorEvent.SECURITY_ERROR, errorHandler);
		
		loader.loadBytes(bytes, c);
	}
	
	/**
	 * 卸载模块
	 * 
	 */		
	public function unload():void
	{
		clearLoader();
		
		if (_loaded)
			ApplicationGlobals.application.getEventDispatcher().dispatchEvent(ModuleEvent.createEvent(ModuleEvent.UNLOAD,null,0,0,this));
		
		_loaded = false;
		_ready = false;
		_error = false;
	}
	
	/**
	 * 模块第一帧初始化完成 
	 * @param event
	 * 
	 */		
	private function initHandler(event:Event):void
	{			
		if (!loader.content)
		{
			ApplicationGlobals.application.getEventDispatcher().dispatchEvent(ModuleEvent.createEvent(ModuleEvent.ERROR,"SWF is not a loadable module",0,0,this));
			//log
			Log.getLogger(ModuleInfo).error("[Module] SWF不是一个可用的模块, SWF="+url);
			return;
		}else
			_module = loader.content;
	}
	
	/**
	 * 加载进度 
	 * @param event
	 * 
	 */		
	private function progressHandler(event:ProgressEvent):void
	{
		ApplicationGlobals.application.getEventDispatcher().dispatchEvent(ModuleEvent.createEvent(ModuleEvent.PROGRESS,null,event.bytesLoaded,event.bytesTotal,this));
	}
	
	
	/**
	 * 模块加载完成 
	 * @param event
	 * 
	 */		
	private function completeHandler(event:Event):void
	{
		_ready = true;
		if(!_module)
			_module = loader.content;
		//event
		ApplicationGlobals.application.getEventDispatcher().dispatchEvent(ModuleEvent.createEvent(ModuleEvent.READY,null,loader.contentLoaderInfo.bytesLoaded,loader.contentLoaderInfo.bytesTotal,this));
		clearLoader();
		//log
		Log.getLogger(ModuleInfo).info("[Module] 模块加载完成  SWF="+url);
	}
	
	/**
	 * 模块加载出错 
	 * @param event
	 * 
	 */		
	private function errorHandler(event:ErrorEvent):void
	{
		_error = true;
		//event
		ApplicationGlobals.application.getEventDispatcher().dispatchEvent(ModuleEvent.createEvent(ModuleEvent.ERROR,event.text,0,0,this));
		//log
		Log.getLogger(ModuleInfo).error("[Module] 模块加载出错, SWF="+url+ " errorText=" + event.text);
	}
	/**
	 * 移除模块监听事件 
	 * 
	 */		
	private function clearLoader():void
	{
		if (loader)
		{
			if (loader.contentLoaderInfo)
			{
				loader.contentLoaderInfo.removeEventListener(
					Event.INIT, initHandler);
				loader.contentLoaderInfo.removeEventListener(
					Event.COMPLETE, completeHandler);
				loader.contentLoaderInfo.removeEventListener(
					ProgressEvent.PROGRESS, progressHandler);
				loader.contentLoaderInfo.removeEventListener(
					IOErrorEvent.IO_ERROR, errorHandler);
				loader.contentLoaderInfo.removeEventListener(
					SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			}				
			
			if (_loaded)
			{
				try
				{				
					//关闭
					loader.close();
				}
				catch(error:Error)
				{
				}
			}
			
			try
			{
				//卸载加载器
				loader.unload();
			}
			catch(error:Error)
			{
			}
			
			loader = null;
		}
	}
}