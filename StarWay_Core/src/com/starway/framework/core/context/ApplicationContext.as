package com.starway.framework.core.context
{
	import com.starway.framework.core.inject.InjectGlobals;
	import com.starway.framework.core.log.Log;

	/**
	 * @author Cray
	 */
	public class ApplicationContext implements IApplicationContext
	{
		private  var _contextCon:Object=new Object();
		public function ApplicationContext()
		{
			InjectGlobals.contextContanier = _contextCon;
		}
		/**
		 * 注册 
		 * @param name
		 * @param classObject
		 * 
		 */		
		public function registerContext(name:String, classObject:Object):void
		{
			if(name == null || classObject == null)
			{
				//throw new Error("registerContext params error");
				//log
				Log.getLogger(this).error("[Context] 注册对象到容器失败. 原因：name=" +name + "  Class="+classObject);
				return;
			}
			if(!hasContext(name))
			{
				_contextCon[name] = newInstance(classObject);
				//log
				Log.getLogger(this).info("[Context] 注册对象到容器. name=" +name + "  Class="+classObject);
			}
		}
		/**
		 * 获得上下文对象 
		 * @param name
		 * @return 
		 * 
		 */		
		public function getContext(name:String):*
		{
			if (hasContext(name)) {
				return _contextCon[name];
			}
			return null;
		}
		
		/**
		 * 是否存在指定的context
		 *  
		 * @param name
		 */		
		private function hasContext(name:String):Boolean {
			return _contextCon.hasOwnProperty(name) && _contextCon[name];
		}
		
		/**
		 * 实例化 
		 * @param context
		 * 
		 */		
		private function newInstance(classObject:Object):Object
		{			
			var obj:Object;
			if (classObject is Class)
				obj = new classObject();
			else
				obj = classObject;
			
			return obj;
		}
	}
}