package com.tloader.model {
	
	/**
	 * TLoader接口
	 * @author taojianlong 2014-6-3 21:21
	 */
	public interface ITLoader {
		
		function get sourceList():Vector.<TSource>; //资源列表
		function add( source:TSource ):void; //添加资源
		function addTSourceList( sourceList:Vector.<TSource> ):void;
		function remove( source:TSource ):void;
		function hasTSource( source:TSource ):Boolean;
		function load( complete:Function = null , params:Array = null ):void;
		function dispose():void;
		
	}

}