package com.starway.framework.core.objpool.ibase
{
	/**
	 * @author Cray
	 * @version 1.0
	 * @date Oct 28, 2014 4:24:59 PM
	 */
	public interface IKeyObjectPool extends IBaseObjectPool
	{
		function addObject(key:String,obj:IObject):void;
		function borrowObject(key:String):IObject;
		function returnObject(obj:IObject):void;
	}
}