package com.starway.framework.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class DisplayUtil
	{
		public function DisplayUtil()
		{
		}
		
		/**
		 * 将mc对象停止 
		 * @param mc
		 * 
		 */	    
		public static function stop(mc:DisplayObjectContainer):void{
			if(!mc)
				return;
			if(mc is MovieClip)
				MovieClip(mc).stop();
			for(var i:int=0;i<mc.numChildren;i++){
				var disp:DisplayObject = mc.getChildAt(i);
				if(disp is DisplayObjectContainer){
					stop(disp as DisplayObjectContainer);
				}
			}
		}
		/**
		 * 冻结交互对象鼠标事件 
		 * @param button
		 * @param time
		 * 
		 */		
		public static function freeze(button:InteractiveObject, time:Number=1000):void
		{
			button.mouseEnabled=false;
			var timer:Timer=new Timer(time, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, function timerCompleteHandler(event:TimerEvent):void
			{
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
				button.mouseEnabled=true;
			});
			timer.start();
		}
	}
}