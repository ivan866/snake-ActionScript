package {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.utils.Timer;
	
	/**
	 * Cell graphics
	 * @author ivan866
	 */
	public class Cell extends Sprite {
		private var board:Board;
		
		private var type:int;
		
		private var bitmap:Bitmap;
		
		private var filterTimer:Timer;
		public function Cell(board:Board, type:int) {
			this.board = board;
			
			bitmap = new Bitmap();
			
			filterTimer = new Timer(500, 1);
			filterTimer.addEventListener(TimerEvent.TIMER, filterHandler);
			
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
		private var typeI:int =-1;
		public function setType(type:int, lit:Boolean = true):void {
			this.type = type;
			
			if (type == 0 && typeI == 0) {
				typeI = 2;
			} else {
				typeI = type;
			}
			charI = Math.floor(Math.random() * board.charBitmapsLit[typeI].length);
			if (lit) {
				bitmap.bitmapData = board.charBitmapsLit[typeI][charI].clone();
				bitmap.filters = [new GlowFilter(0xB9D0BB, 0.75, 12, 12)];
			
				filterTimer.start();
			} else {
				filterHandler();
			}
		}
		
		private function filterHandler(e:TimerEvent = null):void {
			filterTimer.reset();
			
			bitmap.bitmapData = board.charBitmaps[typeI][charI].clone();
			bitmap.filters = [new GlowFilter(0x5C985F, 0.75, 12, 12)];
		}
		
	
	}

}