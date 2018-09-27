package com.utils {
	
	import avmplus.getQualifiedClassName;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.globalization.DateTimeFormatter;
	import flash.globalization.LocaleID;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	//import com.ui.componet.Rect;
	
	/*
	 * taojianlong 2013-1-1 23:57
	 * This is a static class , contains ArrayToString、StringToArray、ArrayToXML、GetTimeFormat function
	 * You can use it by youself when you look the next function.
	 */
	public class CommonUtils {
		
		
		/**
		 * 时间转换格式
		 * 00：00：00（时：分：秒）
		 * 不足一小时时：00：00（分：秒）
		 * 不足一分钟时：00（秒）
		 * @param time 秒
		 * @param isAll 是否显示完整 00:00:00格式 
		 * @return
		 */
		public static function timeToStr( time:Number , isAll:Boolean = false ):String {
			
			var h:int = int( time / 3600 );
			var m:int = int( int( time % 3600 ) / 60 ) ;
			var s:int = int( time % 60 ) ;
			var str:String = "";
			if ( time >= 3600 ) { //时间大于一小时
				str = "" + ( h < 10 ? "0" + h : h ) + ":" + ( m < 10 ? "0" + m : m ) + ":" + ( s < 10 ? "0" + s : s );
			}
			else if ( time >= 60 ) { //时间大于一分钟的
				str = ( isAll ? "00:" : "" ) + ( m < 10 ? "0" + m : m ) + ":" + ( s < 10 ? "0" + s : s );
			}
			else { //小于一分钟
				str = ( isAll ? "00:00:" : "" ) + ( s < 10 ? "0" + s : s );
			}			
			return str;
		}
		
		/**
		 * 遍历XML的每一个节点
		 * @param source 源数据XML
		 * @param singleXMLFunc 处理单个节点XML的方法，将传入三个参数[ 当前节点XML,父节点XML,当前节点对应父节点的索引]
		 * @param curXML 当前遍历XML
		 * @param parent 父节点XML
		 * @return
		 */
		public static function ergodicEveryXMLNode( source:XML , singleXMLFunc:Function = null , curXML:XML = null , parent:XML = null ):void {
			
			if ( source == null ) {
				return;
			}
			
			if ( parent == null ) {
				curXML = source;
			}
			else {
				curXML = parent;
			}
			
			var i:int;
			var x:XML;
			for ( i = 0; i < curXML.children().length();i++ ) {				
				x = curXML.children()[i];
				if ( x == null ) {
					continue;
				}
				
				//执行单条XML的逻辑
				if ( singleXMLFunc != null ) {
					singleXMLFunc.apply( null , [ x , curXML , i ] );
				}
				
				//继续搜寻下一个XML条目的节点,这个子节点转换为父节点继续遍历！
				if ( x.children().length() > 0 ) { //有子节点
					ergodicEveryXMLNode( source , singleXMLFunc , null , x );
				}
			}		
		}
		
		public static function getKeys( o:Object ):int {
			
			var count:int = 0;
			for each( var key:* in o ) {
				count++;
			}
			return count;
		}
		
		/**
		 * 显示Object对象中数据
		 * @param	obj 要显示的Object对象
		 * @return
		 */
		public static function showObject(obj:Object):String {
			
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
		
		/**
		 * 缩放图片到某个尺寸
		 *
		 * @param	bitmap
		 * @param	width
		 * @param	height
		 * @return
		 */
		public static function scaleBitmapTo(bitmap:BitmapData, width:Number = 40, height:Number = 40):BitmapData {
			
			if ( bitmap == null )
				return null;
				
			if ( bitmap.width == width && bitmap.height == height ) {
				
				return bitmap;
			}
			
			var scaleX:Number = width / bitmap.width;
			var scaleY:Number = height / bitmap.height;
			
			return scaleBitmapData(bitmap, scaleX, scaleY);
		}
		
		/**
		 * 缩放图片
		 * @param	bitmap 原始BitmapData
		 * @param	scaleX
		 * @param	scaleY
		 * @return
		 */
		public static function scaleBitmapData(bitmap:BitmapData, scaleX:Number = 1, scaleY:Number = 1):BitmapData {
			
			if (bitmap == null) {				
				return null;
			}
			
			var bitWidth:Number = bitmap.width * scaleX;
			var bitHeight:Number = bitmap.height * scaleY;			
			if ( bitWidth == 0 || bitHeight == 0 ) {
				return null;
			}
			var matrix:Matrix = new Matrix;
			matrix.scale(scaleX, scaleY);
			var bmd:BitmapData = new BitmapData(bitWidth, bitHeight, true, 0);
			bmd.draw(bitmap, matrix);
			
			return bmd;
		}
		
		/**
		 * 向字符串中插入字符，间隔gap字符插入一个char
		 * @param	value 原始字符串,不能是htmlText文本！
		 * @param	gap   间隔
		 * @param	char  要插入的字符
		 * @return
		 */
		public static function insertToString(value:String, gap:int = 10, char:String = "-"):String {
			
			var arr:Array = [];
			var len:int = (value.length % gap) > 0 ? (int(value.length / gap) + 1) : int(value.length / gap);
			var i:int;
			var str:String;
			trace("value: " + value + " len: " + len);
			for (i = 0; i < len; i++) {
				
				str = value.substr(i * gap, gap);
				trace("str: " + str);
				arr.push(str);
			}
			
			return arr.join(char);
		}
		
		/**
		 * 判断某一位置是否是有效的（不透明的）
		 */
		public static function isActiveUnderPoint(targetBitmapData:BitmapData, x:Number, y:Number):Boolean {
			
			if (targetBitmapData != null) {
				
				var vector:Vector.<uint> = targetBitmapData.getVector(new Rectangle(x, y, 1, 1));
				var pix:uint;
				for each (pix in vector) {
					if (pix > 0) {
						return true;
					}
				}
			}
			return false;
		}
		
		/**
		 * 将字符串String转化为BitmapData
		 * @param	text      文本
		 * @param	fontSize  字体大小
		 * @param	fontColor 字体颜色
		 * @param	backColor 背景颜色
		 * @param	width     宽度
		 * @param	height    高度
		 * @return
		 */
		/*public static function stringToBitmapData(text:String, fontSize:int = 20, fontColor:uint = 0xff0000, backColor:uint = 0x8080C0, width:Number = 100, height:Number = 100):BitmapData {
			
			var tf:TextFormat = new TextFormat();
			tf.size = fontSize;
			tf.color = fontColor;
			
			var txt:TextField = new TextField();
			txt.defaultTextFormat = tf;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.background = true;
			txt.backgroundColor = backColor;
			txt.text = text;
			
			var bit:BitmapData = new BitmapData(txt.width, txt.height, true, 0);
			bit.draw(txt);
			
			var rect:Rect = new Rect(width, height, backColor);
			
			var bitmap:BitmapData = new BitmapData(width, height, true, 0);
			bitmap.draw(rect);
			bitmap.copyPixels(bit, new Rectangle(0, 0, rect.width, rect.height), new Point((width - bit.width) / 2, (height - bit.height) / 2));
			
			return bitmap;
		}*/
		
		/**
		 * 打开网页
		 * @param	url    网页地址
		 * @param	window 窗口模式 _blank _self
		 */
		public static function openURL(url:String, window:String = null):void {
			
			navigateToURL(new URLRequest(url), window);
		}
		
		/**
		 * 关闭网页
		 */
		public static function closeURL():void {
			
			navigateToURL(new URLRequest("javascript:window.close()"));
		}
		
		/**
		 * 获取某可视对象对应的类 2013/5/2 9:43
		 * @param	displayObject
		 * @return
		 */
		public function getDisplayObjectClass(displayObject:DisplayObject):Class {
			
			return displayObject != null ? getDefinitionByName(getQualifiedClassName(displayObject)) as Class : null;
		}
		
		/**
		 * 获取随机数
		 * @param	min
		 * @param	max
		 * @return
		 */
		public static function randRange(min:Number, max:Number):Number {
			
			var randomNum:Number = Math.floor(Math.random() * (max - min + 1)) + min;
			return randomNum;
		}
		
		/**
		 * 转换时间格式
		 * @param time 当前毫秒数
		 * @param format 转时间格式
		 * @return String
		 *
		 */
		public static function switchTime(time:Number, format:String = "YYYY-MM-DD"):String {
			var date:Date = new Date;
			date.time = time;
			var dateformater:DateTimeFormatter = new DateTimeFormatter(LocaleID.DEFAULT);
			dateformater.setDateTimePattern(format);
			//trace("___________当前时间: " + dateformater.format(date));
			return dateformater.format(date);
		}
		
		/**
		 * 将非HtmlText文本转换为相应颜色HtmlText字符串
		 * @param str 一般字符串
		 * @param color(颜色 默认为#ff0000)
		 * @return color htmlText
		 *
		 */
		public static function getColorHtmlText(str:String, color:String = "#00ff00"):String {
			return "<font color=\'" + color + "\'>" + str + "</font>";
		}
		
		/**
		 * 获取对应地址的图片地址
		 * @param	url
		 * @return
		 */
		public static function getHtmlImage(url:String, width:Number = 0, height:Number = 0):String {
			
			return "<img src= \'" + url + "\' width=\'" + width + "\' height=\'" + height + "\'></img>";
		}
		
		/**
		 * 替换htmlText中文本
		 * @param	htmlText	htmlText文本
		 * @param	newText		替换的文本
		 * @return
		 */
		public static function replaceHtml( htmlText:String , newText:String = "xxx" ):String {
		
			var str:String = htmlText.replace( /\<font [^>]+\>[^>]+\<\/font\>/gi , function():String {
					var temp:String = arguments[0];
					var s:String = temp.slice();
					var a1:Array = s.match( /\<font [^>]+\>/gi );
					var a2:Array = s.match( /\<\/font\>/gi );					
					s = "";
					s += (a1 && a1.length) ? a1[0] : "";
					s += newText;
					s += (a2 && a2.length) ? a2[0] : "";					
					return s;
				});
			
			return str;
		}
		
		/**clone a Object
		 * 硬拷贝 objToCopy：需要被拷贝的对象
		 */
		public static function cloneObject(objToCopy:Object):Object {
			var ba:ByteArray = new ByteArray();
			ba.writeObject(objToCopy);
			ba.position = 0;
			var objToCopyInto:Object = ba.readObject();
			return objToCopyInto;
		}
		
		/**
		 * 复制对象
		 * @param	element
		 * @return
		 */
		public static function copy( element:* ):* {
		
			var cls:Class = getDefinitionByName( getQualifiedClassName( element ) ) as Class;
			if ( cls != null ) {
				var o:Object = cloneObject( element );
				var obj:* = new cls();
				for ( var key:* in o ){
					obj[ key ] = element[ key ];
				}
				return obj;
			}
			return null;
		}
		
		/*
		 * The Class used to deal with Number data Format to date Format like (00:00)
		 * First I deal the Number data as int data
		 * TimeNumberToString
		 */
		public static function GetTimeFormat(time:Number):String {
			var str:String;
			if (int(time / 60) < 1) {
				str = (int(time % 60) < 10 ? "00:0" + int(time % 60) : "00:" + int(time % 60));
			} else {
				if (int((time / 60) / 10) < 1) {
					str = "0" + int(time / 60) + ":" + (int(time % 60) < 10 ? "0" + int(time % 60) : int(time % 60));
				} else {
					str = int(time / 60) + ":" + (int(time % 60) < 10 ? "0" + int(time % 60) : int(time % 60));
				}
			}
			return str;
		}
		
		/**
		 * 获取当前时间
		 * @param	split 分割符
		 * @return  20170822
		 */
		public static function getDateString( split:String = "/" ):String{
			
			var date:Date = new Date();
			var dYear:String = String(date.getFullYear());
			var dMouth:String = String((date.getMonth() + 1 < 10) ? "0" : "") + (date.getMonth() + 1);
			var dDate:String = String((date.getDate() < 10) ? "0" : "") + date.getDate();
			var ret:String = "";
			ret += dYear + split + dMouth + split + dDate; //年月日  
			return ret;
		}
		
		/*
		 * GET the current date format like this(2010/07/06  11:37:56  星期二)
		 * GetDateFormat
		 */
		public static function DateToString(date:Date):String {
			var str:String;
			var DAYS:Array = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"];
			//var date:Date = new Date();
			var dYear:String = String(date.getFullYear());
			var dMouth:String = String((date.getMonth() + 1 < 10) ? "0" : "") + (date.getMonth() + 1);
			var dDate:String = String((date.getDate() < 10) ? "0" : "") + date.getDate();
			var ret:String = "";
			ret += dYear + "/" + dMouth + "/" + dDate + "  "; //年月日    
			ret += ((date.getHours() < 10) ? "0" : "") + date.getHours() + ":";
			ret += ((date.getMinutes() < 10) ? "0" : "") + date.getMinutes() + ":";
			ret += ((date.getSeconds() < 10) ? "0" : "") + date.getSeconds() + "  ";
			ret += DAYS[date.getDay()] + "";
			str = ret;
			return str;
		}
		
		/*
		 * Switch the time format(2011/1/26 10:01:16) to UTC format.
		 */
		public static function StringToDate(time:String, type:String = "String"):Date {
			if (time == null || time == "") {
				trace(" time: " + time + "非时间格式(2011/1/26 10:01:16) 错误");
				return null;
			}
			var obj:Object = new Object;
			var date:Date;
			switch (type) {
				case "String": 
					obj.year = Number(time.split(" ")[0].split("/")[0]);
					obj.month = Number(time.split(" ")[0].split("/")[1]) - 1;
					obj.day = Number(time.split(" ")[0].split("/")[2]);
					obj.hour = Number(time.split(" ")[1].split(":")[0]) - 8;
					obj.minute = Number(time.split(" ")[1].split(":")[1]);
					obj.second = Number(time.split(" ")[1].split(":")[2]);
					date = new Date(Date.UTC(obj.year, obj.month, obj.day, obj.hour, obj.minute, obj.second));
					break;
				case "Number": 
					date = new Date(time);
					break;
			}
			return date;
		}
		
		/*
		 * Get the distance of two point
		 * 2011.2.7
		 */
		public static function getDist(x1:Number, y1:Number, x2:Number, y2:Number):Number {
			var dx:Number = x2 - x1;
			var dy:Number = y2 - y1;
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		/**Get the angle between two points
		 * 2011.10.2
		 * 斜度
		 **/
		public static function getAngle(point1:Point, point2:Point):Number {
			var dx:Number = point2.x - point1.x;
			var dy:Number = point2.y - point1.y;
			return Math.atan2(dy, dx);
		}
		
		/*************************************************
		 * 2011.2.28
		 * 按照arr的数组进行分页处理
		 * arr = [0,1,2,3,4,5,6],page为当前页，items为每页的条数
		 * 页数从1开始
		 * @param arr   要分割的数组
		 * @param page  当前页数
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
			
			var min:int = (page - 1) * items;
			var max:int = page * items;
			if (int(arr.length % items) == 0) {
				
				max = page * items;
				
			} else {
				
				max = page == pages ? (page - 1) * items + int(arr.length % items) : page * items;
			}
			
			for (var i:int = min; i < max; i++) {
				
				newArr.push(arr[i]);
			}
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
		
		/**
		 * 将一段字符串切断换行或空格
		 * @param	str     原始字符串
		 * @param	length  每段长度
		 * @param	inster  插入空格或回车（换行\n）
		 * @return
		 */
		public static function slipt(str:String, len:uint = 30, inster:String = "\n"):String {
			
			if (str == null || str == "")
				return "";
			if (str.length <= len)
				return str;
			var leng:int = str.length;
			var row:int;
			var arr:Array = [];
			var i:int;
			if (str && str.length > 0) {
				
				row = (str.length % len) > 0 ? (int(str.length / len) + 1) : int(str.length / len);
			}
			var rs:String;
			for (i = 0; i < row; i++) {
				
				rs = str.substr(i * len, len);
				arr.push(rs);
			}
			return arr && arr.length > 0 ? arr.join(inster) : "";
		}
		
		/**
		 * 将一维数组转换为二维数组
		 * @param	arr    一维数组
		 * @param	row    行数
		 * @return  dyadic 二维数组
		 */
		public static function toDyadicArray(arr:Array, row:int = 10):Array {
			
			arr = arr.slice();
			
			var dyadic:Array = [];
			var list:int = getPages(arr, row);
			var rowArr:Array; //每行数组
			var i:int;
			for (i = 0; i < list; i++) {
				
				rowArr = arr.splice(0, row);
				dyadic.push(rowArr);
			}
			//printDyadicArray( dyadic , 2 );			
			return dyadic;
		}
		
		/**
		 * 转换为UTC时间
		 * @param format 时间格式20140311112860
		 * @return
		 */
		public static function getTimeByFormat( format:String ):Number {
			
			var year:int  = int( String( format ).substr( 0 , 4 ) );
			var month:int = int( String( format ).substr( 4 , 2 ) );
			var day:int   = int( String( format ).substr( 6 , 2 ) );
			var hour:int  = int( String( format ).substr( 8 , 2 ) );
			var min:int   = int( String( format ).substr( 10 , 2 ) );
			var sec:int   = int( String( format ).substr( 12 , 2 ) );
			
			var t1:Date = new Date( year , month - 1 , day , hour , min , sec , 1000 );
			
			return t1.time;
		}
		
		/**
		 * 替换占位符 2012.11.15
		 * @param        str 字符串中含占位符，如: xxx{0}xxx{1}
		 * @param        arr
		 * @return
		 */
		public static function replaceHolder(str:String, arr:Array = null):String {
			
			if (arr) {
				
				var ind:int;
				var temp:String;
				
				str = str.replace(/\{[0-9]\}/g, function():String {
					
						temp = arguments[0].replace(/\{/g, "");
						
						ind = int(temp.replace(/\}/g, ""));
						
						return arr[ind];
					});
			}
			return str;
		}
		
		/**
		 * 获取二维数组对应索引位置范围内的数据
		 * @param   arr 二维数组
		 * @param	i
		 * @param	j
		 * @param	range
		 * @return
		 */
		public static function getDyadicArrayRange(arr:Array, i:int, j:int, range:int = 0):Array {
			
			var a:Array = [];
			var m:int;
			var n:int;
			if (arr[i] != null) {
				
				if (arr[i][j] != null) {
					
					var minI:int = i - range;
					var maxI:int = i + range;
					var minJ:int = j - range;
					var maxJ:int = j + range;
					
					minI = minI < 0 ? 0 : minI;
					maxI = maxI > arr.length - 1 ? arr.length - 1 : maxI;
					minJ = minJ < 0 ? 0 : minJ;
					maxJ = maxJ > arr[i].length - 1 ? arr[i].length - 1 : maxJ;
					
					for (m = minI; m <= maxI; m++) {
						
						for (n = minJ; n <= maxJ; n++) {
							
							a.push(arr[m][n]);
						}
					}
				}
			}
			return a;
		}
		
		/**
		 * 打印对称二维数组
		 * @param value 二维数组
		 * @param type  1为正常模式打印，2为视觉打印
		 */
		public static function printDyadicArray(value:Array, type:int = 2):void {
			if (value == null || value.length <= 0)
				return;
			
			var row:int;
			var list:int;
			var i:int;
			var j:int;
			
			//视觉打印
			if (type == 2) {
				
				row  = value.length;
				list = value[0].length;
				trace("row: " + row + " list: " + list);
				trace("********************打印二维数组,视觉模式******************");
				//按格子打印格子行列数据 
				for (i = 0; i < list; i++) {
					
					var arr:Array = [];
					for (j = 0; j < row; j++) {
						
						arr.push(value[j][i]);
					}
					trace(arr);
				}
				trace("***********************************************************");
			} else if (type == 1) { //正常模式打印
				
				trace("row: " + value.length);
				trace("********************打印二维数组,正常模式******************");
				//按格子打印格子行列数据 
				for (i = 0; i < value.length; i++) {
					
					trace(value[i]);
				}
				trace("***********************************************************");
			}
		}
		
		/***********************************************
		 * ...(rest) 用法
		 */
		public static function setArgs(... args):Array {
			var arr:Array = [];
			for (var i:int = 0; i < args.length; i++) {
				arr.push(args[i]);
			}
			return arr;
		}
	}
}