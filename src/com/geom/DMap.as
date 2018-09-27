package com.geom {
	
	import flash.utils.Dictionary;
	
	public class DMap implements IMap {
		
		public var d:Dictionary;
		
		//weakKeys:Boolean (default = false) — 指示 Dictionary 对象在对象键上使用“弱”引用。
		//如果对某个对象的唯一引用位于指定的 Dictionary 对象中，则键符合垃圾回收的条件，并且在回收对象时会被从表中删除。 
		public function DMap(weakKeys:Boolean = false) {
			d = new Dictionary(weakKeys);
		}
		
		/**添加键值对**/
		public function put(key:Object, value:Object):void {
			d[key] = value;
		}
		
		/**是否包含键对应的键值对**/
		public function containsKey(key:Object):Boolean {
			return d[key] != null;
		}
		
		/**根据键获得值 没有则返回null**/
		public function get(key:Object):* {
			return d[key];
		}
		
		/**根据键删除键值对**/
		public function remove(key:Object):void {
			if ( containsKey(key) ) {
				d[key] = null;
				delete d[key];
			}
		}
		
		/**删除所有键值对**/
		public function clear():void {
			while (this.keys > 0) {				
				for (var key:Object in d) {
					remove(key);
				}
			}
		}
		
		/**将map中数据转换为数组**/
		public function toArray():Array {
			
			var list:Array = [];
			for each (var data:*in d) {
				
				list.push(data);
			}
			return list;
		}
		
		/**
		 * map中含有对象个数
		 * @return 数组字典中对象数目
		 *
		 */
		public function get keys():int {
			var count:int = 0;
			for each (var key:* in d) {
				count++;
			}
			return count;
		}
		
		/**
		 * 获取所有属性列表
		 */
		public function get props():Array {
			
			var list:Array = [];
			for ( var key:String in d ) {
				list.push( key );
			}
			return list;
		}
		
		public function toString():String {
			
			return showObject( d );
		}
		
		/**
		 * 显示Object对象中数据
		 * @param	obj 要显示的Object对象
		 * @return
		 */
		private function showObject(obj:Object):String {
			
			var str:String = "";
			var arr:Array = [];
			var oArr:Array = [];
			var child:*;
			for (var key:String in obj) {
				
				child = obj[key];
				if (child is int || child is uint || child is String || child is Number) {
					str = key + ":" + obj[key];
				} else if (child is Array) {
					oArr = [];
					var isObject:Boolean = false;
					for each (var o:*in child) {
						if (o is int || o is uint || o is String || o is Number) {
							
						} else {
							oArr.push(showObject(o));
							isObject = true;
						}
					}
					if (!isObject) {
						str = key + ":" + child.toString();
					} else if (oArr.length > 0) {
						str = key + ":[ " + oArr + " ]";
					}
				} else {
					str = key + ":" + showObject(child);
				}
				arr.push(str);
			}
			
			str = arr.join(" , ");
			return "{ " + str + " }";
		}
	}
}