package com.starway.framework.core.queue
{
	import com.starway.framework.core.ApplicationGlobals;

	public class QueueControl
	{
		public static const CONTEXT_NAME:String = "QueueControl";
		
		private var _taskArray:Array;
		private var _currentTask:ITask;
		public function QueueControl()
		{
			_taskArray = [];
		}
		
		public function startUp():void
		{
			ApplicationGlobals.application.getEventManager().listen("queuecomplete",checkQueue);
			checkQueue();
		}
		/**
		 * 添加任务到队列
		 * @param queue
		 * 
		 */		
		public function addTask(task:ITask):void
		{
			_taskArray.push(task);
		}
		/**
		 * 检查 队列是否还有任务
		 * 
		 */		
		private function checkQueue():void
		{
			if(_currentTask)ApplicationGlobals.application.getApplicationManager().bussnisePrecent = _currentTask.percent;
			if(_taskArray.length>0)
			{
				_currentTask = _taskArray.shift();
				_currentTask.startUp();
			}else{
				_currentTask = null;
				//所有业务加载完成
				ApplicationGlobals.application.getApplicationManager().bussnisePrecent = 100;
			}
		}
	}
}