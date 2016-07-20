package com.starway.framework.components.base
{
	import com.starway.framework.components.Button;
	import com.starway.framework.core.ApplicationGlobals;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * @author Cray 
	 * @version 1.0
	 * @date Oct 11, 2014 8:21:15 PM
	 */
	public class ScrollBarBase extends RangeBase
	{
		/**可拖动滑块**/
		public var thumb:Button;
		/**递减按钮**/
		public var decrementButton:Button;
		/**递增按钮**/
		public var incrementButton:Button;
		// 变量临时存储对象
		private var mouseDownTarget:DisplayObject;
		// 初始thumb 点击点
		private var clickOffset:Point;
		
		public function ScrollBarBase()
		{
			super();
			//舞台添加事件
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			//鼠标按下事件
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			
			//添加焦点事件
			addEventListener(FocusEvent.FOCUS_IN, focusInHandler);
			addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
			
			//显示对象组装
			partsAdd();
		}
		/**
		 * 将各种操作对象组装到舞台 
		 * 
		 */		
		private function partsAdd():void
		{
			thumb = new Button();
			this.addChild(thumb);
			thumb.addEventListener(MouseEvent.MOUSE_DOWN, thumb_mouseDownHandler);
			
			decrementButton = new Button();
			this.addChild(decrementButton);
			
			incrementButton = new Button();
			this.addChild(incrementButton);
		}
		
		protected function pointToValue(x:Number, y:Number):Number
		{
			return 0;
		}
		/**
		 * 更新皮肤 
		 * 
		 */		
		private function updateSkinDisplay():void
		{
			
		}
		/**
		 * 
		 * @param event
		 * 
		 */		
		private function addedToStageHandler(event:Event):void
		{
			updateSkinDisplay();
		}
		/**
		 * 
		 * @param event
		 * 
		 */		
		private function mouseDownHandler(event:MouseEvent):void
		{
			
		}
		
		private function thumb_mouseDownHandler(event:MouseEvent):void
		{
			ApplicationGlobals.application.stage.addEventListener(MouseEvent.MOUSE_MOVE, 
				app_mouseMoveHandler, true);
			ApplicationGlobals.application.stage.addEventListener(MouseEvent.MOUSE_UP, 
				app_mouseUpHandler, true);
			
			clickOffset = thumb.globalToLocal(new Point(event.stageX, event.stageY));
		}
		
		private function app_mouseMoveHandler(event:MouseEvent):void
		{
			var p:Point = thumb.globalToLocal(new Point(event.stageX, event.stageY));
			var newValue:Number = pointToValue(p.x - clickOffset.x, p.y - clickOffset.y);
			newValue = nearestValidValue(newValue, stepMutiple);
			
			if (newValue != value)
				setValue(newValue); 
			
			event.updateAfterEvent();
		}
		
		private function app_mouseUpHandler(event:MouseEvent):void
		{
			
		}
		/**
		 * 
		 * @param event
		 * 
		 */		
		private function focusInHandler(event:FocusEvent):void
		{
			ApplicationGlobals.application.stage.addEventListener(MouseEvent.MOUSE_WHEEL, app_mouseWheelHandler, true);
		}
		/**
		 * 
		 * @param event
		 * 
		 */		
		private function focusOutHandler(event:FocusEvent):void
		{
			ApplicationGlobals.application.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, app_mouseWheelHandler, true);
		}
		/**
		 * 
		 * @param event
		 * 
		 */		
		private function app_mouseWheelHandler(event:MouseEvent):void
		{
			//如果此事件没有取消
			if (!event.isDefaultPrevented())
			{
				var newValue:Number = nearestValidValue(value + event.delta * stepMutiple, stepMutiple);
				setValue(newValue);
			}
		}
	}
}