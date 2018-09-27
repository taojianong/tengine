package com.event {
	import flash.utils.Dictionary;
	/**
	 * 事件管理器
	 * @author cl 2017/6/7 15:43
	 */
	public class EventManager {
		
		private static var _eventDict:Dictionary = new Dictionary();

		/**
		 * 派发事件
		 * @param type	事件类型
		 * @param args	携带数据
		 *
		 */
		public static function dispatchEvent(type:String, ...args):void {
			var funcList:Vector.<Function> = _eventDict[type];
			if (funcList != null) {
				var list:Vector.<Function> = funcList.concat();
				var length:int = list.length;
				if (length > 0) {
					for (var i:int = 0; i < length; i++) {
						if (Config.isRelease) {
							try {
								list[i].apply(null, args);
							} catch (e:Error) {
								trace( e.message + "@@" + e.getStackTrace() + "调度事件出错");
							}
						} else {
							list[i].apply(null, args);
						}
					}
				}
			}
		}

		/**
		 * 是否含有事件侦听
		 * @param	type		事件类型
		 * @param	listener	对应的事件函数，如果填了此项，则会继续匹配函数
		 * @return
		 */
		public static function hasEventListener(type:String, listener:Function = null):Boolean {
			var bool:Boolean = false;
			var funcList:Vector.<Function> = _eventDict[type];
			if (funcList == null || funcList.length == 0) {
				bool = false;
			} else {
				if (listener == null) {
					bool = true;
				} else {
					bool = funcList.indexOf(listener) > -1;
				}
			}
			return bool;
		}

		/**
		 * 添加事件侦听
		 * @param	type		事件类型
		 * @param	listener	事件函数
		 */
		public static function addEventListener(type:String, listener:Function):void {
			
			var funcList:Vector.<Function> = _eventDict[type];
			if (funcList == null) {
				funcList = new Vector.<Function>();
				_eventDict[type] = funcList;
			}
			if (!hasEventListener(type, listener)) {
				funcList.push(listener);
			}
		}

		/**
		 * 移除事件侦听
		 * @param	type		事件类型
		 * @param	listener	事件函数
		 */
		public static function removeEventListener(type:String, listener:Function):void {
			
			var funcList:Vector.<Function> = _eventDict[type];
			if (funcList != null) {
				var length:int = funcList.length;
				for (var i:int = 0; i < length; i++) {
					if (funcList[i] == listener) {
						funcList.splice(i, 1);
						if (funcList.length == 0) {
							_eventDict[type] = null;
							delete _eventDict[type];
						}
						break;
					}
				}
			}
		}

		/**
		 * 移除所有事件函数
		 */
		public static function removeAllEventListener():void {
			for (var type:* in _eventDict) {
				removeEventListeners(type);
			}
		}
		
		/**
		 * 移除某类型的所有事件函数
		 * @param	type	事件类型，如果为null则移除所有事件函数
		 */
		public static function removeEventListeners(type:String = null):void {
			if (type != null) {
				if (_eventDict[type] != null) {
					_eventDict[type] = null;
					delete _eventDict[type];
				}
			} else {
				removeAllEventListener();
			}
		}
		
		/**
		 * 事件类型的数量
		 */
		public static function get eventLength():int {
			
			var len:int = 0;
			for (var type:* in _eventDict) {
				len++;
			}
			return len;
		}

		/**
		 * 事件函数的数量
		 */
		public static function get length():int {
			
			var len:int = 0;
			for (var type:* in _eventDict) {
				len += _eventDict[type].length;
			}
			return len;
		}
	}
}