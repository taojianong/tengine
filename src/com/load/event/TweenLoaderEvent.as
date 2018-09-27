package com.load.event {
	import flash.events.Event;
	
	/**
	 * TweenLoader事件
	 * @author cl 2015/1/30 15:03
	 */
	public class TweenLoaderEvent extends Event{
		
		public static const LOAD_ALL_PROGRESS:String 	= "load_all_progress"; //加载所有的文件的进度
		public static const LOAD_ALL_COMPLETE:String 	= "load_all_complete"; //加载所有文件完成
		public static const LOAD_ALL_ERROR:String 		= "load_all_error"; //加载所有文件错误
		
		public static const LOAD_SINGLE_PROGRESS:String = "load_single_progress";//加载单个文件进度
		public static const LOAD_SINGLE_COMPLETE:String = "load_single_complete";//加载单个文件完成
		public static const LOAD_SINGLE_ERROR:String 	= "load_single_error";//加载单个文件错误
		
		private var _data:Object;
		
		public function TweenLoaderEvent( type:String , data:Object = null ) {
			
			super(type);
			
			_data = data;
		}	
		
		public function get data():Object {
			
			return _data;
		}
	}
}