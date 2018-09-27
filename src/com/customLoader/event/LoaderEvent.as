package com.customLoader.event
{
	import flash.events.Event;
	
	/**
	 * 资源加载自定义事件
	 * */
	public class LoaderEvent extends Event
	{
		
		/**
		 * 监听加载进度
		 * */
		public static const LOAD_PROGRESS:String="load_progress";
		
		/**
		 *  开始加载
		 * */
		public static const LOAD_START:String="load_start";
		
		/**加载对象参数*/
		private var _parameters:*;
		
		public var _loadRate:Number=0;//加载进度百分比
		
		
		/**
		 * 监听加载完成否
		 * */
		public static const LOAD_COMPLETE:String="load_complete";	
		
		/**
		 * 单个资源加载完成
		 * */
		public static const LOAD_SINGLE_COMPLETE:String="load_single_complete";	
		
		/**
		 * 加载事件 
		 * @param type  加载类型
		 * @param rate  加载百分比
		 * @param param 加载对象参数
		 * @param bubbles    确定 Event 对象是否参与事件流的冒泡阶段。默认值为 false。
		 * @param cancelable 确定是否可以取消 Event 对象。默认值为 false。 
		 */		
		public function LoaderEvent(type:String,rate:Number=1,param:*=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_loadRate=rate;
			_parameters=param;
		}
		
		/**
		 * 获得加载进度百分比
		 * @return Number 加载进度百分比值
		 * */
		public function get loadRate():Number
		{
			return _loadRate;
		}
		
		/**加载对象参数*/
		public function get parameters():*
		{
			return _parameters;
		}
	}
}