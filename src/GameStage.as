package {
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * Game board with cells
	 * @author ivan866
	 */
	public class GameStage extends Sprite {
		
		private var stageArray:Array;
		private var params:Object;
		private var gameGraphicsStyle:GameGraphicsStyle;
		private var stageBorderBitmap:Bitmap;
		private var stageShapeBitmap:Bitmap;
		private var prizeNum:uint;
		public function GameStage(params:Object) {
			this.params = params;
			
			var stageBorder:Sprite = new Sprite();
			stageBorder.graphics.lineStyle(params.cellSize);
			stageBorder.graphics.drawEllipse(params.cellSize / 2, params.cellSize / 2, params.cellXMax * params.cellSize - params.cellSize, params.cellYMax * params.cellSize - params.cellSize);
			stageBorderBitmap = new Bitmap(new BitmapData(stageBorder.width, stageBorder.height, true, 0x000000));
			stageBorderBitmap.bitmapData.draw(stageBorder);
			var stageShape:Sprite = new Sprite();
			stageShape.graphics.beginFill(0xFFFFFF);
			stageShape.graphics.drawEllipse(params.cellSize, params.cellSize, params.cellXMax * params.cellSize - params.cellSize * 2, params.cellYMax * params.cellSize - params.cellSize * 2);
			stageShape.graphics.endFill();
			stageShapeBitmap = new Bitmap(new BitmapData(stageShape.width + 100, stageShape.height + 100, true, 0x000000));
			stageShapeBitmap.bitmapData.draw(stageShape);
			
			stageArray = [];
			prizeNum = 0;
			for (var cellX:uint = 0; cellX < params.cellXMax; cellX++) {
				stageArray[cellX] = [];
				for (var cellY:uint = 0; cellY < params.cellYMax; cellY++) {
					if (stageBorderBitmap.bitmapData.hitTest(new Point(), 0, new Point(cellX * params.cellSize, cellY * params.cellSize))) {
						stageArray[cellX][cellY] = 1;
					} else if (stageShapeBitmap.bitmapData.hitTest(new Point(), 0, new Point(cellX * params.cellSize, cellY * params.cellSize))) {
						stageArray[cellX][cellY] = 0;
						if (Math.floor(Math.random() * 50) == 2) {
							stageArray[cellX][cellY] = 2;
							prizeNum++;
						}
					} else {
						stageArray[cellX][cellY] = -1;
					}
				}
			}
		}
		
		
		public function drawStage(gameGraphicsStyle:GameGraphicsStyle):void {
			this.gameGraphicsStyle = gameGraphicsStyle;
			for (var cellX:uint = 0; cellX < params.cellXMax; cellX++) {
				for (var cellY:uint = 0; cellY < params.cellYMax; cellY++) {
					var cell:StageCell = new StageCell(this, stageArray[cellX][cellY], gameGraphicsStyle);
					setCell(cellX, cellY, cell);
					cell.setXY(cellX * params.cellSize, cellY * params.cellSize);
					
					addChild(cell);
				}
			}
		}
		
		
		public function getStageParams():Object {
			return params;
		}
		
		public function getStageShapeBitmap():Bitmap {
			return stageShapeBitmap;
		}

		public function getCell(cellX:uint, cellY:uint):StageCell {
			return stageArray[cellX][cellY];
		}
		
		public function setCell(cellX:uint, cellY:uint, cell:StageCell):void {
			stageArray[cellX][cellY] = cell;
		}
		
		public function exchangeCells(cellX:uint, cellY:uint, newCellX:uint, newCellY:uint):StageCell {
			var exchange:StageCell = getCell(cellX,cellY);
			setCell(cellX, cellY, getCell(newCellX, newCellY));
			getCell(cellX, cellY).setXY(cellX * params.cellSize, cellY * params.cellSize);
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