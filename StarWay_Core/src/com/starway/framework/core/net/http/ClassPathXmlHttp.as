package com.starway.framework.core.net.http
{
	import com.starway.framework.core.ApplicationGlobals;
	import com.starway.framework.core.events.CompleteEvent;
	import com.starway.framework.core.log.Log;
	
	/**
	 * @author Cray 
	 * @version 1.0
	 * @date Oct 30, 2014 4:04:31 PM
	 */
	public class ClassPathXmlHttp
	{
		private var _httpArray:Array=new Array();
		private static var _classPathXmlHttp:ClassPathXmlHttp;
		
		public function ClassPathXmlHttp()
		{
		}
		
		public static function getInstence():ClassPathXmlHttp
		{
			if(_classPathXmlHttp == null)
				_classPathXmlHttp = new ClassPathXmlHttp();
			return _classPathXmlHttp;
		}
		/**
		 * 配置文件 
		 * @param params
		 * 
		 */		
		private var _rootDoc:String="";
		public function classPathXml(params:String):void
		{
			Log.getLogger(this).info("[Http] 开始加载Http配置文件.");
			if(params)
			{
				if(params.indexOf("/")!=-1)
				{
					var array:Array = params.split("/");
					for (var i:int = 0;i<array.length-1;i++)
					{
						_rootDoc += array[i]+"/";
					}
				}
				
				loadFile(params);
			}else
				Log.getLogger(this).error("[HTTP] Http Config File Not Available.  By method classPathXml");			
		}
		/**
		 * 获得请求响应 action
		 * @param name
		 * 
		 */		
		public function getUrlByName(name:String):String
		{
            if(_httpArray.length==0)return name;
			var url:String;
			for each(var scBean:HttpBean in _httpArray)
			{
				if(scBean.name == name)
				{
					url = scBean.url;
					break;
				}
			}
			if(url==null)
				Log.getLogger(this).error("[HTTP] name="+name+" 不存在此Name");
			return url;
		}
	
		/**
		 * 开始加载文件 
		 * @param url
		 * 
		 */		
		private function loadFile(url:String):void
		{
			//lot
			Log.getLogger(this).info("[HTTP] 开始加载  " + url + " 文件");
			
			var httpService:HttpService = new HttpService();
			httpService.loadFile(url,loadSuccess,loadFail);		
		}
		
		/**
		 * 加载失败
		 * @param error
		 * 
		 */		
		private function loadFail(error:Error):void
		{
			//log
			Log.getLogger(this).fatal("[HTTP] http config load fail. http will be not available.");
		}
		
		/**
		 * 加载成功 
		 * @param data
		 * 
		 */		
		private var _incCount:int;
		private function loadSuccess(data:*):void
		{
			var confXml:XML = XML(data);
			if(confXml.hasOwnProperty("include"))
			{
				var infoXmls:XMLList = confXml.children();
				_incCount = infoXmls.length();
				for each(var fileXml:XML in infoXmls)
				{
					loadFile(_rootDoc+fileXml.@file);
				}
			}else if(confXml.hasOwnProperty("path"))
			{
				var acInfoXmls:XMLList = confXml.children();
				for each(var acXml:XML in acInfoXmls)
				{
					if(check(acXml))
						_httpArray.push(new HttpBean(acXml));
				}
			}
			if(_incCount == 0)
			{
				ApplicationGlobals.application.getEventManager().send(CompleteEvent.HTTP_CONF_COMPLETE);
				ApplicationGlobals.application.getApplicationManager().bussnisePrecent = Math.round((Math.random()+1) * 2);
			}
			_incCount--;
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */		
		private function check(value:XML):Boolean
		{
			var fliters:Array = _httpArray.filter(function isExist(item:HttpBean,inedex:int,array:Array):Boolean
			{
				if(item.name == value.@name)return true;
				return false;
			});
			
			if(fliters.length>0)
			{
				//log
				Log.getLogger(this).warn("Http name: "+ value.@name + " 已存在. 不可存在相同的 name!");
				return false;
			}else
				return true;
		}
	}
}


class HttpBean
{
	public var name:String;
	public var url:String;
	
	public function HttpBean(value:XML):void
	{
		name = value.@name;
		url = value.@url;
	}
}