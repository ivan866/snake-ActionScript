package {
	import com.greensock.TweenMax;
	import com.greensock.easing.Elastic;
	import flash.geom.Point;
	
	/**
	 * Snake character logic
	 * @author ivan866
	 */
	public class PlayerChar {
		
		private var XYArray:Array;
		public function PlayerChar(gameStage:GameStage) {
			var stageParams:Object = gameStage.getStageParams();
			XYArray = [[Math.floor(Math.random() * stageParams.cellXMax), Math.floor(Math.random() * stageParams.cellYMax)]];
			while (!gameStage.getStageShapeBitmap().bitmapData.hitTest(new Point(), 0, new Point(XYArray[0][0] * stageParams.cellSize, XYArray[0][1] * stageParams.cellSize))) {
				XYArray = [[Math.floor(Math.random() * stageParams.cellXMax), Math.floor(Math.random() * stageParams.cellYMax)]];
			}
			
			gameStage.setCellType(XYArray[0][0],XYArray[0][1],100);
		}
		
		
		public function move(gameStage:GameStage,callback:Function):void {
			for (var posI:uint = 0; posI < XYArray.length; posI++) {
				var stageParams:Object = gameStage.getStageParams();
				
				var cellX:uint = XYArray[posI][0];
				var cellY:uint = XYArray[posI][1];
				var cell:Object = gameStage.getCell(cellX, cellY);
				var nextCellX:uint = cellX + speedX;
				var nextCellY:uint = cellY + speedY;
				lastSpeedX = speedX;
				lastSpeedY = speedY;
				
				XYArray[posI][0] = nextCellX;
				XYArray[posI][1] = nextCellY;
				
				new TweenMax(cell.cell, 0.75, {x: nextCellX * stageParams.cellSize, y: nextCellY * stageParams.cellSize, ease: Elastic.easeInOut, onComplete: callback});
				gameStage.setCell(gameStage.exchangeCells(nextCellX, nextCellY, cellX, cellY), nextCellX, nextCellY);
				
				gameStage.addChildAt(cell.cell, gameStage.numChildren);
				//TODO addchildat once
				//TODO стенки столкновения
			}
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