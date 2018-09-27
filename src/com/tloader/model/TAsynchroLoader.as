package com.tloader.model {
	
	import com.events.TEventDispatcher;
	import com.log.TLog;
	import com.tloader.event.TLoaderEvent;
	import com.tloader.TSourceConst;
	import com.tloader.TSourceManager;
	import com.utils.CommonUtils;
	
	/**
	 * 异步加载器
	 * @author taojianlong 2014-6-3 21:13
	 */
	public class TAsynchroLoader extends TEventDispatcher implements ITLoader{
		
		protected var _sourceList:Vector.<TSource> = null;		
		
		protected var total:uint  = 0; //总共需要加载的资源数量
		protected var loaded:uint = 0; //当前已加载的资源数量
		
		protected var _complete:Function = null;//加载完成事件
		protected var _completeParams:Array = null;//加载完成事件参数
		
		protected var tLoaderList:Array = [];//加载器列表
		
		public var isLoading:Boolean = false; //是否正在加载中
		
		public function TAsynchroLoader( sourceList:Vector.<TSource> = null ) {
			
			_sourceList = sourceList || new Vector.<TSource>;
		}
		
		/**
		 * 加载资源列表
		 */
		public function get sourceList():Vector.<TSource> {
			
			return _sourceList;
		}
		
		/**
		 * 添加加载资源列表
		 * @param sourceList 资源列表
		 */
		public function addTSourceList( sourceList:Vector.<TSource> ):void {
			
			if ( sourceList == null ) return;
			
			for each( var t:TSource in sourceList ) {
				
				add( t );
			}
		}
		
		/**
		 * 添加资源
		 * @param	source
		 */
		public function add( source:TSource ):void {
			
			if ( source == null ) {
				TLog.addLog("添加资源不能为空！");
				return;
			}
			
			if ( source.isFreeLoad ) { //空闲加载资源				
				TLog.addLog( "添加资源中有空闲加载资源！" , TLog.LOG_WARN );
				return;
			}
			
			if ( TSourceManager.hasCache( source.id ) ) {
				
				TLog.addLog("资源已缓存！");
				return;
			}
			
			if ( hasTSource( source ) ) {
				
				TLog.addLog("资源已在同步加载器列表中！");
				return;
			}
			
			_sourceList = _sourceList || new Vector.<TSource>;
			
			_sourceList.push( source );			
			
			TLog.addLog("添加资源 id: " + source.id + " url: " + source.url + "到[同步加载器]中。" );
			
			if ( isLoading ) {
				total++;
				loadSingle( source );
			}	
		}
		
		/**
		 * 移除要下载的资源
		 * @param	source
		 */
		public function remove( source:TSource ):void {
			
			if ( source == null ) {
				return;
			}
			
			var ind:int = _sourceList.indexOf( source );			
			if ( ind != -1 ) {
				_sourceList.splice( ind , 1 );
				total--;
				TLog.addLog("从[异步加载器]中移除资源 id: " + source.id + " url: " + source.url + "。" );
			}
		}
		
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
		 * 开始加载资源
		 * @param	complete
		 * @param	params
		 */
		public function load( complete:Function = null , params:Array = null ):void {
			
			if ( _sourceList == null ) {
				return;
			}
			
			//列表开始加载时触发
			if ( this.hasEventListener( TLoaderEvent.LIST_START ) ) {
				this.dispatchEvent( new TLoaderEvent(  TLoaderEvent.LIST_START , null , TSourceConst.LOAD_TYPE_ASYNCHRO  ) );
			}
			
			var i:int = 0;
			
			for ( i = 0; i < _sourceList.length; i++ ) {
				
				loadSingle( _sourceList[ i ] ); //加载单个资源
			}
		}
		
		protected function loadSingle( tSource:TSource ):void {
			
			var tLoader:TLoader = new TLoader( tSource );
			tLoaderList.push( tLoader );
			tLoader.addEventListener( TLoaderEvent.SINGEL_START , loadHandler );
			tLoader.addEventListener( TLoaderEvent.SINGEL_COMPLETE , loadHandler );
			tLoader.addEventListener( TLoaderEvent.SINGEL_PROGRESS , loadHandler );				
			tLoader.addEventListener( TLoaderEvent.SINGLE_ERROR , loadHandler );
			tLoader.start();
		}
		
		protected function loadHandler( event:TLoaderEvent ):void {
			
			var tLoader:TLoader = event.target as TLoader;
			var tEvent:TLoaderEvent;
			switch( event.type ) {
				
				//开始加载
				case TLoaderEvent.SINGEL_START:
					if ( event.tSource != null && event.tSource.loadStart != null ) {
						event.tSource.loadStart.apply( null , event.tSource.loadStartParams );
					}
					break;
					
				//加载单个资源进度
				case TLoaderEvent.SINGEL_PROGRESS:
					var progress:Number = event.progress;// event.bytesLoaded / event.bytesTotal;
					TLog.addLog( "[异步]加载资源 " + tLoader.tSource.toString() + " 进度为: " + progress , TLog.LOG_LOAD  );
					//单个资源加载进度
					if ( this.hasEventListener( TLoaderEvent.SINGEL_PROGRESS ) ) {
						
						tEvent = new TLoaderEvent( TLoaderEvent.SINGEL_PROGRESS , event.tSource , TSourceConst.LOAD_TYPE_ASYNCHRO );
						tEvent.progress = progress ;
						this.dispatchEvent( tEvent );
					}
					break;
					
				
				case TLoaderEvent.SINGEL_COMPLETE:	//加载完成				
				case TLoaderEvent.SINGLE_ERROR: //加载错误
					
					//添加日志
					if ( event.type == TLoaderEvent.SINGLE_ERROR ) {
						TLog.addLog( "[异步]加载资源 " + tLoader.tSource.toString() + "错误." , TLog.LOG_ERROR );
					}
					else {
						TLog.addLog( "[异步]加载资源 " + tLoader.tSource.toString() + "完成." , TLog.LOG_LOAD );
					}
					
					//如果加载错误并资源不可重新加载,或者加载完成
					if (  ( event.type == TLoaderEvent.SINGLE_ERROR && !event.tSource.canReLoad ) || ( event.type == TLoaderEvent.SINGEL_COMPLETE ) ) {
						
						loaded++;
						tLoader.dispatchEvent( new TLoaderEvent( TLoaderEvent.SINGEL_COMPLETE , tLoader.tSource , TSourceConst.LOAD_TYPE_ASYNCHRO ) );
						tEvent = new TLoaderEvent( TLoaderEvent.LIST_PROGRESS , null , TSourceConst.LOAD_TYPE_ASYNCHRO );
						tEvent.progress = loaded / total;
						tLoader.dispatchEvent( tEvent );
						
						TSourceManager.getObject( event.tSource.id ).content = TLoaderEvent.SINGEL_COMPLETE ? CommonUtils.cloneObject( tLoader.content ) : null;
						
						if ( loaded == total ) {//所有资源加载完成	
							
							TLog.addLog( "[异步]加载资源列表完成." , TLog.LOG_LOAD );
							
							this.dispatchEvent( new TLoaderEvent( TLoaderEvent.LIST_COMPLETE , null , TSourceConst.LOAD_TYPE_ASYNCHRO ) );
							dispose();//释放资源
						}
					}					
					break;
			}
		}
		
		/**
		 * 释放所有资源
		 */
		public function dispose():void {
			
			loaded    = 0;
			total     = 0;
			isLoading = false;
			
			var tSource:TSource;
			//移除加载列表
			for each( tSource in _sourceList ) {				
				if ( tSource ) {
					ind = _sourceList.indexOf( tSource );
					tSource.dispose();
					_sourceList[ ind ] = null;
				}
			}
			while ( _sourceList && _sourceList.length > 0 ) {
				_sourceList.shift();
			}
			
			//移除所有加载器
			var tLoader:TLoader;
			var ind:int = 0;
			for each( tLoader in tLoaderList ) {				
				if ( tLoader ) {
					ind = tLoaderList.indexOf( tLoader );
					tLoader.dispose();
					tLoaderList[ ind ] = null;
				}
			}			
			while ( tLoaderList.length > 0 ) {				
				tLoaderList.shift();
			}
		}
	}

}