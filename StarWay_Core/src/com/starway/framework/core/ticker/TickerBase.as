package com.starway.framework.core.ticker
{
	/**
	 * @author Cray
	 * 
	 * 计时器的基类
	 */
	public class TickerBase
	{
		public var timerFunc:Function;
		public var compFunc:Function;
		
		public function TickerBase(tf:Function = null, cf:Function = null)
		{
			timerFunc = tf;
			compFunc = cf;   
		}
		/**
		 *开始计时器 
		 * 
		 */		
		public function start():void
		{
			TickerManager.getInstance().addTicker(this);
		}
		/**
		 * 停止计时器 
		 * 将计时器从列表中删除
		 */		
		public function stop():void
		{
			TickerManager.getInstance().removeTicker(this);
		}
		/**
		 * 重置 
		 * 
		 */		
		public function reset():void
		{
		}
		/**
		 * 检查 
		 * @param dtime
		 * 
		 */		
		public function doTick(dtime:Number):void
		{
		}
		/**
		 * 计时器完成处理  
		 * 
		 */		
		public function dispose():void
		{
			stop();
			reset();
			timerFunc = null;
			compFunc = null;
		}
	}
}