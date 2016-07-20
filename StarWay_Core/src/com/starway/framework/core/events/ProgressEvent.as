package com.starway.framework.core.events
{
	
	/**
	 * @author Cray 
	 * @version 1.0
	 * @date Oct 28, 2014 1:40:08 PM
	 */
	public class ProgressEvent extends Event
	{
		/** 加载进度 **/		
		public static const PROGRESS:String = "progress";
		
		public function ProgressEvent(type:String,errorText:String=null,bytesLoaded:Number=0, bytesTotal:Number=0)
		{
			super(type,errorText);
			_bytesLoaded = bytesLoaded;
			_bytesTotal = bytesTotal;
		}
		
		private var _bytesTotal:Number;
		
		public function get bytesTotal():Number
		{
			return _bytesTotal;
		}
		
		private var _bytesLoaded:Number;
		
		public function get bytesLoaded():Number
		{
			return _bytesLoaded;
		}
	}
}