/**
 *
   LocalCookie.Instance.write("属性名","对应属性值" ,“cookie名称")

   读取：

   LocalCookie.Instance.read("属性名","cookie名称")

   清除：
   LocalCookie.Instance.clear("cookie名称")

   eg：
   import SCookie

   LocalCookie.Instance.write("test","name","liam")
   LocalCookie.Instance.write("test","sex","male")
   LocalCookie.Instance.write("test","age",22)

   trace(LocalCookie.Instance.read("test","name")) //liam
   trace(LocalCookie.Instance.read("test","sex")) //male
   trace(LocalCookie.Instance.read("test","age")) //22

 */
package com.utils {
	
	import flash.net.SharedObject;
	
	/**
	 * 本地Cookie缓存
	 */
	public class LocalCookie {
		
		public static const COOKIE_NAME:String = "LocalCookie";//本地缓存名字
		
		private var so:SharedObject;//
		
		/**
		 * 写入缓存
		 * @param	cookieName
		 * @param	value
		 * @param	propertyName
		 */
		public function write( propertyName:String , value:Object , cookieName:String = "LocalCookie" ):void {
			
			try {
				so = so || SharedObject.getLocal( cookieName , "/" );		
				so.data[ propertyName ] = value;
				so.flush();
			}catch (e:Error) {
			   
			}
		}
		
		/**
		 * 读取缓存
		 * @param	cookieName
		 * @param	propertyName
		 * @return
		 */
		public function read( propertyName:String , cookieName:String = "LocalCookie" ):Object {
			
			try {
				
				so = so || SharedObject.getLocal( cookieName , "/" );		
				
				return so.data[ propertyName ];
				
			}catch (e:Error) {
			   
			}
			
			return null;
		}
		
		/**
		 * 清除缓存
		 * @param	cookieName
		 */
		public function clear( cookieName:String = COOKIE_NAME ):void {
			
			try {
				
				so = so || SharedObject.getLocal( cookieName , "/" );		
				
				so.clear();
				
			}catch (e:Error) {
			   
			}
		}
		
		//本地cookie缓存
		private static var instance:LocalCookie;
		public static function get Instance():LocalCookie {
			
			return instance = instance || new LocalCookie;
		}
	}

}
