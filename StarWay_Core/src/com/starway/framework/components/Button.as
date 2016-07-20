package com.starway.framework.components
{
	import com.starway.framework.components.coreSupport.IButton;
	import com.starway.framework.components.coreSupport.SkinnableContainer;
	
	
	/**
	 * @author Cray 
	 * @version 1.0
	 * @date Oct 11, 2014 8:43:08 PM
	 */
	public class Button extends SkinnableContainer implements IButton
	{
		public function Button()
		{
			super();
			
		}
		
		public function set label(value:String):void
		{
		}
		
		public function get label():String
		{
			return null;
		}
		
		public function get autoRepeat():Boolean
		{
			return false;
		}
		
		public function set autoRepeat(value:Boolean):void
		{
		}
	}
}