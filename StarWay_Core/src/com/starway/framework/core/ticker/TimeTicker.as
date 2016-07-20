package com.starway.framework.core.ticker
{	
	/**
	 * @author Cray
	 */
	public class TimeTicker extends TickerBase
	{
		private var _delay:Number;
		private var _repeatCount:int;
		private var _tickTime:Number;
		private var _tickCount:int;
		
		public function TimeTicker(delay:Number, repeatCount:int = 0, timerFunc:Function = null, compFunc:Function = null)
		{
			super(timerFunc, compFunc);
			_delay = Math.abs(delay);
			_repeatCount = Math.max(0, repeatCount);
			
			reset();
		}
		
		override public function reset():void
		{
			_tickCount = 0;
			_tickTime = 0;
		}
		
		override public function doTick(dtime:Number):void
		{
			_tickTime += dtime;
			while (_tickTime >= _delay)
			{
				_tickTime -= _delay;
				++_tickCount;
				if (timerFunc != null)
				{
					timerFunc();
				}
				if (_repeatCount > 0 && _tickCount >= _repeatCount)
				{
					if (compFunc != null)
					{
						compFunc();
					}
					dispose();
					return;
				}
			}
		}
	}
}