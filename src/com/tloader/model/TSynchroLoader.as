package com.tloader.model {
	
	import com.events.TEventDispatcher;
	import com.log.TLog;
	import com.tloader.event.TLoaderEvent;
	import com.tloader.TSourceConst;
	import com.tloader.TSourceLoader;
	import com.tloader.TSourceManager;
	import com.utils.CommonUtils;
	
	/**
	 * 同步加载器
	 * @author taojianlong 2014-6-3 21:12
	 */
	public class TSynchroLoader extends TEventDispatcher implements ITLoader {
		
		protected var _sourceList:Vector.<TSource> = null;
		
		protected var total:uint = 0; //总共需要加载的资源数量
		protected var loaded:uint = 0; //当前已加载的资源数量
		
		protected var _complete:Function = null;//加载完成事件
		protected var _completeParams:Array = null;//加载完成事件参数
		
		protected var loadingTSource:TSource;//当前正在加载的资源
		
		protected var loader:TLoader;//加载器
		
		public var isLoading:Boolean = false; //是否正在加载中
		
		/**
		 * 添加加载资源信息
		 * @param source
		 */
		public function add( source:TSource ):void {
			
			if ( _sourceList == null ) {
				TLog.addLog("添加资源不能为空！");
				return;
			}
			
			if ( source.isFreeLoad ) { //空闲加载资源				
				TLog.addLog( "添加资源中有空闲加载资源！" , TLog.LOG_WARN );
				return;
			}
			
			if ( hasTSource( source ) ) {
				
				TLog.addLog("资源已在同步加载器列表中！");
				return;
			}
			
			if ( TSourceManager.hasCache( source.id ) ) {
				
				TLog.addLog("资源已缓存！");
				return;
			}
			
			_sourceList = _sourceList || new Vector.<TSource>;
			
			_sourceList.push( source );	
			
			//如果正在加载中，则资源数+1
			if ( isLoading ) {
				total++;
			}
			
			TLog.addLog("添加资源 id: " + source.id + " url: " + source.url + "到[同步加载器]中。" );				
		}
		
		/**
		 * 添加加载资源列表
		 * @param	sourceList
		 */
		public function addTSourceList( sourceList:Vector.<TSource> ):void {
			
			if ( sourceList == null ) return;
			
			for each( var t:TSource in sourceList ) {
				add( t );
			}
		}
		
		/**
		 * 该资源是否在空闲加载器中
		 * @param	source TSource 获取 url
		 * @return
		 * 
		 */
		public function hasTSource( source:TSource ):Boolean {
			
			if ( source == null ) {
				return false;
			}
			
			for each( var ts:TSource in _sourceList ) {
				if ( ts.id == source.id ) {
					return true;
				}
			}
			
			return false;
		}
		
		/**
		 * 移除资源,如果资源正在加载则不能移除
		 * @param source
		 */
		public function remove( source:TSource ):void {
			
			if ( source == null ) {
				return;
			}
			
			if ( loadingTSource && source.id == loadingTSource.id ) {
				
				TLog.addLog("该资源正在同步加载器中加载 id: " + source.id + " url: " + source.url + "。" , TLog.LOG_ERROR );
				return;
			}
			
			var ind:int = _sourceList.indexOf( source );			
			if ( ind != -1 ) {
				_sourceList.splice( ind , 1 );
				total--;
				TLog.addLog("从同步加载器中移除资源 id: " + source.id + " url: " + source.url + "。" );
			}			
		}
		
		/**
		 * 开始加载资源
		 * @param complete 加载资源列表完成后调用的事件
		 * @param params   对应上面完成事件的方法参数
		 * */
		public function load( complete:Function = null , params:Array = null ):void {
			
			_complete = complete;
			_completeParams = params;
			
			//列表开始加载时触发
			if ( this.hasEventListener( TLoaderEvent.LIST_START ) ) {
				this.dispatchEvent( new TLoaderEvent(  TLoaderEvent.LIST_START , null , TSourceConst.LOAD_TYPE_SYNCHRO  ) );
			}
			
			total = _sourceList ? _sourceList.length : 0;
			
			if (total > 0) {
				
				isLoading = true;
				startSingle(); //开始加载
			}
			else {
				TLog.addLog("[同步加载]加载资源列表为空，不进行加载!" , TLog.LOG_ERROR );
				isLoading = false;
				if ( _complete != null ) {
					_complete.apply( null , _completeParams );
				}
			}
		}
		
		public function get loadComplete():Function {
			
			return _complete;
		}
		
		public function get loadCompleteParams():Array {
			
			return _completeParams;
		}
		
		/**
		 *加载单个资源
		 */
		private function startSingle():void {
			
			if ( loaded >= total || _sourceList == null || _sourceList.length == 0 ) {
				return;
			}
			
			loadingTSource = _sourceList.shift();
			if ( TSourceManager.hasTSource( loadingTSource.id ) ) {
				loadingTSource = TSourceManager.getTSource( loadingTSource.id );
			}
			else {
				TSourceManager.addSource( loadingTSource ); //设置当前加载的资源
			}
			
			//判断资源是否已经缓存过
			if ( loadingTSource.data == null ) {
				
				if ( this.hasEventListener( TLoaderEvent.SINGEL_START ) )
					this.dispatchEvent( new TLoaderEvent( TLoaderEvent.SINGEL_START , loadingTSource , TSourceConst.LOAD_TYPE_SYNCHRO ) );
				
				TLog.addLog( "[同步加载器]加载资源 id: " + loadingTSource.id + " url: " + loadingTSource.url , TLog.LOG_LOAD ); 
				loader = new TLoader( loadingTSource );
				loader.addEventListener( TLoaderEvent.SINGEL_COMPLETE, loadHandler );
				loader.addEventListener( TLoaderEvent.SINGEL_PROGRESS , loadHandler );
				loader.addEventListener( TLoaderEvent.SINGLE_ERROR , loadHandler );
				loader.start();
				
			} else {
				
				loaded++;
				
				startSingle();
				
				if ( loaded >= total ) {
					clear();
					//列表加载完成
					if ( this.hasEventListener( TLoaderEvent.LIST_COMPLETE ) ) {						
						this.dispatchEvent( new TLoaderEvent( TLoaderEvent.LIST_COMPLETE , null , TSourceConst.LOAD_TYPE_SYNCHRO ) );
					}
				}
			}
		}
		
		/**
		 *监听加载过程
		 */
		private function loadHandler( event:TLoaderEvent ):void {
			
			var loader:TLoader = event.currentTarget as TLoader;
			
			var tEvent:TLoaderEvent;
			
			if ( event.type == TLoaderEvent.SINGEL_COMPLETE ) { //加载单个资源完成
				
				TLog.addLog( "[同步]加载资源 " + loader.tSource.toString() + "完成." , TLog.LOG_LOAD );
				
				TSourceManager.getObject( event.tSource.id ).content = CommonUtils.cloneObject( loader.content );
				
				//加载单个资源完成
				if ( this.hasEventListener( TLoaderEvent.SINGEL_COMPLETE ) ) {
					
					tEvent = new TLoaderEvent( TLoaderEvent.SINGEL_COMPLETE , event.tSource , TSourceConst.LOAD_TYPE_SYNCHRO );
					tEvent.progress = 1;
					this.dispatchEvent( tEvent );
				}
				
				loaded++;
				
				//清除监听
				loader.dispose();
				loader = null;
				
				startSingle();
				
				if (loaded >= total) {
					
					clear();
					//加载列表完成
					if ( this.hasEventListener( TLoaderEvent.LIST_COMPLETE ) ) {						
						tEvent = new TLoaderEvent( TLoaderEvent.SINGEL_COMPLETE , null , TSourceConst.LOAD_TYPE_SYNCHRO );
						tEvent.progress = loaded / total;
						this.dispatchEvent( tEvent );
						
						TLog.addLog( "[同步]加载资源列表完成." , TLog.LOG_LOAD );
					}
					//加载完成方法
					if ( _complete != null ) {
						_complete.apply( null , _completeParams );
					}
				}
				
			}else if ( event.type == TLoaderEvent.SINGEL_PROGRESS ) { //加载单个资源进度
				
				//单个资源加载进度
				if ( this.hasEventListener( TLoaderEvent.SINGEL_PROGRESS ) ) {
					
					//tEvent = new TLoaderEvent( TLoaderEvent.SINGEL_PROGRESS , event.tSource , TSourceConst.LOAD_TYPE_SYNCHRO );
					//tEvent.progress = event.progress;
					//this.dispatchEvent( tEvent );
					
					this.dispatchEvent( event );
				}
				
				TLog.addLog("[同步加载]单个资源: " + event.tSource.toString() + " 完成.");
				
				//列表进度
				if ( this.hasEventListener( TLoaderEvent.LIST_PROGRESS ) ) {
					
					tEvent = new TLoaderEvent( TLoaderEvent.LIST_PROGRESS , null , TSourceConst.LOAD_TYPE_SYNCHRO );
					tEvent.progress = loaded / total ;
					this.dispatchEvent( tEvent );
				}
				
			}else if ( event.type == TLoaderEvent.SINGLE_ERROR ) { //加载单个资源错误
				
				if ( !event.tSource.canReLoad ) {
					
					TLog.addLog( "[同步加载]资源加载资源" + event.tSource.toString +"错误" , TLog.LOG_ERROR );	
					loaded++;
					startSingle(); //加载下一个资源
				}
				else {
					TLog.addLog( "[同步加载]资源加载资源"+ event.tSource.toString +"错误,并重新加载中!" , TLog.LOG_ERROR );
				}
			} 
		}
		
		//清除上一次加载操作的数据
		private function clear():void {
			
			while ( _sourceList && _sourceList.length > 0 ) {
				_sourceList.shift();
			}
			loaded = 0;
			total = 0;
			loadingTSource = null;
			loader.dispose();
			loader = null;
			isLoading = false;
		}
		
		/**
		 * 加载列表
		 */
		public function get sourceList():Vector.<TSource> {
			
			return _sourceList;
		}
		
		/**
		 * 释放资源
		 */
		public function dispose():void {
			
			clear();
			_sourceList = null;
			this.removeAllListeners();
		}
	}

}