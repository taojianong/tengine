package com.customLoader {
	import com.customLoader.event.LoaderEvent;
	import com.customLoader.loader.SourceLoader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	/**
	 * 资源加载类
	 * */
	public class LoaderSource extends EventDispatcher {
		
		private var urlArray:Array = []; //加载路径
		private var total:uint = 0; //总共需要加载的资源数量
		private var loaded:uint = 0; //当前已加载的资源数量
		private var loadPosition:uint = 0;
		
		public function LoaderSource() {
		
		}
		
		/**
		 * 添加需要加载的资源
		 * @param url:String 加载资源的路径
		 * @param forever 是否是永久保存的资源 <b>默认永久保存</b>
		 * @param prop 资源参数
		 * */
		public function add(url:String, forever:Boolean = true, prop:* = null):void {
			var obj:Object = new Object();
			obj.url = url;
			obj.prop = prop;
			obj.forever = forever;
			urlArray.push(obj);
		}
		
		/**
		 * 开始加载资源
		 * */
		public function start():void {
			
			if (total > 0) {
				total = urlArray.length;
			} else {
				
				total = urlArray.length;
				startSingle();
			}
		}
		
		/**
		 *加载单个资源
		 */
		private function startSingle():void {
			
			if (loadPosition >= total) {
				return;
			}
			var loader:SourceLoader;
			//判断是否过去已经加载过,如果没有加载过，则新建SourceLoader执行加载操作			
			if (!SourceLoaderManager.exist(urlArray[loadPosition].url)) {
				
				var obj:Object = new Object();
				obj.url = urlArray[loadPosition].url;
				obj.prop = urlArray[loadPosition].prop;
				SourceLoaderManager.dataArray.push(obj);
				
				if (this.hasEventListener(LoaderEvent.LOAD_START))
					this.dispatchEvent(new LoaderEvent(LoaderEvent.LOAD_START, 0, urlArray[loadPosition].prop));
				
				loader = new SourceLoader(urlArray[loadPosition].url);
				loader.addEventListener(Event.COMPLETE, eventFunction);
				loader.addEventListener(IOErrorEvent.IO_ERROR, eventFunction);
				loader.addEventListener(ProgressEvent.PROGRESS, eventFunction);
				obj.loader = loader;
				
			} else {
				
				var temp:Object = SourceLoaderManager.getObject(urlArray[loadPosition].url);
				if (!temp.content) {
					loader = SourceLoaderManager.getObject(urlArray[loadPosition].url).loader;
					loader.addEventListener(Event.COMPLETE, eventFunction);
					loader.addEventListener(IOErrorEvent.IO_ERROR, eventFunction);
					loader.addEventListener(ProgressEvent.PROGRESS, eventFunction);
				} else {
					loaded++;
					loadPosition++;
					
					startSingle();
					
					if (loaded >= total) {
						clear();
						if (this.hasEventListener(LoaderEvent.LOAD_COMPLETE))
							this.dispatchEvent(new LoaderEvent(LoaderEvent.LOAD_COMPLETE, 1));
					}
				}
			}
		}
		
		/**
		 *监听加载过程
		 */
		private function eventFunction(evt:*):void {
			var loader:SourceLoader = evt.currentTarget as SourceLoader;
			
			if (evt.type == Event.COMPLETE) {
				SourceLoaderManager.getObject(loader.urlRequest.url).content = loader.content;
				
				if (this.hasEventListener(LoaderEvent.LOAD_SINGLE_COMPLETE))
					this.dispatchEvent(new LoaderEvent(LoaderEvent.LOAD_SINGLE_COMPLETE, 1, {prop: urlArray[loadPosition].prop, url: loader.urlRequest.url}));
				
				loaded++;
				loadPosition++;
				
				startSingle();
				
				if (loaded >= total) {
					clear();
					if (this.hasEventListener(LoaderEvent.LOAD_COMPLETE))
						this.dispatchEvent(new LoaderEvent(LoaderEvent.LOAD_COMPLETE, 1, {url: loader.urlRequest.url}));
				}
				
				//清除监听
				loader.removeEventListener(Event.COMPLETE, eventFunction);
				loader.removeEventListener(IOErrorEvent.IO_ERROR, eventFunction);
				loader.removeEventListener(ProgressEvent.PROGRESS, eventFunction);
				loader = null;
			} else if (evt.type == IOErrorEvent.IO_ERROR) {
				loaded++;
				trace("资源加载路径错误" + evt.toString());
			} else if (evt.type == ProgressEvent.PROGRESS) {
				if (evt.bytesLoaded / evt.bytesTotal != 0 && this.hasEventListener(LoaderEvent.LOAD_PROGRESS))
					this.dispatchEvent(new LoaderEvent(LoaderEvent.LOAD_PROGRESS, ((evt.bytesLoaded / evt.bytesTotal) + loaded) / total));
			}
		}
		
		//清除上一次加载操作的数据
		private function clear():void {
			urlArray = null;
			urlArray = [];
			loadPosition = 0;
			loaded = 0;
			total = 0;
		}
	}
}