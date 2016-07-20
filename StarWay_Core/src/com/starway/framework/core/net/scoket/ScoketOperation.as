package com.starway.framework.core.net.scoket
{
	import com.starway.framework.core.ApplicationGlobals;
	import com.starway.framework.core.events.ScoketEvent;
	import com.starway.framework.core.log.Log;
	import com.starway.framework.core.net.scoket.events.UnpackEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.system.Security;
	import flash.utils.ByteArray;
	import flash.utils.Timer;

	/**
	 * 
	 * @author Cray
	 * 
	 */	
	public class ScoketOperation extends EventDispatcher
	{
		/**
		 * Socket对象
		 */		
		private var _socket:Socket;
		/**
		 * 重新链接次数计数 
		 */		
		private var _reTry:int=0;
		/**
		 * 缓存发送数据 
		 */		
		private var _cacheSendData:Array = new Array();
		
		public function ScoketOperation()
		{
			
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
			_socket = new Socket();
			_socket.timeout = 10000;
			//在建立网络连接后调度
			_socket.addEventListener(Event.CONNECT, onSocketConnected);
			//仅在服务器关闭连接时调度 close 事件；在调用 Socket.close() 方法时不调度该事件。
			_socket.addEventListener(Event.CLOSE, onSocketClosed);
			//在套接字接收到数据后调度。套接字接收的数据在被读取之前一直保持在套接字中
			_socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
			//在出现输入/输出错误并导致发送或加载操作失败时调度
			_socket.addEventListener(IOErrorEvent.IO_ERROR, function onIOError(event:IOErrorEvent):void
			{
				//Logthrow new Error("connect error");
				Log.getLogger(instance).error("[Scoket] Scoket链接出错." + "IOError ID: " + event.errorID + "IOError Text: " + event.text + " . 尝试第  " +_reTry+ "链接." + "最大链接次数: "+ScoketMessage.MAX_RETRY);
				_reTry++;
				if(_reTry < ScoketMessage.MAX_RETRY)
					startConnect();
				else
					Log.getLogger(instance).fatal("[Scoket] IOError 尝试链接次数已经达到最大,停止链接Scoket.");
			});			
			//若对 Socket.connect() 的调用尝试连接到调用方的安全沙箱禁止的服务器或低于 1024 的端口，且不存在允许进行此类连接的套接字策略文件，则进行调度。
            //注意：在 AIR 应用程序中，不需要套接字策略文件即允许在应用程序安全沙箱中运行的内容连接到任何服务器和端口号。
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function onSecurityError(event:SecurityErrorEvent):void
			{
				//Logthrow new Error("connect security error");
				Log.getLogger(instance).error("[Scoket] Scoket链接出错." + "SecurityError ID: " + event.errorID + "SecurityError Text: " + event.text + " . 尝试第  " +_reTry+ "链接." + "最大链接次数: "+ScoketMessage.MAX_RETRY);
				_reTry++;
				if(_reTry < ScoketMessage.MAX_RETRY)
					startConnect();
				else
					Log.getLogger(instance).fatal("[Scoket] SecurityError 尝试链接次数已经达到最大,停止链接Scoket.");
			});
			//
			startConnect();
		}
		/*
		 *链接成功 
		**/
		private function onSocketConnected(event:Event):void
		{
			//Log connect success
			Log.getLogger(instance).info("[Scoket] Scoket链接成功.");
			_reTry=0; //重置链接次数
			ApplicationGlobals.application.getEventManager().send(ScoketEvent.CONNECT);
			startUpHeartbeat(); //启动心跳
		}
		/*
		*关闭scoket
		**/
		private function onSocketClosed(event:Event):void
		{
			//Log throw new Error("service connect closed");
			Log.getLogger(instance).warn("[Scoket] Scoket已关闭.");
		}
		
		private function onSocketData(event:ProgressEvent):void
		{
			//				var buffer:ByteArray = new ByteArray();
			//				buffer.position = 0;
			//				_socket.readBytes(buffer);
			//log
			Log.getLogger(instance).debug("[Scoket] Scoket成功接收数据.");
			//解包
			//unPack(buffer);
			checkDataPackage();
		}
		/**
		 * 链接scoket
		 * 从 ScoketMessage 中获得scoket服务器信息
		 * 通过链接次数尝试更换不同的服务器地址,注：如果只有一个地址只能链接一个地址了。
		 */		
		private function startConnect():void
		{
			_handClosed = false;
			var hostInfos:Vector.<HostInfo> = ScoketMessage.getHostInfo();
			var hostInfo:HostInfo = hostInfos[_reTry%hostInfos.length];		
			//加载策略文件
			Security.loadPolicyFile("xmlsocket://" + hostInfo.host + ":" + hostInfo.secPort);		
			//链接
			_socket.connect(hostInfo.host, hostInfo.secPort);
			//log 启动链接
			Log.getLogger(this).info("[Scoket] Scoket启动链接, 主机： " + hostInfo.host + " 端口: "+hostInfo.secPort);
		}
		
		/**
		 * 启动心跳
		 * 
		 */		
		private function startUpHeartbeat():void
		{
			//log
			Log.getLogger(this).info("[Scoket] Scoket启动心跳计时器.");
			//timer
//			var timer:Timer = new Timer(ScoketMessage.HEARTBEAT);
//			timer.addEventListener(TimerEvent.TIMER,
//			timer.start();
			ApplicationGlobals.application.getTicker().tick(ScoketMessage.HEARTBEAT, heartbeatTimerHandler, 0);
		}
		
		private function heartbeatTimerHandler():void
		{
			var type:Object = {"action":3, "type":0}/*ClassPathXmlScoket.getInstence().getActionTypeByName(ScoketMessage.HEARTBEAT_NAME)*/;
			if(type)
				send(type, ScoketMessage.HEARTBEAT_KEY);
			else
				Log.getLogger(instance).error("[Scoket] Scoket心跳action name 不存在. 方法  startUpHeartbeat() 出错.");
		}
		/**
		 * 发送缓存数据 
		 * 
		 */		
		private function sendCacheData():void
		{
			if(_cacheSendData.length>0 && connected)
			{
				//log
				Log.getLogger(this).info("[Scoket] 发送缓存数据同时启动计时器每隔1秒进行检查，如果有数据继续发送，方法 sendCacheData()");
				var cacheData:Array = _cacheSendData.shift();
				this.send(cacheData[0],cacheData[1]);
				
				var timer:Timer = new Timer(1000,1);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE,function timerCompleteHandler(event:TimerEvent):void
				{
					timer.removeEventListener(TimerEvent.TIMER_COMPLETE,timerCompleteHandler);
					sendCacheData();
				});
				timer.start();
			}
		}
		
		private static const PREFIX_LEN:int = 8;
		private var _len:int = 0;
		private var _isReading:Boolean = false;
		private function checkDataPackage():void {
			//根据包是否满了来解析数据
			if (isPackageFull()) {
				_isReading = false;
				resolvePackage();
				//解完了还原长度为0
				_len = 0;
				//如果还有数据,还得继续解
				if (_socket.bytesAvailable > 0)
					checkDataPackage();
			}
		}
		
		/**
		 * 根据长度判断是否满足 
		 * @return 
		 */		
		protected function isPackageFull():Boolean {
			if (!_isReading) {
				if (_socket.bytesAvailable >= PREFIX_LEN) {
					_len = _socket.readUnsignedInt();
					if (_len < 20000) {
						_isReading = true;
					}else {
						//长度异常,直接丢掉
						_socket.readUTFBytes(_socket.bytesAvailable);
						_isReading = false;
					}
				}
			}
			//8位包含一个4位的包长(无符号整形为32bit,即4位)和4位长度的接口标识
			if (_isReading && _socket.bytesAvailable >= (_len - PREFIX_LEN)) {
				//剩余长度大于等于包长,则可以开始解包了
				return true;
			}
			return false;
		}
		
		/**
		 * 解析包体数据 
		 */		
		protected function resolvePackage():void {
			//解析接口标识
			var index:int = _socket.readUnsignedInt();
			//			Debugger.log(Debugger.INFO, "[soeckt]", "包序号: ", index);
			var pack:ByteArray = new ByteArray();
			_socket.readBytes(pack, 0, _len - PREFIX_LEN);
			//			enqueue(pack);
			this.dispatchEvent(UnpackEvent.createEvent(pack));
		}
		
		/**
		 * 解数据包 
		 * @param buffer
		 * 
		 */	
		private function unPack(buffer:ByteArray):void {
			//如果包数据小于包头秘钥长度
			if(buffer.length < SocketSerializer.getInstance().HEAD_KEY)
				return;
			var headLength:int = buffer.readUnsignedInt();
			if(buffer.bytesAvailable >= (headLength - SocketSerializer.getInstance().HEAD_KEY))
			{
				var pack:ByteArray = new ByteArray();
				buffer.readBytes(pack, 0, headLength - SocketSerializer.getInstance().HEAD_KEY);
				//log
				Log.getLogger(this).debug("[Scoket] 成功收到完整包，开始解析数据.");
				//event 转发数据包
				this.dispatchEvent(UnpackEvent.createEvent(pack));
				//如果还有数据继续拆包
				if(buffer.bytesAvailable>0)
				{
					var byte:ByteArray = new ByteArray();
					byte.position=0;
					buffer.readBytes(byte);
					buffer.clear();
					unPack(byte);
				}
			}
		}
		/**
		 * 返回类实例，提供闭合方法使用 
		 * @return 
		 * 
		 */		
		private function get instance():ScoketOperation
		{
			return this;
		}
		
		
		/**
		 * Scoket发送数据 
		 * @param type
		 * @param data
		 * 
		 */		
		public function send(head:Object,data:Object):void
		{
			if(_handClosed)
			{
				Log.getLogger(this).warn("[Scoket] Scoket已被关闭.");
				return;
			}
			if(connected && SocketSerializer.getInstance().writeData(_socket,[head, data]))
			{
				Log.getLogger(this).debug("[Scoket] 发送数据完成  action: " + head.action + " type： " + head.type);
				_socket.flush();
			}
			else
			{
				//log
				Log.getLogger(this).warn("[Scoket] Scoket已断开, 尝试再次链接, 缓存发送数据：action: " + head.action + " type： " + head.type);
				//链接scoket，缓存发送数据
				reconnect();
				_cacheSendData.push([head, data]);
			}
		}
		
		/**
		 * 重新链接 
		 * 
		 */		
		public function reconnect():void
		{
			if (_socket == null)
				Log.getLogger(this).error("[Scoket] Scoket未被初始化! 方法 reconnect()");
			else
				startConnect();
		}
		/**
		 * 关闭链接 
		 * 
		 */		
		private var _handClosed:Boolean;
		public function closed():void
		{
			if(_socket)
			{
				_socket.close();
				_handClosed=true;
			}
		}
		/**
		 * 停止发送心跳
		 * 停止接收scoket返回数据 
		 * @param info
		 * 
		 */		
		public function destroy():void
		{
			ApplicationGlobals.application.getTicker().stop(heartbeatTimerHandler);
			_socket.removeEventListener(Event.CONNECT, onSocketConnected);
			_socket.removeEventListener(Event.CONNECT, onSocketClosed);
		}

		/**
		 * scoket是否链接成功 
		 * @return 
		 * 
		 */		
		public function get connected():Boolean
		{
			if(_socket)
			    return _socket.connected;
			else
			{
				//log throw new Error("Scoket not init.");
				Log.getLogger(this).error("[Scoket] Scoket未被初始化! 方法 connected()");
				return false;
			}
		}
		
		public function heartbeat(value:Object):Boolean
		{
			return Number(value) == ScoketMessage.HEARTBEAT_KEY;
		}
	}
}