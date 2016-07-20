package com.starway.framework.core.net.scoket
{
	/**
	 * 
	 * @author Cray
	 * 
	 */	
	public interface IScoketService
	{
		function send(type:*,data:Object):void;
		
		function listen(type:*,completeFunc:Function):void;
		
		function remove(type:*,completeFunc:Function):void;
	}
}