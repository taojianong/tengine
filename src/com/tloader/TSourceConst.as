package com.tloader {
	
	import com.geom.DMap;
	
	/**
	 * 资源类型
	 * @author taojianlong 2014-3-27 21:39
	 */
	public class TSourceConst {
		
		//释放严格限制ID，就是所有资源ID不能有相同ID
		public static var isRigId:Boolean = true;
		
		/**
		 * 同步加载,即队列加载,列表中资源一个个进行加载
		 */
		public static const LOAD_TYPE_SYNCHRO:int = 0;
		
		/**
		 * 异步加载，即同时加载所有列表中资源
		 */
		public static const LOAD_TYPE_ASYNCHRO:int = 1;
		/**
		 * 空闲加载
		 */
		public static const LOAD_TYPE_FREE:int = 2;
		
		//资源加载等级,0为最优先加载
		public static const LOAD_LEVEL_TOP:int  = 0;//最优先加载
		public static const LOAD_LEVEL_FREE:int = 1;//空闲加载
		
		//资源类型
		public static const SOURCE_XML:String           = "xml";
		public static const SOURCE_SWF:String           = "swf";
		public static const SOURCE_BITMAP:String        = "bitmap";
		public static const SOURCE_BITMAPDATA:String    = "bitmapData";
		public static const SOURCE_OBJECT:String        = "object";
		public static const SOURCE_DISPLAYOBJECT:String = "displayObject";
		public static const SOURCE_TXT:String           = "txt";//文本内容
		public static const SOURCE_JPG:String           = "jpg";
		public static const SOURCE_JPEG:String          = "jpeg";
		public static const SOURCE_GIF:String           = "gif";
		public static const SOURCE_PNG:String           = "png";
		public static const SOURCE_MP3:String           = "mp3";
		
	}

}