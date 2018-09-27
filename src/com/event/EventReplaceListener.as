package com.event {
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	/**
	 * 用于管理对象的所有事件
	 * @author chenlong 2017/6/7 15:47
	 */
	public class EventReplaceListener {
		
		private static var targetMap:Dictionary = new Dictionary();
		
		/**
		 * 监听某个对象的事件
		 * @param	target
		 * @param	type
		 * @param	func
		 */
		public static function addEventListener( target:EventDispatcher , type:String , func:Function ):void{
			
			if (target == null) return;
			var arr:Array = targetMap[ target ];
			if ( arr == null ){
				targetMap[ target ] = [];
			}
			
			if ( !hasEvent( target , type , func ) ){
				target.addEventListener( type , func );
				arr.push( {"type":type,"func":func} );
			}			
		}
		
		/**
		 * 移除对象对应的事件监听
		 * @param	target
		 * @param	type
		 * @param	func
		 */
		public static function removeEventListener( target:EventDispatcher , type:String , func:Function ):void{
			
			if (target == null) return;
			target.removeEventListener( type , func );
			var arr:Array = targetMap[ target ];
			if ( arr != null ){
				for ( var i:int = arr.length - 1; i >= 0;i-- ){
					var o:Object = arr[i];
					if ( o.type == type && o.func == func ){
						arr.splice( i , 1 );
					}
				}
			}
		}
		
		/**
		 * 移除对象身上所有事件监听
		 * @param	target
		 * @param	type
		 */
		public static function removeAllEventListeners( target:EventDispatcher , type:String = null ):void{
			
			if (target == null) return;
			var arr:Array = targetMap[ target ];
			if ( arr != null ){
				for ( var i:int = arr.length - 1; i >= 0;i-- ){
					var o:Object = arr[i];
					if ( o.type == type || !type ){
						arr.splice( i , 1 );
						target.removeEventListener( o.type , o.func );
					}
				}
			}
		}
		
		/**
		 * 是否有对应的事件
		 * @param	target
		 * @param	type
		 * @param	func
		 * @return
		 */
		public static function hasEvent( target:EventDispatcher , type:String , func:Function = null ):Boolean{
			
			var arr:Array = getEventList( target );
			for ( var o:Object in arr ){
				if ( o.type == type && ( func == null || o.func == func ) ){
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 对应类型事件列表
		 * @param	target
		 * @param	type
		 * @return
		 */
		public static function getEventList( target:EventDispatcher , type:String = null ):Array{
			
			var list:Array = [];
			var arr:Array = targetMap[ target ];
			for each( var o:Object in arr ){
				if ( o.type == type || !type ){
					list.push( o );
				}
			}
			return list;
		}
	}

}