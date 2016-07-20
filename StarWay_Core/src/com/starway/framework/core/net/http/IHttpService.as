package com.starway.framework.core.net.http
{
	import flash.utils.ByteArray;

	/**
	 * 
	 * @author Cray
	 * 
	 */	
	public interface IHttpService
	{
		function get successFunc():Function
		function set successFunc(value:Function):void
		/**
		 * 请求失败函数 
		 */
		function get failFunc():Function
		function set failFunc(value:Function):void
		/**
		 * 设置通信方式 get or post 
		 * @return 
		 * 
		 */		
		function get method():String	
		function set method(value:String):void
		/**
		 * 设置返回结果格式 
		 * @return 
		 * 
		 */		
		function get resultFormat():String
		function set resultFormat(rf:String):void
		/**
		 * 设置通信地址 
		 * @return 
		 * 
		 */		
		function get url():String	
		function set url(value:String):void
		/**
		 * 文本数据通信 
		 * @param url
		 * @param params
		 * @param method
		 * @param resultFormat
		 * @param successFunc
		 * @param failFunc
		 * method = {post,PSOT,get,GET} --> HTTPRequestMessage 默认GET
		 * resultFormat = {text,xml,json,variables,bytearray} --> HTTPResponseMessage; 默认json
		 */		
		function send(url:String=null, parameters:Object=null,successFunc:Function=null, failFunc:Function=null, method:String=null,resultFormat:String=null):void
		/**
		 * 数据上传 
		 * @param url
		 * @param bytes
		 * @param params
		 * @param filename
		 */			
		function uploadFile(url:String, bytes:ByteArray, filename:String , parameters:Object=null, successFunc:Function=null, failFunc:Function=null):void
		/**
		 * 下载文本文件
		 * @param url
		 * @param successFunc
		 * @param failFunc
		 * 
		 */			
		function loadFile(url:String=null, successFunc:Function=null, failFunc:Function=null):void
		/**
		 * 下载资源文件(图片，swf等);
		 * @param url
		 * @param successFunc
		 * @param failFunc
		 * 
		 */			
		function loadAssets(url:String=null, successFunc:Function=null, failFunc:Function=null):void
	}

}