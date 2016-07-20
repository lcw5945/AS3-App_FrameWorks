package com.starway.framework.core.events
{
	import com.starway.framework.collection.IIterator;
	
	/**
	 * @author Cray 
	 * @version 1.0
	 * @date Oct 23, 2014 3:42:55 PM
	 */
	public class EventDispatcher implements IEventDispatcher
	{
		public static const CONTEXT_NAME:String = "eventDispatcher";
		
		public function EventDispatcher()
		{
			_eventCollection = new EventCollection();
		}
		
		private var _eventCollection:EventCollection;
		/**
		 * 添加监听 
		 * @param type
		 * @param listener
		 * 
		 */		
		public function addEventListener(type:String, listener:Function):void
		{
			var event:Object = getEventContainer(type,listener);
			if(event)
			_eventCollection.addEvent(event);
		}
		/**
		 * 派发事件 
		 * @param event
		 * @return 
		 * 
		 */		
		public function dispatchEvent(event:Event):Boolean
		{		
			if(event.type == null)
				return false;
			var iterator:IIterator = _eventCollection.iterator(event.type);
			if(iterator == null)return false;
//			{
//				//log
//				Log.getLogger(this).error("注册监听容器不存此事件类型: " +event.type);
//				return false;
//			}
			var events:Object;
			while(iterator.hasNext())
			{
				events = iterator.next();
				events.handler.apply(null, [event]);
			}
			return true;
		}
		/**
		 *  
		 * @param type
		 * @param listener
		 * @return 
		 * 
		 */		
		public function hasEventListener(type:String, listener:Function):Boolean
		{
			if(_eventCollection.contains(type,listener))return true;
			else
				return false;
		}
		
		/**
		 * 移除监听器 
		 * @param type
		 * @param listener
		 * 
		 */		
		public function removeEventListener(type:String, listener:Function):void
		{
			_eventCollection.removeEvent(type,listener);
		}
		/**
		 * 获得事件监听容器 
		 * @param type
		 * @param listener
		 * @return 
		 * 
		 */		
		private function getEventContainer(type:String, listener:Function):Object
		{			
			if(!_eventCollection.contains(type,listener))
			{
				var con:Object = {
					type:type,
					handler:listener 
				};
				return con;
			}
			return null;
		}
	}
}