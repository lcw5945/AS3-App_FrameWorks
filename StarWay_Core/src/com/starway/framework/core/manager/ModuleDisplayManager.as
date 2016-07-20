package com.starway.framework.core.manager
{
	import com.starway.framework.core.ApplicationGlobals;
	import com.starway.framework.core.controller.Command;
	import com.starway.framework.core.controller.ControllerManager;
	import com.starway.framework.core.events.CompleteEvent;
	import com.starway.framework.core.events.ModuleEvent;
	import com.starway.framework.core.inject.InjectGlobals;
	import com.starway.framework.core.log.Log;
	import com.starway.framework.core.module.IModuleInfo;
	import com.starway.framework.core.module.ModuleManager;
	import com.starway.framework.core.net.http.HttpService;
	
	import flash.display.Sprite;
	
	/**
	 * @author Cray 
	 * @version 1.0
	 * @date Oct 28, 2014 10:59:53 AM
	 */
	public class ModuleDisplayManager implements IModuleDisplayManager
	{
		public static const CONTEXT_NAME:String = "ModuleDisplayManager";
		/** 模块信息向量数组 **/
		private var _modBeansVector:Vector.<IModuleBeanInfo> = new Vector.<IModuleBeanInfo>;
		
		private var _acm:ApplicationContainManager;
		
		public function ModuleDisplayManager()
		{
			InjectGlobals.modBeansVector = _modBeansVector;
		}
		/**
		 * 优先下载指定模块
		 */		
		private var _priorityLoads:Array = new Array();
//		public function loadPriorityModule(...args):void
//		{
//			for (var i:uint = 0; i < args.length; i++) {
//				_delayLoadArray.push(args[i]);
//			}
//			//开始下载
//			loadPriModule();
//		}
		/**
		 *模块加载启动 
		 */		
		private var _loadStart:Boolean=false;
		
		/**
		 * 下载所有模块 
		 * 
		 */		
		private var _delay:Boolean;
		public function loadModule(delay:Boolean):void
		{
			_loadStart = true;
			_delay = delay;
			if(!_delay)
			{
				if(_priorityLoads==null || _priorityLoads.length==0){
					//				ApplicationGlobals.application.getEventDispatcher().dispatchEvent(CompleteEvent.createEvent(CompleteEvent.MODULE_PRI_LOAD_COMPLETE));
					ApplicationGlobals.application.getEventManager().send(CompleteEvent.MODULE_PRI_LOAD_COMPLETE, CompleteEvent.createEvent(CompleteEvent.MODULE_PRI_LOAD_COMPLETE));
					return;
				}
				
				var name:String = _priorityLoads.shift();
				_modBeanInfo = this.getModuleBeanInfo(name);
				if(_modBeanInfo && containsInAction(_modBeanInfo))
					loadOperation(_modBeanInfo);
				else
					loadModule(_delay);
			}else{
				if(search()==null){
					//模块全部加载完成
					//				ApplicationGlobals.application.getEventDispatcher().dispatchEvent(CompleteEvent.createEvent(CompleteEvent.MODULE_LOAD_COMPLETE));
					ApplicationGlobals.application.getEventManager().send(CompleteEvent.MODULE_LOAD_COMPLETE, CompleteEvent.createEvent(CompleteEvent.MODULE_LOAD_COMPLETE));
					return;
				}
				//开始下载模块
				loadOperation(_modBeanInfo);
			}
		}

		/**
		 * 启动
		 * 开始读取配置文件，下载模块
		 * 布局视图
		 * 
		 */		
		private var _start:Boolean=false;
		public function startUp(modPath:String=null):Boolean
		{
			if(_start)return _start;
			/** 添加容器到Application **/	
			_start = true;
			if(modPath == null)
				modPath = AMGlobals.info["modulePath"];
			if(modPath && modPath.indexOf("xml")!=-1)
			{
				var httpService:HttpService = new HttpService();
				httpService.loadFile(modPath,modulesConfigSuccess,modulesConfigFail);
			}else{
				Log.getLogger(this).error("[Module] 模块配置文件为空 或者 格式不是xml.");
			}
			
			return _start;
		}
		/**
		 * 
		 * @param name
		 * @return 
		 * 
		 */		
		public function getModuleBeanInfo(name:String):IModuleBeanInfo
		{
			if(containsModule(name))
			{
				var i:int=0;
				for each(var modBeanInfo:ModuleBeanInfo in _modBeansVector)
				{
					if(modBeanInfo.name == name)
						break;
					i++;
				}
				return _modBeansVector[i];
			}else{
				Log.getLogger(this).error("[Module] " + name + " 在   moduleconf.xml 中不存在.");
				return null;
			}
				
		}
		/**
		 * 添加模块到舞台 
		 * @param name
		 * 
		 */		
		public function addModule(name:String):void
		{
			addModuleByInfo(this.getModuleBeanInfo(name));
		}
		/**
		 * 删除模块 
		 * @param name
		 * 
		 */		
		public function removedModule(name:String):void
		{
			var modBeanInfo:IModuleBeanInfo = this.getModuleBeanInfo(name);
			if(AMGlobals.acm.measureContainer.getChildIndex(modBeanInfo.moduleInfo.module)!=-1)
				AMGlobals.acm.measureContainer.removeChild(modBeanInfo.moduleInfo.module);
			else if(AMGlobals.acm.windowContainer.getChildIndex(modBeanInfo.moduleInfo.module)!=-1)
				AMGlobals.acm.windowContainer.removeChild(modBeanInfo.moduleInfo.module);
			//钝化模块
			if(modBeanInfo.moduleInfo.module.hasOwnProperty("onRemoved"))
				modBeanInfo.moduleInfo.module["onRemoved"]();
			//log
			Log.getLogger(this).info("[ModuleManager] 模块 "+modBeanInfo.name+" 已经移除.");
		}
		
		/**
		 * 判断是否包含模块
		 * @param entityModle
		 * @return 
		 * 
		 */		
		public function containsModule(name:String):Boolean
		{
			return  _modBeansVector.some(function (item:*, index:int, vectory:Vector.<IModuleBeanInfo>):Boolean {
				if(name == item["name"])
					return true;
				else 
					return false;
			}, null);
		}
		
		/**
		 * 立即更新视图显示列表
		 * 
		 */		
		public function updateModuleDisplay():void
		{
			if(_modBeansVector.length==0)return;
			for each(var modBeanInfo:ModuleBeanInfo in _modBeansVector)
			{
				if(modBeanInfo.moduleInfo!=null && modBeanInfo.moduleInfo.module!= null)
				{
					if(modBeanInfo.moduleInfo.module.hasOwnProperty("onResize"))
					{
						modBeanInfo.moduleInfo.module["onResize"](ApplicationGlobals.application.stage.stageWidth,ApplicationGlobals.application.stage.stageHeight);
					}
					if(modBeanInfo.needLayout){
						if(modBeanInfo.absoluteLayout)
						{
							modBeanInfo.needLayout = false;
							LayoutManager.setRelativePosition(modBeanInfo.moduleInfo.module,ApplicationGlobals.application.measuredWidth,ApplicationGlobals.application.measuredHeight,modBeanInfo.center,modBeanInfo.middle,modBeanInfo.top,modBeanInfo.left,modBeanInfo.bottom,modBeanInfo.right);
						}
						else{
							LayoutManager.setRelativePosition(modBeanInfo.moduleInfo.module,ApplicationGlobals.application.stage.stageWidth,ApplicationGlobals.application.stage.stageHeight,modBeanInfo.center,modBeanInfo.middle,modBeanInfo.top,modBeanInfo.left,modBeanInfo.bottom,modBeanInfo.right);
						}
					}
				}
			}
		}
		
		/*******************************************************************************************
		/*******************************************************************************************
		 * Private method
		 * *****************************************************************************************/
		/**
		 * 模块配置文件加载成功
		 * 开始解析配置文件，并开始下载模块
		 * @param data
		 * 
		 */		
		private function modulesConfigSuccess(data:Object):void
		{
			//log
			Log.getLogger(this).info("[ModuleConfig] 模块配置文件加载成功.");
			var modulesXmlInfo:XMLList = XML(data).children();
			if(modulesXmlInfo.length()==0)
			{
				//log
				Log.getLogger(this).warn("[ModuleConfig] 模块配置文件为空.");
				return;
			}
			var index:Number=0;
			 for each(var modXML:XML in modulesXmlInfo)
			 {
				 if(modXML.attribute("delayLoad").length() && modXML.@delayLoad == "false")
					 _priorityLoads.push(modXML.@name);
				 
				 var modBeanInfo:ModuleBeanInfo = new ModuleBeanInfo(index, modXML.@name,modXML.@autoAddStage=="true",modXML.@autoLoad=="true",modXML.@delayLoad=="false",modXML.@absoluteLayout=="true",modXML.@mouseEnable=="true");
				 var modUrl:String = modBeanInfo.name;
				 if(modUrl.indexOf(".swf")==-1)modUrl+=".swf";
				 modBeanInfo.moduleInfo =  ModuleManager.getModule(modUrl);
				 modBeanInfo.moduleInfo.name = modBeanInfo.name;
				 if(modXML.attribute("delayLoadTime").length())
					 modBeanInfo.delayLoadTime = Number(modXML.@delayLoadTime);
					 
				 if(modXML.attribute("center").length())
					 modBeanInfo.center = Number(modXML.@center);
				 else if(modXML.attribute("left").length())
					 modBeanInfo.left = Number(modXML.@left);
				 else if(modXML.attribute("right").length())
					 modBeanInfo.right = Number(modXML.@right);
				 
				 if(modXML.attribute("middle").length())
					 modBeanInfo.middle = Number(modXML.@middle);
				 else if(modXML.attribute("top").length())
					 modBeanInfo.top = Number(modXML.@top);
				 else if(modXML.attribute("bottom").length())
					 modBeanInfo.bottom = Number(modXML.@bottom);
				 
				 index++;
				 //存储到数组
				 _modBeansVector.push(modBeanInfo);
			 }
			 
			 _acm = AMGlobals.acm as ApplicationContainManager;
			 _acm.createLayer(_modBeansVector);
			 //添加监听器
			 ApplicationGlobals.application.getEventDispatcher().addEventListener(ModuleEvent.READY,moduleReadyHandler);
			 ApplicationGlobals.application.getEventDispatcher().addEventListener(ModuleEvent.ERROR,moduleReadyHandler);
			 //转发配置加载完成
			 ApplicationGlobals.application.getEventManager().send(CompleteEvent.MODULE_CONF_COMPLETE);
			 ApplicationGlobals.application.getApplicationManager().bussnisePrecent = Math.round((Math.random()+1) * 2);
		}
		
		/**
		 * 是否有自动下载且没有下载的模块
		 * @return 
		 * 
		 */		
		private var _modBeanInfo:IModuleBeanInfo;
		private function search():IModuleBeanInfo
		{
			_modBeanInfo = null;
			
			for each(var modBeanInfo:ModuleBeanInfo in _modBeansVector)
			{
				if(modBeanInfo.autoLoad && !modBeanInfo.moduleInfo.loaded && containsInAction(modBeanInfo))
				{
					_modBeanInfo = modBeanInfo;
					break;
					
				}
			}
			return _modBeanInfo;
		}
		/**
		 *  模块信息是否在action中注册
		 * @param modBeanInfo
		 * @return 
		 * 
		 */		
		private function containsInAction(modBeanInfo:IModuleBeanInfo):Boolean
		{
			var hasMod:Boolean = false;
			for(var key:String in Command.ACTION)
			{
				if(key == modBeanInfo.moduleInfo.name)
				{
					hasMod = true;
					break;
				}
			}
			if(!hasMod)Log.getLogger(this).debug("[Module] " + modBeanInfo.name + " 模块 ，没有注册到Action中.");
			return hasMod;
		}
		
		/**
		 * 执行下载操作 
		 * @param name
		 * 
		 */		
		private function loadOperation(modBeanInfo:IModuleBeanInfo):void
		{
			if(modBeanInfo.moduleInfo.loaded){
				loadModule(_delay);
				return;
			}
			//log
			Log.getLogger(this).info("[Module] 开始加载 " + modBeanInfo.name + " 模块.");
			/*if(modUrl.indexOf(".swf")==-1)modUrl+=".swf";
			modBeanInfo.moduleInfo =  ModuleManager.getModule(modUrl);*/
			/** 延迟加载模块 **/
			if(modBeanInfo.delayLoadTime && _modBeanInfo.delayLoadTime>0)
				ApplicationGlobals.application.getTicker().tick(_modBeanInfo.delayLoadTime*1000,function timerCompleteHandler():void
				{
					modBeanInfo.moduleInfo.load();
				},1);
			else{
				  modBeanInfo.moduleInfo.load();
			}
				
		}

		/**
		 * 模块加载完成 
		 * @param event
		 * 
		 */		
		private function moduleReadyHandler(event:ModuleEvent):void
		{
			if(!_loadStart)return;
			/** 情况信息  **/
			_modBeanInfo = null;
			//设置模块加载进度
			ApplicationGlobals.application.getApplicationManager().bussnisePrecent = Math.round((Math.random()+1) * 2);
			var modBeanInfo:IModuleBeanInfo = getModuleBeanInfoByInfo(event.module);
			/** 模块加载完成初始化开始 **/
			initModule(modBeanInfo);
			/**继续加载模块**/
			loadModule(this._delay);
		}
		/**
		 * 初始化
		 * 模块添加到 舞台
		 * 更新模块的显示
		 * @param modBeanInfo
		 * 
		 */		
		private function initModule(modBeanInfo:IModuleBeanInfo):void
		{
			if(modBeanInfo.autoAddStage)
				this.addModuleByInfo(modBeanInfo);
			/** 关闭模块鼠标交互 **/
			if(!modBeanInfo.mouseEnable && modBeanInfo.moduleInfo.module is Sprite)
			{
				(modBeanInfo.moduleInfo.module as Sprite).mouseChildren=false;
				(modBeanInfo.moduleInfo.module as Sprite).mouseEnabled=false;
			}
			/** 更新模块视图布局 **/
			updateModuleDisplay();
		}
		
		/**
		 * 
		 * @param name
		 * @return 
		 * 
		 */		
		private function getModuleBeanInfoByInfo(module:IModuleInfo):IModuleBeanInfo
		{
			var i:int=0;
			for each(var modBeanInfo:ModuleBeanInfo in _modBeansVector)
			{
				if(modBeanInfo.moduleInfo == module)
					break;
				i++;
			}
			return _modBeansVector[i];
		}
		
		public function addModuleByInfo(modBeanInfo:IModuleBeanInfo):void
		{
			if(!_acm)
				_acm = AMGlobals.acm as ApplicationContainManager;
			if(modBeanInfo.moduleInfo.module == null)return;
			if(modBeanInfo.absoluteLayout && !AMGlobals.acm.measureContainer.contains(modBeanInfo.moduleInfo.module))
				_acm.addToMeasureContainer(modBeanInfo);
			else if(!AMGlobals.acm.windowContainer.contains(modBeanInfo.moduleInfo.module))
				_acm.addToWindowContainer(modBeanInfo);
			//调用模块startup
			if(modBeanInfo.moduleInfo.module.hasOwnProperty("onAdded"))
				modBeanInfo.moduleInfo.module["onAdded"]();
			//模块加载完成控制管理器调用action
			ControllerManager.onModuleLoaded(modBeanInfo.name);
		}
		
		/**
		 * 
		 * @param error
		 * 
		 */		
		private function modulesConfigFail(error:Error):void
		{
			//log
			Log.getLogger(this).error("[ModulePath] 下载视图配置文件失败. error：" + error.message);
		}
	}
}
import com.starway.framework.core.manager.IModuleBeanInfo;
import com.starway.framework.core.module.IModuleInfo;

class ModuleBeanInfo implements IModuleBeanInfo
{
	
	public function ModuleBeanInfo(index:Number, name:String,autoAddStage:Boolean,autoLoad:Boolean,priorityLoad:Boolean,absoluteLayout:Boolean,mouseEnable:Boolean)
	{
		_index = index;
		_name = name;
		_autoAddStage = autoAddStage;
		_autoLoad = autoLoad;
		_absoluteLayout = absoluteLayout;
		_mouseEnable = mouseEnable;
		_priorityLoad = priorityLoad;
	}
	
	private var _needLayout:Boolean=true;

	public function get needLayout():Boolean
	{
		return _needLayout;
	}

	public function set needLayout(value:Boolean):void
	{
		_needLayout = value;
	}

	private var _index:Number;
	public function get index():Number
	{
		return _index;
	}
	
	private var _layerIndex:Number;
	public function get layerIndex():Number
	{
        return _layerIndex;
	}
	public function set layerIndex(value:Number):void
	{
		_layerIndex = value;
	}
	
	private var _name:String;
	public function get name():String
	{
		return _name;
	}
	private var _autoAddStage:Boolean;
	public function get autoAddStage():Boolean
	{
		return _autoAddStage;
	}
	private var _autoLoad:Boolean;
	public function get autoLoad():Boolean
	{
		return _autoLoad;
	}
	private var _priorityLoad:Boolean;
	public function get priorityLoad():Boolean
	{
		return _priorityLoad;
	}
	private var _absoluteLayout:Boolean;
	public function get absoluteLayout():Boolean
	{
		return _absoluteLayout;
	}
	private var _mouseEnable:Boolean;
	public function get mouseEnable():Boolean
	{
		return _mouseEnable;
	}
	private var _delayLoadTime:Number;
	public function get delayLoadTime():Number
	{
		return _delayLoadTime;
	}
	
	public function set delayLoadTime(value:Number):void
	{
		_delayLoadTime = value;
	}
	
	private var _center:Number;
	public function get center():Number
	{
		return _center;
	}
	
	public function set center(value:Number):void
	{
		_center = value;
	}
	private var _middle:Number;
	public function get middle():Number
	{
		return _middle;
	}
	
	public function set middle(value:Number):void
	{
		_middle = value;
	}
	
	private var _top:Number;
	public function get top():Number
	{
		return _top;
	}
	
	public function set top(value:Number):void
	{
		_top = value;
	}
	private var _bottom:Number;
	public function get bottom():Number
	{
		return _bottom;
	}
	
	public function set bottom(value:Number):void
	{
		_bottom = value;
	}
	
	private var _left:Number;
	public function get left():Number
	{
		return _left;
	}
	
	public function set left(value:Number):void
	{
		_left = value;
	}
	private var _right:Number;
	public function get right():Number
	{
		return _right;
	}
	
	public function set right(value:Number):void
	{
		_right = value;
	}
	
	private var _module:IModuleInfo;
	public function get moduleInfo():IModuleInfo
	{
		return _module;
	}
	public function set moduleInfo(module:IModuleInfo):void
	{
		_module = module;
	}
}