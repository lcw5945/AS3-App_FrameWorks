package com.starway.framework.core.entity
{
	import com.starway.framework.core.inject.InjectGlobals;
	import com.starway.framework.core.log.Log;

	/**
	 * @author Cray 
	 * @version 1.0
	 * @date Oct 15, 2014 2:17:09 PM
	 */
	public class EntityModleManager implements IEntityModleManager
	{
		public static const CONTEXT_NAME:String = "entityModleManager";
		/**实体模型数组**/
		private var _entityBeanMaps:Vector.<IEntityModle> = new Vector.<IEntityModle>;
		/**
		 * 当前已经注册的消息队列. 
		 */		
		private var _events:Array = null;

		
		public function EntityModleManager()
		{
			InjectGlobals.entityBeanMaps = _entityBeanMaps;
		}
		/**
		 * @param name
		 * @param entityModle
		 * 
		 */		
		public function persist(entityModle:IEntityModle):void
		{
			if(!contains(entityModle))
			{
				_entityBeanMaps.push(entityModle);
				Log.getLogger(this).info("持久化实体模型 " + entityModle.name +" 成功");
			}
		}
		/**
		 * 删除实体模型 
		 * @param entityModle
		 * @return 
		 * 
		 */		
		public function remove(entityModle:IEntityModle):Boolean
		{
			var res:Boolean=false;
			var index:int=0;
			for each(var item:IEntityModle in _entityBeanMaps)
			{
				if(item.name == entityModle.name)
				{
					_entityBeanMaps.splice(index, 1);
					res = true;
					Log.getLogger(this).info("删除实体 " + entityModle.name +" 成功");
					break;
				}
				index++;
			}
			if(!res)
				Log.getLogger(this).warn("删除实体不存在的实体 " + entityModle.name);
			return res;
		}
		/**
		 * 判断是否包含实体管理器 
		 * @param entityModle
		 * @return 
		 * 
		 */		
		public function contains(entityModle:IEntityModle):Boolean
		{
			return  _entityBeanMaps.some(function (item:IEntityModle, index:int, vectory:Vector.<IEntityModle>):Boolean {
				if(entityModle["name"] == item["name"])
					return true;
				else 
					return false;
			}, null);
		}

		/**
		 * 检索实体模型，成功返回实体
		 * @param name
		 * @return 
		 * 
		 */		
		public function getEntityModle(name:String):*
		{
			var em:IEntityModle = null;
			for each(var entity:IEntityModle in  _entityBeanMaps)
			{
				if(entity.name == name)
				{
					em = entity;
					break;
				}
					
			}
			return em;
		}

	}
}