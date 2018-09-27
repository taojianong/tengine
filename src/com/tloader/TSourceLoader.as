package com.tloader {
	
	import com.events.TEventDispatcher;
	import com.log.TLog;
	import com.tloader.event.TLoaderEvent;
	import com.tloader.model.TAsynchroLoader;
	import com.tloader.model.TFreeLoader;
	import com.tloader.model.TSource;
	import com.tloader.model.TSynchroLoader;
	
	/**
	 * 加载器
	 * TODO设计两种加载方式，同步加载和异步加载
	 * @author taojianlong 2014-5-28 21:08
	 */
	public class TSourceLoader extends TEventDispatcher {
		
		//-----------------------------------------------------
		
		private var synchroLoader:TSynchroLoader = new TSynchroLoader();//同步加载器
		private var asynchroLoader:TAsynchroLoader = new TAsynchroLoader();//异步加载器
		private var freeLoader:TFreeLoader = new TFreeLoader(); //空闲加载器(异步加载器)
		
		/**
		 * 添加加载资源
		 * @param source 加载资源
		 * @param type 加载类型 同步加载还是异步加载 TSourceConst.LOAD_TYPE_SYNCHRO(0,同步加载)  TSourceConst.LOAD_TYPE_ASYNCHRO(1,异步加载)
		 */
		public function addTSource( source:TSource , type:int = 0 ):void {
			
			if ( source == null ) {
				return;
			}
			
			if ( TSourceManager.hasCache( source.id ) ) {
				
				TLog.addLog("资源已缓存！");
				return;
			}
			
			if ( source.isFreeLoad  ) { //是空闲加载并且没有在空闲加载列表中
				
				freeLoader.add( source );				
				if ( !freeLoader.isLoading ) {
					freeLoader.load();
				}
			}
			else if ( type == TSourceConst.LOAD_TYPE_SYNCHRO ) { //同步加载
				
				synchroLoader.add( source );
				
				if ( !synchroLoader.isLoading ) {
					synchroLoader.load();
				}
			}
			else if ( type == TSourceConst.LOAD_TYPE_ASYNCHRO ) { //异步加载
				
				asynchroLoader.add( source );				
				if ( !asynchroLoader.isLoading ) {
					asynchroLoader.load();
				}
			}	
			
			if ( !synchroLoader.hasEventListener( TLoaderEvent.LIST_COMPLETE ) ) {
				synchroLoader.addEventListener( TLoaderEvent.LIST_COMPLETE , loadComplete );
			}
			if ( !asynchroLoader.hasEventListener( TLoaderEvent.LIST_COMPLETE ) ) {
				asynchroLoader.addEventListener( TLoaderEvent.LIST_COMPLETE , loadComplete );
			}
			if ( !freeLoader.hasEventListener( TLoaderEvent.LIST_COMPLETE ) ) {
				freeLoader.addEventListener( TLoaderEvent.LIST_COMPLETE , loadComplete );
			}	
		}
		
		private function loadComplete( event:TLoaderEvent ):void {
			
			this.dispatchEvent( event ); 
		}
		
		/**
		 * 添加空闲加载列表
		 * @param list 资源列表
		 * @param type 加载类型 同步加载还是异步加载
		 *        TSourceConst.LOAD_TYPE_SYNCHRO ( 0 ,同步加载 )
		 *        TSourceConst.LOAD_TYPE_ASYNCHRO( 1 ,异步加载 )
		 */
		public function addTSourceList( list:Vector.<TSource> , type:int = 0 ):void {
			
			if ( list ) {
				
				//将那些空闲加载的资源清理掉,并添加到空闲加载器中
				for each( var t:TSource in list ) {					
					if ( t.isFreeLoad ) {
						freeLoader.add( t );				
						list.splice( list.indexOf( t ) , 1 );
					}
				}
					
				if ( type == TSourceConst.LOAD_TYPE_ASYNCHRO ) { //异步加载
					asynchroLoader.addTSourceList( list );
				}
				else if( type == TSourceConst.LOAD_TYPE_SYNCHRO ) { //同步加载
					synchroLoader.addTSourceList( list );
				}				
			}
		}
		
		/**
		 * 开始异步加载
		 */
		public function startAsynchroLoader():void {
			
			asynchroLoader.load();
		}
		
		/**
		 * 空闲加载列表,初步将空闲加载定为队列加载，这样可以节省带宽！
		 * 
		 */
		public function get freeList():Vector.<TSource> {
			
			return freeLoader.sourceList;
		}
		
		/**
		 * 该资源是否在空闲加载器中
		 * @param	source TSource 获取 url
		 * @return
		 * 
		 */
		public function hasFreeSource( source:* ):Boolean {
			
			if ( source == null ) {
				return false;
			}
			
			for each( var ts:TSource in freeList ) {
				if ( ( source && ts.id == source.id ) || ( source is String && ts.url == source ) ) {
					return true;
				}
			}
			
			return false;
		}
		
		/**
		 * 释放空闲加载器
		 * 
		 */
		public function disposeFreeLoader():void {
			
			freeLoader.dispose();			
		}
		
		/**
		 * 释放同步加载器
		 */
		public function disposeSynchroLoader():void {
			
			synchroLoader.dispose();
		}
		
		public function disposeAsynchroLoader():void {
			
			asynchroLoader.dispose();
		}
		
		//-----------------------------------------------------
		
		
		//-----------------------------------------------------
		
		private static var instance:TSourceLoader;
		public static function get Instance():TSourceLoader {
			
			return instance = instance || new TSourceLoader();
		}
	}

}