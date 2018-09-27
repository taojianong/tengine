package com.inter {
	
	/**
	 * 渲染管理文件类
	 * @author taojianlong 2014-1-12 16:22
	 */
	public interface IRender {
		
		//var isMult:Boolean;//是否可多个渲染
		//var isDispose:Boolean;//是否释放渲染
		
		function renderAnimation():void; //渲染		
		function stop():void; //停止渲染
		
		function set isPause(value:Boolean):void;//暂停渲染
		function get isPause():Boolean;
		
	}

}