package com.starway.framework.components.base
{
	/**
	 * @author Cray
	 * @version 1.0
	 * @date Oct 9, 2014 7:38:22 PM
	 */
	public interface IEditableText extends IDisplayText
	{
		function get editable():Boolean;
		function set editable(value:Boolean):void;
		
		function get enabled():Boolean;
		function set enabled(value:Boolean):void;
		

		function get maxChars():int;
		function set maxChars(value:int):void;
		

		function get multiline():Boolean;
		function set multiline(value:Boolean):void;

		
		function get restrict():String;
		function set restrict(value:String):void;
		

		function get selectable():Boolean;
		function set selectable(value:Boolean):void;
		
		function appendText(text:String):void;
		
		function get verticalScrollPosition():Number;
		function set verticalScrollPosition(value:Number):void;
		
		function get horizontalScrollPosition():Number;
		function set horizontalScrollPosition(value:Number):void;
	}
}