package com.starway.framework.core.events
{
	import com.starway.framework.collection.IIterator;
	
	
	/**
	 * @author Cray 
	 * @version 1.0
	 * @date Oct 23, 2014 4:49:21 PM
	 */
	public class EventIterator implements IIterator
	{
		private var _cursor:Number=0;
		private var _collection:Array;
		
		public function EventIterator(collection:Array)
		{
			_collection = collection;
			_cursor=0;
		}
		
		public function reset():void
		{
			_cursor=0;
		}
		
		public function next():Object
		{
			var obj:Object = _collection[_cursor];
			_cursor++;
			return obj;
		}
		
		public function hasNext():Boolean
		{
			return _cursor != _collection.length;
		}
	}
}