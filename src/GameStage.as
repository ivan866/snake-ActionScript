package {
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author ivan866
	 */
	public class GameStage extends Sprite {
		
		private var _stageArray:Array;
		private var _cellXMax:uint;
		private var _cellYMax:uint;
		private var _cellSize:uint;
		private var _cellShake:uint;
		private var _gameGraphicsStyle:GameGraphicsStyle;
		private var _stageBorderBitmap:Bitmap;
		private var _stageShapeBitmap:Bitmap;
		
		public function GameStage(cellXMax:uint, cellYMax:uint, cellSize:uint, gameGraphicsStyle:GameGraphicsStyle) {
			_stageArray = [];
			_cellXMax = cellXMax;
			_cellYMax = cellYMax;
			_cellSize = cellSize;
			_gameGraphicsStyle = gameGraphicsStyle;
			
			var stageBorder:Sprite = new Sprite();
			stageBorder.graphics.lineStyle(cellSize);
			stageBorder.graphics.drawEllipse(cellSize / 2, cellSize / 2, cellXMax * cellSize - cellSize, cellYMax * cellSize - cellSize);
			_stageBorderBitmap = new Bitmap(new BitmapData(stageBorder.width, stageBorder.height, true, 0x000000));
			_stageBorderBitmap.bitmapData.draw(stageBorder);
			var stageShape:Sprite = new Sprite();
			stageShape.graphics.beginFill(0xFFFFFF);
			stageShape.graphics.drawEllipse(cellSize, cellSize, cellXMax * cellSize - cellSize * 2, cellYMax * cellSize - cellSize * 2);
			stageShape.graphics.endFill();
			_stageShapeBitmap = new Bitmap(new BitmapData(stageShape.width + 100, stageShape.height + 100, true, 0x000000));
			_stageShapeBitmap.bitmapData.draw(stageShape);
			for (var cellX:uint = 0; cellX < cellXMax; cellX++) {
				_stageArray[cellX] = [];
				for (var cellY:uint = 0; cellY < cellYMax; cellY++) {
					if (_stageBorderBitmap.bitmapData.hitTest(new Point(), 0, new Point(cellX * cellSize, cellY * cellSize))) {
						_stageArray[cellX][cellY] = {type: 1};
					} else if (_stageShapeBitmap.bitmapData.hitTest(new Point(), 0, new Point(cellX * cellSize, cellY * cellSize))) {
						_stageArray[cellX][cellY] = {type: 0};
						if (Math.floor(Math.random() * 50) == 2) {
							_stageArray[cellX][cellY] = {type: 2};
						}
					} else {
						_stageArray[cellX][cellY] = {type: -1};
					}
				}
			}
		}
		
		public function drawStage():void {
			for (var cellX:uint = 0; cellX < _cellXMax; cellX++) {
				for (var cellY:uint = 0; cellY < _cellYMax; cellY++) {
					var cell:StageCell = new StageCell(_stageArray[cellX][cellY].type, _cellSize, _gameGraphicsStyle);
					var cellShake:uint = _cellShake;
					cell.x = cellX * _cellSize;
					cell.y = cellY * _cellSize;
					_stageArray[cellX][cellY].cell = cell;
					var tween:TweenMax = new TweenMax(cell, Math.random() * 0.333 + 0.175, {x: cell.x + Math.random() * cellShake, y: cell.y + Math.random() * cellShake});
					tween.currentProgress = Math.random();
					tween.repeat = -1;
					tween.yoyo = true;
					_stageArray[cellX][cellY].tween = tween;
					this.addChild(cell);
				}
			}
		}
		
		public function getStageArray():Array {
			return _stageArray;
		}
		
		public function getStageShapeBitmap():Bitmap {
			return _stageShapeBitmap;
		}
		
		public function setAnimationParams(params:Object):void {
			_cellShake = params.cellShake;
		}
	
	}

}