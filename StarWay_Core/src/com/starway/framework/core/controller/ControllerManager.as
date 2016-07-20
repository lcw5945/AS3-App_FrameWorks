package com.starway.framework.core.controller
{
	
	
	/**
	 * @author Cray 
	 * @version 1.0
	 * @date Nov 5, 2014 9:14:44 AM
	 */
	public class ControllerManager
	{
		public  static var controllerIns:Object;
		
		public static function startUpAction():void
		{
			controllerIns.startUp();
		}
		
		public static function onModuleLoaded(name:String):void
		{
			controllerIns.onModuleLoaded(name);
		}
	}
}