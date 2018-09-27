package com.manager {
	
	import com.event.WorkerEvent;
	import flash.concurrent.Mutex;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.registerClassAlias;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.utils.ByteArray;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	/**
	 * 线程管理
	 * 因为创建线程会创建一个新的AVM2，所以子线程最多一个两个
	 * @author dragon 2016/9/1 14:20
	 */
	public class WorkManager extends EventDispatcher{
		
		//互斥对象
		private var _mutex:Mutex;
		
		protected var mainToWorker:MessageChannel;//主线程到子线程的通道
		protected var workerToMain:MessageChannel;//子线程到主线程的通道
		
		protected var worker:Worker;
		
		protected var sharedBytes:ByteArray;
		
		public function WorkManager() {
		
			//创建互斥对象
            _mutex = new Mutex();
			
		}
		
		public function initWorkers( stage:Stage ):void{
			
			//这里可以注册要序列化的相关类
			//registerClassAlias("ActiveAwardDef", ActiveAwardDef); 
			
			//触发线程初始化的事件，可以执行线程开始前的一些操作,比如上面的序列号相关类
			this.dispatchEvent( new WorkerEvent( WorkerEvent.WORK_INIT_BEFORE ) );
			
			
			if (Worker.current.isPrimordial){//如果是主线程
				
				worker = WorkerDomain.current.createWorker(stage.loaderInfo.bytes);
				
				mainToWorker = Worker.current.createMessageChannel(worker);
				workerToMain = worker.createMessageChannel(Worker.current);
				
				worker.setSharedProperty("mainToWorker", mainToWorker);
				worker.setSharedProperty("workerToMain", workerToMain);
				worker.setSharedProperty("mutex",_mutex);
				
				workerToMain.addEventListener(Event.CHANNEL_MESSAGE, onWorkerToMain);
				
				sharedBytes = new ByteArray();
				sharedBytes.shareable = true;
				worker.setSharedProperty( "shareBytes" , sharedBytes );
				
				worker.start();
				
				this.dispatchEvent( new WorkerEvent( WorkerEvent.CREATE_CHILD_WORKER_COMPLETE ) );
					
			}else {
				mainToWorker = Worker.current.getSharedProperty("mainToWorker");
				workerToMain = Worker.current.getSharedProperty("workerToMain");
				mainToWorker.addEventListener(Event.CHANNEL_MESSAGE, onMainToWorker);
			}		
			
			mainToWorker
		}
		
		/**
		 * 将数据发送到子线程
		 * @param	data
		 */
		public function sendToChildWorker( data:Object ):void{
			
			if ( data != null ){
				setTimeout( function send():void{
					
					mainToWorker.send( data );
					
				} , 100 );	
			}
		}
		
		//Main >> Worker
		protected function onMainToWorker(event:Event):void {
			
			//从主线程接收到数据后			
			var msg:* = mainToWorker.receive(); //从主线程接收到的数据
			
			if ( Worker.current.isPrimordial ){
				trace("当前为主线程");
			}else{
				trace("当前为子线程");
				
				//在这里最好还是继承来实现相关方法，把这里的操作当作是在另外一个SWF执行，在主线程中应该不会触发相关监听的事件的!
				//子线程返回数据到主线程
				//workerToMain.send( dataList );
			}
		}
		
		private static var instance:WorkManager;		
		public static function get Instance():WorkManager{
			
			return instance = instance || new WorkManager();
		}
	}

}