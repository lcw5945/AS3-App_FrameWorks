package com.starway.framework.core.net.http
{
	import com.starway.framework.core.net.http.HttpOperation;
	import com.starway.framework.core.net.http.IHttpService;
	
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;

	/**
	 * 
	 * @author Cray
	 * 
	 */	
	public class HttpService extends EventDispatcher implements IHttpService
	{
		internal var httpOperation:HttpOperation;
	
		public function HttpService()
		{
			httpOperation = new HttpOperation(this);
		}
		/**
		 * 
		 * **********参数设置函数*******
		 * 
		 */	    
		public function get successFunc():Function
		{
			return httpOperation.successFunc;
		}
		
		public function set successFunc(value:Function):void
		{
			httpOperation.successFunc = value;
		}
		
		/**
		 * 请求失败函数 
		 */
		public function get failFunc():Function
		{
			return httpOperation.failFunc;
		}
		
		/**
		 * @private
		 */
		public function set failFunc(value:Function):void
		{
			httpOperation.failFunc = value;
		}
		/**
		 * 设置通信方式 get or post 
		 * @return 
		 * 
		 */		
		public function get method():String
		{
			return httpOperation.method;
		}
		
		public function set method(value:String):void
		{
			httpOperation.method = value;
		}
		/**
		 * 设置返回结果格式 
		 * @return 
		 * 
		 */		
		public function get resultFormat():String
		{
			return httpOperation.resultFormat;
		}
		public function set resultFormat(rf:String):void
		{
			httpOperation.resultFormat = rf;
		}
		/**
		 * 设置通信地址 
		 * @return 
		 * 
		 */		
		public function get url():String
		{
			return httpOperation.url;
		}
		
		public function set url(value:String):void
		{
			httpOperation.url = value;
		}
		
		public function get request():Object
		{
			return httpOperation.request;
		}
		public function set request(r:Object):void
		{
			httpOperation.request = r;
		}
		/**
		 * 
         *****Over************
		 *封装通信方法
		 */	
		
		/**
		 * 文本数据通信 
		 * @param url
		 * @param params
		 * @param method
		 * @param resultFormat
		 * @param successFunc
		 * @param failFunc
		 * method = {post,PSOT,get,GET} --> HTTPRequestMessage 默认GET
		 * resultFormat = {text,xml,json,variables,bytearray} --> HTTPResponseMessage; 默认text
		 */		
		public function send(url:String=null, parameters:Object=null, successFunc:Function=null, failFunc:Function=null, method:String=null,resultFormat:String=null):void
		{
			if (parameters == null)
				parameters = request;
			
			if(url)
				this.url = url;
			if(method)
				this.method = method;
			if(resultFormat)
				this.resultFormat = resultFormat;
			if(successFunc!=null)
				this.successFunc=successFunc;
			if(failFunc!=null)
				this.failFunc = failFunc;
			
			httpOperation.sendBody(parameters);
		}
		/**
		 * 
		 * @param url
		 * @param bytes
		 * @param filename
		 * @param params
		 * 
		 */		
		public function uploadFile(url:String, bytes:ByteArray, filename:String,  parameters:Object=null, successFunc:Function=null, failFunc:Function=null):void
		{
			if (parameters == null)
				parameters = request;
			if(url!=null)
				this.url = url;
			
			httpOperation.uploadFile(bytes, filename, parameters);
		}
		
		/**
		 * 下载Txt，XML等格式文件
		 * @param url
		 * @param successFunc
		 * @param failFunc
		 * 
		 */		
		public function loadFile(url:String=null, successFunc:Function=null, failFunc:Function=null):void
		{
			if(url)
				this.url = url;
			if(successFunc!=null)
				this.successFunc=successFunc;
			if(failFunc!=null)
				this.failFunc = failFunc;
			
			httpOperation.loadFile();
		}
		/**
		 * 下载图片，Swf等资源文件
		 * @param url
		 * @param successFunc
		 * @param failFunc
		 * 
		 */		
		public function loadAssets(url:String=null, successFunc:Function=null, failFunc:Function=null):void
		{
			if(url)
				this.url = url;
			if(successFunc!=null)
				this.successFunc=successFunc;
			if(failFunc!=null)
				this.failFunc = failFunc;
			
			httpOperation.loadAssets();
		}
	}
}