package com.starway.framework.core.net.scoket
{
	import flash.utils.ByteArray;
	import flash.utils.IDataOutput;
	
	/**
	 * 
	 * @author Cray
	 * 
	 */	
	public class SocketSerializer
	{
		//包头秘钥
		public var HEAD_KEY:int=8;
		public var END_KEY:int=0;
		
		public function SocketSerializer()
		{
			ISocketData
		}
		
		private static var _scoketSerialiser:SocketSerializer;
		public static function getInstance():SocketSerializer
		{
			if(_scoketSerialiser == null)
				_scoketSerialiser = new SocketSerializer();
			return _scoketSerialiser;
		}
		/**
		 * scoket 数据解析类 
		 */		
		private var _scoketData:ISocketData;
		public function set scoketData(value:ISocketData):void
		{
			_scoketData = value;
		}
		
		/**
		 * 
		 * @param buffer
		 * @return 
		 * 
		 */		
		public  function readData(buffer:ByteArray):Object {
			return _scoketData.readData(buffer);
		}
		/**
		 * 
		 * @param socket
		 * @param data
		 * @return 
		 * 
		 */		
		public  function writeData(socket:IDataOutput,data:Array):Boolean {
			return _scoketData.writeData(socket,data);
		}
	}
}