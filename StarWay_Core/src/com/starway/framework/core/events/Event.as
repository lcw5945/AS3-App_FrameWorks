package com.starway.framework.core.events
{
	
	/**
	 * @author Cray 
	 * @version 1.0
	 * @date Oct 23, 2014 1:48:39 PM
	 */
	public class Event
	{
		public function Event(type:String,errorText:String = null)
		{
			_type = type;
			_errorText = errorText;
		}
		/**
		 * 事件类型 
		 */		
		private var _type:String;
		public function get type():String
		{
			return _type;
		}

		private var _errorText:String;

		public function get errorText():String
		{
			return _errorText;
		}

	}
}