package com.load {
	
	import com.event.TEventDispatcher;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.BinaryDataLoader;
	import com.greensock.loading.DataLoader;
	import com.greensock.loading.display.ContentDisplay;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.MP3Loader;
	import com.greensock.loading.SWFLoader;
	import com.greensock.loading.XMLLoader;
	import com.load.event.TweenLoaderEvent;
	import com.load.util.LoaderUtil;
	import com.log.TLog;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.external.ExternalInterface;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.utils.Dictionary;
	
	/**
	 * 加载管理
	 * @author cl 2014/11/13 11:31
	 */
	public class TweenLoader extends TEventDispatcher{
		
		/**
		 * 加载单个资源
		 * @param	resource	资源
		 * @param	complete	加载完成事件
		 * @param	args		加载完成事件参数
		 */
		public static function loadSingle( resource:Resource , complete:Function = null , args:Array = null ):TweenLoader {
			
			var list:Array = [ resource ];
			
			return TweenLoader.load( list , complete , args );
		}
		
		/**
		 * 加载资源列表
		 * @param	list		资源列表
		 * @param	complete	资源列表加载完成事件
		 * @param	args		完成事件参数
		 */
		public static function load( list:Array , complete:Function = null ,  args:Array = null ):TweenLoader {
			
			var tweenLoader:TweenLoader = new TweenLoader();
			tweenLoader.addEventListener( TweenLoaderEvent.LOAD_ALL_COMPLETE , completeHandler );
			tweenLoader.loadList( list );			
			function completeHandler( event:TweenLoaderEvent ):void {				
				tweenLoader.removeEventListener( TweenLoaderEvent.LOAD_ALL_COMPLETE , completeHandler );
				tweenLoader.clear();
				if ( complete != null ) {
					complete.apply( null , args );
				}
			}
			return tweenLoader;
		}
		
		private static const cachePool:Dictionary = new Dictionary();//缓存资源池
		
		/**
		 * 加载完成后缓存该资源到池中
		 * @param	id		缓存资源ID
		 * @param	data	缓存资源
		 */
		public static function cacheSource( id:String , data:* = null ):void {
			
			if ( cachePool[ id ] == null ) {
				cachePool[ id ] = data;
			}
			else {
				TLog.addLog( "已缓存该资源" , TLog.LOG_ERROR );
			}
		}
		
		/**
		 * 获取对应资源
		 * @param	nameOrUrl	资源ID或资源URL
		 * @param	link		SWF资源对应的链接名
		 * @return
		 */
		public static function getSource( nameOrUrl:String , link:String = "" ):*{
			
			var data:* = TweenLoader.getData( nameOrUrl );
			if ( data is MovieClip ) {
				var app:ApplicationDomain = data.loaderInfo.applicationDomain;
				if ( link == "" || link == null ) {
					return app;
				}
				else if( app.hasDefinition( link ) ) {
					data = TweenLoader.getSWFComponent( nameOrUrl , link ) ;		
					return data is Bitmap ? ( data as Bitmap ).bitmapData : ( data is BitmapData ? data : data );
				}
			}			
			return data;
		}
		
		/**
		 * 对应资源的数据
		 * @param url 缓存地址
		 */
		public static function getData( nameOrURL:String ):*{
			
			var cont:* = LoaderMax.getContent( nameOrURL );			
			if ( cont is ContentDisplay ) {
				return ContentDisplay( cont ).rawContent;
			}			
			return cont || cachePool[ nameOrURL ];
		}
		
		/**
		 * 获取SWF中的组件
		 * @param	nameOrUrl	缓存ID或缓存地址
		 * @param	link		链接名
		 * @return
		 */
		public static function getSWFComponent( nameOrUrl:String , link:String = "" ):*{
			
			var app:ApplicationDomain = nameOrUrl ? TweenLoader.getApp( nameOrUrl ) : ApplicationDomain.currentDomain;
			if ( app != null && app.hasDefinition( link ) ) {
				var tempClass:Class= app.getDefinition( link ) as Class;
				return new tempClass();
			}			
			return null;
		}
		
		/**
		 * 获取对应SWF的域
		 * @param nameOrUrl 缓存ID或缓存地址
		 * @return
		 */
		public static function getApp( nameOrUrl:String ):ApplicationDomain {
			
			var mc:MovieClip = TweenLoader.getData( nameOrUrl ) as MovieClip;
			if (mc == null ) return null;
			var app:ApplicationDomain = mc.loaderInfo.applicationDomain;			
			return app;
		}
		
		/**
		 * 获取BitmapData
		 * @param url 	资源URL地址
		 * @param link 	资源链接名，JPG或PNG为""
		 **/
		public static function getBmpd( url:String , link:String = "" ):BitmapData {
			
			var ext:String = LoaderUtil.getFileExtension( url );
			var data:* =  ext == "swf" && link != "" ? TweenLoader.getSWFComponent( url , link ) : TweenLoader.getData( url );		
			var bmd:BitmapData = data is Bitmap ? ( data as Bitmap ).bitmapData : ( data is BitmapData ? data : null );
			return bmd;
		}
		
		/**
		 * 释放资源
		 * @param nameOrUrl 对应资源的ID或URL
		 */
		public static function disposeSource( nameOrUrl:String ):void {
			
			var loader:* = LoaderMax.getLoader( nameOrUrl );
			if ( loader != null && cachePool[ loader.name ] != null ) {
				cachePool[ loader.name ] = null;
				delete cachePool[ loader.name ];
			}
			
			var cont:* = LoaderMax.getContent( nameOrUrl );			
			if ( cont is ContentDisplay ) {
				ContentDisplay( cont ).dispose();
			}
		}
		
		public static function disposeAllSource():void {
			
			var isBreak:Boolean = false ;
			while ( !isBreak ) {
				isBreak = true;
				for each( var res:Resource in cachePool ) {
					if ( res != null ) {
						isBreak = true;
						res.dispose();
					}
				}
			}
		}
		
		//---------------------------------------------------华丽丽的分隔线----------------------------------------------------------
		
		
		private var _loadList:Array 	= [];//加载列表
		private var _complete:Function 	= null;//加载完成事件		
		private var queue:LoaderMax;//加载器
		
		/**
		 * 加载单个文件
		 * @param	resource
		 * @param	complete
		 */
		public function load( resource:Resource , complete:Function = null ):void {
			
			this.loadList( [resource] , complete );
		}
		
		/**
		 * 加载资源列表
		 * @param	list
		 */
		public function loadList( list:Array , complete:Function = null ):void {
			
			_complete = complete;
			_loadList = this.clearLoadList( list );
			
			if ( list == null || _loadList.length <= 0 ) {
				allLoadComplete();
				return;
			}
			
			queue = new LoaderMax( {name:"muiltLoad", onProgress:progressHandler, onComplete:loadComplete, onError:errorHandler} );
			var i:int = 0;
			var resource:Resource;
			
			for ( i = 0 ; i < _loadList.length;i++ ) {
				resource = _loadList[i];
				if ( resource != null ) {
					
					if ( resource.isXML ) {
						queue.append( new XMLLoader( resource.url , { name:resource.id , onProgress:progressHandler1, onComplete:completeHandler1, onError:errorHandler1} ));
					}else if ( resource.isJson ){
						queue.append( new DataLoader( resource.url , { name:resource.id , onProgress:progressHandler1, onComplete:completeHandler1, onError:errorHandler1} ));
					}
					else if( resource.isJPG || resource.isPNG ){
						queue.append( new ImageLoader( resource.url , { name:resource.id , onProgress:progressHandler1, onComplete:completeHandler1, onError:errorHandler1} ));
					}
					else if ( resource.isSWF ) {
						
						//如果在网页中加载设置此则加载不同域中，不设置默认加载到同一个域中，加在同一个域中时，不同SWF的LINK资源同名的话只能取其中一个！
						var lc : LoaderContext = null;
						if ( ExternalInterface.available ) {
							lc						= new LoaderContext();
							lc.securityDomain		= SecurityDomain.currentDomain; 
							lc.applicationDomain 	= new ApplicationDomain();
						}
						if ( resource.loadToCurrentDomain ){
							lc					 = new LoaderContext();
							lc.applicationDomain = ApplicationDomain.currentDomain;//当前域
						}
						queue.append( new SWFLoader( resource.url , { name:resource.id , context:lc , autoPlay:false , onProgress:progressHandler1, onComplete:completeHandler1, onError:errorHandler1 } ));
					}
					else if ( resource.isMP3 ) {
						queue.append( new MP3Loader( resource.url , { name:resource.id , repeat:0 , autoPlay:false , onProgress:progressHandler1, onComplete:completeHandler1, onError:errorHandler1} ));
					}else{ //二进制方式加载
						queue.append( new BinaryDataLoader( resource.url , { name:resource.id , onProgress:progressHandler1, onComplete:completeHandler1, onError:errorHandler1} ));
					}
				}
			}
			queue.load();
			
			var _this:TweenLoader = this;
			
			function progressHandler1(event:LoaderEvent):void {
				//trace("progress: " + event.target.progress);	
				if ( _this.hasEventListener( TweenLoaderEvent.LOAD_SINGLE_PROGRESS ) ) {
					_this.dispatchEvent( new TweenLoaderEvent( TweenLoaderEvent.LOAD_SINGLE_PROGRESS , { name:event.target.name ,"loadedBytes":event.target.bytesLoaded , "totalBytes":event.target.bytesTotal , "progress":event.target.progress } ) );
				}
			}

			function completeHandler1(event:LoaderEvent):void {
				
				var str:String = "加载: " + event.target.name + " --------------------->>> url: " + event.target.url + " 完成.";
				trace( str );	
				
				completeHandler( event ); //加载单个资源完成
				
				if ( _this.hasEventListener( TweenLoaderEvent.LOAD_SINGLE_COMPLETE ) ) {
					_this.dispatchEvent( new TweenLoaderEvent( TweenLoaderEvent.LOAD_SINGLE_COMPLETE , { name:event.target.name , "progress":1 , "url":event.target.url } ) );
				}
			}
			 
			function errorHandler1(event:LoaderEvent):void {
				
				//trace("error occured with " + event.target + ": " + event.text);
				
				if ( _this.hasEventListener( TweenLoaderEvent.LOAD_SINGLE_ERROR ) ) {
					_this.dispatchEvent( new TweenLoaderEvent( TweenLoaderEvent.LOAD_SINGLE_ERROR , { name:event.target.name ,"error":event.text , "url":event.target.url } ) );
				}
			}
			
			//所有资源加载完成
			function loadComplete( event:LoaderEvent ):void {
				
				if ( _complete != null ) {
					_complete();
				}
				
				if ( _this != null ) {
					_this.dispatchEvent( new TweenLoaderEvent( TweenLoaderEvent.LOAD_ALL_COMPLETE , { name:event.target.name ,"loadedBytes":event.target.bytesLoaded , "totalBytes":event.target.bytesTotal , "progress":event.target.progress } ) );
				}
				
				clear();
			}		
		}
		
		//所有资源加载完成
		private function allLoadComplete():void {
			
			if ( _complete != null ) {
				_complete();
			}
			
			if ( this.hasEventListener( TweenLoaderEvent.LOAD_ALL_COMPLETE ) ) {
				this.dispatchEvent( new TweenLoaderEvent( TweenLoaderEvent.LOAD_ALL_COMPLETE ) );
			}	
			
			this.clear();
		}
		
		private function progressHandler(event:LoaderEvent):void {
			
			//trace("progress: " + event.target.progress);
			if ( this.hasEventListener( TweenLoaderEvent.LOAD_ALL_PROGRESS ) ) {
				this.dispatchEvent( new TweenLoaderEvent( TweenLoaderEvent.LOAD_ALL_PROGRESS , { "loadedBytes":event.target.bytesLoaded , "totalBytes":event.target.bytesTotal , "progress":event.target.progress } ) );
			}
		}

		//加载完成单个资源
		private function completeHandler(event:LoaderEvent):void {
			
			//trace(event.target + " is complete!");	
			
			this.cacheSource( event.target.name , event.target.content );
		}
		 
		private function errorHandler(event:LoaderEvent):void {
			
			//trace("error occured with " + event.target + ": " + event.text);			
			TLog.addLog( "加载资源 id: " + event.target.name + " url: " + event.target.url + " 错误." , TLog.LOG_ERROR );
		}
		
		//缓存资源
		private function cacheSource( id:String , data:* = null ):void {
			
			var res:Resource = this.getResource( id );			
			if ( res == null ) {
				return;
			}
			
			var cont:* = TweenLoader.getData( res.id ) || data;
			
			if ( res != null && res.complete != null ) {
				res.complete.apply( null , [ cont ] );
			}
			
			TweenLoader.cacheSource( id , cont );
		}
		
		private function getResource( id:String ):Resource {
			
			for each( var res:Resource in _loadList ) {
				if ( res.id == id ) {
					return res;
				}
			}
			return null;
		}
		
		/**
		 * 清理资源
		 * @param	list
		 * @return
		 */
		private function clearLoadList( list:Array ):Array {
			
			if ( list == null ) {
				list = [];
				return list;
			}
			
			//检测是否有已缓存了的资源,并去掉重合的资源
			var resource:Resource;
			var cache:Object = { };
			var i:int;
			for ( i = list.length - 1 ; i >= 0;i-- ) {
				resource = list[i];
				if ( resource != null ) {						
					if ( resource.hasCache ) {
						list.splice( i , 1 );
					}	
				}
			}		
			return list;
		}
		
		/**
		 * 加载对应XML配置中的资源
		 * @param	xml
		 * //加载对应XML配置中的文件
			<data> 
				 <ImageLoader url="1.jpg" name="image1" load="true" /> 
				 <ImageLoader url="2.jpg" name="image2" load="true" /> 
			</data>
			
			TODO:
		 */
		public function loadXMLSource( xml:XML ):void {
			
			LoaderMax.activate( [ImageLoader, SWFLoader ] );
			var loader:XMLLoader = new XMLLoader("data.xml", {onComplete:completeHandler,estimatedBytes:50000}); 
			loader.load();
			function completeHandler(event:LoaderEvent):void{ 
				//var image1:Bitmap = LoaderCore( LoaderMax.getLoader("image1") ).content as Bitmap; 
				//var image2:Bitmap = LoaderCore( LoaderMax.getLoader("image2") ).content as Bitmap; 
			}
		}
		
		public function clear():void {
			
			this.removeAllListeners();
			
			_complete 	 = null;
			_loadList	 = [];
			if ( queue != null ) {
				//queue.dispose();
				queue = null;
			}
		}
	}
}