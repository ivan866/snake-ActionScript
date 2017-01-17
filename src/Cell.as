package {
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	/**
	 * Cell graphics
	 * @author ivan866
	 */
	public class Cell extends Sprite {
		public static const type0Chars:Array = ["", "", "", "", "", "", ""];
		public static const type1Chars:Array = [".", "-", "'", "`"];
		public static const type2Chars:Array = ["1", "0"];
		public static const type3Chars:Array = ["û", "À", "ö", "ȵ", "Ɂ", "ɐ", "ə", "ɰ", "ʁ", "ʭ"];
		public static const type4Chars:Array = ["2", "3", "4", "5", "6", "7", "8", "9"];
		public static const typeChars:Array = [type0Chars, type1Chars, type2Chars, type3Chars, type4Chars];
		
		private var board:Board;
		
		private var delayTimer:Timer;
		private var minDelay:uint;
		
		private var type:int;
		
		private var text:TextField;
		private const textFormat:TextFormat = new TextFormat("Arial", 30, 0x008000);
		public function Cell(board:Board, type:int) {
			this.board = board;
			
			delayTimer = new Timer(board.getBoardParams().delay, 1);
			delayTimer.addEventListener(TimerEvent.TIMER, delayHandler);
			
			text = new TextField();
			text.selectable = false;
			text.filters = [new GlowFilter(0x008000, 0.75, 12, 12)];
			text.cacheAsBitmap = true;
			addChild(text);

			setType(type);
			
			cacheAsBitmap = true;
		}
		
		
		public function setXY(x:Number, y:Number):void {
			this.x = x;
			this.y = y;
		}
		
		
		public function getType():int {
			return type;
		}
		
		public function setType(type:int):void {
			this.type = type;
			
			delayTimer.start();
		}
		
		private function delayHandler(e:TimerEvent):void {
			text.text =	typeChars[type][Math.floor(Math.random() * Cell.typeChars[type].length)];
			text.setTextFormat(textFormat);
			
			minDelay = 4-type * 1000 + 250;
			delayTimer.delay = Math.random() * delayTimer.delay + minDelay;
		}
		
		
		public function setDelay(delay:uint):void {
			delayTimer.delay = delay;
		}
		
		public function decreaseDelay():void {
			if (delayTimer.delay >= minDelay) {
				delayTimer.delay -= 500;
			} else {
				delayTimer.delay = minDelay-500;
			}
		}
		
	
	}

}