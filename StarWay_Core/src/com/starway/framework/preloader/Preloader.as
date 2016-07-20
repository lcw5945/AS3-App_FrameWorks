package com.starway.framework.preloader
{
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	/**
	 * @author Cray 
	 * @version 1.0
	 * @date Oct 22, 2014 10:01:41 AM
	 */	
	
	public class Preloader extends Sprite  implements IPreloaderSkinnable
	{
		
		/**
		 * 进度加载监听器 
		 */	    
		private var _progressTimer:Timer;
		private var _percentValue:Number = 100;
        private var _dispayText:TextField;
		public function Preloader() 
		{
		}
		/**
		 * 初始化 
		 * 
		 */		
		public function initialize():void
		{
			if(!_displayClass)
			{
				_dispayText = new TextField();
				_dispayText.width = 100;
				_dispayText.height = 30;
				_dispayText.text = "loading......";
				
				addChild(_dispayText);
			}
			
			_progressTimer = new Timer(10);
			_progressTimer.addEventListener(TimerEvent.TIMER, timerHandler);
			_progressTimer.start();
		}
		/**
		 * 每10毫秒检查加载进度
		 * 如果完成则删除监听器 
		 * @param event
		 * 
		 */		
		private function timerHandler(event:TimerEvent):void
		{
			if (!root)
				return;
			
			var li:LoaderInfo = root.loaderInfo;
			var loaded:int = li.bytesLoaded;
			var total:int = li.bytesTotal;
			if(loaded >= total)
			{			
				_progressTimer.stop();
				_progressTimer.removeEventListener(TimerEvent.TIMER,timerHandler);
				_progressTimer = null;
				this.dispatchEvent(new Event(Event.COMPLETE));
			}			
			setProgress(Math.round(loaded/total)*_percentValue);
		}
		/**
		 * 设置进度
		 * 如果有自定义皮肤则调用设置进度方法
		 * @param value
		 * 
		 */		
		public function setProgress(value:Number):void 
		{
			if(_displayClass)
				_displayClass.setProgress(value);
			else
				_dispayText.text = "load: "+ value;
		}
		/**
		 * 设置进度条百分比，默认值100，切最大值也是100
		 * @param value
		 * 
		 */		
		public function set percentValue(value:Number):void
		{
			if(value>100 || value<1)return;
			_percentValue = value;
		}
		/**
		 * 设置自定义进度皮肤
		 */		
		private var _displayClass:IPreloaderSkinnable;
		public function set preloader(displayclass:Class):void
		{
			_displayClass = new displayclass();
			this.addChild(_displayClass as DisplayObject);
		}
	}
}
