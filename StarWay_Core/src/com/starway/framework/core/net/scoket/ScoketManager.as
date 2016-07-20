package com.starway.framework.core.net.scoket
{
	import com.starway.framework.core.manager.AMGlobals;

	/**
	 * 
	 * @author Cray
	 * 
	 * 管理scoket通信
	 * 管理scoket事件
	 */	
	public class ScoketManager
	{
		
		public function ScoketManager()
		{
		}
		
		/**
		 * 加载scoket action 文件 
		 * @param params
		 * 
		 */		
		public static function loadConfigXml(scoketPath:String=null):void
		{		
			if(scoketPath==null)
				scoketPath = AMGlobals.info["scoketPath"];
			if(scoketPath && scoketPath.indexOf("xml")!=-1)
				ClassPathXmlScoket.getInstence().classPathXml(scoketPath);
		}
		
		/**
		 * 获得Scoket操作类对象 
		 * 启动Scoket，判读是否链接，关闭Scoket 
		 * @return 
		 * 
		 */		
		public static function getScoket():IScoketOperation
		{
			return getSingleton().getScoket();
		}
		/**
		 * 单例实例对象 初始化Scoket管理实现类 
		 * @return 
		 * 
		 */	    
		public static function getSingleton():Object
		{
			if (!ScoketManagerGlobals.managerSingleton)
				ScoketManagerGlobals.managerSingleton = new ScoketManagerImpl();
			
			return ScoketManagerGlobals.managerSingleton;
		}
	}
}
import com.starway.framework.core.ApplicationGlobals;
import com.starway.framework.core.events.ScoketEvent;
import com.starway.framework.core.log.Log;
import com.starway.framework.core.net.scoket.ClassPathXmlScoket;
import com.starway.framework.core.net.scoket.IScoketManager;
import com.starway.framework.core.net.scoket.IScoketOperation;
import com.starway.framework.core.net.scoket.IScoketService;
import com.starway.framework.core.net.scoket.ScoketManagerGlobals;
import com.starway.framework.core.net.scoket.ScoketOperation;
import com.starway.framework.core.net.scoket.SocketSerializer;
import com.starway.framework.core.net.scoket.events.UnpackEvent;
import com.starway.framework.utils.ObjectUtil;
import com.starway.framework.utils.StringUtils;

import flash.events.EventDispatcher;
import flash.utils.ByteArray;

class ScoketManagerImpl implements IScoketManager{

	public function ScoketManagerImpl()
	{
		
	}
	
	/**
	 * scoket操作类对象 
	 * @return 
	 * 
	 */	
	private var _sckOpe:IScoketOperation;
	public function getScoket():IScoketOperation
	{
		if(_sckOpe==null)
		   _sckOpe = new ScoketOperationProxy(new ScoketOperation());
		return _sckOpe;
	}
	/**
	 * 返回内部类 ScoketService对象 
	 * @return 
	 * 
	 */	
	private var _sckSer:IScoketService
	public function getScoketService():IScoketService
	{
		if(_sckSer==null)
			_sckSer =  new ScoketService();
		return _sckSer;
	}
	
}

class ScoketOperationProxy extends EventDispatcher implements IScoketOperation
{
	private var _sckOpe:ScoketOperation;
	private var _sckSer:IScoketService;
	public function ScoketOperationProxy(sckOpe:ScoketOperation)
	{
		_sckOpe = sckOpe;		
		_sckOpe.addEventListener(UnpackEvent.RESULT,unpackHandler);
	}
	/**
	 * 获得解压的二级制数据 
	 * @param event
	 * 
	 */	
	private function unpackHandler(event:UnpackEvent):void
	{
		var pack:ByteArray = event.result as ByteArray;
		//解析是否压缩
		if (pack[0] == 0x78 && pack[1] == 0x9c) {			
			pack.uncompress();
		}
		//返回给使用者
		var data:Object = SocketSerializer.getInstance().readData(pack);
		/** 如果是心跳返回值则忽略 **/
		if(_sckOpe.heartbeat(data))return;
		//错误处理消息
		if(!(data.hasOwnProperty("retcode") && data.retcode == "000000")){
			//log
			Log.getLogger(this).error("[Socket] 系统错误. retcode = 000000");
			ApplicationGlobals.application.getEventManager().send(ScoketEvent.SYS_ERROR, data);
			return;
		}//验证返回结果从code上是否出现了错误
		if(data.msg == null){
			// log
			Log.getLogger(this).error("[Scoket] 返回msg 为null." + " action: "+ data.action + " msgtype: " + data.msgtype);
			return;
		}
		/** 如果是握手消息 **/
		if(isHandshake(data))
			Log.getLogger(this).info("[Scoket] 返回握手消息.");
		
		var msgs:Array = data.msg;
		var escape:Boolean = data.hasOwnProperty("escapeflag") ? data["escapeflag"] == 1 : false;
		//如果一个消息体中有多个数据,则分多次解析
		if (msgs && msgs.length)
		{
			while (msgs.length)
			{
				resolveData(msgs.shift(), escape);
			}
		}
	}
	
	/**
	 * 解析单个数据并调用回调方法
	 *
	 * @param result
	 * @param escape
	 */
	private function resolveData(result:Object, escape:Boolean):void
	{
		//读取接口标识
		var action:int = result.action;
		var type:int = result.msgtype;
		Log.getLogger(this).info("[Socket]" + " 监听action: " + action + " type:" + type);
		//msgtype为1的时候才需要考虑html转义,否则不需要
		if (type == 1)
		{
			if (!StringUtils.isEmpty(result.ct))
			{
				//还原字符串
				if (escape)
					result.ct = unescape(result.ct);//解码html				
				result.ct = JSON.parse(result.ct);//转成object
			}
			else
				result.ct = {};//默认为空object
		}		
		var name:String = ClassPathXmlScoket.getInstence().getNameByActionType(action,type);
		//执行监听函数
		for each (var lisObj:Object in _events)
		{
			if(name == null)
			{
				if(lisObj.name.action == action && lisObj.name.type == type){
					try
					{
						Log.getLogger(this).debug("[Socket] 执行ScoketService监听回调函数, 方法： "+ lisObj.completeFunc + " 监听action: " + action + " type:" + type);
						lisObj.completeFunc.apply(null, [result]);
					}
					catch (e:Error)
					{
						//返回错误消息
						Log.getLogger(this).error("[Socket] ScoketService监听回调函数出错, 方法： "+ lisObj.completeFunc + " 监听action: " + action + " type:" + type + " 原因：" + e.message);
					}
				}
			}
			else if(lisObj.name == name)
			{
				try
				{
					Log.getLogger(this).debug("[Socket] 执行ScoketService监听回调函数, 方法： "+ lisObj.completeFunc + " 监听actionName: " + name);
					lisObj.completeFunc.apply(null, [result]);
				}
				catch (e:Error)
				{
					//返回错误消息
					Log.getLogger(this).error("[Socket] ScoketService监听回调函数出错, 方法： "+ lisObj.completeFunc + " 监听actionName: " + name  + " 原因：" + e.message);
				}	
			}						
		}
	}
	
	/**
	 * 判断返回的消息是否握手消息.
	 * 如果是握手消息,把缓存的请求和数据都队列处理.
	 *
	 * @param data
	 * @return
	 */
	private function isHandshake(data:Object):Boolean
	{
		var result:Object = data.msg[0];
		//读取接口标识
		var action:int = result.action;
		var type:int = result.msgtype;
		//解除握手消息阻止
		var name:String = ClassPathXmlScoket.getInstence().getNameByActionType(action,type);
		return name == null ? (action == 9 && type == 9 ? true : false) : (name == "HAND") ? true : false;
	}
	
	/**
	 * scoket监听回调函数
	 */	
	private var _events:Vector.<Object>;
	public function set events(value:Vector.<Object>):void
	{
		 _events = value;
	}
	
	
	/**
	 * host-->主机地址
	 * port-->主机端口
	 * secPort-->策略文本端口 
	 * @param host
	 * @param port
	 * @param secPort
	 * 
	 */		
	public function startUp():void
	{
		_sckOpe.startUp();
	}
	/**
	 * 发送数据 
	 * @param type
	 * @param data
	 * 
	 */    
	public function send(name:*,data:Object):void
	{
		var head:Object;
		if(ObjectUtil.type(name) === "string"){
			Log.getLogger(this).debug("[Scoket] 发送数据 name= "+name);
			head = ClassPathXmlScoket.getInstence().getActionTypeByName(name);
		}else{
			head = name;
		}
		
		if(head)
		  _sckOpe.send(head,data);
	}
	/**
	 * 重新链接 
	 * 
	 */	
	public function reconnect():void
	{
		_sckOpe.reconnect();
	}
	/**+
	 * 关闭链接 
	 * 
	 */	
	public function closed():void
	{
		_sckOpe.closed();
	}
	/**+
	 * 停止心跳 
	 * 
	 */
	public function destroy():void
	{
		_sckOpe.destroy();
	}
	/**
	 * 是否处于链接状态 
	 * @return 
	 * 
	 */	
	public function get connected():Boolean
	{
		return _sckOpe.connected;
	}
}

class ScoketService implements IScoketService
{
	/**
	 * 发送Scoket数据 
	 * @param type
	 * @param data
	 * 
	 */	
	public function send(type:*,data:Object):void
	{
		ScoketManagerGlobals.managerSingleton.getScoket().send(type,data);
	}
	
	/**
	 * 添加事件监听
	 * 监听Scoket返回事件
	 */	
	private var _events:Vector.<Object>=new Vector.<Object>;
	public function listen(name:*,completeFunc:Function):void
	{
		var find:Vector.<Object> = _events.filter(function (item:Object, index:int, vector:Vector.<Object>):Boolean {
			if (name == item["name"] && completeFunc == item["completeFunc"]) return true;
			return false;
		}, null);
		if (find.length == 0) {
			//log
			Log.getLogger(this).debug("[Scoket] 监听事件  " + ObjectUtil.serializer(name) + " Function= " + completeFunc+ "成功监听.");
			//push events
			_events.push({"name":name, "completeFunc":completeFunc});
			//添加监听数组
			ScoketManagerGlobals.managerSingleton.getScoket().events = _events;
		}else
			Log.getLogger(this).debug("[Scoket] 监听事件  " + ObjectUtil.serializer(name) + " Function= " + completeFunc+ "已存在."); //log warn
	}
	
	/**
	 * 删除Scoket事件监听 
	 * @param type
	 * @param completeFunc
	 * 
	 */	
	public function remove(type:*,completeFunc:Function):void
	{
		for each(var item:Object in _events)
		{
			if (type == item["name"] && completeFunc == item["completeFunc"])
			{
				var index:int = _events.indexOf(item);
				if (index != -1) {
					_events.splice(index, 1);
					//log
					Log.getLogger(this).debug("[Scoket] 监听事件  " + ObjectUtil.serializer(type) + " Function= " + completeFunc+ "成功删除监听.");
				}
			}
		}
	}
}