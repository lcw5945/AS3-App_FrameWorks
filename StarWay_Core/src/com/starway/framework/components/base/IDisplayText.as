package com.starway.framework.components.base
{
	/**
	 * @author Cray 
	 * @version 1.0
	 * @date Oct 3, 2014 7:42:14 PM
	 */
	public interface IDisplayText
	{
		
		function get text():String;
		function set text(value:String):void;
		
		function get rowSpace():Number;
		function set rowSpace(value:Number):void;
		
		function get backgroundColor():String;
		function set backgroundColor(value:String):void;
		
		function get backgroundAlpha():Number;
		function set backgroundAlpha(value:Number):void;
		
		function get measureWidth():Number;
		function set measureWidth(value:Number):void;
		
		function get measureHeight():Number;
		function set measureHeight(value:Number):void;
	}
}