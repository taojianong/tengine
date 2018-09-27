package com.sound {
	
	import flash.media.Sound;
	
	/**
	 * 声音数据
	 * @author cl 2014/12/6 23:59
	 */
	public class SoundData {
		
		/**音乐ID**/
		private var _id:String; //
		/**名称**/
		private var _name:String;
		/**重复次数**/
		private var _repeat:int = 1;
		/**描述**/
		private var _des:String; //
		/**播放延迟时间(秒),播放完成1次后延迟_delay秒后继续播放**/
		private var _delay:Number = 0; //
		/**音乐类型**/
		private var _type:String; //
		/**唯一索引**/
		private var _index:int = 1; //
		/***声音**/
		private var _sound:Sound; //
		/**播放地址**/
		private var _url:String; //
		/**二级目录名称**/
		private var _select:String; //
		/**播放要求等级**/
		private var _levelMin:uint;
		
		public function SoundData(id:String = "", url:String = "", index:int = 1, name:String = "", repeat:int = 1, delay:Number = 0, type:String = "effect", des:String = "", select:String = "") {
			this._id = id;
			this._name = name;
			this._repeat = repeat;
			this._des = des;
			this._delay = delay;
			this._type = type;
			this._index = index;
			this._url = url;
			this._select = select;
		}
		
		public function set levelMin(value:uint):void {
			
			_levelMin = value;
		}
		
		/**
		 * 播放音乐要求的最低等级
		 */
		public function get levelMin():uint {
			
			return _levelMin;
		}
		
		public function set select(value:String):void {
			
			_select = value;
		}
		
		/**
		 * 二级目录名称
		 */
		public function get select():String {
			
			return _select;
		}
		
		public function set sound(value:Sound):void {
			
			_sound = value;
		}
		
		/**
		 * 声音对象
		 */
		public function get sound():Sound {
			
			return _sound;
		}
		
		public function set index(value:int):void {
			
			_index = value;
		}
		
		/**
		 * 唯一索引
		 */
		public function get index():int {
			
			return _index;
		}
		
		public function set id(value:String):void {
			
			_id = value;
		}
		
		/**
		 * 声音ID
		 */
		public function get id():String {
			
			return _id;
		}
		
		public function set name(value:String):void {
			
			_name = value;
		}
		
		/**
		 * 播放文件名
		 */
		public function get name():String {
			
			return _name;
		}
		
		public function set repeat(value:int):void {
			
			_repeat = value;
		}
		
		/**
		 * 播放重复次数
		 */
		public function get repeat():int {
			
			return _repeat;
		}
		
		public function set delay(value:Number):void {
			
			_delay = value;
		}
		
		/**
		 * 延迟
		 */
		public function get delay():Number {
			
			return _delay;
		}
		
		public function set type(value:String):void {
			
			_type = value;
		}
		
		/**
		 * 声音类型
		 */
		public function get type():String {
			
			return _type;
		}
		
		/**声音类型 1为音效 2为场景音乐**/
		public function get soundType():int {
			
			return _index / 1000;
		}
		
		public function set des(value:String):void {
			
			_des = value;
		}
		
		/**
		 * 描述
		 **/
		public function get des():String {
			
			return _des;
		}
		
		public function set url(value:String):void {
			
			_url = value;
		}
		
		/**
		 * 音乐地址
		 */
		public function get url():String {
			
			return _url;
		}
	}

}