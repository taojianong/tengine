package com.tloader {
	import com.log.TLog;
	import com.tloader.model.TSource;
	
	
	/**
	 * 加载管理
	 * @author taojianlong 2014-6-3 21:42
	 */
	public class TLoadManager {
		
		/**
		 * 缓存正在加载的资源列表
		 * 不管是同步加载还是异步加载正在加载的数据都会缓存到这里，进行相应的处理
		 */
		public var loadSourceList:Vector.<TSource> = new Vector.<TSource>;
		
		/**
		 * 添加TSource资源数据
		 * @param	source
		 */
		public function addSource( source:TSource ):void {
			
			if ( source == null ) {
				return ;
			}
			
			if ( TSourceManager.hasCache( source ) ) {
				
				TLog.addLog( "缓存中已缓存该加载数据 id:" + s.id + " url: " + s.url + ",添加加载数据失败！" , TLog.LOG_ERROR );
				return;
			}
			
			if ( !hasSource( source ) ) {
				
				loadSourceList.push( source );
				
				TLog.addLog( "添加加载数据 id:" + s.id + " url: " + s.url + "到加载管理器中." );
			}
		}
		
		/**
		 * 移除资源
		 * @param source  TSource或url地址
		 */
		public function removeSource( source:* ):void {
			
			if ( source == null ) {
				return ;
			}
			
			var s:TSource;
			for each( s in loadSourceList ) {
				if ( ( source is TSource && s.url == source.url) || s.url == source ) {
					loadSourceList.splice( loadSourceList.indexOf( s ) , 1 );					
					TLog.addLog( "从加载管理器中移除加载数据 id:" + s.id + " url: " + s.url );
					break;
				}
			}			
		}
		
		/**
		 * 是否有该资源
		 * @param source  为TSource或url地址
		 * @param hasData 是否有数据，一般来说加载完的TSource是要从这里移除的！
		 * @return
		 */
		public function hasSource( source:* , hasData:Boolean = false ):Boolean {
			
			if ( source == null ) {
				return false;
			}
			
			for each( var s:TSource in loadSourceList ) {
				if ( ( source is TSource && s.url == source.url) || s.url == source ) {
					return hasData ? s.data != null : true;
				}
			}
			
			return false;
		}
		
		/**
		 * 当前正在加载的资源数
		 */
		public function get totalCount():int {
			
			return loadSourceList ? loadSourceList.length : 0;
		}
		
		/**
		 * 获取优先加载资源数量
		 */
		public function get topCount():int {
			
			var count:int = 0;
			for each( var s:TSource in loadSourceList ) {					
				if ( s.level == TSourceConst.LOAD_LEVEL_TOP ) {
					count++;
				}
			}
			return count;
		}
		
		/**
		 * 获取空间加载资源数量
		 */
		public function get freeCount():int {
			
			var count:int = 0;
			for each( var s:TSource in loadSourceList ) {					
				if ( s.level == TSourceConst.LOAD_LEVEL_FREE ) {
					count++;
				}
			}
			return count;
		}
		
		
		/**
		 * 释放加载管理
		 */
		public function dispose():void {
			
			while ( totalCount > 0 ) {
				
				var ind:int = 0;
				for each( var s:TSource in loadSourceList ) {					
					ind = loadSourceList.indexOf( s );
					if ( ind == -1 ) {
						continue;
					}
					s.dispose();
					loadSourceList[ ind ] == null;
					loadSourceList.splice( ind , 1 );
				}
			}
			
			TLog.addLog("释放加载管理器资源信息！");
		}
		
		private static var instance:TLoadManager;		
		public static function get Instance():TLoadManager {
			
			return instance = instance || new TLoadManager();
		}
	}

}