package com.load {
	
	import com.greensock.loading.display.ContentDisplay;
	import com.greensock.loading.LoaderMax;
	import com.load.util.LoaderUtil;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.media.Sound;
	import flash.system.ApplicationDomain;
	
	/**
	 * 用TweenMax加载的资源缓存
	 * @author cl 2015/1/26 11:35
	 */
	public class TweenSourceCache {
		
		public var id:String 		= ""; //资源ID
		public var url:String 		= ""; //本地地址
		public var cacheUrl:String 	= ""; //缓存地址
		
		/**
		 * @param	id		 资源ID
		 * @param	url		 资源本地地址
		 * @param	cacheUrl 资源缓存地址
		 */
		public function TweenSourceCache( id:String , url:String , cacheUrl:String = "" ):void {
			
			this.id 		= id;
			this.url 	  	= url;
			this.cacheUrl   = cacheUrl;
		}
		
		/**
		 * 文件后缀名
		 */
		public function get extension():String {
			
			return LoaderUtil.getFileExtension( this.url );
		}
		
		/**
		 * 获取MovieClip
		 * */
		public function getMovieClip():MovieClip {
			
			return this.data is MovieClip ? this.data as MovieClip : null;
		}
		
		/**
		 * 获取SWF中的组件
		 * @param	id		SWF资源ID
		 * @param	link	链接名
		 * @return
		 */
		public function getSWFComponent( link:String = "" ):*{
			
			if ( this.isSWF ) {
				var mc:MovieClip = this.data as MovieClip;
				var app:ApplicationDomain = mc.loaderInfo.applicationDomain;
				if ( link == "" ) {
					return app;
				}					
				
				if ( app.hasDefinition( link ) ) {
					var tempClass:Class= app.getDefinition( link ) as Class;
					return new tempClass();
				}				
			}			
			return null;
		}
		
		/**
		 * 获取BitmapData
		 * @param id SWF或JPG资源ID
		 * @param link 资源链接名，JPG为""
		 **/
		public function getBmpd( link:String = "" ):BitmapData {
			
			var data:* =  this.isSWF && link != "" ? this.getSWFComponent( link ) : this.data;			
			
			return data is Bitmap ? ( data as Bitmap ).bitmapData : ( data is BitmapData ? data : null );
		}
		
		/**
		 * 声音
		 * @return
		 */
		public function get sound():Sound {
			
			return this.data as Sound;
		}
		
		/**
		 * 对应资源的数据
		 */
		public function get data():*{
			
			var cont:* = LoaderMax.getContent( this.cacheUrl );			
			if ( cont is ContentDisplay ) {
				return ContentDisplay( cont ).rawContent;
			}			
			return cont;
		}
		
		/**
		 * 释放资源
		 */
		public function dispose():void {
			
			var cont:* = LoaderMax.getContent( this.cacheUrl );			
			if ( cont is ContentDisplay ) {
				ContentDisplay( cont ).dispose();
			}
		}
		
		//---------------------------------------------------
		
		public function get isXML():Boolean {
			
			return this.extension.toLowerCase() == "xml";
		}
		
		public function get isSWF():Boolean {
			
			return this.extension.toLowerCase() == "swf";
		}
		
		public function get isJPG():Boolean {
			
			return this.extension.toLowerCase() == "jpg";
		}
		
		public function get isPNG():Boolean {
			
			return this.extension.toLowerCase() == "png";
		}
		
		public function get isMP3():Boolean {
			
			return this.extension.toLowerCase() == "mp3";
		}
		
		public function get isTXT():Boolean {
			
			return this.extension.toLowerCase() == "txt";
		}
	}

}