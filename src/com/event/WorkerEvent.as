package com.event {
	
	import flash.events.Event;
	
	/**
	 * 线程事件
	 * @author dragon 2016/9/1 14:27
	 */
	public class WorkerEvent extends Event {
		
		/**
		 * 线程初始化前
		 */
		public static const WORK_INIT_BEFORE:String = "workBefore";		
		
		/**
		 * 从子线程获得数据
		 */
		public static const GET_DATA_FROM_CHILD_WORKER:String = "getDataFromChildWorker";
		
		/**
		 * 创建子线程完成
		 */
		public static const CREATE_CHILD_WORKER_COMPLETE:String = "createChildWorkerComplete";
		
		/**
		 * 子线程运行结束后
		 */
		public static const CHILD_WORK_END:String = "childWorkEnd";
		
		public var data:* = null;
		
		public function WorkerEvent( type:String , data:* = null ) {
			
			super( type );
			
			this.data = data;
 		}	
	}
}