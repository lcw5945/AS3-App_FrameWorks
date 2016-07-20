package com.starway.framework.core.events
{
	import com.starway.framework.core.module.IModuleInfo;
	
	/**
	 * @author Cray 
	 * @version 1.0
	 * @date Oct 23, 2014 3:24:31 PM
	 */
	public class ModuleEvent extends ProgressEvent
	{
		/**************************************************************************
		 * 模块相关事件
		 **************************************************************************/
		/** 模块加载进度 **/		
		public static const PROGRESS:String = "ModuleEvent_progress";
		/** 模块加载完成 **/		
		public static const READY:String = "ModuleEvent_ready";
		/** 模块加载错误 **/		
		public static const ERROR:String = "ModuleEvent_error";
		/** 模块添加到舞台 **/		
		public static const ADDSTAGE:String = "ModuleEvent_addstage";
		/** 模块卸载 **/		
		public static const UNLOAD:String = "ModuleEvent_unload";
		
		public function ModuleEvent(type:String,errorText:String=null,bytesLoaded:Number=0, bytesTotal:Number=0, module:IModuleInfo = null)
		{
			super(type,errorText,bytesLoaded,bytesTotal);
			this._module = module;
		}
		
		private var _module:IModuleInfo;
		
		public function get module():IModuleInfo
		{
			return _module;
		}

		/**
		 * 创建事件 
		 * @param type
		 * @param modName
		 * @return 
		 * 
		 */		
		public static function createEvent(type:String,errorText:String=null,bytesLoaded:Number=0, bytesTotal:Number=0, module:IModuleInfo = null):ModuleEvent
		{
			return new ModuleEvent(type,errorText,bytesLoaded,bytesTotal,module);
		}
	}
}