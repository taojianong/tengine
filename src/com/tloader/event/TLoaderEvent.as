package com.tloader.event {
	
	import com.tloader.model.TSource;
	import flash.events.Event;
	
	/**
	 * TLoader事件
	 * @author taojianlong 2014-5-28 21:01
	 */
	public class TLoaderEvent extends Event {
		
		public static const SINGEL_START:String    = "singleStart";    //开始单个资源加载
		public static const SINGEL_PROGRESS:String = "singleProgress"; //加载单个资源进度
		public static const SINGEL_COMPLETE:String = "singleComplete"; //加载单个资源完成
		public static const SINGLE_ERROR:String    = "singleError"; //加载单个资源错误
		
		public static const LIST_START:String    = "listStart";    //开始加载资源列表
		public static const LIST_PROGRESS:String = "listProgress"; //加载资源列表进度
		public static const LIST_COMPLETE:String = "listComplete"; //加载资源列表完成
		public static const LIST_ERROR:String    = "listError"; //加载列表资源错误
		
		public var tSource:TSource = null ; //当前加载资源
		public var progress:Number = 0; //加载进度
		public var loadType:int    = 0;//加载类型 0为同步加载(TSourceConst.LOAD_TYPE_SYNCHRO)，1为异步加载(TSourceConst.LOAD_TYPE_ASYNCHRO)
		
		public function TLoaderEvent( type:String , source:TSource = null , loadType:int = 0 , bubbles:Boolean=false, cancelable:Boolean=false ) {
			
			this.tSource  = source;
			this.loadType = loadType;
			
			super( type , bubbles , cancelable );
		}
		
	}

}