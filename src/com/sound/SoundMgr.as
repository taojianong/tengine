package com.sound {
	
	import com.Common;
	import com.log.TLog;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.setTimeout;
	
	/**
	 * 播放音效类
	 * @author taojianlong 2014/12/6 23:41
	 */
	public class SoundMgr {
		
		/**<b>当前播放地址</b>**/
		private var url:String;
		/**<b>Sound</b>**/
		private var sound:Sound;
		/**<b>背景音乐声道对象</b>**/
		private var soundChannel:SoundChannel;
		/**<b>重复播放音乐次数</b>**/
		public var repeat:int;
		/**<b>每次播放完成间歇delay秒再播放</b>**/
		private var delay:Number = 0;
		/**<b>当前音乐播放位置</b>**/
		private var position:Number = 0;
		
		/**<b>this.ID</b>**/
		private var _id:String = "";
		/**<b>音效播放完成</b>**/
		private var _complete:Function;
		
		public function SoundMgr() {
			
			//this.url    = url ;
			//this.repeat = repeat;
			//this.delay  = delay;	
			//this._id = soundId;
			//this._complete = complete;
		
			//playSound( url , soundId);
		}
		
		public function playEffictSound(url:String, repeat:int = 1, delay:Number = 0, id:int = 0, complete:Function = null, soundId:String = ""):void {
			
			this.url = url;
			this.repeat = repeat;
			this.delay = delay;
			this._id = soundId;
			this._complete = complete;
			
			playSound(url, soundId);
		}
		
		public function get id():String {
			
			return _id;
		}
		
		/**<b>暂停</b>**/
		public function pause():void {
			
			if (this.soundChannel != null) {
				
				position = this.soundChannel.position;
				
				this.soundChannel.stop();
			}
		}
		
		/**<b>继续播放</b>**/
		public function play():void {
			
			toPlay(position);
		}
		
		/**<b>停止播放音乐</b>**/
		public function sotpSound():void {
			clear();
		}
		
		/**
		 * 播放音效
		 * @param url 音效地址
		 *
		 */
		public function playSound(url:String, soundId:String):void {
			if (!Common.isEffect) {
				
				return;
			}
			
			this.url = url;
			this.position = 0;
			
			if (url == null || url == "") {
				return;
			}
			
			SoundPool.getSound(soundId, url, completeSoundHandler, ioSoundErrorHandler);
		}
		
		private function completeSoundHandler(sound:Sound):void {
			
			this.sound = sound;
			
			if (delay > 0) {
				
				setTimeout(toPlay, delay);
			} else {
				
				toPlay();
			}		
		}
		
		private function toPlay(position:Number = 0):void {
			
			if (this.repeat > 0 && this.sound) {
				
				this.soundChannel = this.sound.play(position, 1);
				if (this.soundChannel != null) {
					
					this.soundChannel.addEventListener(Event.SOUND_COMPLETE, overSoundHandler);
				}
			} else {
				if (_complete != null) {
					
					_complete(_id.toString());
				}
				clear();
				if (this.soundChannel) {
					
					this.soundChannel.removeEventListener(Event.SOUND_COMPLETE, overSoundHandler);
				}
			}
		}
		
		//声音播放完成
		private function overSoundHandler(event:Event = null):void {
			
			this.repeat--;
			
			if ( delay > 0 ) {				
				setTimeout(toPlay, delay);
			} else {				
				toPlay();
			}
		}
		
		private function ioSoundErrorHandler(event:Event = null):void {
			
			TLog.addLog( "加载" + url + ".mp3音效文件失败." , Log.LOG_ERROR );
			if ( this.sound != null ) {
				this.sound.removeEventListener(Event.COMPLETE, completeSoundHandler);
				this.sound.removeEventListener(IOErrorEvent.IO_ERROR, ioSoundErrorHandler);
				this.sound = null;				
				this.soundChannel = null;
			}
		}
		
		public function clear():void {
			
			url = "";
			position = 0;
			if (this.soundChannel != null) {
				this.soundChannel.stop();
				this.soundChannel.removeEventListener(Event.SOUND_COMPLETE, overSoundHandler);
				this.soundChannel = null;
			}
			if (this.sound != null) {
				this.sound.removeEventListener(Event.COMPLETE, completeSoundHandler);
				this.sound.removeEventListener(IOErrorEvent.IO_ERROR, ioSoundErrorHandler);
				this.sound = null;
			}
		}
		
		private static var instance:SoundMgr;		
		public static function get Instance():SoundMgr {
			
			return instance = instance || new SoundMgr();
		}
	}
}