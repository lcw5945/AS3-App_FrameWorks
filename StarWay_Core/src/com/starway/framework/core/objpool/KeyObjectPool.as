package com.starway.framework.core.objpool
{
	import com.starway.framework.core.objpool.ibase.IKeyObjectPool;
	import com.starway.framework.core.objpool.ibase.IObject;
	
	
	/**
	 * @author Cray 
	 * @version 1.0
	 * @date Oct 28, 2014 4:26:40 PM
	 */
	public class KeyObjectPool implements IKeyObjectPool
	{
		private var _objCollection:Vector.<KeyPoolBean> = new Vector.<KeyPoolBean>;
		
		private var _active:Boolean=true;
		
		private var _typeCls:Class;
		
		public function KeyObjectPool(typeCls:Class)
		{
			_typeCls = typeCls;
		}
		/**
		 * 添加对象到对象池 
		 * @param key
		 * @param obj
		 * 
		 */		
		public function addObject(key:String,obj:IObject):void
		{
			_objCollection.push(new KeyPoolBean(key,obj));
		}
		/**
		 * 借出对象但是保持引用 
		 * @param key
		 * @return 
		 * 
		 */		
		public function borrowObject(key:String):IObject
		{
			var poolItem:IObject;
			for each(var kpb:KeyPoolBean in _objCollection)
			{
				if(kpb.key == key)
				{
					poolItem = kpb.poolItem;
					break;
				}
			}
			if(poolItem)
			   return poolItem;
			else
			{
				poolItem = new _typeCls();
				_objCollection.push(new KeyPoolBean(key,poolItem));
				return poolItem;
			}
		}
		
		/**
		 * 返回对象，只有被借出的才可返回
		 * @param obj
		 * 
		 */		
		public function returnObject(obj:IObject):void
		{
			for (var i:int = _objCollection.length-1; i>=0; i--) {
				var kpb:KeyPoolBean = _objCollection[i];
				if(kpb.poolItem == obj)
					kpb.poolItem.reset();
			}
		}
		
		public function clear():void
		{
			for (var i:int = _objCollection.length-1; i>=0; i--) {
				var obj:KeyPoolBean = _objCollection.pop();
				obj.poolItem.dipose();
			}
		}
		
		public function close():void
		{
			this.clear();
			_active = false;
		}
		
		public function get active():Boolean
		{
			return _active;
		}
		
		public function set active(value:Boolean):void
		{
			_active = true;
		}
	}
}
import com.starway.framework.core.objpool.ibase.IObject;

class KeyPoolBean
{
	
	public function KeyPoolBean(key:String, poolItem:IObject)
	{
		_key = key;
		_poolItem = poolItem;
	}
	
	private var _poolItem:IObject;

	public function get poolItem():IObject
	{
		return _poolItem;
	}

	public function set poolItem(value:IObject):void
	{
		_poolItem = value;
	}

	private var _key:String;

	public function get key():String
	{
		return _key;
	}

	public function set key(value:String):void
	{
		_key = value;
	}

}