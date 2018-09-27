package com {
	
	import com.geom.Fps;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	/**
	 * 主函数
	 * @author cl 2014/8/2 11:32
	 */
	public class BaseMain extends Sprite {		
		
		private var _bMoniter:Boolean;
		
		/**
		 * FPS显示在最上层
		 */
		public function fpsTop():void {
			
			if ( _bMoniter ) {
				Fps.toUp();
			}
		}
		
		protected var _bRightClick:Boolean;
		
		/**
		 * IObitMain
		 * @param	bMoniter 	是否监控当前状态
		 * @param	bGridView	是否显示网格
		 * @param	gridSize	网格大小
		 */
		public function BaseMain( bMoniter:Boolean = false  ):void {
			
			_bMoniter = bMoniter;			
			
			if ( stage ) {
				
				init();
				
			} else {
				
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		protected function init( e:Event = null ):void {
			
			removeEventListener( Event.ADDED_TO_STAGE , init );
			
			//stage.showDefaultContextMenu = false;
			
			stage.scaleMode = "noScale";
			
			if ( _bMoniter ) {
				
				Fps.setup(this);
				Fps.visible = true;
			}
			
			this.initEvt();
		}
		
		/**
		 * 初始化
		 */
		public function initEvt():void {
			
			stage.addEventListener( "enterFrame", handleGameLoop );	
			stage.addEventListener( "click", handleOnClick );
			stage.addEventListener( "rightClick" , rightClickHandler );
			//stage.addEventListener( "mouseMove", handleMouseMove );
			//stage.addEventListener( "mouseDown", handleMouseDown );
			//stage.addEventListener( "mouseUp", handleMouseUp );
			stage.addEventListener( "keyDown", handleKeyDown );
			stage.addEventListener( "keyUp", handleKeyUp );
			//stage.addEventListener( "activate", handleActive );
			//stage.addEventListener( "deactivate", handleDeActivate );
			stage.addEventListener( "resize" , handleResize );
		}
		
		//右击
		protected function rightClickHandler( event:MouseEvent ):void { };
		
		/**
		 * 游戏主循环
		 * @param	e
		 */
		protected function handleGameLoop( e:Event ):void {	}
		
		protected function handleOnClick( mouseEvt:MouseEvent ):void {	}
		
		protected function handleMouseMove( mouseEvt:MouseEvent ):void {}
		
		protected function handleDeActivate( evt:Event ):void {	}
		
		protected function handleActive( evt:Event ):void {}
		
		/**自动适应屏幕**/
		protected function handleResize( event:Event ):void {}
		
		protected function handleMouseDown( event:MouseEvent ):void {
			
			_bRightClick = !_bRightClick;
		}
		
		protected function handleMouseUp( event:MouseEvent ):void {
			
			_bRightClick = !_bRightClick;			
		}
		
		/**键盘按下**/
		protected function handleKeyDown( event:KeyboardEvent):void {}
		
		/*键盘弹起*/
		protected function handleKeyUp( event:KeyboardEvent):void {	}		
		
		//-------------------------------------------------------
		
		/**
		 * 添加元件
		 *
		 * @param	element  添加元件
		 * @param	parent   容器
		 */
		public function addElement( element:DisplayObject ):DisplayObject {
			
			if ( element && !this.contains(element) ) {
				
				return this.addChild( element );
			}
			return null;
		}
		
		/**
		 * 移除元件
		 *
		 * @param	element 移除元件
		 * @param	parent  父容器
		 */
		public function removeElement( element:DisplayObject ):DisplayObject {
			
			if ( element && this.contains( element ) ) {
				
				return this.removeChild( element );
			}
			return null;
		}
	}
}