package com.utils {
	
	/**
	 * 时间参数相关工具
	 * @author taojianlong 2014-2-22 18:57
	 */
	public class TimeUtils {
		
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
					obj.year   = Number(time.split(" ")[0].split("/")[0]);
					obj.month  = Number(time.split(" ")[0].split("/")[1]) - 1;
					obj.day    = Number(time.split(" ")[0].split("/")[2]);
					obj.hour   = Number(time.split(" ")[1].split(":")[0]) - 8;
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
		
	}

}