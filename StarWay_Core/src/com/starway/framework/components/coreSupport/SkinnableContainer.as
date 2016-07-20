package com.starway.framework.components.coreSupport
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	
	/**
	 * @author Cray 
	 * @version 1.0
	 * @date Oct 11, 2014 8:34:47 PM
	 */
	public class SkinnableContainer extends Sprite
	{
		public function SkinnableContainer()
		{
			super();
			
			attchSkin();
		}
		
		private var _skin:DisplayObject;

		public function get skin():DisplayObject
		{
			return _skin;
		}

		public function set skin(value:DisplayObject):void
		{
			_skin = value;
		}
		
		private function attchSkin():void
		{
			if(!_skin)
			{
				
			}
		}

	}
}