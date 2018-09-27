package com.customLoader.loader {
	
	import com.customLoader.util.LoaderUtil;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	
	/**
	 * 加载单个资源loader类
	 * */
	public class SourceLoader extends EventDispatcher {
		
		public var urlRequest:URLRequest;
		private var _type:String = "";
		private var _loader:Loader;
		private var _URLloader:URLLoader;
		
		/**
		 * 加载单个资源loader类
		 * @param url:String 资源路径
		 * */
		public function SourceLoader(url:String) {
			
			urlRequest = new URLRequest(url);
			
			var extension:String = LoaderUtil.getFileExtension(url);
			
			switch (extension) {
				case "swf": 
				case "jpg": 
				case "jpeg": 
				case "gif": 
				case "png": 
					this._type = "_loader";
					try {
						_loader = new Loader;
						this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, eventFunction);
						this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, eventFunction);
						this._loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, eventFunction);
						
						if ( extension == "swf" ) {
							//将SWF文件加载进主文件域中
							this._loader.load( urlRequest , new LoaderContext(false ,ApplicationDomain.currentDomain ) );
						}else {
							this._loader.load(urlRequest);
						}
						
					} catch (e:*) {
						throw("[ SourceLoader 错误 ]");
					}
					break;
				
				case "txt": 
				case "xml": 
					this._type = "_URLloader";
					try {
						_URLloader = new URLLoader;
						this._URLloader.addEventListener(Event.COMPLETE, eventFunction);
						this._URLloader.addEventListener(IOErrorEvent.IO_ERROR, eventFunction);
						this._URLloader.addEventListener(ProgressEvent.PROGRESS, eventFunction);
						this._URLloader.load(urlRequest);
						
					} catch (e:*) {
						throw("[SourceLoader 错误 ]");
					}
					break;
				
				default: 
					throw("[SourceLoader 错误 ]不能识别的文件后缀-" + extension);
					break;
			}
		}
		
		/**
		 * 获取加载内容
		 * @return 如果是Loader加载swf信息,则返回Loader
		 *         如果是URLloader加载XML和text等信息,则返回data数据
		 * */
		public function get content():* {
			switch (this._type) {
				case "_loader": 
					return this._loader.contentLoaderInfo;
					break;
				
				case "_URLloader": 
					return this._URLloader.data;
					break;
			}
		}
		
		//发送事件
		private function eventFunction(evt:Event):void {
			if (evt.type == Event.COMPLETE)
				clear();
			
			dispatchEvent(evt);
		}
		
		//清除事件
		private function clear():void {
			if (_loader) {
				this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, eventFunction);
				this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, eventFunction);
				this._loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, eventFunction);
			}
			
			if (_URLloader) {
				this._URLloader.removeEventListener(Event.COMPLETE, eventFunction);
				this._URLloader.removeEventListener(IOErrorEvent.IO_ERROR, eventFunction);
				this._URLloader.removeEventListener(ProgressEvent.PROGRESS, eventFunction);
			}
		
		}
	}
}