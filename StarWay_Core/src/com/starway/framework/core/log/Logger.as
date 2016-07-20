package com.starway.framework.core.log
{
	import com.starway.framework.components.concsole.IConsoleAppender;
	import com.starway.framework.core.ApplicationGlobals;
	import com.starway.framework.utils.ObjectUtil;

	/**
	 * 
	 * @author Cray
	 * 
	 */	
	public class Logger implements ILogger
	{
		private var _category:String;
		
		public function Logger(category:String)
		{
			_category = category;
		}
		/**
		 * 返回日志类别 (Class Name) 
		 * @return 
		 * 
		 */		
		public function get category():String
		{
			return _category;
		}
		
		/**
		 * 写日志
		 * @param level
		 * @param mesages
		 * @param rest
		 * 
		 */		
		public function log(level:int, message:*):void
		{
			outputConsole(level,message);
		}
		/**
		 * 输出到控制台 
		 * @param level
		 * @param message
		 * @param rest
		 * 
		 */		
		private function outputConsole(level:int, message:*):void
		{
			if(ApplicationGlobals.application){
				var conApp:IConsoleAppender =  ApplicationGlobals.application.getConsoleAppender();
				if(conApp){
					conApp.outputConsole(_category,level,message);
				}
			}
		}
		/**
		 * 拆包成字符串 
		 * @param args
		 * @return 
		 * 
		 */		
		private function serialize(args:Array, res:String = ""):String
		{
			for each(var obj:* in args)
			{
				if(obj is Array){
					res += serialize(obj, res);
				}else if (ObjectUtil.type(obj) == "object"){
					res += ObjectUtil.serializer(obj);
				}else{
					res += obj.toString();
				}
			}
			return res;
		}
		/**
		 * 写入信息日志
		 * @param message
		 * @param rest
		 * 
		 */		
		public function info(...args):void		
		{
			var s:String = serialize(args);
			outputConsole(LogLevel.INFO, serialize(args));
		}
		/**
		 * 写入调试日志
		 * @param message
		 * @param rest
		 * 
		 */
		public function debug(...args):void
		{
			outputConsole(LogLevel.DEBUG, serialize(args));
		}
		/**
		 * 写入警告日志
		 * @param message
		 * @param rest
		 * 
		 */
		public function warn(...args):void
		{
			outputConsole(LogLevel.WARN, serialize(args));
		}
		/**
		 * 写入错误日志
		 * @param message
		 * @param rest
		 * 
		 */
		public function error(...args):void
		{
			outputConsole(LogLevel.ERROR, serialize(args));
		}
		/**
		 * 写入致命错误日志
		 * @param message
		 * @param rest
		 * 
		 */
		public function fatal(...args):void
		{
			outputConsole(LogLevel.FATAL, serialize(args));
		}
	}
}