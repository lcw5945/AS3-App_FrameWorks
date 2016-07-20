package com.starway.framework.core.ticker
{
	import com.starway.framework.core.ApplicationGlobals;
	import com.starway.framework.core.log.Log;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	/**
	 *  
	 * @author Cray
	 * 
	 */    
	public class Ticker implements ITicker
	{
		public static const CONTEXT_NAME:String = "tickerLaunch";
		
		public var tickerMgr:TickerManager = TickerManager.getInstance();
		public var lastTime:Number = 0;

		public function Ticker()
		{
			lastTime = getTimer();
			var timer:Timer = new Timer(10);
			timer.addEventListener(TimerEvent.TIMER,function timerHandler(event:TimerEvent):void
			{
				if(ApplicationGlobals.application && ApplicationGlobals.application.stage)
				{
					timer.stop();
					timer.removeEventListener(TimerEvent.TIMER,timerHandler);
					timer = null;
					ApplicationGlobals.application.stage.addEventListener(Event.ENTER_FRAME, onUpdate);
				}
			});
			timer.start();
		}	
		/**
		 * 进入帧更新时间 
		 * @param event
		 * 
		 */		
		private function onUpdate(event:Event):void
		{
			var time:Number = getTimer();
			var dtime:Number = time - lastTime;
			lastTime = time;
			tickerMgr.doTick(dtime);
		}
		/**
		 * 
		 * @param delay
		 * @param callback
		 * @param repeatCount
		 * @param frame 为true表示是帧计时器
		 */        	
		public function tick(delay:Number, callback:Function = null, repeatCount:int = 1, frame:Boolean=false):void
		{
//			Log.getLogger(this).debug("添加 "+ "Timer: " + callback +" 监听器成功.");
			if(!frame){
				var timerTicker:TimeTicker;
				if(!have(callback))
				{
					timerTicker = new TimeTicker(delay,repeatCount,callback);
					timerTicker.start();
				}
			}else{
				var frameTicker:FrameTicker;
				if(!have(callback))
				{
					frameTicker = new FrameTicker(delay,repeatCount,callback);
					frameTicker.start();
				}
			}
		}
		/**
		 * 
		 * @param timerFunc
		 * @return 
		 * 
		 */	
		public function have(timerFunc:Function = null):Boolean
		{
			var ticker:TickerBase = TickerManager.getInstance().getTicker(timerFunc);
			return ticker || false;
		}
		
		/**
		 * 移除监听器 
		 * @param ticker
		 * 
		 */			
		public function stop(timerFunc:Function = null):void
		{
		    var ticker:TickerBase = TickerManager.getInstance().getTicker(timerFunc);
			if(ticker)
			{
				//log
				Log.getLogger(this).debug("删除 "+ "Timer: " + timerFunc +" 监听器成功.");
				TickerManager.getInstance().removeTicker(ticker);
			}
		}
		
	}
}

