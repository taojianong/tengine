package com.handlers {
	
	/**
	 * 处理器
	 */
	public class Handler {
		
		/**处理方法*/
		private var _method:Function;
		/**参数*/
		private var _args:Array;
		
		/**保存一些数值,使用时可从中取相关数值**/
		private var _data:Object = new Object;
		
		public function Handler( method:Function = null , args:Array = null ) {
			
			this._method = method;
			this._args   = args;
		}
		
		public function get data():Object {
			
			return _data;
		}
		
		/**执行处理*/
		public function execute():void {
			
			if ( _method != null ) {
				
				_method.apply( null, _args );
			}
		}
		
		/**执行处理(增加数据参数)*/
		public function executeWith(data:Array):void {
			
			if ( data == null ) {
				
				execute();
			}
			if ( _method != null ) {
				
				_method.apply( null, _args ? _args.concat( data ) : data );
			}
		}
		
		/**
		 * 方法
		 * 
		 */
		public function get method():Function {
			
			return _method;
		}
		
		/**
		 * 参数
		 * 
		 */
		public function get args():Array {
			
			return _args;
		}
	}
}