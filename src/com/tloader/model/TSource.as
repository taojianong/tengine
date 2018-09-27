package com.tloader.model {
	
	import com.tloader.TSourceConst;
	import com.tloader.TSourceManager;
	import com.tloader.util.TLoaderUtil;
	
	/**
	 * 资源数据
	 * @author taojianlong 2014-5-28 20:29
	 */
	public class TSource {
		
		private var _url:String = ""; //资源路径
		private var _id:String  = ""; //资源ID
		private var _level:int  = 0;  //加载资源等级 , 见TrouceConst相关参数
		private var _extension:String = "";//后缀名
		private var _version:String   = "";//资源版本号		
		
		public var prop:* = null;//资源参数,加载的设置		
		public var forever:Boolean = true;//资源是否永久保存
		public var canReLoad:Boolean = false;//是否允许加载错误重新加载
		
		public var data:* = null;//加载资源数据,资源加载完后设置
		
		public var loadStart:Function = null; //加载开始事件
		public var loadStartParams:Array = null; //加载开始事件参数
		public var loadComplete:Function = null;//完成事件
		public var loadCompleteParams:Array = null;//完成事件参数
		
		/**
		 * 加载资源数据
		 * @param	url   资源路径
		 * @param	id    资源ID
		 * @param	level 资源等级
		 * @param   canReLoad 设置是否可重复加载，当遇到错误时
		 * @param	prop  资源参数,任意参数
		 * @param	forever 资源是否永久保存
		 * @param   loadComplete 完成事件
		 * @param   loadCompleteParams 完成事件参数
		 */
		public function TSource( id:String = "" , url:String = "" , level:int = 0 , canReLoad:Boolean = false , version:String = "" , prop:* = null , forever:Boolean = true , loadComplete:Function = null , loadCompleteParams:Array = null ) {
			
			setSource( url , id , level , canReLoad , version , prop , forever , loadComplete , loadCompleteParams );
		}
		
		public function setSource( id:String = "" , url:String = "" , level:int = 0 , canReLoad:Boolean = false , version:String = "" , prop:* = null , forever:Boolean = true , loadComplete:Function = null , loadCompleteParams:Array = null ):void {
			
			this.id        = id;
			this.url       = url;		
			this.version   = version;
			this.level     = level;			
			this.prop      = prop;
			this.forever   = forever;
			this.canReLoad = canReLoad;
			this.loadComplete = loadComplete;
			this.loadCompleteParams = loadCompleteParams;
		}
		
		public function set id( value:String ):void {
			
			_id = value;
			
			if ( _id == null || _id == "" ) {
				_id = this.defaultId;				
			}			
			
			TSourceManager.putSourceId( _id );
		}
		/**资源ID**/
		public function get id():String {
			
			return _id;
		}
		
		public function set url( value:String ):void {
			
			_url = value + _version;
			
			_extension = TLoaderUtil.getExtension( _url );
		}		
		/**资源路径**/
		public function get url():String {
			
			return _url;
		}
		
		public function set version( value:String ):void {
			
			_version = value;
			
			if ( version == "" ) {
				_version = TSourceManager.VERSION;
			}			
		}
		/**设置版本号**/
		public function get version():String {
			
			return _version;
		}
		
		/**
		 * 获取默认名字
		 */
		private function get defaultId():String {
			
			return TLoaderUtil.getFileName( _url );
		}
		
		public function set level( value:int ):void {
			
			_level = value;
		}
		/**
		 * 加载等级
		 */
		public function get level():int {
			
			return _level;
		}
		
		/**
		 * 释放资源
		 */
		public function dispose():void {
			
			data       = null;
			_url       = null;
			_id        = "";
			_level     = 0;
			_extension = "";
			prop       = null;			
			_version   = "";
			forever    = true;
			canReLoad  = false;
			loadComplete = null;
			loadCompleteParams = null;
		}
		
		//------------------------get方法----------------------
		
		/**
		 * 是否正在加载中
		 */
		public function get isLoading():Boolean {
			
			return data == null ;
		}
		
		/**
		 * 获取文件后缀名
		 */
		public function get extension():String {
			
			return _extension;
		}
		
		public function get isXml():Boolean {
			
			return this.extension == TSourceConst.SOURCE_XML;
		}
		
		public function get isSwf():Boolean {
			
			return this.extension == TSourceConst.SOURCE_SWF;
		}
		
		public function get isJpg():Boolean {
			
			return this.extension == TSourceConst.SOURCE_JPG;
		}
		
		public function get isJpeg():Boolean {
			
			return this.extension == TSourceConst.SOURCE_JPEG;
		}
		
		public function get isGif():Boolean {
			
			return this.extension == TSourceConst.SOURCE_GIF;
		}
		
		public function get isPng():Boolean {
			
			return this.extension == TSourceConst.SOURCE_PNG;
		}
		
		public function get isMp3():Boolean {
			
			return this.extension == TSourceConst.SOURCE_MP3;
		}
		
		/**
		 * 是否空闲加载
		 */
		public function get isFreeLoad():Boolean {
			
			return _level == TSourceConst.LOAD_LEVEL_FREE;
		}
		
		/**
		 * TSource信息
		 */
		public function toString():String {
			
			return "id: " + this.id + " url: " + this.url + " level: " + this.level + " version: " + this.version + " canReLoad: " + this.canReLoad + " forever: " + this.forever; 
		}
		
	}

}