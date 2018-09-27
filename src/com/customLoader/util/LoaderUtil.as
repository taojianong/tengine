package com.customLoader.util {
	
	public class LoaderUtil {
		
		/**
		 * 获得文件后缀名
		 * @param url 文件路径
		 * @return <b>String</b> 文件后缀名
		 *
		 */
		public static function getFileExtension(url:String):String {
			//切掉路径后面的参数
			var searchString:String = url.indexOf("?") > -1 ? url.substring(0, url.indexOf("?")) : url;
			
			//截取后缀
			var finalPart:String = searchString.substring(searchString.lastIndexOf("/"));
			return finalPart.substring(finalPart.lastIndexOf(".") + 1).toLowerCase();
		}
	}
}