package com.starway.framework.components.concsole
{
	import com.starway.framework.core.events.Event;
	
	public class ConsoleEvent extends Event
	{
		/** level **/		
		public static const CHANGELEVEL:String = "changelevel";
		
		public function ConsoleEvent(type:String, levle:String, errorText:String=null)
		{
			super(type, errorText);
			_level = levle;
		}
		
		private var _level:String;
		
		
		public function get level():String
		{
			return _level;
		}

		public function set level(value:String):void
		{
			_level = value;
		}

		public static function createEvent(type:String,levle:String,errorText:String=null):ConsoleEvent
		{
			return new ConsoleEvent(type,levle,errorText);
		}
	}
}