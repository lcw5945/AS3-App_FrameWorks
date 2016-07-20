package com.starway.framework.core.module
{
	import com.starway.framework.core.manager.IModuleBeanInfo;

	/** 
	 * @author Cray
	 * @version 创建时间：Nov 8, 2014 2:16:26 PM 
	 **/ 
	public interface IModuleProxy
	{
		/**
		 * 对模块设置数据 
		 * @param fun
		 * @param value
		 * 
		 */		
		function invokeFunByData(fun:String,...params):void;
		/**
		 * 调用没有参数函数 
		 * @param fun
		 * 
		 */			
		function invokeFun(fun:String):void;
		/**
		 * 获得模块封装所有信息
		 * @return 
		 * 
		 */		
		function getModuleBeanInfo():IModuleBeanInfo;
		/**
		 * 获得模块信息
		 * @return 
		 * 
		 */		
		function getModuleInfo():IModuleInfo;
	}
}