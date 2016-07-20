package com.starway.framework.core.net.scoket
{
	import flash.utils.ByteArray;
	import flash.utils.IDataOutput;

	/**
	 * @author Cray
	 * @version 1.0
	 * @date Oct 24, 2014 6:33:09 PM
	 */
	public interface ISocketData
	{
		function readData(buffer:ByteArray):Object;
		function writeData(socket:IDataOutput,data:Array):Boolean;
	}
}