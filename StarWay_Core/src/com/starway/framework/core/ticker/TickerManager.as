package com.starway.framework.core.ticker
{
	public class TickerManager
	{	
		//存放计时器数组    
		public var tickerList:Array = [];
		
		public function TickerManager()
		{
			
		}
	
		/**
		 * 静态实例 
		 */	
		private static var _instance:TickerManager = new TickerManager();
		
		public static function getInstance():TickerManager
		{
			if(_instance==null)
				_instance = new TickerManager();
			return _instance;
		}
		
		public function get length():int
		{
			return tickerList.length;
		}
		/**
		 * 每帧进入一次检查 
		 * @param dtime
		 * 
		 */	
		public function doTick(dtime:Number):void
		{
			for each (var ticker:TickerBase in tickerList)
			{
				ticker.doTick(dtime);
			}
		}
		/**
		 * 将计时器加入到计时器列表 
		 * @param ticker
		 * 
		 */	
		public function addTicker(ticker:TickerBase):void
		{
			if(!contains(ticker))
			tickerList.push(ticker);
		}
		/**
		 * 是否已经存在 
		 * @param ticker
		 * @return 
		 * 
		 */		
		public function contains(ticker:TickerBase):Boolean
		{
			return tickerList.some(function (item:*,index:int,array:Array):Boolean
			{
				if(item == ticker)
					return true;
				else 
					return false;
			});
		}
		
		public function getTicker(timeFun:Function):TickerBase
		{
			var ticker:TickerBase;
			var res:Boolean=false;
			for(var i:int=0;i<tickerList.length;i++)
			{
				ticker = tickerList[i];
				if(ticker.timerFunc == timeFun)
				{
					res = true;
					break;
				}
			}
			return res ? ticker : null;
		}
		/**
		 * 删除计时器 
		 * @param ticker
		 * 
		 */	
		public function removeTicker(ticker:TickerBase):void
		{
			for(var i:int=0;i<tickerList.length;i++)
			{
				if(tickerList[i] == ticker)
				{
					tickerList.splice(i,1);
					break;
				}
			}
		}
    }
}