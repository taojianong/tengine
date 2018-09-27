package com.manager {
	import com.geom.DMap;
	import com.inter.IResize;
	/**
	 * 所有自适应管理
	 * @author cl 2015/2/2 11:32
	 */
	public class ResizeManager {
		
		private var rMap:DMap = new DMap();
		
		/**
		 * 添加要自适应的对象
		 * @param	iResize
		 */
		public function put( iResize:IResize ):void {
			
			rMap.put( iResize , iResize );
		}
		
		/**
		 * 移除对应的适应
		 * @param	id
		 */
		public function remove( iResize:IResize ):void {
			
			rMap.remove( iResize );
		}
		
		/**
		 * 自适应
		 */
		public function resize():void {
			
			for each( var iResize:IResize in rMap.d ) {
				if ( iResize != null ) {
					iResize.resize();
				}
			}
		}
		
		private static var instance:ResizeManager;
		public static function get Instance():ResizeManager {
			return instance = instance || new ResizeManager();
		}
	}
}