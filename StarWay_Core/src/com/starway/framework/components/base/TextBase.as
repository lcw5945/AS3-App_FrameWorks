package com.starway.framework.components.base
{
	import com.starway.framework.utils.HtmlUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;

	public class TextBase extends Sprite implements IDisplayText
	{	
		private var _backgroundShape:Shape;
		
		public function TextBase()
		{
			super();
			
			_backgroundShape = new Shape();
			addChild(_backgroundShape);
		}
		

		/**
		 * textline 数组 
		 */
		private var _textLines:Vector.<DisplayObject> = new Vector.<DisplayObject>();
		public function get textLines():Vector.<DisplayObject>
		{
			return _textLines;
		}

		/**
		 * @private
		 */
		public function set textLines(value:Vector.<DisplayObject>):void
		{
			_textLines = value;
		}

		
		/**
		 * 文本 
		 */		
		public var _text:String;

		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			_text = value;
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
			_backgroundColor = value;
			//更新背景
			updateBackground();
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
			_backgroundAlpha = value;
			//更新背景
			updateBackground();
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
			_measureWidth = value;
			//更新背景
			updateBackground();
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
			_measureHeight = value;
			//更新背景
			updateBackground();
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
		
		/**
		 * 0x000000
		 * 1.0 
		 * @param backgroundColor
		 * @param backgroundAlpha
		 * 
		 */        
		private function updateBackground():void
		{
			var color:int = HtmlUtil.colorStrToInt(backgroundColor);
			
			var g:Graphics = _backgroundShape.graphics;
			g.clear();
			g.beginFill(color, backgroundAlpha);
			g.drawRect(0, 0, measureWidth, measureHeight);
			g.endFill();
		}
		/**
		 * 清空textline数组 
		 * 
		 */		
		public function clear():void
		{
			while(_textLines.length>0)
			{
				_textLines.pop();
			}
		}
	}
}