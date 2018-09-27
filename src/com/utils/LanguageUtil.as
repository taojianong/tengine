package com.utils {
	import mx.resources.ResourceManager;
	
	/**
	 * 语言管理包 2012-12-22 16:29
	 * @author taojianlong
	 */
	public class LanguageUtil {
		
		public static const LANGUAGE:String = "cn";
		
		public static const LANG_CN:String = "WebLogic_zh_CN"; //中文
		
		/**
		 * <b>根据指定替换的文本资源</b>
		 * @param
		 * <b>subText</b> 资源束的名称<br/>
		 * <b>subList</b> 替换占位符的参数的数组。在替换每个参数之前都会使用 toString() 方法将其转换为字符串<br/>
		 **/
		public static function getWebLogicText(subText:String, subList:Array = null, language:String = LANG_CN):String {
			return ResourceManager.getInstance().getString(language, subText, subList);
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
	}

}