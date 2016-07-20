package com.starway.framework.core.inject
{
	import com.starway.framework.core.entity.IEntityModle;
	import com.starway.framework.core.manager.IModuleBeanInfo;
	
	import flash.utils.Dictionary;
	
	/**
	 * @author Cray 
	 * @version 1.0
	 * @date Nov 7, 2014 1:07:59 PM
	 */
	public class InjectGlobals
	{
		public static var modBeansVector:Vector.<IModuleBeanInfo>;
		public static var contextContanier:Object;
		public static var entityBeanMaps:Vector.<IEntityModle>;
		public static var keyObjectPoolDic:Dictionary;
	}
}