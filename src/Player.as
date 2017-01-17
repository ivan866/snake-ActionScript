package {
	import flash.geom.Point;
	
	/**
	 * Snake character logic
	 * @author ivan866
	 */
	public class Player {
		
		private var board:Board;
		
		private var XYArray:Array;
		public function Player(board:Board) {
			this.board = board;
			
			generatePlayer();
		}
		
		
		public function generatePlayer():void {
			var boardParams:Object = board.getBoardParams();
			
			XYArray = [[Math.floor(Math.random() * boardParams.xMax), Math.floor(Math.random() * boardParams.yMax)]];
			while (!board.getBoardShapeBitmap().bitmapData.hitTest(new Point(), 0, new Point(XYArray[0][0] * boardParams.size, XYArray[0][1] * boardParams.size)) || board.getBoardBorderBitmap().bitmapData.hitTest(new Point(), 0, new Point(XYArray[0][0] * boardParams.size, XYArray[0][1] * boardParams.size))) {
				XYArray = [[Math.floor(Math.random() * boardParams.xMax), Math.floor(Math.random() * boardParams.yMax)]];
			}
			
			var playerCell:Cell = board.getCell(XYArray[0][0], XYArray[0][1]);
			playerCell.setType(4);
			
			board.addChildAt(playerCell, board.numChildren);
			
			reset();
		}
		
		
		public function move():void {
			for (var posI:uint = 0; posI < getLength(); posI++) {
				var boardParams:Object = board.getBoardParams();
				
				var cellX:uint = XYArray[posI][0];
				var cellY:uint = XYArray[posI][1];
				var cell:Cell = board.getCell(cellX, cellY);
				if (posI == 0) {
					var nextCellX:uint = cellX + speedX;
					var nextCellY:uint = cellY + speedY;
				} else {
					var nextCellX:uint = XYArray[posI-1][0];
					var nextCellY:uint = XYArray[posI-1][1];
				}
				var nextCell:Cell = board.getCell(nextCellX, nextCellY);
				
				lastSpeedX = speedX;
				lastSpeedY = speedY;
				
				if (nextCell.getType() == 1) {
					board.setCell(nextCellX, nextCellY, board.exchangeCells(cellX, cellY, nextCellX, nextCellY));
					board.getCell(nextCellX, nextCellY).setXY(nextCellX, nextCellY);
					
					if (posI == getLength() - 1) {
						moveCoords();
					}
				} else if (nextCell.getType() == 0 || nextCell.getType() == 1 || nextCell.getType() == 4) {
					stop();
					
					looser = true;
					
					break;
				} else if (nextCell.getType() == 3) {
					nextCell.setType(3);

					board.addChildAt(nextCell, board.numChildren);
					
					moveCoords(true);
					
					board.removePrize();
						
					if (!board.hasPrize()) {
						winner = true;
					}
				}
				
			}
		}
		
		
		public function moveCoords(grow:Boolean=false):void {
			XYArray.unshift([XYArray[0][0] + speedX, XYArray[0][1] + speedY]);
			
			if (!grow) {
				var lastCell:Array = XYArray.pop();
				
				board.getCell(lastCell[0], lastCell[1]).decreaseDelay();
			}
		}
		
		
		public function stop():void {
			setSpeed(0, 0);
			lastSpeedX = 0;
			lastSpeedY = 0;
		}
		
		public function reset():void {
			stop();
			
			winner = false;
			looser = false;
		}
		
		
		public var winner:Boolean;
		public function win():void {
			trace("winner")
		}
		
		
		public var looser:Boolean;
		public function lose():void {
			trace("looser")
		}

		
		private function getLength():uint {
			return XYArray.length;
		}
		
		
		private var speedX:int;
		private var speedY:int;
		private var lastSpeedX:int;
		private var lastSpeedY:int;
		public function getSpeed():Object {
			return {x:speedX, y:speedY};
		}
		
		public function getLastSpeed():Object {
			return {x:lastSpeedX, y:lastSpeedY};
		}
		
		public function setSpeed(speedX:int, speedY:int):void {
			this.speedX = speedX;
			this.speedY = speedY;
		}
	
	}

}