package com.starway.framework.core.ticker
{
	public class FrameTicker extends TickerBase
	{
		private var _totalCount:int;
		private var _tickCount:int;
		private var _frequency:int;
		private var _repeatCount:int;
		
		public function FrameTicker(frequency:int = 1, repeatCount:int = 0, timerFunc:Function = null, compFunc:Function = null)
		{
			super(timerFunc, compFunc);
			_frequency = Math.max(1, frequency);
			_repeatCount = Math.max(0, repeatCount);
			
			reset();
		}
		
		override public function reset():void
		{
			_tickCount = 0;
		}
		
		override public function doTick(dtime:Number):void
		{
			++_tickCount;
			
			if (_tickCount == _frequency)
			{
				_tickCount = 0;
				++_totalCount;
				if (timerFunc != null)
				{
					timerFunc();
				}
				if (_repeatCount > 0 && _totalCount >= _repeatCount)
				{
					if (compFunc != null)
					{
						compFunc();
					}
					dispose();
				}
			}
		}
	}
}