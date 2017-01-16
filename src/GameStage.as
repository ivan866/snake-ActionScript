package {
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
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
			
			var stageShapes:Array = generateShapes();
			var stageBorder:Shape = stageShapes[0];
			var stageShape:Shape = stageShapes[1];
			
			stageBorderBitmap = new Bitmap(new BitmapData(stageBorder.width, stageBorder.height, true, 0x000000));
			stageBorderBitmap.bitmapData.draw(stageBorder);
			
			stageShapeBitmap = new Bitmap(new BitmapData(stageShape.width, stageShape.height, true, 0x000000));
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
		
		private function generateShapes(shapeCode:int = -1):Array {
			if (shapeCode==-1) {
				shapeCode = Math.floor(Math.random() * 3);
			}
			var stageBorder:Shape = new Shape();
			var stageShape:Shape = new Shape();
			if (shapeCode == 0) {
				stageBorder.graphics.lineStyle(params.cellSize);
				stageBorder.graphics.drawEllipse(params.cellSize/2,params.cellSize/2,params.cellXMax*params.cellSize-params.cellSize,params.cellYMax*params.cellSize-params.cellSize);
			
				stageShape.graphics.beginFill(0xFFFFFF);
				stageShape.graphics.drawEllipse(params.cellSize/2,params.cellSize/2,params.cellXMax*params.cellSize-params.cellSize,params.cellYMax*params.cellSize-params.cellSize);
				stageShape.graphics.endFill();
			} else if (shapeCode == 1) {
				stageBorder.graphics.lineStyle(params.cellSize);
				stageBorder.graphics.moveTo(0,(params.cellYMax-1)*params.cellSize);
				stageBorder.graphics.lineTo(params.cellXMax / 2 * params.cellSize, 0);
				stageBorder.graphics.lineTo(params.cellXMax * params.cellSize, (params.cellYMax-1) * params.cellSize);
				stageBorder.graphics.lineTo(0,(params.cellYMax-1)*params.cellSize);
			
				stageShape.graphics.beginFill(0xFFFFFF);
				stageShape.graphics.moveTo(0,(params.cellYMax-1)*params.cellSize);
				stageShape.graphics.lineTo(params.cellXMax / 2 * params.cellSize, 0);
				stageShape.graphics.lineTo(params.cellXMax * params.cellSize, (params.cellYMax-1) * params.cellSize);
				stageShape.graphics.lineTo(0,(params.cellYMax-1)*params.cellSize);
				stageShape.graphics.endFill();
			} else if (shapeCode == 2) {
				stageBorder.graphics.lineStyle(params.cellSize);
				stageBorder.graphics.drawRect(0,0,(params.cellXMax-1)*params.cellSize,(params.cellYMax-1)*params.cellSize);
				stageBorder.graphics.drawRect(params.cellXMax / 4*params.cellSize, params.cellYMax / 4*params.cellSize, (params.cellXMax-1) / 2*params.cellSize, (params.cellYMax-1) / 2*params.cellSize);
				
				stageShape.graphics.beginFill(0xFFFFFF);
				stageShape.graphics.drawRect(0,0,(params.cellXMax-1)*params.cellSize,(params.cellYMax-1)*params.cellSize);
				stageShape.graphics.drawRect(params.cellXMax / 4*params.cellSize, params.cellYMax / 4*params.cellSize, (params.cellXMax-1) / 2*params.cellSize, (params.cellYMax-1) / 2*params.cellSize);
				stageShape.graphics.endFill();
			}
			
			return [stageBorder,stageShape];
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