package com.starway.framework.core.objpool
{
	import com.starway.framework.core.objpool.ibase.IGenericObjectPool;
	import com.starway.framework.core.objpool.ibase.IKeyObjectPool;

	/** 
	 * @author Cray
	 * @version 创建时间：Oct 25, 2014 10:24:29 PM 
	 **/ 
	public interface IPoolObjectFactory
	{
		/**
		 * 获得一般对象池 
		 * 对象不做持久化，借出后即删除
		 * 对象返还后调用reset方法
		 * @param typeCls
		 * @return 
		 * 
		 */		
		function getObjectPool(typeCls:Class):IGenericObjectPool;
		/**
		 * 获得一个带key值得对象
		 * 但是会持久化到对象池中，可以通过key值获取此对象
		 * 每次对象返回都是调用reset方法，如果不想改变某些值则小心使用reset。
		 * @param typeCls
		 * @return 
		 * 
		 */		
		function getKeyObjectPool(typeCls:Class):IKeyObjectPool;
		/**
		 * 激活对象池 
		 * @param typeCls
		 * 
		 */		
		function activeObjectPool(typeCls:Class):void;
		/**
		 * 钝化对象池 
		 * 对象池暂时不可用，等待激活
		 * @param typeCls
		 * 
		 */		
		function passivateObjectPool(typeCls:Class):void;
		/**
		 * 销毁对象池 
		 * 同时销毁对象池中所有对象
		 * 会一次调用每个对象的dispose方法
		 * 如果是显示对象 最好在dispose方法中 去掉监听器，设置为null 等待GC回收
		 * @param typeCls
		 * 
		 */		
		function destroyObjectPool(typeCls:Class):void;
	}
}