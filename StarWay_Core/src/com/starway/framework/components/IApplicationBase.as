package com.starway.framework.components
{
	import flash.display.Stage;

	public interface IApplicationBase
	{
		/******************************************
		 * 属性
		 *******************************************/		
		/**
		 * 版本 
		 * @return 
		 * 
		 */		
		function get version():String;
		/**
		 * 设置宽度 
		 * @param value
		 * 
		 */		
		function set measuredWidth(value:Number):void;
		/**
		 * 获得宽度 
		 * @return 
		 * 
		 */		
		function get measuredWidth():Number;
		/**
		 * 设置高度 
		 * @param value
		 * 
		 */		
		function set measuredHeight(value:Number):void;
		/**
		 * 获得高度 
		 * @return 
		 * 
		 */		
		function get measuredHeight():Number;
		
		/**
		 * 舞台对象
		 */	
		function get stage():Stage;			
		/**
		 *获得URL属性值
		 */		
		function get url():String;
		/**
		 * 获得Parameters属性值 
		 */	
		function get parameters():Object;
	}
}