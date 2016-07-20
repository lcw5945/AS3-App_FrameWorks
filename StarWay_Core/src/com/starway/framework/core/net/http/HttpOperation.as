package com.starway.framework.core.net.http
{
	import com.starway.framework.common.LoaderConfig;
	import com.starway.framework.core.log.Log;
	import com.starway.framework.core.net.events.FaultEvent;
	import com.starway.framework.core.net.events.ResultEvent;
	import com.starway.framework.utils.ObjectUtil;
	import com.starway.framework.utils.StringUtils;
	import com.starway.framework.utils.URLUtil;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLVariables;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.utils.ByteArray;


	public class HttpOperation
	{
		
		
		public var request:Object = {};
		
		private var _httpService:HttpService;
		
		public function HttpOperation(httpService:HttpService)
		{
			_httpService = httpService;
		}
		
		/**
		 * http协议方式 
		 */		
		private var _method:String = HTTPRequestMessage.GET_METHOD;
		public function get method():String
		{
			return _method;
		}

		public function set method(value:String):void
		{
			_method = value;
		}
		
		private var _reTry:Number=0;
		/**
		 * 发送参数 开始通信
		 * @param parameters
		 * 
		 */		
		internal function sendBody(parameters:Object=null):void
		{
			_reTry = 0;
			var urlVar:URLVariables = null;
			if (parameters is URLVariables) {
				urlVar = parameters as URLVariables;
			} else {
				urlVar = new URLVariables();
				for (var key:String in parameters) {
					urlVar[key] = parameters[key];
				}
			}
			if (urlVar.toString().indexOf("&t=") == -1 && url.indexOf("&t=") == -1 && url.indexOf("?t=") == -1) {
				urlVar.decode("t=" + new Date().time);
			}
			
			var urlLoader:URLLoader = new URLLoader();
			var urlRequest:URLRequest = new URLRequest();
			urlRequest.method = method; //通信方式
			urlRequest.data = urlVar; // 参数
			urlRequest.url = URLUtil.getFullURL(rootURL,url); //通信地址
			urlRequest.contentType = HTTPRequestMessage.CONTENT_TYPE_FORM;// name-value 表单格式输出
			//设置返回类型值
			if(resultFormat == HTTPResponseMessage.RESULT_FORMAT_BYTEARRAY)
				urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			else if(resultFormat == HTTPResponseMessage.RESULT_FORMAT_TEXT || resultFormat == HTTPResponseMessage.RESULT_FORMAT_XML ||  resultFormat == HTTPResponseMessage.RESULT_FORMAT_JSON)
				urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			else if(resultFormat == HTTPResponseMessage.RESULT_FORMAT_VARIABLES)
				urlLoader.dataFormat = URLLoaderDataFormat.VARIABLES;

			//加载完成
			urlLoader.addEventListener(Event.COMPLETE,function urlLoadCompleteHandler(event:Event):void
			{
				//删除监听
				urlLoader.removeEventListener(Event.COMPLETE,urlLoadCompleteHandler);
				//log
				Log.getLogger(HttpOperation).debug("[HTTP] http请求成功返回数据. url=" + urlRequest.url + " method=" + method + " 参数=" + JSON.stringify(urlVar));
				//解析结果
				processResult(urlLoader.data);
			});
			//服务器上策略文件问题
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,function securityErrorHandler(event:SecurityErrorEvent):void
			{
				urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
				//log
				Log.getLogger(HttpOperation).error("[HTTP] SecurityErrorEvent事件错误. url=" + urlRequest.url);
				//event
				var er:Error = new Error(event.text,event.errorID);
				failFunc.apply(null, [er]);
			});
			
			//无法完成加载操作
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR,function ioErrorHandler(event:IOErrorEvent):void
			{
				_reTry++;
				if(_reTry==3)
				{
					urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
					//log
					Log.getLogger(HttpOperation).error("[HTTP] IOErrorEvent事件错误. url=" + urlRequest.url);
					//event
					var er:Error = new Error(event.text,event.errorID);
					failFunc.apply(null, [er]);
				}else
					urlLoader.load(urlRequest);
			});
			
			//使用 URLLoader.load() 方法后, 获取 HTTP 状态代码时触发, 通过判断他的 state 属性我们可以获得远程文件的加载状态. 
			//成功 (200), 没有权限 (403), 找不到文件 (404), 服务器内部错误 (500) 等等. 这个事件总是在 compelete 之前被触发.
			urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS,function httpStatusHandler(event:HTTPStatusEvent):void
			{
				urlLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS,httpStatusHandler);
				//log
				Log.getLogger(HttpOperation).debug("[HTTP] HTTP_STATUS: " + event.status);
			});
			//开始通信
			urlLoader.load(urlRequest);
		}
		
		/**
		 * 上传文件
		 * 
		 */		
		internal function uploadFile(bytes:ByteArray, filename:String, parameters:Object):void
		{
			var form:MsMultiPartFormData=new MsMultiPartFormData();
			
			for (var key:String in parameters) {
				form.AddFormField(key , parameters[key]);
			}
			
			form.AddStreamFile("fileUpload", filename, bytes);
			form.PrepareFormData();
			
			var request:URLRequest=new URLRequest();
			request.url=url;
			var header:URLRequestHeader=new URLRequestHeader("Content-Type", "multipart/form-data; boundary=" + form.Boundary);
			request.requestHeaders.push(header);
			request.method="POST";
			request.data=form.GetFormData();
			
			var urlLoader:URLLoader=new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, function saveCompleteHandler(event:Event):void
			{
				urlLoader.removeEventListener(Event.COMPLETE,saveCompleteHandler);
				successFunc.apply(null,[urlLoader.data]);
			});
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR,function ioErrorHandler(event:IOErrorEvent):void
			{
				urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
				var er:Error = new Error(event.text,event.errorID);
				failFunc.apply(null, [er]);
			});
			urlLoader.dataFormat=URLLoaderDataFormat.TEXT;
			urlLoader.load(request);
		}
		/**
		 * internal function
		 * 
		 */		
		internal function loadFile():void
		{
			var urlLoader:URLLoader = new URLLoader();
			var urlRequest:URLRequest = new URLRequest();
			urlRequest.method = method; //通信方式
			urlRequest.url = URLUtil.getFullURL(rootURL,url); //通信地址

			//加载完成
			urlLoader.addEventListener(Event.COMPLETE,function urlLoadCompleteHandler(event:Event):void
			{
				//删除监听
				urlLoader.removeEventListener(Event.COMPLETE,urlLoadCompleteHandler);			
				//log
				Log.getLogger(HttpOperation).debug("[HTTP] http请求成功返回数据. url=" + urlRequest.url + " method=" + method);
				successFunc.apply(null,[urlLoader.data]);
			});
			//服务器上策略文件问题
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,function securityErrorHandler(event:SecurityErrorEvent):void
			{
				urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
				//log
				Log.getLogger(HttpOperation).error("[HTTP] SecurityErrorEvent事件错误. url=" + urlRequest.url);
				var er:Error = new Error(event.text,event.errorID);
				failFunc.apply(null, [er]);
			});
			
			//无法完成加载操作
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR,function ioErrorHandler(event:IOErrorEvent):void
			{
				_reTry++;
				if(_reTry==3)
				{
					urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
					//log
					Log.getLogger(HttpOperation).error("[HTTP] IOErrorEvent事件错误. url=" + urlRequest.url);
					var er:Error = new Error(event.text,event.errorID);
					failFunc.apply(null, [er]);
				}else
					urlLoader.load(urlRequest);
			});
			urlLoader.load(urlRequest);
		}
		/**
		 * internal function
		 * 
		 */		
		internal function loadAssets():void
		{
			var loader:Loader = new Loader();
			var urlRequest:URLRequest = new URLRequest();
			urlRequest.method = HTTPRequestMessage.GET_METHOD;
			urlRequest.url = URLUtil.getFullURL(rootURL,url); //通信地址
			var loaderContext:LoaderContext =  new LoaderContext(true, ApplicationDomain.currentDomain);
			var domain:SecurityDomain = null;
			if (Security.sandboxType == Security.REMOTE) {
				domain = SecurityDomain.currentDomain;
			}
			loaderContext.securityDomain = domain;
			//加载完成
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function loaderCompleteHandler(event:Event):void
			{
				//删除监听
				loader.removeEventListener(Event.COMPLETE,loaderCompleteHandler);
				//log
				Log.getLogger(HttpOperation).debug("[HTTP] http请求成功返回数据. url=" + urlRequest.url + " method=" + method);
				successFunc.apply(null,[loader.content]);
			});
			
			//加载出错
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR ,function loaderErrorHandler(event:IOErrorEvent):void
			{
				_reTry = 0;
				if(_reTry==3)
				{
					loader.removeEventListener(IOErrorEvent.IO_ERROR,loaderErrorHandler);
					//log
					Log.getLogger(HttpOperation).error("[HTTP] IOErrorEvent事件错误. url=" + urlRequest.url);
					var er:Error = new Error(event.text,event.errorID);
					failFunc.apply(null, [er]);
				}else
					loader.load(urlRequest,loaderContext);
			});
			//load
			loader.load(urlRequest,loaderContext);
		}
		
		/**
		 * 结果处理
		 * @param result
		 * 
		 */		
		private function processResult(result:*):void
		{
			var faultEvent:FaultEvent;
			
			if((result == null) || ((result != null) && (result is String) && (StringUtils.trim(String(result)) == "")))
			{
				var er:Error = new Error("result is emptey",1000);
				faultEvent = FaultEvent.createEvent(er);
				_httpService.dispatchEvent(faultEvent);
				
				Log.getLogger(HttpOperation).error("[HTTP] 请求返回数据结果为空");
				return;
			}

			switch(resultFormat)
			{
				case HTTPResponseMessage.RESULT_FORMAT_TEXT:
				{
					try
					{
						result = String(result);
					}catch(e:Error)
					{
						faultEvent = FaultEvent.createEvent(e);
						_httpService.dispatchEvent(faultEvent);
						//log
						Log.getLogger(HttpOperation).error("[HTTP] 请求返回数据转换String类型失败");
					}
					
					break;
				}
				case HTTPResponseMessage.RESULT_FORMAT_XML:
				{
					try
					{
						result = XML(String(result));
					}catch(e:Error)
					{
						faultEvent = FaultEvent.createEvent(e);
						_httpService.dispatchEvent(faultEvent);
						//log
						Log.getLogger(HttpOperation).error("[HTTP] 请求返回数据转换XML类型失败");
					}
					
					break;
				}
				case HTTPResponseMessage.RESULT_FORMAT_JSON:
				{				
					try
					{
						result = JSON.parse(result);
					}catch(e:Error)
					{
						faultEvent = FaultEvent.createEvent(e);
						_httpService.dispatchEvent(faultEvent);
						//log
						Log.getLogger(HttpOperation).error("[HTTP] 请求返回数据转换JSON类型失败");
					}
					break;
				}
				case HTTPResponseMessage.RESULT_FORMAT_VARIABLES:
				{
					result = result as URLVariables;
					if(result==null)
					{
						//log
						Log.getLogger(HttpOperation).error("[HTTP] 请求返回数据转换URLVariables类型失败");
						//event
						er = new Error("强制转换失败",1053);
						faultEvent = FaultEvent.createEvent(er);
						_httpService.dispatchEvent(faultEvent);
					}
					break;
				}
				case HTTPResponseMessage.RESULT_FORMAT_BYTEARRAY:
				{
					result = result as ByteArray;
					if(result==null)
					{
						//log
						Log.getLogger(HttpOperation).error("[HTTP] 请求返回数据转换ByteArray类型失败");
						er = new Error("强制转换失败",1053);
						faultEvent = FaultEvent.createEvent(er);
						_httpService.dispatchEvent(faultEvent);
					}
					break;
				}
			}
			
			this.successFunc.apply(null,[result]);
		}
		/** 默认通信返回类型JSON **/
		private var _resultFormat:String = HTTPResponseMessage.RESULT_FORMAT_JSON;
		public function get resultFormat():String
		{
			return _resultFormat;
		}
		
		/**
		 *  @private
		 */
		public function set resultFormat(value:String):void
		{
			switch (value)
			{
				case HTTPResponseMessage.RESULT_FORMAT_TEXT:
				case HTTPResponseMessage.RESULT_FORMAT_XML:
				case HTTPResponseMessage.RESULT_FORMAT_JSON:
				case HTTPResponseMessage.RESULT_FORMAT_VARIABLES:
				case HTTPResponseMessage.RESULT_FORMAT_BYTEARRAY:
				{
					break;
				}	
				default:
				{
					value = HTTPResponseMessage.RESULT_FORMAT_TEXT;
					break;
				}
			}
			_resultFormat = value;
		}
		/**
		 * 请求成功函数 
		 */		
		private var _successFunc:Function = success;	
		private function success(result:Object):void{
			var resultEvent:ResultEvent = ResultEvent.createEvent(result);
			_httpService.dispatchEvent(resultEvent);
		}; 
		
		public function get successFunc():Function
		{
			return _successFunc;
		}
		
		public function set successFunc(value:Function):void
		{
			_successFunc = value;
		}

		private var _failFunc:Function = fail;		
		private function fail(er:Error):void{
			var faultEvent:FaultEvent = FaultEvent.createEvent(er);
			_httpService.dispatchEvent(faultEvent);
		};
		/**
		 * 请求失败函数 
		 */
		public function get failFunc():Function
		{
			return _failFunc;
		}

		/**
		 * @private
		 */
		public function set failFunc(value:Function):void
		{
			_failFunc = value;
		}
		/**
		 *  @private
		 */
		private var _url:String;
		public function get url():String
		{
			return _url;
		}
		/**
		 * 设置通信地址 
		 * @param value
		 * 
		 */        
		public function set url(value:String):void
		{
			_url = value;
		}
		
		//stage url
		internal var _rootURL:String;
		public function get rootURL():String
		{
			if (_rootURL == null)
			{
				_rootURL = LoaderConfig.url;
			}
			return _rootURL;
		}
		
		/**
		 *  @private
		 */
		public function set rootURL(value:String):void
		{
			_rootURL = value;
		}
	}
}