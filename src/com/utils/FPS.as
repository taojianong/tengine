package com.utils {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getTimer;
	
	/**
	 * 帧频显示,包括内存显示 2012.11.11
	 * @author taojianlong
	 */
	public class FPS extends Sprite {
		
		private var fpsTxt:TextField; //显示帧频		
		private var memTxt:TextField; //显示内存
		private var timer:int = 0;
		private static const MAX_DELAY:int = 10; //最大延迟
		private var deley:int = 0;
		private var globalX:Number = 0;
		private var globalY:Number = 0;
		
		public static var instance:FPS;
		
		public function FPS(globalX:Number = 0, globalY:Number = 0) {
			this.globalX = globalX;
			this.globalY = globalY;
			
			this.mouseEnabled = false;
			this.mouseChildren = false;
			
			fpsTxt = this.createTextField();
			memTxt = this.createTextField();
			
			this.addChild(fpsTxt);
			this.addChild(memTxt);
			
			this.addEventListener(Event.ADDED_TO_STAGE, run);
		}
		
		private function run(event:Event):void {
			
			if (instance == null) {
				
				instance = this;
			}
			
			fpsTxt.text = "FPS: " + Number(stage.frameRate).toFixed(2);
			
			memTxt.text = "MEM: " + bytesToString(System.freeMemory) + "/" + bytesToString(System.totalMemory); //释放内存/总内存
			memTxt.y = fpsTxt.y + fpsTxt.height + 2;
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			stage.addEventListener(Event.RESIZE, onResize);
			onResize();
			timer = getTimer();
			
			this.addEventListener(Event.RESIZE, onResize);		
		}
		
		private function enterFrameHandler(event:Event):void {
			
			deley++;
			if (deley > MAX_DELAY) {
				
				deley = 0;
				fpsTxt.text = "FPS: " + Math.ceil(1000 * MAX_DELAY / (getTimer() - timer));
				timer = getTimer();
			}
			
			memTxt.text = "MEM: " + bytesToString(System.freeMemory) + "/" + bytesToString(System.totalMemory); //释放内存/总内存
			memTxt.y = fpsTxt.y + fpsTxt.height + 2;
		}
		
		//创建文本
		private function createTextField():TextField {
			
			var txt:TextField = new TextField;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.selectable = false;
			txt.textColor = 0xff0000;
			return txt;
		}
		
		private function onResize(event:Event = null):void {
			
			var _point:Point = this.parent.globalToLocal(new Point(this.globalX, this.globalY));
			
			this.x = _point.x;
			
			this.y = _point.y;
		}
		
		/**
		 * 字节数显示为对应内存数目
		 * @param	memory 内存数
		 * @return
		 */
		public static function bytesToString(memory:uint):String {
			var _str:String;
			
			if (memory < 1024) {
				_str = String(memory) + "b";
			} else if (memory < 10240) {
				_str = Number(memory / 1024).toFixed(2) + "kb";
			} else if (memory < 102400) {
				_str = Number(memory / 1024).toFixed(1) + "kb";
			} else if (memory < 1048576) {
				_str = int(memory / 1024) + "kb";
			} else if (memory < 10485760) {
				_str = Number(memory / 1048576).toFixed(2) + "mb";
			} else if (memory < 104857600) {
				_str = Number(memory / 1048576).toFixed(1) + "mb";
			} else {
				_str = int(memory / 1048576) + "mb";
			}
			
			return _str;
		}
	}

}