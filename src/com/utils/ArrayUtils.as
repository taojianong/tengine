package com.utils {
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	/*
	 * 2011.3.8
	 * taojianlong
	 * This class deal with Array
	 */
	public class ArrayUtils {
		/**
		 * 2013-1-2 0:10 待验证
		 * 清理一个数组中相同的数据
		 * @param  arr 要清理的数组
		 * @return Array 清理后的数据
		 *
		 */
		public static function clearTheSameInArray(arr:Array):Array {
			if (arr == null)
				return arr;
			
			arr = arr.sort(Array.NUMERIC);
			
			var o1:Object;
			var o2:Object;
			for each (o1 in arr) {
				
				for each (o2 in arr) {
					
					if (o1 == o2 && arr.indexOf(o1) != arr.indexOf(o2)) {
						
						arr.splice(arr.indexOf(o2), 1);
					}
				}
			}
			
			return arr;
		}
		
		/**
		 * 从数组中随机抽取出几位数字组成新的数组
		 * @param arr 初始数组
		 * @param num 抽出几位
		 * @return Array 随机数组
		 *
		 */
		public static function getRandomFromArray(arr:Array, num:int = 6):Array {
			arr = clearTheSameInArray(arr);
			if (arr.length > num) {
				var ran:int;
				var _arr:Array = [];
				while (_arr.length == num) {
					ran = int(Math.random() * arr.length);
					_arr.push(arr.splice(ran, 1));
				}
				return _arr;
			}
			return arr;
		}
		
		/**
		 * 随机化数组 2012.10.4
		 * @param value 要混淆的原始数组
		 * @param length 要返回混淆后对应长度的数组
		 * **/
		public static function randomArray(value:Array, length:int = 6):Array {
			var arr:Array = value.slice(); //克隆数组,只能克隆非引用数组
			if (arr != null) {
				var rnd:uint;
				var temp:*;
				var len:uint = arr.length;
				//var time:int = getTimer();
				
				for (var i:uint; i < len; i++) {
					temp = arr[i];
					rnd = Math.random() * len;
					arr[i] = arr[rnd];
					arr[rnd] = temp;
				}
				//time = getTimer() - time;
				arr = arr.slice( 0 , length );
				//arr = arr.sort(Array.NUMERIC);
				//trace("循环" + len + "次,花费时间: " + time + " 毫秒,获得随机数组: " + arr);
			}
			return arr;
		}
		
		/**
		 * 将一维数组转换为二维数组
		 * @param	arr 一维数组
		 * @param	items(或list)
		 * @return  dyadic 二维数组
		 */
		public static function toDyadicArray(arr:Array, items:int = 10):Array {
			
			var dyadic:Array = [];
			var list:int = getPages(arr, items);
			var rowArr:Array; //每行数组
			var i:int;
			for (i = 0; i < list; i++) {
				
				rowArr = arr.splice(0, items);
				dyadic.push(rowArr);
			}
			return dyadic;
		}
		
		/**
		 * 打印对称二维数组  2012.9.21
		 * @param value 要打印的二维数组
		 * @param row 即value.length
		 * @param lie 即value[0].length
		 *
		 * 格式
		 * arr = [[0,0,1,1],[0,1,0,0],[0,0,1,0]]
		 * 打印后为
		 * 1 0 0
		 * 1 0 1
		 * 0 1 0
		 * 0 0 0
		 * **/
		public static function printArray(value:Array):void {
			if (value != null && value[0] != null) {
				var row:int = value.length;
				var lie:int = value[0].length;
				var i:int;
				var j:int;
				trace("********************");
				//按格子打印格子行列数据 
				for (i = 0; i < lie; i++) {
					var arr:Array = [];
					for (j = 0; j < row; j++) {
						arr.push(value[j][i]);
					}
					trace(arr);
				}
				trace("********************");
			}
		}
		
		/**
		 * 检测数组中是否出现连号
		 * @param  arr     要检测的数组
		 * @return Boolean 是否检测出连号
		 */
		public static function arrayHasHyphen(arr:Array):Boolean {
			arr = arr.sort(Array.NUMERIC);
			for (var i:int = 0; i < arr.length - 1; i++) {
				if (Math.abs(arr[i] - arr[i + 1]) == 1) {
					
					return true;
				}
					//for(var j:int=i+1;j<arr.length;j++)
					//{
					//if( int( arr[j] ) == int( arr[i] ) + 1 )
					//{
					//return true;
					//}
					//}
			}
			return false;
		}
		
		/**
		 * 2012.3.3
		 * 讲两个数组合成一个数组，并将数据相同的两个数合并
		 * @param arr1  数字数组
		 * @param arr2 数字数组
		 * @param type 返回类型 0为返回合并的数组(交集)，1为返回两个数组中相同数据的数组(交集取补)，2为返回两个数组中除去相同数据后的数组(并集)
		 * @return Array 合并的数组
		 *
		 */
		public static function mergeArray(arr1:Array, arr2:Array, type:int = 2):Array {
			var a1:Array = [];
			var a2:Array = [];
			var a3:Array = [];
			var temp:Array = arr1.concat(arr2);
			temp = temp.sort(Array.NUMERIC);
			for each (var _key:*in temp) {
				if (arr1.indexOf(_key) != -1 && arr2.indexOf(_key) != -1) {
					if (a1.indexOf(_key) == -1) {
						a1.push(_key); //相同
					}
				} else {
					if (a2.indexOf(_key) == -1) {
						a2.push(_key); //不同
					}
				}
			}
			if (type == 0) //交集
			{
				temp = a1;
			} else if (type == 1) //交集取补
			{
				temp = a2;
			} else if (type == 2) //并集
			{
				temp = a1.concat(a2);
			}
			trace("_______________a1（交集）: " + a1 + " a2（交集取补）: " + a2 + " 并集: " + a1.concat(a2));
			return temp;
		}
		
		/**
		 * 2012.3.3
		 * 找出两个不同数组中相同的对象来
		 * @param arrA
		 * @param arrB
		 * @return Array
		 *
		 */
		public static function findDiff(arrA:Array, arrB:Array):Array {
			var diff:Array = new Array;
			var dic:Dictionary = new Dictionary(true);
			var o:Object;
			for each (o in arrA) {
				if (dic[o])
					diff.push(o);
				dic[o] = true;
			}
			for each (o in arrB) {
				if (dic[o])
					diff.push(o);
				dic[o] = true;
			}
			return diff;
		}
		
		/*
		 * 一个冒泡程序
		 * 0,1,2,3,4
		 * 4,0,1,2,3
		 * 3,4,0,1,2
		 * 2,3,4,0,1
		 * 1,2,3,4,0
		 */
		public static function maopao(arr:Array, arrs:Array):Array {
			for (var i:uint = 0; i < arr.length; i++) {
				arrs[i] = new Array();
				for (var j:uint = 0; j < arr.length; j++) {
					if (i == 0) {
						arrs[i][j] = arr[j];
					} else {
						if (j == 0) {
							arrs[i][j] = arrs[i - 1][arr.length - 1];
						} else {
							arrs[i][j] = arrs[i - 1][j - 1];
						}
					}
				}
			} //end for			
			return arrs[arr.length - 1];
		}
		
		/*************************************************
		 * 2011.2.28
		 * 按照arr的数组进行分页处理
		 * arr = [0,1,2,3,4,5,6],page为当前页，items为每页的条数
		 * 页数从1开始
		 * @param arr   要分割的数组
		 * @param page  页数
		 * @param items 每页页数条目
		 */
		public static function page(arr:Array, page:int = 1, items:int = 5):Array {
			var newArr:Array = new Array;
			/*
			 * 根据当前数组长度得到总页数
			 */
			var pages:int = 0;
			if (arr.length > 0) {
				pages = (arr.length % items) > 0 ? (int(arr.length / items) + 1) : int(arr.length / items);
			} else {
				pages = 0;
				return newArr;
			}
			if (page > pages) {
				trace("page > pages,wrong");
				return null;
			}
			trace("arr: " + arr);
			var min:int = (page - 1) * items;
			var max:int = page * items;
			if (int(arr.length % items) == 0) {
				max = page * items;
			} else {
				if (page == pages) {
					max = (page - 1) * items + int(arr.length % items);
				} else {
					max = page * items;
				}
			}
			
			for (var i:int = min; i < max; i++) {
				newArr.push(arr[i]);
			}
			trace(page + "/" + pages + "                      " + newArr);
			return newArr;
		}
		
		/**
		 * 获取分页页数
		 * @param	arr   要分页的数组
		 * @param	items 分页条目数
		 * @return
		 */
		public static function getPages(arr:Array, items:int = 5):int {
			
			var pages:int = 0;
			if (arr && arr.length > 0) {
				
				pages = (arr.length % items) > 0 ? (int(arr.length / items) + 1) : int(arr.length / items);
				
			} else {
				
				pages = 0;
			}
			return pages;
		}
		
		/*
		 * Array data switch to String data
		 * Array.join("");
		 */
		public static function arrayToString(arr:Array, partition:String = "|"):String {
			//Array.join(partition);
			var str:String = new String();
			if (arr == null) {
				str = "";
				return str;
			} else {
				for (var i:uint = 0; i <= arr.length - 1; i++) {
					str += arr[i] + partition;
				}
				str = str.substr(0, str.length - 1);
				return str;
			}
		}
		
		/*
		 * String data switch to Array data
		 */
		public static function stringToArray(str:String, partition:String = "|"):Array {
			var arr:Array = new Array();
			if (str == "" || str == "null" || str == null) {
				arr = [];
				return arr;
			} else {
				for (var i:uint = 0; i <= str.split(partition).length - 1; i++) {
					arr[i] = str.split(partition)[i];
				}
				return arr;
			}
		}
		
		/*
		 * 2011.2.19
		 * 升序(降序)排列,Ascending升序,Grade降序
		 * arr.sort(Array.CASEINSENSITIVE | Array.NUMERIC) 按数字大小升序
		 * Array.DESCENDING | Array.NUMERIC 按数字大小降序排列
		 * var arr:Array = [{a:0,b:4},{a:3,b:5},{a:8,b:9},{a:2,b:6}];     //关联数组
		 *     arr.sortOn(["b"],Array.CASEINSENSITIVE | Array.NUMERIC);   //排列关联数组
		 * //  {a:0,b:4},{a:3,b:5},{a:2,b:6},{a:8,b:9}
		 * 1 或 Array.CASEINSENSITIVE      //升序
		 * 2 或 Array.DESCENDING           //降序
		 * 4 或 Array.UNIQUESORT           //表示唯一的排序要求   Number
		 * 8 或 Array.RETURNINDEXEDARRAY   //指定排序返回索引数组 Number
		 * 16 或 Array.NUMERIC             //按数字大小排列
		 */
		public static function sortOn(arr:Array, type:uint = 1):Array {
			var rArr:Array = new Array;
			//避免arr数组被处理掉			
			for (var a:int = 0; a < arr.length; a++) {
				rArr.push(arr[a]);
				if (!(arr[a] is Number)) {
					trace("Array is not Number");
					return null;
					break;
				}
			}
			var _arr:Array = [];
			var i:int = 0;
			var num:Number = rArr[0];
			while (i < rArr.length) {
				if (type == Array.CASEINSENSITIVE) {
					//降序
					if (num < Number(rArr[i])) {
						num = Number(rArr[i]);
					}
				} else if (type == Array.DESCENDING) {
					//升序
					if (num > Number(rArr[i])) {
						num = Number(rArr[i]);
					}
				}
				i++;
				if (i == rArr.length) {
					for (var j:int = 0; j < rArr.length; j++) {
						if (rArr[j] == num) {
							rArr.splice(j, 1);
							_arr.push(num);
							i = 0;
							num = rArr[0];
						}
					}
				}
			}
			return _arr;
		}
		
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
		 * 获取随即数组,将数组内数据随即混乱
		 **/
		public static function getRandomArray(arr:Array):Array {
			
			var _rarr:Array = getNotRepetNumber(0, arr.length, arr.length);
			var _arr:Array = new Array;
			
			for (var i:int = 0; i < _rarr.length; i++) {
				_arr.push(arr[_rarr[i]]);
			}
			return _arr;
		}
		
		/*
		 * this is a simple mode from Array data format to XML data format.
		 * you can set your xml format arrcording to your needs.
		 */
		public static function arrayToXML( arr:Array , xml:XML=null ):XML {
			
			if ( xml == null ){
				xml = <data></data>;
			}			
			for (var i:int = 0; i < arr.length; i++) {				
				var obj:* = arr[i];				
				var item:XML = <item />;
				if( obj is Array ){
					arrayToXML( obj , item );
				}else if ( obj === Object ){
					for ( var key:String in obj ){						
						if ( obj[key] is Array ){
							arrayToXML( obj[key] , item );
						}else{
							item.@[key] = obj[key];
						}
					}
				}else{
					item.value = arr[i];
				}
				
				xml.appendChild(item);
			}
			return xml;
		}
	}
}