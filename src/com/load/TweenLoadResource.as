package com.load {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.system.ApplicationDomain;
	
	/**
	 * 获取TweenMax加载的资源
	 * 通过此类可方便的获取对应的TweenMax加载的资源
	 * @author cl 2015/1/30 14:48
	 */
	public class TweenLoadResource {
		
		/**
		 * 获取对应资源
		 * @param	nameOrUrl	资源ID或资源URL
		 * @param	link		SWF资源对应的链接名
		 * @return
		 */
		public static function getTweenLoadResource( nameOrUrl:String , link:String = "" ):* {
			
			return TweenLoader.getSource( nameOrUrl , link );
		}	
	}
}