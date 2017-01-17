package {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	/**
	 * Game board with cells
	 * @author ivan866
	 */
	public class Board extends Sprite {
		public const type0Chars:Array = [" "];
		public const type1Chars:Array = type0Chars;
		public const type2Chars:Array = ["ə", "ə", "ɰ", "‡", "‡", "‡", "ᶲ", "ᵷ", "ᵵ", "ᵴ", "ђ", "Ƶ", "Ƶ"];
		public const type3Chars:Array = ["2", "2", "3", "5", "7", "7", "7", "8", "9", "9"];
		public const type4Chars:Array = ["s","ȵ","ɐ","Ɫ","r","i","x"];
		public const typeChars:Array = [type0Chars, type1Chars, type2Chars, type3Chars, type4Chars];
		
		public var charBitmaps:Array;
		public var charBitmapsLit:Array;
		
		private var params:Object;
		
		private var boardBorder:Shape;
		private var boardShape:Shape;
		private var boardBorderBitmap:Bitmap;
		private var boardShapeBitmap:Bitmap;
		public function Board(params:Object) {
			this.params = params;
			
			boardBorder = new Shape();
			boardShape = new Shape();
			boardBorderBitmap = new Bitmap(new BitmapData(1,1));
			boardShapeBitmap = new Bitmap(new BitmapData(1, 1));
			
			generateCharBitmaps();
			
			generateBoard();
		}
		
		
		private function generateCharBitmaps():void {
			var text:TextField = new TextField();
			text.text = type0Chars.join(" ") + "\n" + type1Chars.join(" ") + "\n" + type2Chars.join(" ") + "\n" + type3Chars.join(" ") + "\n" + type4Chars.join(" ");
			text.setTextFormat(new TextFormat("Courier New", 24, 0x5C985F, true));
			text.autoSize = TextFieldAutoSize.LEFT;
			
			var textLit:TextField = new TextField();
			textLit.text = text.text;
			textLit.setTextFormat(new TextFormat("Courier New", 24, 0xB9D0BB, true));
			textLit.autoSize = text.autoSize;
			
			var bitmap:Bitmap = new Bitmap(new BitmapData(text.width, text.height, true, 0xff0000));
			bitmap.bitmapData.draw(text);
			//bitmap.x=-100
			//addChild(bitmap)
			
			var bitmapLit:Bitmap = new Bitmap(new BitmapData(textLit.width, textLit.height, true, 0x000000));
			bitmapLit.bitmapData.draw(textLit);
			
			charBitmaps = [];
			charBitmapsLit = [];
			for (var typeI:uint = 0; typeI < typeChars.length; typeI++) {
				var chars:Array = typeChars[typeI];
				charBitmaps[typeI] = [];
				charBitmapsLit[typeI] = [];
				for (var charI:uint = 0; charI < chars.length; charI++) {
					var charBitmap:BitmapData = new BitmapData(44, 41, true, 0x000000);
					charBitmap.copyPixels(bitmap.bitmapData, new Rectangle(charI * 28, typeI * 28, 28, 28), new Point());
					charBitmaps[typeI][charI] = charBitmap;
					
					var charBitmapLit:BitmapData = new BitmapData(44, 41, true, 0x000000);
					charBitmapLit.copyPixels(bitmapLit.bitmapData, new Rectangle(charI * 28, typeI * 28, 28, 28), new Point());
					charBitmapsLit[typeI][charI] = charBitmapLit;
				}
			}
		}
		
		
		private var typesArray:Array;
		private var prizeNum:uint;
		public function generateBoard():void {
			generateShapes();
			
			boardBorderBitmap.bitmapData.dispose();
			boardBorderBitmap.bitmapData = new BitmapData(boardBorder.width, boardBorder.height, true, 0x000000);
			boardBorderBitmap.bitmapData.draw(boardBorder);
			
			boardShapeBitmap.bitmapData.dispose();
			boardShapeBitmap.bitmapData = new BitmapData(boardShape.width, boardShape.height, true, 0x000000);
			boardShapeBitmap.bitmapData.draw(boardShape);
			
			typesArray = [];
			prizeNum = 0;
			for (var cellX:uint = 0; cellX < params.xMax; cellX++) {
				typesArray[cellX] = [];
				for (var cellY:uint = 0; cellY < params.yMax; cellY++) {
					if (boardBorderBitmap.bitmapData.hitTest(new Point(), 0, new Point(cellX * params.size, cellY * params.size))) {
						typesArray[cellX][cellY] = 2;
					} else if (boardShapeBitmap.bitmapData.hitTest(new Point(), 0, new Point(cellX * params.size, cellY * params.size))) {
						typesArray[cellX][cellY] = 1;
					} else {
						typesArray[cellX][cellY] = 0;
					}
				}
			}
			while (prizeNum < 8) {
				cellX = Math.floor(Math.random() * params.xMax);
				cellY = Math.floor(Math.random() * params.yMax);
				if (typesArray[cellX][cellY] == 1) {
					typesArray[cellX][cellY] = 3;
					prizeNum++;
				}
			}
		}
		
		
		private function generateShapes(shapeCode:int = -1):void {
			if (shapeCode==-1) {
				shapeCode = Math.floor(Math.random() * 3);
			}
			
			boardBorder.graphics.clear();
			boardShape.graphics.clear();
			if (shapeCode == 0) {
				boardBorder.graphics.lineStyle(params.size);
				boardBorder.graphics.drawEllipse(params.size/2,params.size/2,params.xMax*params.size-params.size,params.yMax*params.size-params.size);
			
				boardShape.graphics.beginFill(0xFFFFFF);
				boardShape.graphics.drawEllipse(params.size/2,params.size/2,params.xMax*params.size-params.size,params.yMax*params.size-params.size);
				boardShape.graphics.endFill();
			} else if (shapeCode == 1) {
				boardBorder.graphics.lineStyle(params.size);
				boardBorder.graphics.moveTo(0,(params.yMax-1)*params.size);
				boardBorder.graphics.lineTo(params.xMax / 2 * params.size, 0);
				boardBorder.graphics.lineTo(params.xMax * params.size, (params.yMax-1) * params.size);
				boardBorder.graphics.lineTo(0,(params.yMax-1)*params.size);
			
				boardShape.graphics.beginFill(0xFFFFFF);
				boardShape.graphics.moveTo(0,(params.yMax-1)*params.size);
				boardShape.graphics.lineTo(params.xMax / 2 * params.size, 0);
				boardShape.graphics.lineTo(params.xMax * params.size, (params.yMax-1) * params.size);
				boardShape.graphics.lineTo(0,(params.yMax-1)*params.size);
				boardShape.graphics.endFill();
			} else if (shapeCode == 2) {
				boardBorder.graphics.lineStyle(params.size);
				boardBorder.graphics.drawRect(0,0,(params.xMax-1)*params.size,(params.yMax-1)*params.size);
				boardBorder.graphics.drawRect(params.xMax / 4*params.size, params.yMax / 4*params.size, (params.xMax-1) / 2*params.size, (params.yMax-1) / 2*params.size);
				
				boardShape.graphics.beginFill(0xFFFFFF);
				boardShape.graphics.drawRect(0,0,(params.xMax-1)*params.size,(params.yMax-1)*params.size);
				boardShape.graphics.drawRect(params.xMax / 4*params.size, params.yMax / 4*params.size, (params.xMax-1) / 2*params.size, (params.yMax-1) / 2*params.size);
				boardShape.graphics.endFill();
			}
		}
		
		
		private var cellsArray:Array;
		public function drawBoard(typeOnly:Boolean=false):void {
			if (!typeOnly) {
				cellsArray = [];
			}
			
			for (var cellX:uint = 0; cellX < params.xMax; cellX++) {
				if (!typeOnly) {
					cellsArray[cellX] = [];
				}
				for (var cellY:uint = 0; cellY < params.yMax; cellY++) {
					if (!typeOnly) {
						var cell:Cell = new Cell(this, typesArray[cellX][cellY]);
						setCell(cellX, cellY, cell);
						
						addChild(cell);
					} else {
						var cell:Cell = getCell(cellX, cellY);
						cell.setType(typesArray[cellX][cellY]);
					}
					
					cell.setXY(cellX * params.size, cellY * params.size);
				}
			}
		}
		
		
		private var rainStartTimer:Timer;
		private var rainTimerArray:Array;
		public function digitalRain():void {
			rainTimerArray = [];
			for (var i:int = 0; i < params.xMax; i++) {
				rainTimerArray[i] = new Timer(Math.random() * 250 + 250, params.yMax);
				rainTimerArray[i].addEventListener(TimerEvent.TIMER, rainHandler);
			}
			
			rainStartTimer = new Timer(1000, rainTimerArray.length);
			rainStartTimer.addEventListener(TimerEvent.TIMER, rainStartHandler);
			rainStartTimer.start();
		}
		private function rainStartHandler(e:TimerEvent):void {
			var timer:Timer = rainTimerArray[0];
			while (timer.running || timer.currentCount > 0) {
				timer = rainTimerArray[Math.floor(Math.random() * rainTimerArray.length)];
			}
			timer.start();
		}
		private function rainHandler(e:TimerEvent) {
			var i:uint = rainTimerArray.indexOf(e.target);
			getCell(i, e.target.currentCount - 1).setType(getCell(i, e.target.currentCount - 1).getType());
		}
		
		
		public function getBoardParams():Object {
			return params;
		}
		
		public function getBoardBorderBitmap():Bitmap {
			return boardBorderBitmap;
		}
		
		public function getBoardShapeBitmap():Bitmap {
			return boardShapeBitmap;
		}

		
		public function getCell(cellX:uint, cellY:uint):Cell {
			return cellsArray[cellX][cellY];
		}
		
		public function setCell(cellX:uint, cellY:uint, cell:Cell):void {
			cellsArray[cellX][cellY] = cell;
		}
		
		public function exchangeCells(cellX:uint, cellY:uint, newCellX:uint, newCellY:uint):Cell {
			var exchange:Cell = getCell(cellX,cellY);
			setCell(cellX, cellY, getCell(newCellX, newCellY));
			getCell(cellX, cellY).setXY(cellX * params.size, cellY * params.size);
			return exchange;
		}
		
		
		public function removePrize():void {
			prizeNum--;
		}
		
		public function hasPrize():Boolean {
			return prizeNum > 0;
		}
		
	
	}

}