package com.starway.framework.components
{
	import com.starway.framework.components.base.IEditableText;
	
	import flash.display.Sprite;
	
	
	/**
	 * @author Cray 
	 * @version 1.0
	 * @date Oct 9, 2014 7:42:14 PM
	 */
	public class RichEditableText extends Sprite implements IEditableText
	{
		public function RichEditableText()
		{
			super();
		}
		
		public function get editable():Boolean
		{
			return false;
		}
		
		public function set editable(value:Boolean):void
		{
		}
		
		public function get enabled():Boolean
		{
			return false;
		}
		
		public function set enabled(value:Boolean):void
		{
		}
		
		public function get maxChars():int
		{
			return 0;
		}
		
		public function set maxChars(value:int):void
		{
		}
		
		public function get multiline():Boolean
		{
			return false;
		}
		
		public function set multiline(value:Boolean):void
		{
		}
		
		public function get restrict():String
		{
			return null;
		}
		
		public function set restrict(value:String):void
		{
		}
		
		public function get selectable():Boolean
		{
			return false;
		}
		
		public function set selectable(value:Boolean):void
		{
		}
		
		public function appendText(text:String):void
		{
		}
		
		public function get verticalScrollPosition():Number
		{
			return 0;
		}
		
		public function set verticalScrollPosition(value:Number):void
		{
		}
		
		public function get horizontalScrollPosition():Number
		{
			return 0;
		}
		
		public function set horizontalScrollPosition(value:Number):void
		{
		}
		
		public function get text():String
		{
			return null;
		}
		
		public function set text(value:String):void
		{
		}
		
		/**
		 * 背景颜色 
		 */		
		private var _backgroundColor:String = "#ffffff";
		
		public function get backgroundColor():String
		{
			return _backgroundColor;
		}
		
		public function set backgroundColor(value:String):void
		{
	
		}
		/**
		 * 背景透明度 
		 */        
		private var _backgroundAlpha:Number = 1;
		
		public function get backgroundAlpha():Number
		{
			return _backgroundAlpha;
		}
		
		public function set backgroundAlpha(value:Number):void
		{

		}
		
		/**
		 * 默认宽度 
		 */		
		private var _measureWidth:Number = 300;
		
		public function get measureWidth():Number
		{
			return _measureWidth;
		}
		
		public function set measureWidth(value:Number):void
		{

		}
		/**
		 * 默认高度 
		 */		
		private var _measureHeight:Number = 200;
		
		public function get measureHeight():Number
		{
			return _measureHeight;
		}
		
		public function set measureHeight(value:Number):void
		{

		}
		
		/** 行间距 **/ 
		private var _rowSpace:int = 8;
		public function get rowSpace():Number
		{
			return _rowSpace;
		}
		public function set rowSpace(value:Number):void
		{
			_rowSpace = value;
		}
	}
}