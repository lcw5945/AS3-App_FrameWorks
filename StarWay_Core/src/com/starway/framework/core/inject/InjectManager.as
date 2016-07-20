package com.starway.framework.core.inject
{
	/**
	 * @author Cray 
	 * @version 1.0
	 * @date Nov 7, 2014 11:26:45 AM
	 */
	public class InjectManager implements IInjectManager
	{
		public static const CONTEXT_NAME:String = "InjectManager";
		
		private var _injectVector:Vector.<InjectBean> = new Vector.<InjectBean>;
		public function InjectManager()
		{
		}
		
		/**
		 * 注入检测
		 * 如果注入完成则返回
		 * 否则进行注入操作 
		 */		
		private var _injecOpert:InjectOperation =  new InjectOperation();
		public function inject(ins:Object):void
		{
			var jb:InjectBean;			
			if(contains(ins))
			{
				for each(jb in _injectVector)
				{
					if(jb.ins == ins)break;
				}
			}
			else
			{
				jb = new InjectBean(ins,false)
				_injectVector.push(jb);
			}
			if(jb.finished)return;
			else
			jb.finished = _injecOpert.anlaysMeta(ins);
		}
		
		/**
		 * 是否包含 
		 * @param action
		 * @return 
		 * 
		 */		
		private function contains(ins:Object):Boolean
		{
			return _injectVector.some(function (item:*,index:int,iv:Vector.<InjectBean>):Boolean
			{
				if(item.ins == ins)
					return true;
				else 
					return false;
			});
		}
	}
}


class InjectBean{
	public var ins:Object;
	public var finished:Boolean;
	
	public function InjectBean(o:Object,f:Boolean)
	{
		ins = o;
		finished = f;
	}
}