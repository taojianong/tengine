package com.manager {
	
	import com.inter.IRender;
	import com.log.TLog;
	import com.geom.DMap;
	
	/**
	 * 渲染容器管理
	 * 一般为需要渲染的类,这样可以全局管理要渲染的类
	 * 作为管理类，一般只有一个，所以一般是单例的
	 * @author taojianlong 2014-1-12 16:25
	 */
	public class RenderManager {
		
		//加入继承Irender接口的类
		private var renderDMap:DMap = new DMap();
		
		public var isPause:Boolean = false; //释放暂停渲染
		
		public function RenderManager():void {
			
		}
		
		/**
		 * 渲染,在主文件刷新事件中初始化
		 */
		public function render():void {
			
			if ( isPause ) {
				return;
			}
			
			for each( var render:IRender in renderDMap.d ) {
				
				//如果不是暂停则渲染
				if ( !render.isPause ) {
					render.renderAnimation();
				}
			}
		}
		
		/**
		 * 开始渲染
		 */
		public function startRender():void {
			
			isPause = false;
		}
		
		/**
		 * 暂停渲染
		 */
		public function pauseRender():void {
			
			isPause = true;
		}
		
		/**
		 * 释放所有渲染
		 */
		public function disposeAllRender():void {
			
			renderDMap.clear();
			
			isPause = true;
		}
		
		/**
		 * 添加渲染对象
		 * @param render 继承自IRender的渲染对象
		 */
		public function add( render:IRender ):void {		
			
			if ( render == null ) {
				return;
			}
			
			if( !hasRender( render ) ) {
				renderDMap.put( render , render );
			}
			else {				
				TLog.addLog( "已经有该Render在渲染中!" , TLog.LOG_WARN );
			}
		}
		
		/**
		 * 移除渲染对象
		 * @param render 继承自IRender的渲染对象
		 */
		public function remove( render:IRender ):void {
			
			if ( render && renderDMap.containsKey( render ) ) {
				renderDMap.remove( render );
			}			
		}
		
		/**
		 * 获取某个渲染对象
		 * @param render 继承自IRender的渲染对象
		 * @return
		 */
		public function getRender( render:IRender ):IRender {
			
			return renderDMap.get( render ) as IRender;
		}
		
		/**
		 * 是否有某个渲染对象
		 * @param render 继承自IRender的渲染对象
		 * @return
		 */
		public function hasRender( render:IRender ):Boolean {
			
			return renderDMap.containsKey( render );
		}		
		
		//------------------------------------------------------
		
		private static var instance:RenderManager;
		
		public static function get Instance():RenderManager {
		
			return instance = instance || new RenderManager();
		}
	}

}