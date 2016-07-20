package com.starway.framework.core.manager
{
	import com.starway.framework.core.module.IModuleInfo;

	/**
	 * @author Cray
	 * @version 1.0
	 * @date Oct 28, 2014 10:54:36 AM
	 */
	public interface IModuleBeanInfo
	{
		function get index():Number;
		function get layerIndex():Number;
		function set layerIndex(value:Number):void;
		function get name():String;
		function get autoAddStage():Boolean;
		function get autoLoad():Boolean;
		function get priorityLoad():Boolean;
		function get needLayout():Boolean;
		function set needLayout(value:Boolean):void;
		function get absoluteLayout():Boolean;
		function get mouseEnable():Boolean;
		function get delayLoadTime():Number;
		function set delayLoadTime(value:Number):void;
		function get center():Number;
		function set center(value:Number):void;
		function get middle():Number;
		function set middle(value:Number):void;
		function get top():Number;
		function set top(value:Number):void;
		function get bottom():Number;
		function set bottom(value:Number):void;
		function get left():Number;
		function set left(value:Number):void;
		function get right():Number;
		function set right(value:Number):void;
		function get moduleInfo():IModuleInfo;
		function set moduleInfo(module:IModuleInfo):void;
	}
}