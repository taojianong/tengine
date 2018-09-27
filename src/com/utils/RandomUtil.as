package com.utils {
	
	public class RandomUtil {
		/**
		 * 随机选择一组6位数字数字，即红色球数据
		 * @return Array 选出的1~33不重复的6位红色球数字
		 *
		 */ /*public static function getRandomRedNumbers():Array
		   {
		   var arr:Array = [];
		   while(arr.length < DataGlobal.REDS)
		   {
		   var num:int = makeRomdom( DataGlobal.RED_FROM , DataGlobal.RED_TO , arr );
		
		   arr.push( num );
		   }
		   return arr;
		 }*/		 
		
		/**
		 * 返回from ~ to内不重复的数字count个
		 * 比如产生0 ~ 10以内不重复的数字10个
		 * @param	from  开始数字
		 * @param	to    结束数字
		 * @param	count 重复个数
		 * @return
		 */
		public static function getNotRepetNumber(from:int = 0, to:int = 10, count:int = 10):Array {
			
			var numArr:Array = [];
			for (var a:int = from; a < to; a++) {
				numArr.push(a);
			}
			var arr:Array = [];
			var i:int = numArr.length;
			var m:int = numArr.length - count;
			while (i > m) {
				var n:int = int(Math.random() * numArr.length);
				arr.push(numArr[n]);
				numArr.splice(n, 1);
				i = numArr.length;
			}
			return arr;
		}
		
		/**
		 * 在一个区间范围产生一个随机整数
		 * @param from 区间最小值
		 * @param to 区间最大值 (from必须小于to值)
		 * @param outArr 要排除的数字
		 * @return int
		 **/
		public static function makeRomdom(from:int = 0, to:int = 100, outArr:Array = null):int {
			if (from > to) {
				trace("from 值不能大于 to 值");
				return 0;
			}
			
			if (from == to) {
				return from;
			}
			
			var isHas:Boolean = false; //是否在outArr中找到产生的那个随机数
			var isFind:Boolean = false;
			var num:Number;
			while (!isFind) {
				num = int(Math.random() * to) + 1; //产生的随机红色球
				isHas = false;
				if (outArr != null && outArr.length > 0) {
					for (var i:int = 0; i < outArr.length; i++) {
						var n:int = int(outArr[i]);
						if (n >= from && n <= to && num == n) {
							isHas = true;
							break;
						}
					}
				}
				
				if (!isHas) {
					if (num >= from && num <= to) {
						isFind = true;
						return num;
					}
				}
			}
			
			return 0;
		}
	}
}