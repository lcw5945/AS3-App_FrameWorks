package com.starway.framework.core.log
{
	import flash.utils.getQualifiedClassName;

	/**
	 * 
	 * @author Cray
	 * 
	 */	
	public class Log
	{
		/**
		 * 按照类别存储日志信息 
		 */		
		private static var _loggers:Array;
		
		public function Log()
		{
		}
		/**
		 * 获得日志
		 * Log.getLogger(getQualifiedClassName(this))
		 * @param clsName -->类的实例对象，或者是类
		 * Eg： Class A{
		 *     public function testLog():void
		 *     {
		 *         Log.getLogger(this).info(msg);
		 *         //or
		 *         //Log.getLogger("A").info(msg);
		 *         //or
		 *          //Log.getLogger(A).info(msg);
		 *     }
		 * }
		 * 注意如果在闭合函数中不能用this，因为this会指向当前闭合函数对象，而不是自定义类对象
		 * Eg：
		 *  var timer:Timer = new Timer(1000,1);
		 *		timer.addEventListener(TimerEvent.TIMER_COMPLETE,function timerCompleteHandler(event:TimerEvent):void
		 *		{
		 *           //ClassName 自定义类， 不要写this
		 *           Log.getLogger(ClassName).info(msg);
		 *  });
		 *
		 * @return 
		 * 
		 */		
		public static function getLogger(clsName:Object):ILogger
		{
			var category:String = getQualifiedClassName(clsName);
			if (!_loggers)
				_loggers = [];
			
			var result:ILogger = _loggers[category];
			if (result == null)
			{
				result = new Logger(category);
				_loggers[category] = result;
			}
			
			return result;
		}
		
		/**
		 * 清空内容日志
		 * 
		 */		
		public static function flush():void
		{
			_loggers = [];
		}
	}
}