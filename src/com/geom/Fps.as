package com.geom {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	/**
	 * 程序运行时帧数、内存信息显示
	 * @author ｋａｋａ
	 */
	public class Fps {
		
		static private var _stats:Stats;
		static private var _target:Sprite;
		
		static public function setup(target:Sprite):void {
			
			_target = target;
			
			_stats = new Stats();
			_stats.y = 250;
			if (_target.stage != null) {
				
				start();
				
			} else {
				
				_target.addEventListener(Event.ADDED_TO_STAGE, start);
				
			}		
		}
		
		public static function toUp():void {
			
			if ( _target && _stats && _target.contains(  _stats ) ) {
				
				_target.setChildIndex( _stats , _target.numChildren - 1 );
			}
		}
		
		static public function set visible(value:Boolean):void {
			
			if (value) {
				_target.addChild(_stats);
			} else {
				if (_stats.parent != null)
					_stats.parent.removeChild(_stats);
			}		
		}
		
		static public function get visible():Boolean {
			
			return _target.contains(_stats);		
		}
		
		static private function start(evt:Event = null):void {
			
			_target.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownHandler);		
		}
		
		static private function onKeyDownHandler(evt:KeyboardEvent):void {
			
			if (evt.shiftKey && evt.keyCode == 68) {
				
				visible = !visible;				
			}		
		}			
	}
}