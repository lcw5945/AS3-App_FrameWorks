package com.starway.framework.core.log
{
	/**
	 *  
	 * @author Cray
	 * 
	 * 日志等级定义5个等级 由低到高一次为
	 * debug -- 调试
	 * info  -- 信息
	 * warn -- 警告
	 * error -- 错误
	 * fatal -- 致命
	 *  
	 * 根据实际情况选择哪种等级输出到日志
	 * debug 等级最低，供开发阶段使用
	 * 发布版本 日志信息中默认显示 info级别以上信息
	 */	
	public interface ILogger
	{
		/**
		 * 
		 * @return 
		 * 
		 */		
		function get category():String;
		/**
		 * 写日志
		 * @param level  类LogLevel定义值
		 * @param mesages 消息内容
		 * 
		 */		
		function log(level:int,mesages:*):void;
		/**
		 * 
		 * @param message 消息内容
		 * 
		 */		
		function info(...args):void;
		/**
		 * 
		 * @param message 消息内容
		 * 
		 */		
		function debug(...args):void; 
		/**
		 * 
		 * @param message 消息内容
		 * 
		 */		
		function warn(...args):void;
		/**
		 * 
		 * @param message 消息内容
		 * 
		 */		
		function error(...args):void;
		/**
		 * 
		 * @param message 消息内容
		 * 
		 */		
		function fatal(...args):void;
	}
}