package com.starway.framework.core.manager
{
	import com.starway.framework.preloader.Preloader;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.system.Security;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	
	/**
	 * @author Cray 
	 * @version 1.0
	 * @date Oct 21, 2014 10:01:41 AM
	 */
	
	public class ApplicationBootstrapManager extends MovieClip implements IAppliactionManager
	{	
		private var _preloader:Preloader;
		
		public function ApplicationBootstrapManager() {
			
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			
			if (stage)
			{
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
				stage.quality = StageQuality.HIGH;
			}
			/**停到第一帧**/
			stop();
			
			if (root && root.loaderInfo)
				root.loaderInfo.addEventListener(Event.INIT, initHandler);
		}
		
		/**
		 * 初始化事件
		 * 获得舞台参数 
		 * @param event
		 * 
		 */		
		private function initHandler(event:Event):void
		{		
			root.loaderInfo.removeEventListener(Event.INIT, initHandler);
			
			if(!AMGlobals.sm)
				AMGlobals.sm = this;
			if (!AMGlobals.info)
				AMGlobals.info = info();
			if (!AMGlobals.parameters)
				AMGlobals.parameters = loaderInfo.parameters;
			
			addEventListener(Event.ENTER_FRAME, docFrameListener);
			
			initialize();
		}
		/**
		 * 进入第二帧   当前帧标签 为主应用类名字
		 * 初始化应用
		 * @param event
		 * 
		 */	
		private var _timer:Timer;
		private function docFrameListener(event:Event):void
		{
			if (currentFrame == 2)
			{
				removeEventListener(Event.ENTER_FRAME, docFrameListener);					
				initApplication();
				
				_timer = new Timer(50);
				_timer.addEventListener(TimerEvent.TIMER,timerHandler);
				_timer.start();
			}
		}
		/**
		 * 收到完成 延迟300ms 在显示舞台 
		 * @param event
		 * 
		 */		
		private function timerHandler(event:TimerEvent):void
		{	
			_preloader.setProgress(100 - _bussnisePrecent);
			if(_bussnisePrecent<0)
			{
				_timer.removeEventListener(TimerEvent.TIMER,timerHandler);
				_timer.stop();
				_timer.reset();
				_timer.delay = 300;
				_timer.repeatCount = 1;
				_timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
				_timer.start();
			}
		}
		
		private function timerCompleteHandler(event:TimerEvent):void
		{
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE,timerCompleteHandler);
			_timer.stop();
			_timer = null;
			//移除preloader
			removeChild(_preloader);
			_app.visible = true;
		}
		/**
		 * 初始化 
		 * 
		 */        
		private function initialize():void
		{
			_preloader = new Preloader();
			_preloader.addEventListener(Event.COMPLETE,preloader_completeHandler);
			var preClass:Object;
			if("preloader" in info())
				preClass = info()["preloader"];
			if(preClass && preClass is Class)
				_preloader.preloader = preClass as Class;
			var precentValue:Number = 0;
			if("bussnisePrecent" in info())
				precentValue = info()["bussnisePrecent"];
			_bussnisePrecent = precentValue;
			_preloader.percentValue = 100 - precentValue;
			addChild(_preloader);
			
			_preloader.x = (stage.stageWidth - _preloader.width)/2;
			//_preloader.y = stage.stageHeight/2 - _preloader.height/2;
			_preloader.y = 0;
			
			_preloader.initialize();
		}
		
		/**
		 * 进度加载完成 进入下一帧并停止
		 * @param event
		 * 
		 */        
		private function preloader_completeHandler(event:Event):void
		{
			nextFrame();
		}
		/**
		 * 初始化主应用 
		 * 
		 */		
		private var _app:DisplayObject;
		private function initApplication():void {
			/**这里不能直接写成：
			 var app:Application = new Application();
			 这样的由于引用到 Application，Application中所有的资源都会被编译到第一帧来
			 这样的话 PreLoader就没有意义了，你也看不到PreLoader，就跳到第二帧了
			 **/		
			var mainAppName:String = AMGlobals.info["mainAppName"];
			
			if (mainAppName == null)
			{
				var url:String = loaderInfo.loaderURL;
				var dot:int = url.lastIndexOf(".");
				var slash:int = url.lastIndexOf("/");
				mainAppName = url.substring(slash + 1, dot);
			}
			
			var mainApp:Class = Class(getDefinitionByName(mainAppName));
			_app = new mainApp() as DisplayObject;
			_app.visible=false;
			addChild(_app);
		}
		
		private var _bussnisePrecent:Number=0;
		public function set bussnisePrecent(value:Number):void
		{
			_bussnisePrecent = _bussnisePrecent - value;
		}
		
		/**
		 * 可用属性：
		 * preloader: 自定义进度条***必须是显示对象，并实现IPreloaderSkinnable 接口,
		 * bussnisePrecent: 设置业务进度所占进度的百分比,
		 * logPath:"log配置文件",
		 * scoketPath:"scoket文件位置",
		 * modulePath:"module文件位置"
		 * @return 
		 * 
		 */		
		protected function info():Object
		{
			return {};
		}
	}
}
