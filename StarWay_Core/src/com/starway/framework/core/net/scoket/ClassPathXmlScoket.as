package com.starway.framework.core.net.scoket
{
	import com.starway.framework.core.ApplicationGlobals;
	import com.starway.framework.core.events.CompleteEvent;
	import com.starway.framework.core.log.Log;
	import com.starway.framework.core.net.http.HttpService;

	/**
	 * 
	 * @author Cray
	 * 
	 */	
	public class ClassPathXmlScoket
	{
		private var _actionArray:Array=new Array();
		private static var _classPathXmlScoket:ClassPathXmlScoket;
		
		public function ClassPathXmlScoket()
		{
		}
		
		public static function getInstence():ClassPathXmlScoket
		{
			if(_classPathXmlScoket == null)
				_classPathXmlScoket = new ClassPathXmlScoket();
            return _classPathXmlScoket;
		}
		/**
		 * 配置文件 
		 * @param params
		 * 
		 */		
		private var _rootDoc:String="";
		public function classPathXml(params:String):void
		{
			Log.getLogger(this).info("[Scoket] 开始加载Scoket 配置文件.");
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
				Log.getLogger(this).error("[Scoket] Scoket Config File Not Available.  By method classPathXml");			
		}
		/**
		 * 获得请求响应 action
		 * @param name
		 * 
		 */		
		public function getActionTypeByName(name:String):Object
		{
			if(_actionArray.length==0)return null;
			var obj:Object;
			for each(var scBean:ScoketActionBean in _actionArray)
			{
				if(scBean.name == name)
				{
					obj = scBean.data;
					break;
				}
			}
			if(obj==null)
				Log.getLogger(this).error("[Scoket] name="+name+" 不存在此actionName");
			return obj;
		}
		/**
		 * 获得请求名字 
		 * @param data
		 * @return 
		 * 
		 */		
		public function getNameByActionType(action:int,type:int):String
		{
			if(_actionArray.length==0)return null;
			var name:String;
			for each(var scBean:ScoketActionBean in _actionArray)
			{
				if(scBean.data.action == action && scBean.data.type == type)
				{
					name = scBean.name;
					break;
				}
			}
			if(name==null)
				Log.getLogger(this).error("[Scoket] action="+action+ " type="+ type + " 不存在此action and type");
			return name;
		}
		/**
		 * 开始加载文件 
		 * @param url
		 * 
		 */		
		private function loadFile(url:String):void
		{
			//lot
			Log.getLogger(this).info("[Scoket] 开始加载  " + url + " 文件");
			
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
			Log.getLogger(this).fatal("[Scoket] Scoket config load fail. Scoket will be not available.");
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
			}else if(confXml.hasOwnProperty("action"))
			{
				var acInfoXmls:XMLList = confXml.children();
				for each(var acXml:XML in acInfoXmls)
				{
					if(checkAction(acXml))
					_actionArray.push(new ScoketActionBean(acXml));
				}
			}
			if(_incCount == 0)
			{
				ApplicationGlobals.application.getEventManager().send(CompleteEvent.SCOKET_CONF_COMPLETE);
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
		private function checkAction(value:XML):Boolean
		{
			var fliters:Array = _actionArray.filter(function isExist(item:ScoketActionBean,inedex:int,array:Array):Boolean
			{
				if(item.name == value.@name)return true;
				if(item.data.action == value.@action && item.data.type == value.@type)return true;
				return false;
			});
			
			if(fliters.length>0)
			{
				//log
				Log.getLogger(this).warn("Action name: "+ value.@name + " 已存在. 不可存在相同的action name!");
				return false;
			}else
				return true;
		}
	}
}

class ScoketActionBean
{
	public var name:String;
	public var data:Object={};
	
	public function ScoketActionBean(value:XML):void
	{
		name = value.@name;
		data.action = value.@action;
		data.type = value.@type;
	}
}