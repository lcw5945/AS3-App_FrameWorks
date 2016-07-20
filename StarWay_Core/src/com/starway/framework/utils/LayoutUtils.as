package com.starway.framework.utils
{
	import flash.display.DisplayObject;

	/**
	 * 
	 * @author Cray
	 * 
	 */	
	public class LayoutUtils
	{
		public function LayoutUtils()
		{
		}
		/**
		 * 將顯示對象置到最上層 
		 * @param object
		 * 
		 */		
		public static function setActive(object:DisplayObject):void{
			object.parent.setChildIndex(object, (object.parent.numChildren - 1));
		}
		
		/**
		 * 设置显示对象位置 
		 * @param object
		 * @param x
		 * @param y
		 * 
		 */		
		public static function setPosition(object:DisplayObject, x:Number, y:Number):void{
			object.x = x;
			object.y = y;
		}
		/**
		 * 设置显示对象位置以及大小 
		 * @param object
		 * @param x
		 * @param y
		 * @param w
		 * @param h
		 * 
		 */		
		public static function setPositionAndSize(object:DisplayObject, x:Number, y:Number, w:Number, h:Number):void{
			setPosition(object, x, y);
			setSize(object, w, h);
		}
		/**
		 * 設置顯示對象大小 
		 * @param object
		 * @param w
		 * @param h
		 * 
		 */		
		public static function setSize(object:DisplayObject, w:Number, h:Number):void{
			object.width = w;
			object.height = h;
		}
		/**
		 * 設置顯示對象放縮 
		 * @param object
		 * @param size
		 * 
		 */		
		public static function setScale(object:DisplayObject, size:Number):void{
			if(object.width > object.height)
			{
				object.scaleX = size/object.width;
				object.scaleY = size/object.width;
			}else
			{
				object.scaleX = size/object.height;
				object.scaleY = size/object.height;
			}
		}
	}
}