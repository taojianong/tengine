package com.utils {
	/*
	 * 摘自网站 http://ria9.com/flashbuilder/2010/0321/5.html
	 * 2011.2.19
	 */
	import flash.utils.ByteArray;

	public class StringUtil {
		
		/**
		 * 模糊搜索
		 * @param	info		要搜索的文本
		 * @param	searchList 	搜索源文本列表
		 * @return
		 */
		public static function blurSearch(info:String, searchList:Vector.<String>):Vector.<String> {

			var list:Vector.<String> = new Vector.<String>();
			if (info == "") return list;

			var isSame:Boolean = false;
			var mInfo:String = "";
			var sInfo:String = null;
			for (var i:int = 0; i < searchList.length; i++) {
				mInfo = searchList[i];
				if (mInfo == info) {
					//完全相同
					list.push(info);
				} else {
					//不相等，找相近
					//if (hasRelation(mInfo, info)) {
						//sInfo = getRelationData(mInfo, info);
						//if (sInfo != "") list.push(sInfo);
					//}
					
					if ( mInfo.search(new RegExp(info,"gi")) > -1 ){
						list.push(mInfo);
					}
				}
			}

			//list.sort(sortByLength);

			return list;
		}

		/** 两个字符串是否有相同字符 */
		private static function hasRelation(resInfo:String, searchInfo:String):Boolean {
			if (resInfo.indexOf(searchInfo) >= 0) return true;
			var len0:int = resInfo.length;
			var info0:String;
			var len1:int = searchInfo.length;
			var j:int = 0;
			for (var i:int = 0; i < len0; i++) {
				info0 = resInfo.charAt(i);
				for (j = 0; j < len1; j++) {
					if (info0 == searchInfo.charAt(j)) return true;
				}
			}
			return false;
		}

		/** 得到两个字符串匹配结果的类型数据 */
		private static function getRelationData(resInfo:String, searchInfo:String):String {
			//被包含
			var index:int = resInfo.indexOf(searchInfo);
			if (index >= 0) return resInfo;

			//不包含
			var len0:int = resInfo.length;
			var info0:String;
			var len1:int = searchInfo.length;
			var j:int = 0;
			var sameAmount:int = 0;
			for (var i:int = 0; i < len0; i++) {
				info0 = resInfo.charAt(i);
				for (j = 0; j < len1; j++) {
					if (info0 == searchInfo.charAt(j)) {
						sameAmount++;
						break;
					}
				}
			}
			if (sameAmount >= len1) {
				return resInfo;
			}
			return "";
		}

		/** 按长度排列顺序 */
		private static function sortByLength(data1:String, data2:String):int {
			if (data1.length < data2.length) {
				return -1
			} else if (data1.length > data2.length) {
				return 1;
			} else {
				return 0;
			}
		}

		/**
		 * 替换占位符 2012.11.15
		 * @param	str 字符串中含占位符，如: xxx{0}xxx{1}
		 * @param	arr
		 * @return
		 */
		public static function replaceHolder(str:String, arr:Array = null):String {

			if (arr) {

				var ind:int;
				var temp:String;

				str = str.replace(/\{[0-9]\}/g, function():String {

					temp = arguments[0].replace(/\{/g, "")
					ind = int(temp.replace(/\}/g, ""));

					return arr[ind];
				});
			}
			return str;
		}

		/**
		 * 是否包含了字母或数字等字符
		 * @param value
		 * @return
		 */
		public static function containsChar(value:String):Boolean {

			if (!value) {
				return false;
			}
			var reg:RegExp = /[a-z]|[0-9]|[A-Z]|[\u4e00-\u9fa5]/;
			for (var j:uint = 0; j < value.length; j++) {
				if (value.charAt(j).match(reg)) {
					return true;
				}
			}
			return false;
		}

		/**
		 * 读取字符串指定字节长度字符串！
		 * @param char    字符串
		 * @param byteLen 字节长度
		 * @param charSet 字符格式,如"gb2312","utf-8"
		 * @return
		 */
		public static function readStringBytes(char:String, byteLen:int = 0, charSet:String = "gb2312"):String {

			var bytes:ByteArray = new ByteArray();
			bytes.writeMultiByte(char, charSet);
			bytes.position = 0;

			if (byteLen == 0 || byteLen > bytes.length) {
				byteLen = bytes.length;
			}
			return bytes.readMultiByte(byteLen, charSet);
		}

		/**
		 * 获取字符串字节长度
		 * @param char    字符串
		 * @param charSet 字符格式,如"gb2312","utf-8"
		 * @return
		 */
		public static function getStringBytesLength(char:String, charSet:String = "gb2312"):uint {

			var bytes:ByteArray = new ByteArray();
			bytes.writeMultiByte(char, charSet);
			bytes.position = 0;
			return bytes.length;
		}

		//忽略大小字母比较字符是否相等;
		public static function equalsIgnoreCase(char1:String, char2:String):Boolean {
			return char1.toLowerCase() == char2.toLowerCase();
		}

		//比较字符是否相等;
		public static function equals(char1:String, char2:String):Boolean {
			return char1 == char2;
		}

		//是否为Email地址;
		public static function isEmail(char:String):Boolean {
			if (char == null) {
				return false;
			}
			char = trim(char);
			var pattern:RegExp = /(\w|[_.\-])+@((\w|-)+\.)+\w{2,4}+/;
			var result:Object = pattern.exec(char);
			if (result == null) {
				return false;
			}
			return true;
		}

		//是否是数值字符串;
		public static function isNumber(char:String):Boolean {
			if (char == null) {
				return false;
			}
			return !isNaN(Number(char));
		}

		//是否为Double型数据;
		public static function isDouble(char:String):Boolean {
			char = trim(char);
			var pattern:RegExp = /^[-\+]?\d+(\.\d+)?$/;
			var result:Object = pattern.exec(char);
			if (result == null) {
				return false;
			}
			return true;
		}

		//Integer;
		public static function isInteger(char:String):Boolean {
			if (char == null) {
				return false;
			}
			char = trim(char);
			var pattern:RegExp = /^[-\+]?\d+$/;
			var result:Object = pattern.exec(char);
			if (result == null) {
				return false;
			}
			return true;
		}

		//English;
		public static function isEnglish(char:String):Boolean {
			if (char == null) {
				return false;
			}
			char = trim(char);
			var pattern:RegExp = /^[A-Za-z]+$/;
			var result:Object = pattern.exec(char);
			if (result == null) {
				return false;
			}
			return true;
		}

		//中文;
		public static function isChinese(char:String):Boolean {
			if (char == null) {
				return false;
			}
			char = trim(char);
			var pattern:RegExp = /[\u4e00-\u9fa5]/;// /^[\u0391-\uFFE5]+$/;
			var result:Object = pattern.exec(char);
			if (result == null) {
				return false;
			}
			return true;
		}

		//双字节
		public static function isDoubleChar(char:String):Boolean {
			if (char == null) {
				return false;
			}
			char = trim(char);
			var pattern:RegExp = /^[^\x00-\xff]+$/;
			var result:Object = pattern.exec(char);
			if (result == null) {
				return false;
			}
			return true;
		}

		//含有中文字符
		public static function hasChineseChar(char:String):Boolean {
			if (char == null) {
				return false;
			}
			char = trim(char);
			var pattern:RegExp = /[^\x00-\xff]/;
			var result:Object = pattern.exec(char);
			if (result == null) {
				return false;
			}
			return true;
		}

		//注册字符;
		public static function hasAccountChar(char:String, len:uint = 15):Boolean {
			if (char == null) {
				return false;
			}
			if (len < 10) {
				len = 15;
			}
			char = trim(char);
			var pattern:RegExp = new RegExp("^[a-zA-Z0-9][a-zA-Z0-9_-]{0," + len + "}$", "");
			var result:Object = pattern.exec(char);
			if (result == null) {
				return false;
			}
			return true;
		}

		//URL地址;
		public static function isURL(char:String):Boolean {
			if (char == null) {
				return false;
			}
			char = trim(char).toLowerCase();
			var pattern:RegExp = /^http:\/\/[A-Za-z0-9]+\.[A-Za-z0-9]+[\/=\?%\-&_~`@[\]\’:+!]*([^<>\"\"])*$/;
			var result:Object = pattern.exec(char);
			if (result == null) {
				return false;
			}
			return true;
		}

		// 是否为空白;
		public static function isWhitespace(char:String):Boolean {
			switch (char) {
			case " ": 
			case "\t": 
			case "\r": 
			case "\n": 
			case "\f": 
				return true;
			default: 
				return false;
			}
		}

		//去左右空格;
		public static function trim(char:String):String {
			if (char == null) {
				return null;
			}
			return rtrim(ltrim(char));
		}

		//去左空格;
		public static function ltrim(char:String):String {
			if (char == null) {
				return null;
			}
			var pattern:RegExp = /^\s*/;
			return char.replace(pattern, "");
		}

		//去右空格;
		public static function rtrim(char:String):String {
			if (char == null) {
				return null;
			}
			var pattern:RegExp = /\s*$/;
			return char.replace(pattern, "");
		}

		//是否为前缀字符串;
		public static function beginsWith(char:String, prefix:String):Boolean {
			return prefix == char.substring(0, prefix.length);
		}

		//是否为后缀字符串;
		//public static function endsWith(char:String, suffix:String):Boolean
		//{
		//return (suffix == char.substring(char.length – suffix.length));
		//}

		//去除指定字符串;
		public static function remove(char:String, remove:String):String {
			return replace(char, remove, "");
		}

		//字符串替换
		public static function replace(char:String, replace:String, replaceWith:String):String {
			return char.split(replace).join(replaceWith);
		}

		//utf16转utf8编码;
		/*public static function utf16to8(char:String):String
		   {
		   var out:Array = new Array();
		   var len:uint = char.length;
		   for(var i:uint=0;i= 0*0001 && c <= 0*007F)
		   {
		   if(c) //???????????????
		   {
		   out[i] = char.charAt(i);
		   }
		   else if (c > 0*07FF)
		   {
		   out[i] = String.fromCharCode(0xE0 | ((c >> 12) & 0*0F),
		   0*80 | ((c >> 6) & 0*3F),
		   0*80 | ((c >> 0) & 0*3F));
		   }
		   else
		   {
		   out[i] = String.fromCharCode(0xC0 | ((c >> 6) & 0*1F),
		   0*80 | ((c >> 0) & 0*3F));
		   }
		   }
		   return out.join("");
		   }*/
		//utf8转utf16编码;
		/*public static function utf8to16(char:String):String
		   {
		   var out:Array = new Array();
		   var len:uint = char.length;
		   var i:uint = 0;
		   var char2:int,char3:int;
		   while(i> 4)
		   {
		   switch(i)
		   {
		   case 0:
		   case 1:
		   case 2:
		   case 3:
		   case 4:
		   case 5:
		   case 6:
		   case 7:
		   // 0xxxxxxx
		   out[out.length] = char.charAt(i-1);
		   break;
		   case 12:
		   case 13:
		   // 110x xxxx 10xx xxxx
		   char2 = char.charCodeAt(i++);
		   out[out.length] = String.fromCharCode(((c & 0*1F) << 6) | (char2 & 0*3F));
		   break;
		   case 14:
		   // 1110 xxxx 10xx xxxx 10xx xxxx
		   char2 = char.charCodeAt(i++);
		   char3 = char.charCodeAt(i++);
		   out[out.length] = String.fromCharCode(((c & 0*0F) << 12) | ((char2 & 0*3F) << 6) | ((char3 & 0*3F) << 0));
		   break;
		   }
		   }
		   return out.join("");
		   } */

		//转换字符编码;
		public static function encodeCharset(char:String, charset:String):String {
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes(char);
			bytes.position = 0;
			return bytes.readMultiByte(bytes.length, charset);
		}

		//添加新字符到指定位置;
		public static function addAt(char:String, value:String, position:int):String {
			if (position > char.length) {
				position = char.length;
			}
			var firstPart:String = char.substring(0, position);
			var secondPart:String = char.substring(position, char.length);
			return (firstPart + value + secondPart);
		}

		//替换指定位置字符;
		public static function replaceAt(char:String, value:String, beginIndex:int, endIndex:int):String {
			beginIndex = Math.max(beginIndex, 0);
			endIndex = Math.min(endIndex, char.length);
			var firstPart:String = char.substr(0, beginIndex);
			var secondPart:String = char.substr(endIndex, char.length);
			return firstPart + value + secondPart;
		}

		//删除指定位置字符;
		public static function removeAt(char:String, beginIndex:int, endIndex:int):String {
			return StringUtil.replaceAt(char, "", beginIndex, endIndex);
		}

		//修复双换行符;
		public static function fixNewlines(char:String):String {
			return char.replace(/\r\n/gm, "\n");
		}

		/**
		 * 复制字符
		 * @param	char
		 * @param	num
		 * @return
		 */
		public static function copyChar(char:String, num:int = 1, join:String = ""):String {

			var arr:Array = [];
			for (var i:int = 0; i < num; i++) {
				arr.push(char);
			}
			return arr.join(join);
		}
	}
}