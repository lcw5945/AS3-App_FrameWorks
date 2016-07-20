package com.starway.framework.core.net.scoket
{
	/**
	 * 
	 * @author Cray
	 * 
	 */	
	public class ScoketMessage
	{
		//最大尝试链接次数
		public static const MAX_RETRY:Number = 40;
		//心跳值
		public static const HEARTBEAT:Number = 30000;
		//心跳秘钥 32位最大整数 
		public static const HEARTBEAT_KEY:Number = 452337042;
		//心跳Action
		public static var HEARTBEAT_NAME:String = "HEART_BEAT";
		
		public function ScoketMessage()
		{
		}
		
		private static var _hostInfos:Vector.<HostInfo> = new Vector.<HostInfo>;
		
		public static function addHostInfo(hostInfo:HostInfo):void
		{
			_hostInfos.push(hostInfo);
		}
		
		public static function getHostInfo():Vector.<HostInfo>
		{
			return _hostInfos;
		}
	}
}