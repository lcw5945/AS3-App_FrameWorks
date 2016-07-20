package com.starway.framework.core.events
{
	import com.starway.framework.collection.ICollection;
	import com.starway.framework.collection.IIterator;
	import com.starway.framework.core.log.Log;
	
	
	/**
	 * @author Cray 
	 * @version 1.0
	 * @date Oct 23, 2014 4:02:23 PM
	 */
	public class EventCollection implements ICollection
	{
		public function EventCollection()
		{
			_events = [];
		}
		
		/**
		 * 当前已经注册的消息队列. 
		 */		
		private var _events:Array = null;
		public function addEvent(event:Object):void
		{
			_events.push(event);
		}
		
		/**
		 * 是否包含监听
		 * 对数组中的每一项执行测试函数，直到获得对指定的函数返回 true 的项。
		 * @param element
		 * @return 
		 * 
		 */		
		public function contains(type:String, listener:Function):Boolean
		{
			return _events.some(function hasEvent(item:Object,index:int,arr:Array):Boolean
			{
				if(item.type == type && item.handler == listener)
					return true;
				else 
					return false;
			});
		}
		/**
		 * 删除监听容器
		 * 对数组中的每一项执行函数。 
		 * @param type
		 * @param listener
		 * 
		 */		
		public function removeEvent(type:String, listener:Function):void
		{
			var res:Boolean=false;
			var index:int=0;
			for each (var item:Object in _events) {
				if(item.type == type && item.handler == listener){
					_events.splice(index, 1);
					res = true;
					//log
					Log.getLogger(this).info("已移除监听器, type: "+ item.type + " handler: "+item.handler);
				}
				index++;
			}
            if(!res)
				Log.getLogger(this).info("不存在监听器, type: "+ item.type + " handler: "+item.handler);
		}
		/**
		 * 获得类型相同的事件容器 
		 * @param type
		 * @return 
		 * 
		 */		
		public function iterator(type:String):IIterator
		{
			var events:Array = _events.filter(function getiterator(item:Object, index:int, arr:Array):Boolean
			{ 
				return item.type == type;
			});
			if(events.length==0)
				return null;
			else
				return new EventIterator(events);
		}
	}
}