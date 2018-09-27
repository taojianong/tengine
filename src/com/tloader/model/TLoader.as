package com.tloader.model {
	
	import com.events.TEventDispatcher;
	import com.log.TLog;
	import com.tloader.event.TLoaderEvent;
	import com.tloader.TSourceConst;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	/**
	 * 加载器
	 * @author taojianlong 2014-5-28 23:03
	 */
	public class TLoader extends TEventDispatcher{
		
		//加载类型
		public const TYPE_LOADER:String    = "loader"; //加载jpg,jpeg,swf,gif等资源
		public const TYPE_URLLOADER:String = "urlloader";//加载txt,xml等资源
		public const TYPE_SOUND:String     = "sound"; //加载声音资源
		
		private var _loader:Loader; //用于加载图片，SWF等资源
		private var _URLloader:URLLoader; //用于加载文本资源
		private var _sound:Sound;//用于加载声音
		
		private var type:String = TYPE_LOADER; //加载类型,默认加载图片
		
		private var _tSource:TSource; //加载资源数据		
		
		public function TLoader( resouce:TSource ) {
			
			this.tSource = resouce;
		}
		
		public function set tSource( value:TSource ):void {
			
			_tSource = value;
			
			if ( _tSource ==  null ) {				
				this.dispose();
				return;
			}
		}
		/**加载资源数据**/
		public function get tSource():TSource {
			
			return _tSource;
		}
		
		/**
		 * 开始加载
		 */
		public function start():void {
			
			if ( _tSource == null ) {				
				return;
			}
			
			var isStart:Boolean = true; //是否开始加载
			var urlRequest:URLRequest = new URLRequest( _tSource.url );
			switch ( _tSource.extension ) {
				case TSourceConst.SOURCE_SWF: 
				case TSourceConst.SOURCE_JPG: 
				case TSourceConst.SOURCE_JPEG: 
				case TSourceConst.SOURCE_GIF: 
				case TSourceConst.SOURCE_PNG:				
					this.type = TYPE_LOADER;
					try {
						
						if ( _loader == null ) {
							_loader = new Loader;
							_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadHandler);
							_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadHandler);
							_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadHandler);
						}
						if ( this.hasEventListener( TLoaderEvent.SINGEL_START ) ) {
							this.dispatchEvent( new TLoaderEvent( TLoaderEvent.SINGEL_START , this.tSource ) );
						}
						
						if ( _tSource.isSwf ) {
							//将SWF文件加载进主文件域中
							_loader.load( urlRequest , new LoaderContext( false , ApplicationDomain.currentDomain ) );
						}else {
							_loader.load( urlRequest );
						}
						
					} catch (e:*) {
						TLog.addLog( "TLoader错误!" , TLog.LOG_ERROR );
						isStart = false;
					}
					break;
				
				case TSourceConst.SOURCE_TXT: 
				case TSourceConst.SOURCE_XML:				
					this.type = TYPE_URLLOADER;
					try {
						if ( _URLloader == null ) {
							_URLloader = new URLLoader;
							_URLloader.addEventListener(Event.COMPLETE, loadHandler);
							_URLloader.addEventListener(IOErrorEvent.IO_ERROR, loadHandler);
							_URLloader.addEventListener(ProgressEvent.PROGRESS, loadHandler);
						}						
						_URLloader.load(urlRequest);
						
					} catch (e:*) {
						TLog.addLog( "TLoader错误!" , TLog.LOG_ERROR );
						isStart = false;
					}
					break;
					
				case TSourceConst.SOURCE_MP3:
					this.type = TYPE_SOUND;
					try {
						if ( _sound == null ) {
							_sound = new Sound();			
							_sound.addEventListener(Event.COMPLETE, loadHandler);
							_sound.addEventListener(IOErrorEvent.IO_ERROR, loadHandler);
							_sound.addEventListener(ProgressEvent.PROGRESS, loadHandler);
						}						
						_sound.load(urlRequest);
					} catch (e:*) {
						TLog.addLog( "TLoader错误!" , TLog.LOG_ERROR );
						isStart = false;
					}					
					break;
				
				default: 
					TLog.addLog( "加载错误,TLoader不能识别的文件!" , TLog.LOG_ERROR );
					isStart = false;
					break;
			}
			
			if ( isStart ) {
				this.dispatchEvent( new TLoaderEvent(TLoaderEvent.SINGEL_START ,  _tSource ) );
			}
		}
		
		/**
		 * 停止下载
		 */
		public function stop():void {
			
			if ( _loader != null ) {
				_loader.close();
			}
			if ( _URLloader != null ) {
				_URLloader.close();
			}
			if ( _sound != null ) {
				_sound.close();
			}
		}
		
		private function loadHandler( event:Event ):void {
			
			var tEvent:TLoaderEvent;
			
			switch( event.type ) {
				
				//加载进度
				case ProgressEvent.PROGRESS:
					tEvent = new TLoaderEvent( TLoaderEvent.SINGEL_PROGRESS , _tSource );
					tEvent.progress = ProgressEvent( event ).bytesLoaded / ProgressEvent( event ).bytesTotal;
					break;
					
				case Event.COMPLETE:
					tEvent = new TLoaderEvent( TLoaderEvent.SINGEL_COMPLETE , _tSource );
					tEvent.progress = 1;
					break;
					
				case IOErrorEvent.IO_ERROR:
					tEvent = new TLoaderEvent( TLoaderEvent.SINGLE_ERROR , _tSource );
					tEvent.progress = 0;
					if ( _tSource.canReLoad ) {
						reLoad();
						TLog.addLog("资源 id: "+ _tSource.id + " url: " + _tSource.url + "加载错误，重新加载中！",TLog.LOG_ERROR);
						return;
					}
					break;
			}
			
			this.dispatchEvent( event );
			if ( tEvent != null ) {
				this.dispatchEvent( tEvent ); 
			}
			
			if ( event.type == Event.COMPLETE ) {				
				dispose();
			}
		}
		
		//重新加载
		private function reLoad():void {
			
			if ( _loader != null ) {
				_loader.close();
			}
			if ( _URLloader != null ) {
				_URLloader.close();
			}
			if ( _sound != null ) {
				_sound.close();
			}
			
			start();
		}
		
		/**
		 * 获取加载内容
		 * @return 如果是Loader加载swf信息,则返回Loader
		 *         如果是URLloader加载XML和text等信息,则返回data数据
		 * */
		public function get content():* {
			switch (this.type) {
				
				//图像资源等
				case TYPE_LOADER: 
					return this._loader.contentLoaderInfo;
					break;
				//文本资源
				case TYPE_URLLOADER: 
					return this._URLloader.data;					
					break;
					
				//声音资源
				case TYPE_SOUND:
					return _sound;
					break;
			}
		}
		
		/**
		 * 释放资源
		 */
		public function dispose():void {
			
			TLog.addLog( "释放加载器 当前加载资源为id: " + _tSource.id + " url: " + _tSource.url , TLog.LOG_LOAD );
			
			if ( _loader != null ) {
				_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadHandler);
				_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadHandler);
				_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loadHandler);
				_loader.close();
				_loader.unloadAndStop();				
			}
			
			if ( _URLloader != null ) {
				_URLloader.removeEventListener(Event.COMPLETE, loadHandler);
				_URLloader.removeEventListener(IOErrorEvent.IO_ERROR, loadHandler);
				_URLloader.removeEventListener(ProgressEvent.PROGRESS, loadHandler);
				_URLloader.close();				
			}
			
			if ( _sound != null ) {
				_sound.removeEventListener(Event.COMPLETE, loadHandler);
				_sound.removeEventListener(IOErrorEvent.IO_ERROR, loadHandler);
				_sound.removeEventListener(ProgressEvent.PROGRESS, loadHandler);
				_sound.close();
			}
			
			_tSource   = null;
			_loader    = null;
			_URLloader = null;
			_sound     = null;	
			
			this.removeAllListeners();
		}
		
	}

}