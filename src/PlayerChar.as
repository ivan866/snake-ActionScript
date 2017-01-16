package {
	import com.greensock.TweenMax;
	import com.greensock.easing.Elastic;
	import flash.geom.Point;
	
	/**
	 * Snake character logic
	 * @author ivan866
	 */
	public class PlayerChar {
		
		private var gameStage:GameStage;
		private var XYArray:Array;
		public function PlayerChar(gameStage:GameStage) {
			this.gameStage = gameStage;
			var stageParams:Object = gameStage.getStageParams();
			XYArray = [[Math.floor(Math.random() * stageParams.cellXMax), Math.floor(Math.random() * stageParams.cellYMax)]];
			while (!gameStage.getStageShapeBitmap().bitmapData.hitTest(new Point(), 0, new Point(XYArray[0][0] * stageParams.cellSize, XYArray[0][1] * stageParams.cellSize))) {
				XYArray = [[Math.floor(Math.random() * stageParams.cellXMax), Math.floor(Math.random() * stageParams.cellYMax)]];
			}
			
			gameStage.getCell(XYArray[0][0],XYArray[0][1]).setType(100);
		}
		
		
		public function move(callback:Function):void {
			for (var posI:uint = 0; posI < getLength(); posI++) {
				var stageParams:Object = gameStage.getStageParams();
				
				var cellX:uint = XYArray[posI][0];
				var cellY:uint = XYArray[posI][1];
				var cell:StageCell = gameStage.getCell(cellX, cellY);
				if (posI == 0) {
					var nextCellX:uint = cellX + speedX;
					var nextCellY:uint = cellY + speedY;
				} else {
					var nextCellX:uint = XYArray[posI-1][0];
					var nextCellY:uint = XYArray[posI-1][1];
				}
				var nextCell:StageCell = gameStage.getCell(nextCellX, nextCellY);
				
				lastSpeedX = speedX;
				lastSpeedY = speedY;
				
				//TODO addchildat once
				gameStage.addChildAt(cell, gameStage.numChildren);

				if (nextCell.getType() == 0) {
					var tween:TweenMax = new TweenMax(cell, 0.5, {x: nextCellX * stageParams.cellSize, y: nextCellY * stageParams.cellSize, delay:0.25/getLength()*posI,ease: Elastic.easeInOut});
					
					gameStage.setCell(nextCellX, nextCellY, gameStage.exchangeCells(cellX, cellY, nextCellX, nextCellY));
					
					if (posI == getLength() - 1) {
						tween.vars.onComplete = callback;
						
						moveCoords();
					}
				} else if (nextCell.getType() == 1 || nextCell.getType() == 100 || nextCell.getType() == -1) {
					lose();
					
					break;
				} else if (nextCell.getType() == 2) {
					nextCell.tweenType(100, 0,tweenCompleteHandler);
					
					moveCoords(true);
					
					break;
					
					function tweenCompleteHandler():void {
						gameStage.removePrize();
						
						callback();
					}
				}
				
			}
		}
		
		public function moveCoords(grow:Boolean=false):void {
			XYArray.unshift([XYArray[0][0] + speedX, XYArray[0][1] + speedY]);
			if (!grow) {
				var lastCell:Array = XYArray.pop();
				
				gameStage.getCell(lastCell[0], lastCell[1]).setType( -1);
			}
		}
		
		public function setTremor():void {
			for (var posI:uint = 0; posI < getLength(); posI++) {
				gameStage.getCell(XYArray[posI][0], XYArray[posI][1]).setTremor();
			}
		}
		
		public function win():void {
			for (var posI:uint = 0; posI < getLength(); posI++) {
				gameStage.getCell(XYArray[posI][0], XYArray[posI][1]).tweenType(-1, 0.1*posI,tweenCompleteHandler);
			}
			
			function tweenCompleteHandler():void {
				if (posI==getLength()-1) {
					setTremor();
				}
			}
		}
		
		public function lose():void {
			for (var posI:uint = 0; posI < getLength(); posI++) {
				gameStage.getCell(XYArray[posI][0], XYArray[posI][1]).tweenType(1, 0.1*posI,tweenCompleteHandler);
			}
			
			function tweenCompleteHandler():void {
				if (posI==getLength()-1) {
					setTremor();
				}
			}
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