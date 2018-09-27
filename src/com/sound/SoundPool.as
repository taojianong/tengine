package com.sound {
	
	import com.load.Resource;
	import flash.media.Sound;
	import flash.utils.Dictionary;
	
	/**
	 * 声音池
	 * @author cl 2014/12/6 23:46
	 */
	public class SoundPool {
		
		/**<b>声音池</b>**/
		public static var pool:Dictionary = new Dictionary;
		
		/**
		 * 从池中获取对应音乐
		 * @param	url
		 * @param	complete
		 * @param	error
		 * @return
		 */
		public static function getSound(id:String, url:String, complete:Function = null, error:Function = null):void {
			
			if ( url == null || url == "" ) {				
				return;
			}
			
			var soundRes:Resource = new Resource( id , url , "" );
		}
		
		/**
		 * 回收音乐到池中 2012.11.19
		 * @param	url
		 */
		public static function reback(sound:Sound):void {
			
			if (pool[sound.url] != null) {
				
				throw new Error("池中已存在该音乐");
			}
			pool[sound.url] = sound;
		}
	}

}