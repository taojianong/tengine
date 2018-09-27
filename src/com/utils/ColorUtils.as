package com.utils {
	
	/**
	 * 颜色管理静态类
	 * @author taojianlong
	 *
	 */
	public class ColorUtils {
		
		/**<b>黑色 0x000000</b>**/
		public static const BLACK:uint = 0x000000;
		/**<b>红色 0xff0000</b>**/
		public static const RED:uint = 0xff0000;
		/**<b>白色 0xffffff</b>**/
		public static const WHITE:uint = 0xffffff;
		/**<b>黄色 0xfff83d</b>**/
		public static const YELLOW:uint = 0xfff83d;
		/**<b>橙色,暗金色 #fd9215</b>**/
		public static const ORANGE:uint = 0xfd9215;
		/**<b>绿色 0x00ff00</b>**/
		public static const GREEN:uint = 0x00ff00;
		/**<b>灰色 0x808080</b>**/
		public static var GRAY:uint = 0x808080;
		/**<b>蓝色 0x0000ff</b>**/
		public static var BLUE:uint = 0x0000ff;
		
		public static const colorHtml:Object = { 0:"#ffffff" , 1:"#00ff00" , 2:"#0080FF" , 3:"#ff00ff" , 4:"#ff8040" , 5:"#ff0000" };
		
		public static const colorUint:Object = { 0:0xffffff , 1:0x00ff00 , 2:0x0080FF , 3:0xff00ff , 4:0xff8040 , 5:0xff0000 };
		
		/**
		 * 颜色值转换,将0x格式转换为'#'格式
		 * @param value 要转换的颜色值 ,默认为RED
		 */
		public static function toString(value:uint = RED):String {
			
			return "#" + value.toFixed(16); //  String(value).replace(/0x/g, "#");
		}
		
		public static function toUint(color:String):uint {
			
			return uint(String(color).replace(/#/g, "0x"));
		}
		
		/**
		 * 
		 * @param	quility 品质
		 */
		public static function getColorUint(quility:int):uint {
			
			return colorUint[quility] == null ? 0xffffff : colorUint[quility];
		}
		
		public static function getColorHtml(quility:int):String {
			
			return colorHtml[quility] == null ? "#ffffff" : colorHtml[quility];
		}
		
		public static function setColorHtml(str:String, color:String = "", quility:int = -1):String {
			
			if (quility > -1) {
				
				return "<font color='" + getColorHtml(quility) + "'>" + str + "</font>";
			}
			else {
				
				return "<font color='" + color + "'>" + str + "</font>";
			}
		}
		
		//菊蓝色
		public static var CORNFLOWER_BLUE:uint = 0x6495ed;
		//淡蓝
		public static var LIGHT_BLUE:uint = 0xbaddfb;
		//天蓝色
		public static var SKY_BLUE:uint = 0x87CEEB;
		//艾利斯兰 蓝色
		public static var ALICEBLUE:uint = 0xF0F8FF;
		//金色
		public static var GOLD:uint = 0xfaf945;
		//亮黄色
		public static var FLUSH_YELLOW:uint = 0xecff1e;
		//桔黄色
		public static var BISQUE:uint = 0xffe4c4;
		//米色
		public static var RICE:uint = 0xffffee;
		//米色
		public static var BEIGE:uint = 0xF5F5DC;
		//古董白
		public static var ANTIQUE_WHITE:uint = 0xFAEBD7;
		//碧绿色
		public static var AQUAMARINE:uint = 0x7FFFD4;
		//白杏色
		public static var BLANCHE_DALMOND:uint = 0xffebcd;
		//紫罗兰色
		public static var BLUEVIOLET:uint = 0x8a2be2;
		//褐色
		public static var BROWN:uint = 0xa52a2a;
		//实木色
		public static var BURLYWOOD:uint = 0xdeb887;
		//军蓝色
		public static var CADET_BLUE:uint = 0x5f9ea0;
		//黄绿色
		public static var CHARTREUSE:uint = 0x7fff00;
		//巧克力色
		public static var CHOCOLATE:uint = 0xd2691e;
		//珊瑚色
		public static var CORAL:uint = 0xff7f50;
		//米绸色
		public static var CORNSILK:uint = 0xfff8dc;
		//暗红深色
		public static var CRIMSON:uint = 0xdc143c;
		//青色
		public static var CYAN_EXTRA:uint = 0x00ffff;
		//暗蓝
		public static var DARK_BLUE:uint = 0x00008b;
		//暗青
		public static var DARK_CYAN:uint = 0x008b8b;
		//暗金黄色
		public static var DARK_GOLDENROD:uint = 0xb8860b;
		//暗灰色
		public static var DARY_GRAY:uint = 0xa9a9a9;
		//暗绿色
		public static var DARK_GREEN:uint = 0x006400;
		//暗黄褐色
		public static var DARK_KHAKI:uint = 0xbdb76b;
		//暗洋红
		public static var DARK_MAGENTA:uint = 0x8b008b;
		//暗橄榄绿
		public static var DARK_OLIVEGREEN:uint = 0x556b2f;
		//暗桔黄色
		public static var DARK_ORANGE:uint = 0xff8c00;
		//暗紫色
		public static var DARK_ORCHID:uint = 0x9932cc;
		//暗红色
		public static var DRAK_RED:uint = 0x8b0000;
		//暗肉色
		public static var DARK_SALMON:uint = 0xe9967a;
		//暗海蓝色
		public static var DARK_SEAGREEN:uint = 0x8fbc8f;
		//暗灰蓝色
		public static var DARK_SLATEBLUE:uint = 0x483d8b;
		//墨绿色
		public static var DRAK_SLATEGRAY:uint = 0x2f4f4f;
		//暗宝石绿
		public static var DARK_TURGUOISE:uint = 0x00ced1;
		//暗紫罗兰
		public static var DRAK_VIOLET:uint = 0x9400d3;
		//深粉红色
		public static var DEEP_PINK:uint = 0xff1493;
		//深天蓝色
		public static var DEEP_SKYBLUE:uint = 0x00bfff;
		//暗灰色
		public static var DIM_GRAY:uint = 0x696969;
		//火砖色
		public static var FIREBRICK:uint = 0xb22222;
		//森林绿
		public static var FOREST_GREEN:uint = 0x228b22;
		//紫红色
		public static var FUCHSIA:uint = 0xff00ff;
		//深灰色
		public static var GAINSBORO:uint = 0xdcdcdc;
		//幽灵白
		public static var GHOST_WHITE:uint = 0xf8f8ff;
		//金色
		public static var GOLD_EXTRA:uint = 0xffd700;
		//金麒麟色
		public static var GOLDENROD:uint = 0xdaa520;
		//绿色
		public static var GREEN_EXTRA:uint = 0x008000;
		//黄绿色
		public static var GREEN_YELLOW:uint = 0xadff2f;
		//蜜色
		public static var HONEYDEW:uint = 0xf0fff0;
		//热粉红色
		public static var HOTPINK:uint = 0xff69b4;
		//印第安红
		public static var INDIANRED:uint = 0xcd5c5c;
		//浅紫色
		public static var LAVENDER:uint = 0xe6e6fa;
		//蓟色
		public static var THISTLE:uint = 0xd8bfd8;
		//灰石色
		public static var SLATE_GRAY:uint = 0x708090;
	}
}