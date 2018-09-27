package com.manager {
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	
	/**
	 * 滤镜管理
	 * @author cl 2016/10/2 2:28
	 */
	public class FiltersManager {
		
		/**
		 * 文本通用外发光 
		 */		
		public static const TEXT_GLOWFILTER_COMMON:Array = [new GlowFilter(0x260900 , 1 , 2 , 2 , 10)];
		
		
		/**
		 * 高亮滤镜 
		 */		
		public static const HIGH_LIGHT_FILTER:ColorMatrixFilter = new ColorMatrixFilter(
			[
				1.6,	0, 		0, 		0, 	0,
				0,		1.6, 	0, 		0, 	0,
				0,		0, 		1.6,	0, 	0,
				0,		0, 		0, 		1, 	0
			]);
		
		/**
		 * 黑白滤镜
		 */
		public static const blackWhiteFilter:ColorMatrixFilter = new ColorMatrixFilter([0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0]);
		
        public static function applyRed():Array {
			var matrix:Array = [];
            matrix = matrix.concat([1, 0, 0, 0, 0]); // red
            matrix = matrix.concat([0, 0, 0, 0, 0]); // green
            matrix = matrix.concat([0, 0, 0, 0, 0]); // blue
            matrix = matrix.concat([0, 0, 0, 1, 0]); // alpha
            return matrix;
        }

        public static function applyGreen():Array {
            var matrix:Array = [];
            matrix = matrix.concat([0, 0, 0, 0, 0]); // red
            matrix = matrix.concat([0, 1, 0, 0, 0]); // green
            matrix = matrix.concat([0, 0, 0, 0, 0]); // blue
            matrix = matrix.concat([0, 0, 0, 1, 0]); // alpha
			return matrix;
        }

        public static function applyBlue():Array {
            var matrix:Array = [];
            matrix = matrix.concat([0, 0, 0, 0, 0]); // red
            matrix = matrix.concat([0, 0, 0, 0, 0]); // green
            matrix = matrix.concat([0, 0, 1, 0, 0]); // blue
            matrix = matrix.concat([0, 0, 0, 1, 0]); // alpha
			return matrix;
        }
		
		/**
		 * 去除蓝色通道
		 * @return
		 */
		public static function removeBlue():Array {
			
			var matrix:Array = [];
            matrix = matrix.concat([1, 0, 0, 0, 0]); // red
            matrix = matrix.concat([0, 0, 0, 0, 0]); // green
            matrix = matrix.concat([0, 0, 1, 0, 0]); // blue
            matrix = matrix.concat([0, 0, 0, 1, 0]); // alpha
			return matrix;
		}
		
		/**
		 * 发光滤镜 红色
		 */
		public static const redGlowFilter:GlowFilter = new GlowFilter(0xff0000, 1, 2, 2, 3, 255, false, false);
		
		/**
		 * 发光滤镜 绿色
		 */
		public static const greenGlowFilter:GlowFilter = new GlowFilter(0x00ff00, 1, 2, 2, 3, 255, false, false);
		
		/**
		 * 发光滤镜 黑色
		 */
		public static const blackGlowFilter:GlowFilter = new GlowFilter(0x000000, 1, 2, 2, 3, 255, false, false);
		
		/**
		 * 发光滤镜 白色
		 */
		public static const whiteGlowFilter:GlowFilter = new GlowFilter(0xffffff, 1, 2, 2, 1, 255, false, false);
		
		/**
		 * 发光滤镜 蓝色
		 */
		public static const blueGlowFilter:GlowFilter = new GlowFilter(0x00deff, 1, 2 , 2, 1 , 255, false, false);
		
		/**
		 * 获取对应颜色发光滤镜
		 * @param	color  颜色
		 * @return
		 */
		public static function getGlowFilter(strength:Number = 2, color:uint = 0xff0000):GlowFilter {
			
			return new GlowFilter(color, 1, 2, 2, strength, 255, false, false);
		}
		
		/**
		 * 颜色滤镜
		 */
		public static function get colorFilter():ColorMatrixFilter {
			
			var matrix:Array = [1, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0];
			
			var _colorFilter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
			
			return _colorFilter;
		}
		
		/**
		 * 获取投影滤镜
		 */
		public static function getDropShadowFilter(color:uint = 0x000000, angle:Number = 45, alpha:Number = 0.8, blurX:Number = 8, blurY:Number = 8, distance:Number = 15, strength:Number = 0.65, inner:Boolean = false, knockout:Boolean = false, quality:Number = 3):DropShadowFilter {
			
			return new DropShadowFilter(distance, angle, color, alpha, blurX, blurY, strength, quality, inner, knockout);
		
		}
	}

}