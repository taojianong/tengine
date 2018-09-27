package com.manager {
	
	import com.geom.DMap;
	import com.inter.IRender;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * 动画渲染器
	 * @author cl 2014/8/14 13:09
	 */
	public class AnimationRenderManager {
		
		private var renderMap:DMap = new DMap();		
		private var fps:Number = 30;//动画渲染帧频 2014/8/14 12:56			
		private	var timer:Timer;
		
		public function put( render:IRender ):void {
			
			if ( renderMap.containsKey( render ) ) {
				return;
			}
			
			renderMap.put( render , render );
			
			if ( timer == null ) {				
				fps = 1 / fps * 1000;
				timer = new Timer( fps );
			}
			
			if ( !timer.hasEventListener( TimerEvent.TIMER ) ) {
				timer.addEventListener( TimerEvent.TIMER , renderHandler );
				timer.start();
			}
		}
		
		public function remove( render:IRender ):void {
			
			renderMap.remove( render );			
		}
		
		private var canRender:Boolean = true ; //是否可渲染
		
		private function renderHandler( event:TimerEvent ):void {
			
			if ( renderMap.keys <= 0 || !canRender ) {
				timer.stop();
				timer.removeEventListener( TimerEvent.TIMER , renderHandler );
				return;
			}
			
			canRender = false;
			for each( var r:* in renderMap.d ) {
				if ( r is IRender ) {
					IRender( r ).renderAnimation();
					canRender = true;
				}
			}
		}
		
		public function removeAll():void {
			
			renderMap.clear();
		}
		
		/**
		 * 是否暂停渲染
		 * */
		public function set isPause( value:Boolean ):void {
			
			canRender = !value;
		}
		
		private static var instance:AnimationRenderManager;
		public static function get Instance():AnimationRenderManager {
			
			return instance = instance || new AnimationRenderManager();
		}
	}

}