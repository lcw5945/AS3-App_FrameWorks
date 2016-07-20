package com.starway.framework.core.module
{
	import flash.display.DisplayObject;
	import flash.system.ApplicationDomain;
	import flash.system.SecurityDomain;
	import flash.utils.ByteArray;

	public interface IModuleInfo
	{
		/**
		 * 数据接口 
		 * @return 
		 * 
		 */		
		function get data():Object;
		function set data(value:Object):void;
		
		function get name():String;
		function set name(value:String):void;
		/**
		 * 是否加载过模块 
		 * @return 
		 * 
		 */		
		function get loaded():Boolean;
		/**
		 * 是否加载完成 
		 * @return 
		 * 
		 */		
		function get ready():Boolean;
		/**
		 * 模块地址 
		 * @return 
		 * 
		 */		
		function get url():String;
		/**
		 * 加载是否出错 
		 * @return 
		 * 
		 */	
		function get error():Boolean;
		/**
		 * 模块实例 
		 * @return 
		 * 
		 */		
		function get module():DisplayObject
		/**
		 * 开始加载模块 
		 * @param applicationDomain
		 * @param securityDomain
		 * @param bytes
		 * 
		 */		
		function load(applicationDomain:ApplicationDomain = null,
					  securityDomain:SecurityDomain = null,
					  bytes:ByteArray = null):void;
		/**
		 * 卸载 模块 
		 * 
		 */		
		function unload():void;
	}
}