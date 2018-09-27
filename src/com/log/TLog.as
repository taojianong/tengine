package com.log {
	
	import com.utils.CommonUtils;
	import com.geom.DMap;
	import flash.display.DisplayObject;
	import flash.system.Capabilities;
	
	/**
	 * 显示日志
	 * @author taojianlong 2014-5-27 21:13
	 */
	public class TLog {
		
		private static const LOG_NAME:Object = {			 
			0:{ "text":"" , "color":"#000000" } ,
			1:{ "text":"【 调试 】" , "color":"#00FFFF" } ,
			2:{ "text":"【 警告 】" , "color":"#FF8000" } ,
			3:{ "text":"【 错误 】" , "color":"#FF0000" } , 
			4:{ "text":"【 加载 】" , "color":"#8080FF" },
			5: { "text":"【 所有 】" , "color":"#00FF00" },
			6:{ "text":"【 SOCKET 】" , "color":"#00FF00" }
		}
		
		public static const LOG_NOMAL:uint  = 0 ; //正常类型
		public static const LOG_DEBUG:uint  = 1 ; //调试类型
		public static const LOG_WARN:uint   = 2 ; //警告类型
		public static const LOG_ERROR:uint  = 3 ; //错误类型		
		public static const LOG_LOAD:uint   = 4 ; //加载类型		
		public static const LOG_ALL:uint   	= 5 ; //所有类型		
		public static const LOG_SOCKET:uint	= 6 ; //SOCKET类型		
		
		public static var showTypes:Array    = [ LOG_NOMAL , LOG_DEBUG , LOG_WARN , LOG_ERROR , LOG_LOAD , LOG_ALL , LOG_SOCKET ]; //要显示的所有类型.
		public static var isShowLog:Boolean  = true;  //是否显示Log ,此时已经添加到缓存中
		public static var isAddLog:Boolean   = true;  //是否添加日志到缓存中，添加后自动显示(如果isShowLog为ture的话!)		
		public static var isShowTime:Boolean = false; //是否显示时间
		public static var isAddLogId:Boolean = false; //是否添加日志ID到日志数据中
		
		private static var logMap:DMap = new DMap( true ); //日志存储容器
		
		/**
		 * 显示日志
		 * @param text 日志文本
		 * @param type 日志类型
		 */
		public static function addLog( text:* , type:uint = LOG_NOMAL ):void {
			
			if ( text == null || text == "" || ( !isAddLog && !isShowLog ) || !Capabilities.isDebugger ) {
				//不是调试版本也不用显示日志!
				return;
			}
			
			//添加日志类型数据库
			if ( !logMap.containsKey( type ) ) {
				logMap.put( type , new DMap( true ) );
			}
			
			var d:DMap = logMap.get( type ) as DMap ;	
			
			var id:int = d.keys;
			
			var info:String = TLog.getLogInfo( text , type );
			
			//显示日志信息
			showLog( info , type , id );	
			
			//将日志信息添加到缓存
			if ( isAddLog ) {
				d.put( id , info );
			}			
		}		
		
		private static function showLog( info:String , type:uint , id:int ):void {
			
			if ( isShowLog ) { //判断是否显示日志
				
				if ( showTypes.indexOf( type ) == -1 ) { //不显示某一种日志
					return;
				}
				
				//在trace内容前家{0-4}:为显示对应系统类型颜色
				if ( isAddLogId ) {					
					trace( "[ " + id + " ]" + info );
				}
				else {
					trace( info );
				}				
			}	
		}
		
		/**
		 * 释放所有日志
		 */
		public static function disposeLogs():void {
			
			for each( var d:DMap in logMap.d ) {
				if ( d ) {
					d.clear();
				}
			}
		}
		
		/**
		 * 处理原始信息
		 * @param text 原始显示信息
		 * @return 处理后获得的显示信息
		 */
		private static function getLogInfo( text:* , type:int ):String {
			
			var info:String = "";
			if ( text is int || text is uint || text is String || text is Number || text is Array ) {
				info = getTypeString( type ) + ( isShowTime ? "[" + new Date().toString() + "] " : "" ) + String( text ) ;
			}
			else if ( text is DisplayObject ) {
				
				info = "[ 不允许显示显示对象！ ]";
			}else {
				info = getTypeString( type ) + ( isShowTime ? "[" + new Date().toString() + "] " : "" ) + CommonUtils.showObject( text );
			}
			
			return info;
		}
		
		/**
		 * 打印缓存的所有日志及对应类型日志
		 * @param type 5为所有日志,
		 */
		public static function printLogs( type:int = 5 ):void {			
			
			if ( type == 5 ) {
				
				trace("-----------------------开始打印所有日志-----------------------");
				
				for ( var i:int = 0; i <= 4;i++ ) {
					printLog( i );
				}
				
				trace("-----------------------结束打印所有日志-----------------------");
			}
			else {
				printLog( type );
			}
		}
		
		/**
		 * 获取缓存中对应类型的日志
		 * @param	type
		 * @return
		 */
		public static function getCacheLog( types:Array = null , str:String = "" ):String {
			
			if ( types == null ) {
				types = [ LOG_NOMAL , LOG_DEBUG , LOG_WARN , LOG_ERROR , LOG_LOAD , LOG_SOCKET  ];
			}
			
			if ( types.length <= 0 ) {
				return str;
			}
			
			var type:int	= types.shift(); 
			var d:DMap 		= logMap.get( type ) as DMap;
			
			if ( d == null || d.keys <= 0) {	
				return getCacheLog( types , str );
			}
			
			str += "*********打印所有【" + getTypeString( type ) +"】日志，日志数量为: " + d.keys + "*********" + "\n" ;
			
			if ( d.keys > 0 ) {
				for ( var i:int = 0; i < d.keys; i++ ) {
					if ( d.get( i ) != null ) {
						str += d.get( i ) + "\n" ;
					}					
				}
			}
			
			if ( types.length > 0 ) {
				getCacheLog( types , str );
			}			
			return str;
		}
		
		private static function printLog( type:int ):void {
			
			var d:DMap = logMap.get( type ) as DMap;
			
			if ( d == null ) {
				return;
			}
			
			trace( "*********打印所有[" + getTypeString( type ) +"]日志，日志数量为: " + d.keys + "*********" );
			
			if ( d.keys > 0 ) {
				for ( var i:int = 0; i < d.keys; i++ ) {
					if ( d.get( i ) != null ) {
						trace( d.get( i ) + "\n" );
					}					
				}
			}
			
			trace("//////////////////////////////////////////////////////");
		}
		
		private static function getTypeString( type:int ):String {
			
			var t:Object = LOG_NAME[ type ];
			if ( t == null || t.text == "" ) {
				return "";
			}
			
			//显示对应的颜色 ,只有前缀加{0-4}:才会显示对应trace系统颜色,其余为默认的黑色
			//trace( "0:[grey]This is a debug message" );
			//trace( "1:[black]This is a log message" );
			//trace( "2:[orange]This is a warning" );
			//trace( "3:[red]This is an error" );
			//trace( "4:[magenta]This is a special one for your mother" );
			
			return type + ":" + t.text;// CommonUtils.getColorHtmlText( t.text , t.color ) + "：";
		}
	}

}