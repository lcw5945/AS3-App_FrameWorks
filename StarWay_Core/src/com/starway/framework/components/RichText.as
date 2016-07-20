package com.starway.framework.components
{
	import com.starway.framework.components.base.TextBase;
	import com.starway.framework.utils.TextUtil;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.engine.GroupElement;
	import flash.text.engine.TextBaseline;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextLine;
	import flash.text.engine.TextLineMirrorRegion;

	/**
	 *  
	 * @author Cray
	 * 
	 */	
	public class RichText extends TextBase
	{	
		private var _textContainer:Sprite;
		/** 保存上一个textline对象  **/
		private var _preTextLine:TextLine;
		private var _offsetY:int = 0;
		
		
		public function RichText()
		{
			super();
			_textContainer = new Sprite();
			this.addChild(_textContainer);
			_textContainer.mouseChildren=false;
			_textContainer.mouseEnabled=false;
			
			this.addEventListener(MouseEvent.MOUSE_WHEEL,mouseWheelHandler);
		}
		
		private function mouseWheelHandler(event:MouseEvent):void
		{
			//计算文本容器的高度
			if(_textContainer.height > this.measureHeight)
			{
				_textContainer.y += event.delta*15;
				if(_textContainer.y < this.measureHeight - _textContainer.height)
					_textContainer.y = this.measureHeight - _textContainer.height;
				if(_textContainer.y>0)
					_textContainer.y = 0;
				
			}
		}
		
		public function displayTop(value:Boolean):void
		{
			if(value){
				_textContainer.y = this.measureHeight - _textContainer.height;
			}
		}
		
		/**
		 * 字体颜色 
		 */
		private var _fontColor:String = "#FFFFFF";
		public function get fontColor():String
		{
			return _fontColor;
		}

		/**
		 * @private
		 */
		public function set fontColor(value:String):void
		{
			_fontColor = value;
		}


		/**
		 * 字体大小 
		 */
		private var _fontSize:int = 12;

		public function get fontSize():int
		{
			return _fontSize;
		}

		public function set fontSize(value:int):void
		{
			_fontSize = value;
		}
		/**
		 * 字体类型 
		 */        
		private var _fontFamily:String="Microsoft YaHei,微软雅黑,宋体,Monaco";

		public function get fontFamily():String
		{
			return _fontFamily;
		}

		public function set fontFamily(value:String):void
		{
			_fontFamily = value;
		}
		
		/**
		 * 设置文本内容 
		 * @param value
		 * 
		 */		
		override public function set text(value:String):void
		{
		    //如果为null 设置默认空
			if (value == null)
				value = "";
            //如果值相同不处理
			if (value == _text)
				return;
			_text = value;
			//清楚内容
			this.clear();
			
			analyzeText(value);
		}
		/**
		 * 获得文本内容 
		 * @return 
		 * 
		 */		
		override public function get text():String
		{
			return _text;
		}
		/**
		 * 像原有字符串内容添加新的内容 
		 * @param value
		 * 
		 */		
		public function appendText(value:String):void
		{
			if (value == null)return;
			else if(_text)
			_text = _text.concat(value);
			else _text = value;
			
			analyzeText(value);
		}
		/**
		 * 解析文本 
		 * @param value
		 * 
		 */		
		private function analyzeText(value:String):void
		{
			var groupsVecor:Vector.<GroupElement> = TextUtil.analyzeToGroups(value,fontFamily,fontColor,fontSize);
			for each(var groupElement:GroupElement in groupsVecor)
			{
				appendGroupElement(groupElement);
			}
		}
		
		/**
		 *  添加组元素
		 * @param value
		 * 
		 * 添加可以点击的字符串
		 * 
		 *  var groupVector:Vector.<ContentElement> = new Vector.<ContentElement>();
		 *  var hyperlink:String = "[超链接]"
		 *	//响应鼠标事件
		 *	var eventDP:EventDispatcher = new EventDispatcher;
		 *	eventDP.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutHandler,false,0,true);
		 *	eventDP.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverHandler,false,0,true);
		 *	eventDP.addEventListener(MouseEvent.CLICK,onChannelClk,false,0,true);
		 * 
		 *  设置字体
		 *  var fontDescriptionItalic:FontDescription = new FontDescription("Arial", FontWeight.NORMAL, FontPosture.ITALIC);
		 *  var formatItalic:ElementFormat = new ElementFormat(fontDescriptionItalic);
		 *	formatItalic.fontSize = 12;
		 *	var textElement:TextElement = new TextElement(hyperlink,formatItalic);
		 *	textElement.eventMirror = eventDP;
		 *	groupVector.push(textElement);
		 *	appendGroupElement(new GroupElement(groupVector));
		 * 
		 * 
		 */		
		public function appendGroupElement(value:GroupElement):void
		{
			var textBlock:TextBlock = new TextBlock;
			textBlock.baselineZero =  TextBaseline.IDEOGRAPHIC_CENTER;
			textBlock.content = value;
			
			var textLine:TextLine = textBlock.createTextLine (null, measureWidth);
//			trace(textLine.textBlock.content.text);
			while (textLine)
			{
				textLines.push(textLine);
				//textLine.filters =  [new GlowFilter(0,1,2,2,16)];
				for each (var tlm:TextLineMirrorRegion in textLine.mirrorRegions) 
				{
					//用此变量来作为下划线标志
					if (tlm.element.userData)
					{
						var shape:Shape = new Shape();
						var g:Graphics = shape.graphics;
						g.lineStyle(1,0xd8e5c6);
						g.moveTo(tlm.bounds.left+4, tlm.bounds.bottom+1);
						g.lineTo(tlm.bounds.left+tlm.bounds.width-4, tlm.bounds.bottom+1);
						textLine.addChild(shape);
					}
				}
				//设置行y轴坐标
				textLine.y = _offsetY + textLine.height / 2;
				_textContainer.addChild(textLine);
				//保存最后一个textline
				_preTextLine = textLine;
				//是否存在下一个textline
				textLine = textBlock.createTextLine(_preTextLine, measureWidth);
				//保存下一个textline y轴坐标
				_offsetY += int(_preTextLine.height + rowSpace);
			}
		}
		
		/**
		 *  清除内容
		 **/
		override public function clear():void
		{
			super.clear();
			while(_textContainer.numChildren > 0){
				_textContainer.removeChildAt(0);
			}
			_preTextLine = null;	
			_offsetY = 0;
			_textContainer.y = 0;
		}

	}
}