package com.utils {
	
	import flash.geom.Rectangle;
	
	/**
	 * 最佳区域
	 * @author cl 2015/6/2 10:25
	 */
	public class BestArena {
		
		/**
		 * 当前区域
		 */
		public var arena:Rectangle = null;
		
		/**
		 * 横向空白区域
		 */
		public var hEmptyArenas:Array = [];
		
		/**
		 * 纵向空白区域
		 */
		public var vEmptyArenas:Array = [];
		
		/**
		 * 已经占用的区域
		 */
		public var usedArenas:Array = [];
		
		public function BestArena( width:Number = 1024 , height:Number = 1024 , x:Number = 0 , y:Number = 0 ) {
			
			arena = new Rectangle( x , y , width , height );
			
			hEmptyArenas.push( arena );
			
			//vEmptyArenas.push( arena );
		}
		
		/**
		 * 占用区域
		 * @param	width
		 * @param	height
		 * @return
		 */
		public function useArena( width:Number , height:Number ):Rectangle {
			
			//最终返回区域
			var lastArena:Rectangle = null;
			var i:int = 0;
			var rect:Rectangle = null;
			var tempRect:Rectangle = null;
			for ( i = 0; i < hEmptyArenas.length; i++ ) {
				rect = hEmptyArenas[i];
				if ( rect != null ) {
					tempRect = new Rectangle(rect.x, rect.y, width, height);
					if ( rect.containsRect( tempRect ) ) {
						lastArena = tempRect;
						usedArenas.push( lastArena );
						this.spitHArena( lastArena , rect );
						break;
					}
				}
			}			
			
			//横向区域没找到合适的位置，则在纵向区域中寻找
			if ( lastArena == null ) {
				for ( i = 0; i < vEmptyArenas.length; i++ ) {
					rect = vEmptyArenas[i];
					if ( rect != null ) {
						tempRect = new Rectangle(rect.x, rect.y, width, height);
						if ( rect.containsRect( tempRect ) ) {	
							lastArena = tempRect;
							usedArenas.push( lastArena );
							this.spitVArena( lastArena , rect );
							break;
						}
					}
				}
			}
			else {
				this.splitMaxVArena();
			}
			
			return lastArena;
		}
		
		/**
		 * 分割横向区域
		 * @param	usedArena	已经占用了的区域
		 * @param	sourceArena	源区域
		 * 占用区域只能在源区域左上角
		 */
		private function spitHArena( usedArena:Rectangle , sourceArena:Rectangle ):void {
			
			var a1:Rectangle = new Rectangle( usedArena.x + usedArena.width , usedArena.y , sourceArena.width - usedArena.width , sourceArena.height );
			if ( a1.width > 0 && a1.height > 0 ) hEmptyArenas.push( a1 );
			
			var a2:Rectangle = new Rectangle( usedArena.x , usedArena.y + usedArena.height , usedArena.width , sourceArena.height - usedArena.height );
			if ( a2.width > 0 && a2.height > 0 ) hEmptyArenas.push( a2 );
			
			hEmptyArenas.splice( hEmptyArenas.indexOf(sourceArena) , 1 );
			
			this.splitMaxVArena( );
		}
		
		//因为会影响到纵向区域，所以要重新计算纵向区域
		private function splitMaxVArena( ):void {
			
			var maxH:Number = 0;
			var i:int = 0;
			var rect:Rectangle;
			for ( i = 0; i < usedArenas.length;i++ ) {
				rect = usedArenas[i];
				if ( rect != null ) {
					maxH = Math.max( maxH , rect.y + rect.height );
				}
			}
			var vRect:Rectangle = new Rectangle( 0 , maxH , arena.width, arena.height - maxH);
			if ( vRect.height > 0 ) {
				vEmptyArenas.push( vRect );
			}
			for ( i = 0; i < vEmptyArenas.length;i++ ) {
				var rAena:Rectangle = vEmptyArenas[i];
				if ( rAena.intersection( vRect ) ) { //与纵向的矩形相交
					var nrAena:Rectangle = new Rectangle( rAena.x , rAena.y , rAena.width , rAena.height - vRect.height );
					if ( nrAena.height > 0 ) {
						vEmptyArenas.splice( vEmptyArenas.indexOf(rAena) , 1 , nrAena );
					}
				}				
			}
		}
		
		/**
		 * 分割纵向区域
		 * @param	usedArena
		 * @param	sourceArena
		 */
		private function spitVArena( usedArena:Rectangle , sourceArena:Rectangle = null ):void {
			
			var a1:Rectangle = new Rectangle( usedArena.x + usedArena.width , usedArena.y , sourceArena.width - usedArena.width , usedArena.height );
			if ( a1.width > 0 && a1.height > 0 ) vEmptyArenas.push( a1 );
			
			var a2:Rectangle = new Rectangle( usedArena.x , usedArena.y + usedArena.height , sourceArena.width , sourceArena.height - usedArena.height );
			if ( a2.width > 0 && a2.height > 0 ) vEmptyArenas.push( a2 ); 
			
			vEmptyArenas.splice( vEmptyArenas.indexOf(sourceArena) , 1 );
		}
	}
}