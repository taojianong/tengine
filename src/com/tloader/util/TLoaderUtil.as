package com.tloader.util {
	
	import flash.net.LocalConnection;
	
	public class TLoaderUtil {
		
		/**
		 * 获得文件后缀名
		 * @param url 文件路径
		 * @return <b>String</b> 文件后缀名
		 */
		public static function getExtension(url:String):String {
			
			//切掉路径后面的参数
			var searchString:String = url.indexOf("?") > -1 ? url.substring(0, url.indexOf("?")) : url;
			
			//截取后缀
			var finalPart:String = searchString.substring(searchString.lastIndexOf("/"));
			return finalPart.substring(finalPart.lastIndexOf(".") + 1).toLowerCase();
		}
		
		/**
		 * 获取文件名
		 * @param	url
		 * @return
		 */
		public static function getFileName( url:String ):String {
			
			//切掉路径后面的参数
			var searchString:String = url.indexOf("?") > -1 ? url.substring(0, url.indexOf("?")) : url;
			
			//截取后缀
			var finalPart:String = searchString.substring(searchString.lastIndexOf("/"));
			
			return finalPart.substring( 0 , finalPart.lastIndexOf(".") ); 
		}
		
		/**
		 * 强制系统马上进行垃圾垃圾回收
		 */
		public static function gc():void {
			
			try {
				
			    new LocalConnection().connect("foo");
				new LocalConnection().connect("foo");
			}
			catch (e:Error) {
				
			}
		}
	}
}