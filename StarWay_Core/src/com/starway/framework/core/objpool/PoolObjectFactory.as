package com.starway.framework.core.objpool
{
	import com.starway.framework.core.inject.InjectGlobals;
	import com.starway.framework.core.log.Log;
	import com.starway.framework.core.objpool.ibase.IGenericObjectPool;
	import com.starway.framework.core.objpool.ibase.IKeyObjectPool;
	import com.starway.framework.core.objpool.ibase.IObject;
	
	import flash.utils.Dictionary;
	
	/** 
	 * @author Cray
	 * @version 创建时间：Oct 26, 2014 10:27:34 AM 
	 **/ 
	public class PoolObjectFactory implements IPoolObjectFactory
	{
		public static const CONTEXT_NAME:String = "poolObjectFactory";
		
		public function PoolObjectFactory()
		{
			InjectGlobals.keyObjectPoolDic = _keyObjectPoolDic;
		}
		/**
		 * 对象池容器 
		 */		
		private var _objectPoolDic:Dictionary = new Dictionary();
		/**
		 * key对象池容器 
		 */	
		private var _keyObjectPoolDic:Dictionary = new Dictionary();
		/**
		 * 获得对象池 
		 * @param typeCls
		 * @return 
		 * 
		 */		
		public function getObjectPool(typeCls:Class):IGenericObjectPool
		{
			if(!(new typeCls() is IObject)){
				Log.getLogger(this).error("[ObjectPool] 获得对象池失败，池对象元素类型必须是实现IObject接口.");
				return null;
			}
			if(!_objectPoolDic[typeCls])
				_objectPoolDic[typeCls] = new GenericObjectPool(typeCls);
			var io:IGenericObjectPool = _objectPoolDic[typeCls];
			if(io.active)
				return io;
			else{
				Log.getLogger(this).error("[ObjectPool] 类型 " + typeCls + "对象池已关闭.");
				return null;
			}
		}
		/**
		 * 
		 * @param typeCls
		 * @return 
		 * 
		 */		
		public function getKeyObjectPool(typeCls:Class):IKeyObjectPool
		{
			if(!(new typeCls() is IObject)){
				Log.getLogger(this).error("[ObjectPool] 获得对象池失败，池对象元素类型必须是实现IObject接口.");
				return null;
			}
			if(!_keyObjectPoolDic[typeCls])
				_keyObjectPoolDic[typeCls] = new KeyObjectPool(typeCls);

			return _keyObjectPoolDic[typeCls] as IKeyObjectPool;
		}

		
		/**
		 * 激活对象池 
		 * @param typeCls
		 * 
		 */		
		public function activeObjectPool(typeCls:Class):void
		{
			if(_objectPoolDic[typeCls] == undefined)return;
			_objectPoolDic[typeCls].active = true;
		}
		/**
		 * 钝化对象池 
		 * @param typeCls
		 * 
		 */		
		public function passivateObjectPool(typeCls:Class):void
		{
			if(_objectPoolDic[typeCls] == undefined)return;
			_objectPoolDic[typeCls].active = false;
		}
		
		/**
		 * 销毁对象池 
		 * @param typeCls
		 * 
		 */		
		public function destroyObjectPool(typeCls:Class):void
		{
			if(_objectPoolDic[typeCls] == undefined)return;
			_objectPoolDic[typeCls].close();
			delete _objectPoolDic[typeCls];
		}
	}
}