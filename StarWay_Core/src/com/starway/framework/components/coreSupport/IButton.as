package com.starway.framework.components.coreSupport
{
	/**
	 * @author Cray
	 * @version 1.0
	 * @date Oct 11, 2014 8:31:19 PM
	 */
	public interface IButton
	{
		function set label(value:String):void;
		function get label():String;
		
		function get autoRepeat():Boolean;
		function set autoRepeat(value:Boolean):void;
	}
}