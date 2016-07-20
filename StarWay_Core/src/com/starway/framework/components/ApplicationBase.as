package com.starway.framework.components
{
	import flash.display.Sprite;
	
	public class ApplicationBase extends Sprite implements IApplicationBase
	{
		public function ApplicationBase()
		{
			
		}
		
		private var _version:String = null;
		
		/******************************************
		 * 属性
		 *******************************************/		
		
		/**
		 * 版本号
		 */
		public function set version(value:String):void
		{
			_version = value;
		}
		/**
		 * 版本 
		 * @return 
		 * 
		 */		
		public function get version():String
		{
			return _version;
		}
		
		/**
		 * 存储URL属性值
		 */		
		internal var _url:String;
		
		public function get url():String
		{
			return _url;
		}
		/**
		 * 存储Parameters属性值 
		 */		
		internal var _parameters:Object;
		
		public function get parameters():Object
		{
			return _parameters;
		}
		
		/**
		 * 默认宽度 
		 */		
		private var _measuredWidth:Number = 1064;
		
		public function get measuredWidth():Number
		{
			return _measuredWidth;
		}
		
		public function set measuredWidth(value:Number):void
		{
			_measuredWidth = value;
		}
		/**
		 * 默认高度 
		 */        
		private var _measuredHeight:Number = 600;
		
		public function get measuredHeight():Number
		{
			return _measuredHeight;
		}
		
		public function set measuredHeight(value:Number):void
		{
			_measuredHeight = value;
		}
	}
}