package com.starway.framework.core.context
{
	/**
	 * @author Cray
	 */
	public interface IApplicationContext
	{
		 /**
		  * 注册上下文  context可以是Class 也可以是 Instence
		  * @param name 
		  * @param context
		  * 
		  */		
		 function registerContext(name:String, classObject:Object):void;
		 /**
		  * 获得上下文对象 
		  * @param name
		  * @return 
		  * 
		  */			 
		 function getContext(name:String):*;
	}
}