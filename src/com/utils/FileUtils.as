package com.utils {
	
	//AIR才有这些类
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	/**
	 * 文件类工具 2013-3-29 22:39
	 * @author taojianlong
	 */
	public class FileUtils {
		
		public static const FILE_XML:String = "xml";
		public static const FILE_JPG:String = "jpg";
		public static const FILE_JPEG:String = "jpeg";
		public static const FILE_PNG:String = "png";
		public static const FILE_TXT:String = "txt";
		public static const FILE_MP3:String = "mp3";
		public static const FILE_EXE:String = "exe";
		public static const FILE_SWF:String = "swf";
		public static const FILE_BAT:String = "bat";
		public static const FILE_XLS:String = "xls";
		public static const FILE_JSON:String = "json";
		
		public static const IMAGES_FILEFILTER:FileFilter = new FileFilter("Images", "*.jpg;*.gif;*.png");
		public static const XML_FILEFILTER:FileFilter = new FileFilter("XML", "*.xml");
		public static const TXT_FILEFILTER:FileFilter = new FileFilter("TXT", "*.txt");
		public static const SWF_FILEFILTER:FileFilter = new FileFilter("SWF", "*.swf");
		public static const MP3_FILEFILTER:FileFilter = new FileFilter("MP3", "*.mp3");
		public static const XLS_FILEFILTER:FileFilter = new FileFilter("XLS", "*.xls");
		
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
		
		/**
		 * 将文件地址保存为指定格式地址,未验证
		 * @param	url    文件地址
		 * @param	format 文件格式
		 */
		public static function toFileName(url:String, format:String = FILE_XML):String {
			
			var ind:int = url.lastIndexOf(".");
			
			return ind != -1 ? url.substr(0, ind + 1) + format : url + "." + format;
		}
		
		/**
		 * 保存文本数据,在AIR项目时打开
		 * @param	url
		 * @param	data
		 * @param	complete
		 * @param   params 完成事件的参数
		 */
		public static function saveUTFFile(url:String, data:String, file:File = null, complete:Function = null , params:Array = null ):void {
			
			if (file == null) {
				file = new File(url);
			} else {
				var extension:String = getFileExtension(url);
				file.nativePath = toFileName(file.nativePath, extension);
			}
			var stream:FileStream = new FileStream();
			if (!file.exists) //如果不存在该文件则创建一个新文件并打开
			{
				stream.open(file, FileMode.WRITE);
				stream.writeUTFBytes(data);
				stream.close();
				if (complete != null) {
					complete();
				}
			} else {
				
				try {
					stream.open(file, FileMode.WRITE);
					stream.writeUTFBytes(data);
					stream.close();
					if (complete != null) {
						complete();
					}
				} catch (e:Error) {
					trace(e.message);
				}
			}
		}
		
		/**
		 * 保存流文件
		 * @param	byte
		 * @param	url
		 * @param	file
		 * @param	complete
		 */
		public static function saveByte( bytes:ByteArray , url:String , file:File = null , complete:Function = null , args:Array = null ):void {
			
			if ( url == "" ){
				return;
			}
			
			if ( file == null ){
				file = new File( url );
			}
			
			var extension:String = getFileExtension( url );
			file.nativePath = toFileName( file.nativePath , extension );
			var stream:FileStream = new FileStream();
			if ( !file.exists ) //如果不存在该文件则创建一个新文件并打开
			{
				stream.open( file, FileMode.WRITE );
				stream.writeBytes( bytes );
				stream.close();
				if (complete != null) {
					complete.apply( null , args );
				}
			} else {
				
				try {
					stream.open(file, FileMode.WRITE);
					stream.writeBytes( bytes );
					stream.close();
					if (complete != null) {
						complete.apply( null , args );
					}
				} catch (e:Error) {
					trace(e.message);
				}
			}
		}
		
		/**
		 * 遍历所有文件及目录
		 * @param	file	文件目录
		 * @param 	format	要遍历的文件后缀名
		 * @param 	files	当前目录的列表
		 * @param 	func	遍历时触发
		 * @param 	funcParams 遍历方法参数
		 * @param 	list 	所有目录列表
		 */
		public static function loopFiles( file:File , format:String = ".asset" , func:Function = null , funcParams:Array = null , files:Array = null   , list:Array = null ):Array{
			
			list = list || [];
			if ( file == null ){
				return list;
			}
			var params:Array = null;
			if ( file.isDirectory ){
				files = files || file.getDirectoryListing();
				while ( files && files.length > 0 ){
					var f:File = files.shift();
					if ( f != null ){
						if ( f.isDirectory ){ //目录
							//trace( "导入目录: " + f.nativePath );						
							loopFiles( f , format , func , funcParams , null , list );
						}else if ( format ){
							if ( f.name.indexOf(format) != -1 ){
								list.push( f );	
							}else{
								continue;
							}
						}else{
							list.push( f );
						}
						
						if ( func != null ){
							params = funcParams || [];
							params.unshift( f );
							func.apply( null , params );
						}
					}
				}
			}else if( !format || file.name.indexOf(format) != -1 ){
				list.push( file );
				if ( func != null ){
					params = funcParams || [];
					params.unshift( file );
					func.apply( null , params );
				}
			}
			return list;
		}
		
	}
}