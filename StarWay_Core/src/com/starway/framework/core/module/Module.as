package com.starway.framework.core.module
{
	import flash.display.Sprite;
	
	/**
	 * @author Cray 
	 * @version 1.0
	 * @date Oct 29, 2014 5:48:10 PM
	 */
	public class Module extends Sprite implements IModule
	{
		public function Module()
		{
		}
		private var _data:Object;
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			_data = value;
		}
		
		
		/******************************************************************************************
		 ********** 保护方法供继承的模块重写********************************************
		 *****************************************************************************************/
		/**
		 * 当模块添加到舞台调用
		 * 开始启动 
		 * 模块启动入口
		 */		
		public function onAdded():void
		{
			
		}
		/**
		 * 舞台大小改变 
		 * @param rect
		 * 
		 */		
		public function onResize(stageWidth:Number,stageHeight:Number):void
		{
			
		}
		/**
		 * 移除模块
		 * 当然要舞台中移除模块式调度 
		 * 如果模块总有计时器，监听器等暂时停止
		 */		
		public function onRemoved():void
		{
			
		}
	}
}