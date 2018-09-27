package com.customLoader {
	
	import com.customLoader.util.LoaderUtil;
	import com.tloader.TSourceConst;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.LoaderInfo;
	import flash.system.ApplicationDomain;	
	
	/**
	 * 加载资源数据管理类
	 * */
	public class SourceLoaderManager {
		
		public static var dataArray:Array = [];
		
		public function SourceLoaderManager() {
			
		}
		
		/**
		 * 根据资源ID获取对应类型资源
		 * @param sourceId 资源ID
		 * @param type     资源类型，见SourceConst
		 * @param linkName 链接名
		 * @return
		 */
		public static function getSource( sourceId:String , type:String = "object" , linkName:String = "" ):*{
			
			//获取对应资源ID的资源
			var url:String = null;
			for each (var obj:*in dataArray) {
				if (obj.prop == sourceId) {
					url = obj.url;
					break;
				}
			}
			
			if ( !url ) {
				return null;
			}
			
			switch( type ) {
				
				case TSourceConst.SOURCE_XML:
					return getXML( url );
					break;
					
				case TSourceConst.SOURCE_OBJECT:
					return getObject( url );
					break;
					
				case TSourceConst.SOURCE_BITMAP:
					return getBitmap( url );
					break;
					
				case TSourceConst.SOURCE_BITMAPDATA:
					return getBitmapData( url );
					break;
					
				case TSourceConst.SOURCE_DISPLAYOBJECT: //获取SWF中链接对象
					return getComponent( url , linkName );
					break;
					
				case TSourceConst.SOURCE_TXT:
					return getContent( url );//文本资源
					break;
			}
			
			return null;
		}
		
		//---------------------------------------------------
		
		/**
		 *清空缓存图像数据
		 */
		public static function clear():void {
			
			for (var i:uint = 0; i < dataArray.length; i++) {
				if (dataArray[i].forever == false) {
					dataArray.splice(i, 1);
					i--;
				}
			}
		}
		
		/**
		 * 检测资源是否已经加载过
		 * @param url:String 被检测资源路径
		 * @return  Boolean 是否已经加载过
		 * */
		public static function exist(url:String):Boolean {
			for each (var obj:*in dataArray) {
				if (obj.url == url) {
					return true;
				}
			}
			
			return false;
		}
		
		/**
		 * 根据路径获得资源管理类里面的对象
		 * @param url:String 资源路径
		 * @return  Object 如果返回null，证明此路径不存在于加载资源管理类里面
		 * */
		public static function getObject(url:String):Object {
			for each (var obj:*in dataArray) {
				if (obj.url == url) {
					return obj;
				}
			}
			return null;
		}
		
		/**
		 * 根据SWF文件路径及组件名获得资源管理类里面的组件
		 * @param url:String 资源路径
		 * @param component:String 要获取的组件名
		 * @return  DisplayObject 如果没有找到，返回null
		 * */
		public static function getComponent(url:String, component:String):* {
			if (!url)
				return null;
			
			var extension:String = LoaderUtil.getFileExtension(url);
			if (extension != "swf")
				return null;
			
			for each (var obj:*in dataArray) {
				if (obj.url == url) {
					var tempClass:Class = ((obj.content as LoaderInfo).applicationDomain.getDefinition(component) as Class);
					return tempClass != null ? new tempClass : null;// ((new (tempClass) as DisplayObject));
				}
			}
			
			return null;
		}
		
		/**
		 * 获取Swf域,或域中资源
		 * @param	swfUrl
		 * @return
		 */
		public static function getSwfSource( swfUrl:String , className:String = null ):* {
			
			if ( LoaderUtil.getFileExtension(swfUrl) == "swf") {
				
				var loaderInfo:LoaderInfo = LoaderInfo(getContent(swfUrl));
				if (loaderInfo != null) {
					var app:ApplicationDomain = loaderInfo.applicationDomain;
					if (className == null) {
						return app;
					} else if (app != null && app.hasDefinition(className)) {
						return app.getDefinition(className) as Class;
					}
				}
			}
			return null;
		}
		
		/**
		 * 获取加载SWF文件域
		 * @param	swfUrl
		 * @return
		 */
		public static function getApp( swfUrl:String ):ApplicationDomain {
			
			var obj:Object = getObject(swfUrl);
			
			if (obj != null && obj.content != null) {
				return obj.content.applicationDomain;
			}
			return null;
		}
		
		/**
		 * 获得加载的文本数据
		 * @param url 资源路径
		 * @return 文本数据
		 *
		 */
		public static function getContent(url:String):* {
			if (!url)
				return null;
			
			var extension:String = LoaderUtil.getFileExtension(url);
			/*if(extension!="txt"&&extension!="xml")
			 return null;*/
			
			for each (var obj:*in dataArray) {
				if (obj.url == url) {
					return obj.content;
				}
			}
			
			return null;
		}
		
		public static function getXML( url:String ):XML {
			
			return XML( getContent( url ) );
		}
		
		/**
		 * 根据路径获得资源管理类里面的位图信息
		 * @param url:String 资源路径		 *
		 * @return  Bitmap 如果没有找到，返回null
		 * */
		public static function getBitmap(url:String):Bitmap {
			
			if (!url)
				return null;
			
			var extension:String = LoaderUtil.getFileExtension(url);
			if (extension != "jpg" && extension != "jpeg" && extension != "gif" && extension != "png")
				return null;
			
			for each (var obj:*in dataArray) {
				if (obj.url == url) {
					return new Bitmap((obj.content as LoaderInfo).loader.content["bitmapData"]);
				}
			}
			
			return null;
		}
		
		public static function getBitmapData( url:String ):BitmapData {
			
			var bmp:Bitmap = getBitmap( url );
			
			return bmp != null ? bmp.bitmapData : null;
		}
		
	}
}