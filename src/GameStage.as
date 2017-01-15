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
			for (var cellX:uint = 0; cellX < params.cellXMax; cellX++) {
				stageArray[cellX] = [];
				for (var cellY:uint = 0; cellY < params.cellYMax; cellY++) {
					stageArray[cellX][cellY] = {};
					if (stageBorderBitmap.bitmapData.hitTest(new Point(), 0, new Point(cellX * params.cellSize, cellY * params.cellSize))) {
						setCellType(cellX,cellY,1);
					} else if (stageShapeBitmap.bitmapData.hitTest(new Point(), 0, new Point(cellX * params.cellSize, cellY * params.cellSize))) {
						setCellType(cellX,cellY,0);
						if (Math.floor(Math.random() * 50) == 2) {
							setCellType(cellX,cellY,2);
						}
					} else {
						setCellType(cellX,cellY,-1);
					}
				}
			}
		}
		
		
		public function drawStage(gameGraphicsStyle:GameGraphicsStyle):void {
			this.gameGraphicsStyle = gameGraphicsStyle;
			for (var cellX:uint = 0; cellX < params.cellXMax; cellX++) {
				for (var cellY:uint = 0; cellY < params.cellYMax; cellY++) {
					var cell:StageCell = new StageCell(stageArray[cellX][cellY].type, params, gameGraphicsStyle);
					setCellObj(cellX, cellY, cell);
					setCellXY(cellX, cellY, cellX * params.cellSize, cellY * params.cellSize);
					
					addChild(cell);
				}
			}
		}
		
		
		public function getCell(cellX:uint, cellY:uint):Object {
			return stageArray[cellX][cellY];
		}
		
		public function getStageParams():Object {
			return params;
		}
		
		public function getStageShapeBitmap():Bitmap {
			return stageShapeBitmap;
		}

		
		
		public function setCell(cell:Object, cellX:uint, cellY:uint):void {
			stageArray[cellX][cellY] = cell;
		}
		
		public function setCellXY(cellX:uint, cellY:uint, x:Number, y:Number):void {
			var cell:Object = getCell(cellX, cellY);
			try {
				cell.tween.pause();
			} catch (err:Error)	{
				
			}
			cell.cell.x = x;
			cell.cell.y = y;
			
			setCellTremor(cellX,cellY);
		}
		
		public function setCellObj(cellX:uint, cellY:uint, cell:StageCell):void {
			stageArray[cellX][cellY].cell = cell;
		}
		
		public function setCellType(cellX:uint, cellY:uint, type:int):void {
			stageArray[cellX][cellY].type = type;
		}
		
		public function setCellTremor(cellX:uint, cellY:uint):void {
			var cell:Object = getCell(cellX, cellY);
			var tween:TweenMax = new TweenMax(cell.cell, Math.random() * 0.333 + 0.175, {x: cell.cell.x + Math.random() * params.cellShake, y: cell.cell.y + Math.random() * params.cellShake});
			tween.currentProgress = Math.random();
			tween.repeat = -1;
			tween.yoyo = true;
			stageArray[cellX][cellY].tween = tween;
		}
		
		public function exchangeCells(cellX:uint, cellY:uint, newCellX:uint, newCellY:uint):Object {
			var exchange:Object = stageArray[newCellX][newCellY];
			setCell(stageArray[cellX][cellY], newCellX, newCellY);
			setCellXY(newCellX, newCellY, newCellX * params.cellSize, newCellY * params.cellSize);
			return exchange;
		}
	
	}

}