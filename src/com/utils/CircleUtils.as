package com.utils
{
	
	/**
	 * 三角函数类
	 * @author taojianlong
	 */
	public class CircleUtils
	{
		
		/**
		 * 度转为弧度
		 * @param	angle
		 * @return
		 */
		public static function angleToRadian(angle:Number):Number
		{
			return angle * (Math.PI / 180);
		}
		
		/**
		 * 弧度转为度
		 * @param	radian
		 * @return
		 */
		public static function radianToAngle(radian:Number):Number
		{
			return radian * (180 / Math.PI);
		}
		
		public static function sinD(angle:Number):Number
		{
			return Math.sin(angleToRadian(angle));
		}
		
		public static function cosD(angle:Number):Number
		{
			return Math.cos(angleToRadian(angle));
		}
		
		/**
		 * 将对应坐标转为度
		 * @param	y
		 * @param	x
		 * @return
		 */
		public static function atan2D(y:Number, x:Number):Number
		{
			return radianToAngle(Math.atan2(y, x));
		}
	}

}