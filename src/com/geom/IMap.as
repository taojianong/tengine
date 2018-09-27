package com.geom
{
	public interface IMap
	{
		/**
		 * 添加键值对
		 * */
		function put(key:Object,value:Object):void;
		
		/**
		 * 判断键值对是否存在
		 * */
		function containsKey(key:Object):Boolean;
		
		/**
		 * 根据键获得值 如果没有这个键 则返回NULL
		 * */
		function get(key:Object):*;
		
		/**
		 * 根据键移除整个键值对  如果没有这个键则什么都不做
		 * */
		function remove(key:Object):void;
		
		/**
		 * 清除所有键值对
		 * */
		function clear():void;
		
		
	}
}