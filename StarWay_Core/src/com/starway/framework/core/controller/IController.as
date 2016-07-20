package com.starway.framework.core.controller
{
	/**
	 * @author Cray
	 * @version 1.0
	 * @date Oct 17, 2014 11:40:12 AM
	 */
	public interface IController
	{
//		function request(actionName:String,data:Object=null,successFun:Function=null,failFun:Function=null):void;
		function registerAction(action:Class):void;
		function startUp():void;
	}
}