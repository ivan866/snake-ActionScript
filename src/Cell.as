package {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * Cell graphics
	 * @author ivan866
	 */
	public class Cell extends Sprite {
		private var board:Board;
		
		private var typeI:uint;
		private var typeIToggle:Boolean = true;
		private var typeIArray:Array = [0, 2];
		private var type:int;
		
		private var bitmap:Bitmap;
		
		private var litTimer:Timer;
		private var blinkTimer:Timer;
		public function Cell(board:Board, type:int) {
			this.board = board;
			
			bitmap = new Bitmap();
			
			litTimer = new Timer(500, 1);
			litTimer.addEventListener(TimerEvent.TIMER, litHandler);
			blinkTimer = new Timer(0);
			blinkTimer.addEventListener(TimerEvent.TIMER, blinkHandler);
			
			addChild(bitmap);
			
			setType(type);
		}
		
		
		public function setXY(x:Number, y:Number):void {
			this.x = x;
			this.y = y;
		}
		
		
		public function getType():int {
			return type;
		}
		
		
		private var charI:uint;
		public function setType(type:int = -1, lit:Boolean = true):void {
			if (type != -1) {
				this.type = type;
			}
			
			typeI = this.type;
			if (this.type == 0) {
				typeIToggle = !typeIToggle;
				typeI = typeIArray[uint(typeIToggle)];
			}
			
			charI = Math.floor(Math.random() * board.charBitmapsLit[typeI].length);
			if (lit) {
				bitmap.bitmapData = board.charBitmapsLit[typeI][charI].clone();
			
				litTimer.start();
			} else {
				litHandler();
			}
			
			if (this.type == 2 || this.type == 3) {
				blinkTimer.start();
			} else {
				blinkTimer.stop();
			}
		}
		
		private function litHandler(e:TimerEvent = null):void {
			litTimer.reset();
			
			bitmap.bitmapData = board.charBitmaps[typeI][charI].clone();
		}
		private function blinkHandler(e:TimerEvent = null):void {
			blinkTimer.delay = Math.random() * 500 + 500;
			
			setType();
		}
		
	
	}

}