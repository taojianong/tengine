package com.tloader {
	
	import com.log.TLog;
	import com.tloader.model.TSource;
	import com.tloader.util.TLoaderUtil;
	import com.geom.DMap;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.LoaderInfo;
	import flash.system.ApplicationDomain;
	
	/**
	 * 资源管理
	 * @author taojianlong 2014-5-28 20:37
	 */
	public class TSourceManager {
		
		/**
		 * 可设置当前版本号，用于加载资源时加载不同版本
		 * 改变版本号后可不加载已缓存在浏览器的原来版本资源,从而达到加载最新版本资源的目的
		 */
		public static var VERSION:String   = "?ver0.1.201405282040";
		
		//资源管理池,管理加载完后的资源缓存
		private static var sourcePool:DMap = new DMap( true );
		
		/**
		 * 添加资源
		 * @param	source
		 */
		public static function addSource( source:TSource ):TSource {
			
			if ( source == null ) {
				
				TLog.addLog("资源source不能为null" , TLog.LOG_WARN );
				return null;
			}
			
			/*if (  source.data == null ) {
				TLog.addLog("资源未加载完成，请检查对应资源 id: " + source.id + " url: " + source.url , TLog.LOG_ERROR );
				return;
			}*/
			
			if ( sourcePool.containsKey( source.id ) ) {
				
				TLog.addLog("缓存中已有该资源: " + source.toString() , TLog.LOG_WARN );
				return null;
			}
			
			sourcePool.put( source.id , source );
			
			return source;
		}
		
		public static function getTSource( id:String ):TSource {
			
			return sourcePool.get( id ) as TSource;
		}
		
		public static function hasTSource( id:String ):Boolean {
			
			return getTSource( id ) != null;
		}
		
		/**
		 * 获取非永久缓存资源数量
		 * @return
		 */
		private static function get notForeverSourceCount():int {
			
			var count:int = 0;			
			for each( var t:TSource in sourcePool.d ) {
				if ( t && !t.forever ) {
					count++;
				}
			}			
			return count;
		}
		
		/**
		 * 检测资源是否已经缓存
		 * @param   id 资源ID
		 * @return  Boolean 是否已经加载过
		 * */
		public static function hasCache( id:String ):Boolean {
			
			var s:TSource = getTSource( id );
			
			return s && s.data != null ;
		}
		
		/**
		 * 根据路径获得资源管理类里面的对象
		 * @param url:String 资源路径
		 * @return  Object 如果返回null，证明此路径不存在于加载资源管理类里面
		 * */
		public static function getObject( id:String ):Object {
			
			var t:TSource = getTSource( id );
			
			return t != null ? t.data : null;
		}
		
		/**
		 * 根据SWF文件路径及组件名获得资源管理类里面的组件
		 * @param   id            资源路径
		 * @param   linkName      要获取的链接名
		 * @return  DisplayObject 如果没有找到，返回null
		 * */
		public static function getComponent( id:String, linkName:String ):* {
			
			var t:TSource = getTSource( id );
			
			if ( t == null )
				return null;
				
			if ( t.extension != "swf")
				return null;
				
			var tempClass:Class = ( ( t.data.content as LoaderInfo).applicationDomain.getDefinition( linkName ) as Class );
			
			return tempClass != null ? new tempClass : null;			
		}
		
		/**
		 * 获取Swf域,或域中资源
		 * @param	id 资源ID
		 * @return
		 */
		public static function getSwfClass( id:String , className:String = null ):Class {
			
			var t:TSource = getTSource( id );
			
			if ( t == null ) {
				return null;
			}
			
			if ( t.isSwf ) {
				var loaderInfo:LoaderInfo = LoaderInfo( getContent( id ) );
				if (loaderInfo != null) {
					var app:ApplicationDomain = loaderInfo.applicationDomain;
					if (className == null) {
						return null;
					} else if ( app != null && app.hasDefinition(className) ) {
						return app.getDefinition( className ) as Class;
					} 
				}
			}
			
			return null;
		}
		
		/**
		 * 获取加载SWF文件域
		 * @param	id 资源ID
		 * @return
		 */
		public static function getApp( id:String ):ApplicationDomain {
			
			var obj:Object = getObject( id );
			
			if (obj != null && obj.content != null) {
				return obj.content.applicationDomain;
			}
			return null;
		}
		
		/**
		 * 获得加载的文本数据
		 * @param url 资源路径
		 * @return 文本数据
		 *
		 */
		public static function getContent( id:String ):* {
			
			var t:TSource = getTSource( id );
			
			return t != null ? t.data.content : null;			
		}
		
		/**
		 * 获取XML数据
		 * @param	id 资源ID
		 * @return
		 */
		public static function getXML( id:String ):XML {
			
			return XML( getContent( id ) );
		}
		
		/**
		 * 根据路径获得资源管理类里面的位图信息
		 * @param url:String 资源路径		 *
		 * @return  Bitmap 如果没有找到，返回null
		 * */
		public static function getBitmap( id:String ):Bitmap {
			
			var t:TSource = getTSource( id );
			
			if ( t == null ) {
				return null;
			}
			
			if ( t.isJpg || t.isJpeg || t.isGif || t.isPng ) {
				return new Bitmap( ( t.data.content as LoaderInfo ).loader.content["bitmapData"] );
			}
			else {
				return null;
			}
		}
		
		public static function getBitmapData( id:String ):BitmapData {
			
			var t:TSource = getTSource( id );
			
			if ( t == null ) {
				return null;
			}
			
			if ( t.isJpg || t.isJpeg || t.isGif || t.isPng ) {
				return ( t.data.content as LoaderInfo ).loader.content["bitmapData"] as BitmapData;
			}
			else {
				return null;
			}
		}
		
		
		//----------------------------------资源ID管理-----------------------------------
		
		//资源ID池
		private static var idPools:DMap = new DMap( true );
		
		public static function putSourceId( id:String ):void {
			
			if ( idPools.containsKey( id ) ) {
				if ( TSourceConst.isRigId ) { //是否严格管理资源ID
					TLog.addLog( "资源管理器中出现相同ID资源，该资源id为"+id+",请处理！" , TLog.LOG_ERROR );
				}
				else {
					TLog.addLog( "资源管理器中出现相同ID资源，该资源id为"+id+",请注意！" , TLog.LOG_WARN );
				}
			}
			else {
				idPools.put( id , id );
			}
		}
		
		
		//---------------------------------释放资源-----------------------------------
		
		/**
		 * 释放对应资源ID的资源
		 * @param id 资源ID
		 */
		public static function disposeSourceById( id:String = "" ):void {
			
			if ( sourcePool.containsKey( id ) ) {
				
				var t:TSource = sourcePool.get( id ) as TSource;
				TLog.addLog( "释放缓存资源 id: " + t.id + " url: " + t.url , TLog.LOG_LOAD );
				
				sourcePool.put( id , null );
				sourcePool.remove( id );
			}	
		}
		
		/**
		 * 对应url的资源
		 * @param	url
		 */
		public static function disposeSourceByUrl( url:String = "" ):void {
			
			for each( var t:TSource in sourcePool.d ) {
				if ( t && t.url == url ) {
					disposeSourceById( t.id );
					break;
				}
			}
		}
		
		/**
		 * 释放所有非永久缓存的资源
		 */
		public static function disposeAllNoForeverSource():void {
			
			while ( TSourceManager.notForeverSourceCount > 0 ) {				
				for each( var res:TSource in sourcePool.d ) {					
					if ( res && !res.forever ) {
						res.dispose();
						res = null;
					}					
				}				
			}
			
			TLoaderUtil.gc();
			
			TLog.addLog( "释放所有非永久缓存资源！" , TLog.LOG_LOAD );
		}
		
		public static function disposeAll():void {
			
			idPools.clear();
			
			//释放所有资源
			while ( sourcePool.keys > 0 ) {				
				for each( var res:TSource in sourcePool.d ) {					
					if ( res ) {
						res.dispose();
					}		
					res = null;
				}				
			}
			
			TLoaderUtil.gc();
			
			TLog.addLog( "清空资源ID池，并释放所有缓存资源！" , TLog.LOG_LOAD );
		}
	}

}