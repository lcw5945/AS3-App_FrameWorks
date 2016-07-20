package com.starway.framework.core.manager
{
	import com.starway.framework.core.ApplicationGlobals;
	import com.starway.framework.core.log.Log;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * @author Cray 
	 * @version 1.0
	 * @date Oct 29, 2014 11:29:00 AM
	 */
	public class ApplicationContainManager implements IApplicationContainManager
	{
		/** app主容器 **/
		private var _appContainer:Sprite;
		/** 实际使用设定尺寸容器 **/
		private var _measureContainer:Sprite;
		/**固定模块容器**/
		private var _meaModContainer:Sprite;
		/**相对模块容器**/
		private var _winModContainer:Sprite;
		/** 窗口容器 **/
		private var _windowContainer:Sprite;
		
		public function ApplicationContainManager(stageContainer:Sprite)
		{
			if(!AMGlobals.acm)
				AMGlobals.acm = this;
			
			_appContainer = new Sprite();
			stageContainer.addChild(_appContainer);
			
			_measureContainer = new Sprite();
//			_measureContainer.mouseEnabled=false;
			_meaModContainer = new Sprite();
			_meaModContainer.mouseEnabled=false;
			_measureContainer.addChild(_meaModContainer);
			_appContainer.addChild(_measureContainer);
			_windowContainer = new Sprite();
			_windowContainer.mouseEnabled=false;
			_winModContainer = new Sprite();
			_winModContainer.mouseEnabled=false;
			_windowContainer.addChild(_winModContainer);
			_appContainer.addChild(_windowContainer);
		}
		/**
		 * 设置显示背景
		 * 如果存在背景则移除背景 设置为null
		 * 添加新背景冻结鼠标监听
		 * 缓存显示对象的内部位图（此缓存可以提高包含复杂矢量内容的显示对象的性能）
		 * 显示对象不要使用filter 否则cacheAsBitmap 仍然为true，flase失效
		 */		
		private var _bgDisplay:DisplayObject;
		public function setBackgroundDisplay(bgDisplay:DisplayObject):void
		{
			if(_bgDisplay && _measureContainer.contains(_bgDisplay))
			{
				_measureContainer.removeChild(_bgDisplay);
				_bgDisplay=null;
			}
			_bgDisplay = bgDisplay;
			if(_bgDisplay is MovieClip){
				(_bgDisplay as MovieClip).mouseEnabled = false;
				(_bgDisplay as MovieClip).mouseChildren = false;
			}
			_bgDisplay.cacheAsBitmap = true;
			/** 添加显示背景到背景容器 **/
			_measureContainer.addChildAt(_bgDisplay,0);
			//更新位置
			updateDisplay();
		}
		/**
		 * 
		 * @param color
		 * 
		 */		
		public function setBackgroundColor(color:uint):void
		{
			_measureContainer.graphics.clear();
			_measureContainer.graphics.beginFill(color);
			_measureContainer.graphics.drawRect(0,0,ApplicationGlobals.application.measuredWidth,ApplicationGlobals.application.measuredHeight);
			_measureContainer.graphics.endFill();
		}
		
		/**
		 * 设置measure容器top值 
		 * @param value
		 * 
		 */		
		private var _measureTop:int=0;
		public function setMeasureTop(value:int):void
		{
			_measureTop = value;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get measureContainer():Sprite
		{
			return _measureContainer;
		}
		/**
		 * 
		 * @return 
		 * 
		 */        
		public function get windowContainer():Sprite
		{
			return _windowContainer;
		}
		/**
		 * 
		 * 创建层级
		 */		
		internal function createLayer(modBeansVector:Vector.<IModuleBeanInfo>):void
		{
			var i:int =0, j:int = 0;
			var lay:Sprite = null;
			for each(var mod:IModuleBeanInfo in modBeansVector)
			{
				lay = new Sprite();
				lay.mouseEnabled = false;
				if(mod.absoluteLayout){
					mod.layerIndex = i;
					_meaModContainer.addChild(lay);
					i++;
				}else{
					mod.layerIndex = j;
					_winModContainer.addChild(lay);
					j++;
				}
			}
		}
		/**
		 * 添加模块到底部容器
		 * 
		 */		
		internal function addToMeasureContainer(mod:IModuleBeanInfo):void
		{
			Log.getLogger(this).info("[Module] "+ mod.name + " 模块添加到固定容器。");
			addToContainer(_meaModContainer, mod);
		}
		/**
		 *  添加模块到窗口容器
		 * 
		 */		
		internal function addToWindowContainer(mod:IModuleBeanInfo):void
		{
			Log.getLogger(this).info("[Module] "+ mod.name + " 模块添加到窗口容器。");
			addToContainer(_winModContainer, mod);
		}
		/**
		 * 添加到容器
		 * @param c
		 * @param mod
		 * 
		 */		
		private function addToContainer(c:Sprite, mod:IModuleBeanInfo):void
		{
			if(mod.layerIndex > c.numChildren){
				c.addChild(mod.moduleInfo.module);
			}else{
				var lay:Sprite = c.getChildAt(mod.layerIndex) as Sprite;
				if (lay && !lay.contains(mod.moduleInfo.module)) {
					lay.addChild(mod.moduleInfo.module);
				}
			}
		}
		
		/**
		 * 舞台大小改变 
		 * @param event
		 * 
		 */	
		public function updateDisplay():void
		{
			updateDragRectangle();
			var mx:Number = (ApplicationGlobals.application.stage.stageWidth - ApplicationGlobals.application.measuredWidth)/2;
			LayoutManager.setPosition(_measureContainer, mx, _measureTop);
			
			
//			/** 更新measure 容器 **/
//			_measureChilds.sort(sortOnIndex);
//			for each(var meamod:IModuleBeanInfo in _measureChilds)
//			{
//				this._meaModContainer.addChild(meamod.moduleInfo.module);
//			}
//			
//			/** 更新windows 容器 **/
//			_windowChilds.sort(sortOnIndex);
//			for each(var winmod:IModuleBeanInfo in _windowChilds)
//			{
//				this._winModContainer.addChild(winmod.moduleInfo.module);
//			}
		}
		/**
		 * 升序排序 
		 * @param m1
		 * @param m2
		 * @return 
		 * 
		 */		
		private function sortOnIndex(m1:IModuleBeanInfo, m2:IModuleBeanInfo):Number 
		{
			
			if(m1.index > m2.index) {
				return 1;
			} else if(m1.index < m2.index) {
				return -1;
			} else  {
				return 0;
			}
		}
		
		/**
		 * 开始拖动
		 * 
		 */		
		public function startUpDrag():void
		{
			_measureContainer.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		/**
		 * 停止拖动
		 * 
		 */		
		public function stopDragNow():void
		{
			if(_measureContainer.hasEventListener(MouseEvent.MOUSE_DOWN))
				_measureContainer.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		/** 可拖动矩形 **/
		private var _dragRect:Rectangle = null;
		public function updateDragRectangle():void {
			
			var w:Number = ApplicationGlobals.application.stage.stageWidth;
			var h:Number = ApplicationGlobals.application.stage.stageHeight;
			_dragRect = new Rectangle(0, 0, 
				Math.ceil(w - _measureContainer.width), 
				Math.ceil(h - _measureContainer.height));
		}
		
		/**
		 * 鼠标按下启动拖拽,并重新计算当前拖拽的范围.
		 *  
		 * @param event
		 */		
		private function onMouseDown(event:Event):void 
		{
			//对于文本文字上的操作始终抛弃
			//if (event.currentTarget != _measureContainer) return;
			//开始拖动
			_measureContainer.startDrag(false,_dragRect);
			ApplicationGlobals.application.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		/**
		 * 鼠标提起停止拖拽.
		 * @param event
		 */		
		protected function onMouseUp(event:Event):void {
			ApplicationGlobals.application.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			if (_measureContainer) {
				_measureContainer.stopDrag();
			} 
		}
	}
}