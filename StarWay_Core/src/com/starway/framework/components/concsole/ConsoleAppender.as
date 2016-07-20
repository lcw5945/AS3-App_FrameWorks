package com.starway.framework.components.concsole
{
	
	import com.starway.flash.core.components.common.Button;
	import com.starway.framework.components.RichText;
	import com.starway.framework.core.ApplicationGlobals;
	import com.starway.framework.core.log.LogLevel;
	import com.starway.framework.core.manager.LayoutManager;
	import com.starway.framework.utils.FontUtils;
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.System;
	
	/**
	 * @author Cray: 
	 * @version 创建时间：Oct 1, 2014 7:17:32 PM
	 */
	public class ConsoleAppender extends Sprite implements IConsoleAppender
	{
		//log显示对象
		private var _textDisply:RichText;
		//控制对象
		private var _controlDisply:Sprite;
		//按钮
		private var _closeButton:Button;
		private var _copyButton:Button;
		
		private var _maxMsg:int = 600;
		
		private var _msgArray:Vector.<Object> = new Vector.<Object>;
		
		public function ConsoleAppender()
		{
			super();
			_textDisply = new RichText();
			_textDisply.backgroundAlpha = 0;
			_textDisply.fontColor = "#424242F";
			_textDisply.fontFamily = FontUtils.getDefaultFontNotSysFont();
			_textDisply.fontSize = 12;
			this.addChild(_textDisply);
			_textDisply.y = 20;
			
			_closeButton = new Button();
			_closeButton.label = "关闭";
			_closeButton.addEventListener(MouseEvent.CLICK,closeButtonClickHandler);
			this.addChild(_closeButton);
			
			_copyButton = new Button();
			_copyButton.label = "复制";
			_copyButton.addEventListener(MouseEvent.CLICK,copyButtonClickHandler);
			this.addChild(_copyButton);
			
			stageResizeHandler(null);
			
			ApplicationGlobals.application.stage.addEventListener(Event.RESIZE, stageResizeHandler);			
			this.addEventListener(Event.ADDED_TO_STAGE,addStageHandler);
		}
		/**
		 * 舞台大小改变 
		 * @param event
		 * 
		 */		
		private function stageResizeHandler(event:Event):void
		{
			_textDisply.measureWidth = ApplicationGlobals.application.stage.stageWidth;
			_textDisply.measureHeight = ApplicationGlobals.application.stage.stageHeight - 60;
			
		    LayoutManager.setPosition(_copyButton,(ApplicationGlobals.application.stage.stageWidth - _copyButton.width)/2 - 50,ApplicationGlobals.application.stage.stageHeight - _copyButton.height);			
			LayoutManager.setPosition(_closeButton,(ApplicationGlobals.application.stage.stageWidth - _closeButton.width)/2 + 50,ApplicationGlobals.application.stage.stageHeight - _closeButton.height);
			
			this.graphics.clear();
			this.graphics.beginFill(0xC8D1DA,0.95);
			this.graphics.drawRect(0,0,ApplicationGlobals.application.stage.stageWidth,ApplicationGlobals.application.stage.stageHeight);
			this.graphics.endFill();
		}
		
		/**
		 * 添加到舞台开始显示日志 
		 * @param event
		 * 
		 */		
		private function addStageHandler(event:Event):void
		{
			if(!ApplicationGlobals.application.getEventDispatcher().hasEventListener(ConsoleEvent.CHANGELEVEL,changeLevelHandler))
			ApplicationGlobals.application.getEventDispatcher().addEventListener(ConsoleEvent.CHANGELEVEL,changeLevelHandler);
			
			for each(var msObj:Object in _msgArray)
			{
				if(levelValidate(msObj.level))
					displayLog(msObj.message);
			}			
		}
		/**
		 * 
		 * @param event
		 * 
		 */		
		private function changeLevelHandler(event:ConsoleEvent):void
		{
			if(PropertyConfigurator.logConf.hasOwnProperty("level"))
			{
				PropertyConfigurator.logConf["level"] = event.level;
				_textDisply.text = "";
				addStageHandler(null);
			}
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */		
		private function closeButtonClickHandler(event:MouseEvent):void
		{
			if(ApplicationGlobals.application.stage.contains(this))
				TweenMax.fromTo(this,0.5,{y:0},{y:-600,alpha:0,onComplete:complete});
		}
		
		private function copyButtonClickHandler(event:MouseEvent):void
		{
			var clipText:String = "";
			for each(var msObj:Object in _msgArray)
			{
				if(levelValidate(msObj.level))
					clipText += msObj.message+ " \r\n";
			}
			
			System.setClipboard(clipText);
		}

		
		private function complete():void
		{
			ApplicationGlobals.application.stage.removeChild(this);
			this.y = 0;
			this.alpha = 1;
			_textDisply.text = "";
		}
		
		/**
		 * 控制台输出 
		 * 根据级别选择输出信息
		 * @param category
		 * @param level
		 * @param message
		 * 
		 */	    
		public function outputConsole(category:String,level:int,message:String):void
		{
			var msg:String;
			if(level == LogLevel.DEBUG)
				msg = "" + getTime() + " <font color='#009900'>[" +escape(level) + "]</font> " + " [" + category + "] " + message;
			else if(level == LogLevel.WARN)
				msg = "" + getTime() + " <font color='#FF9900'>[" +escape(level) + "]</font> " + " [" + category + "] " + message;
			else if(level == LogLevel.ERROR)
				msg = "" + getTime() + " <font color='#FF3333'>[" +escape(level) + "]</font> " + " [" + category + "] " + message;
			else if(level == LogLevel.FATAL)
				msg = "" + getTime() + " <font color='#FF0000'>[" +escape(level) + "]</font> " + " [" + category + "] " + message;
			else
				msg = getTime() + " [" +escape(level) + "] " + " [" + category + "] " + message;
			_msgArray.push({"level":level,"message":msg});
			if(_msgArray.length > _maxMsg)
				_msgArray.shift();
			
			if(PropertyConfigurator.logConf && PropertyConfigurator.logConf.target == "trace")
				trace(msg);
		}
		/**
		 * 显示日志输出 
		 * @param msg
		 * 
		 */		
		private function displayLog(msg:String):void
		{
			_textDisply.appendText(msg);
			_textDisply.displayTop(true);
		}
		/**
		 * 等级验证 
		 * @param level
		 * @return 
		 * 
		 */		
		private function levelValidate(level:int):Boolean
		{			
			if(PropertyConfigurator.logConf==null)return true;
			else if(PropertyConfigurator.logConf.hasOwnProperty("level"))
				return escape(PropertyConfigurator.logConf.level) <= level ? true:false;
			else
				return true;
		}
		/**
		 * 日志级别转义 
		 * @param value
		 * @return 
		 * 
		 */		
		private function escape(value:*):*
		{
			var result:*;
			if(value is int)
			{
				switch(value)
				{
					case LogLevel.DEBUG:
					{
						result = "DEBUG";
						break;
					}
					case LogLevel.INFO:
					{
						result = "INFO";
						break;
					}
					case LogLevel.WARN:
					{
						result = "WARN";
						break;
					}
					case LogLevel.ERROR:
					{
						result = "ERROR";
						break;
					}
					case LogLevel.FATAL:
					{
						result = "FATAL";
						break;
					}
				    default :
					{
						result = "DEBUG";
						break;
					}
				}
			}else if(value is String)
			{
				value = String(value).toLocaleUpperCase();
				switch(value)
				{
					case "DEBUG":
					{
						result = LogLevel.DEBUG;
						break;
					}
					case "INFO":
					{
						result = LogLevel.INFO;
						break;
					}
					case "WARN":
					{
						result = LogLevel.WARN;
						break;
					}
					case "ERROR":
					{
						result = LogLevel.ERROR;
						break;
					}
					case "FATAL":
					{
						result = LogLevel.FATAL;
						break;
					}
					default :
					{
						result = LogLevel.DEBUG;
						break;
					}
				}
			}
			
			return result;
		}
		
		/**
		 * 日志输出级别 默认为DEBUG
		 */		
		private var _logLevel:int = LogLevel.DEBUG;
		public function set logLevel(value:int):void
		{
			_logLevel = value;
		}
		
		/**
		 * 日志信息发出时间
		 * 
		 */		
		private static function getTime():String {
			var times:String = "";
			var d:Date = new Date();
//			times = String(d.milliseconds);
			times = String(d.seconds) + ":" + times;
			times = String(d.minutes) + ":" + times;
			times = String(d.hours) + ":" + times;
			return times;
		}
	}
}