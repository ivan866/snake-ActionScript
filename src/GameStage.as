package {
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author ivan866
	 */
	public class GameStage extends Sprite {
		
		private var _stage:Stage;
		private var _stageArray:Array;
		private var _cellXMax:uint;
		private var _cellYMax:uint;
		private var _cellSize:uint;
		private var _cellShake:uint;
		private var _gameGraphicsStyle:GameGraphicsStyle;
		private var stageBorderBitmap:Bitmap;
		private var stageShapeBitmap:Bitmap;
		
		public function GameStage(cellXMax:uint, cellYMax:uint, cellSize:uint, gameGraphicsStyle:GameGraphicsStyle) {
			_stageArray = [];
			_cellXMax = cellXMax;
			_cellYMax = cellYMax;
			_cellSize = cellSize;
			_gameGraphicsStyle = gameGraphicsStyle;
			
			var stageBorder:Sprite = new Sprite();
			stageBorder.graphics.lineStyle(cellSize);
			stageBorder.graphics.drawEllipse(cellSize / 2, cellSize / 2, cellXMax * cellSize - cellSize, cellYMax * cellSize - cellSize);
			stageBorderBitmap = new Bitmap(new BitmapData(stageBorder.width, stageBorder.height, true, 0x000000));
			stageBorderBitmap.bitmapData.draw(stageBorder);
			var stageShape:Sprite = new Sprite();
			stageShape.graphics.beginFill(0xFFFFFF);
			stageShape.graphics.drawEllipse(cellSize, cellSize, cellXMax * cellSize - cellSize * 2, cellYMax * cellSize - cellSize * 2);
			stageShape.graphics.endFill();
			stageShapeBitmap = new Bitmap(new BitmapData(stageShape.width + 100, stageShape.height + 100, true, 0x000000));
			stageShapeBitmap.bitmapData.draw(stageShape);
			for (var cellX:uint = 0; cellX < cellXMax; cellX++) {
				_stageArray[cellX] = [];
				for (var cellY:uint = 0; cellY < cellYMax; cellY++) {
					if (stageBorderBitmap.bitmapData.hitTest(new Point(), 0, new Point(cellX * cellSize, cellY * cellSize))) {
						_stageArray[cellX][cellY] = {type: 1};
					} else if (stageShapeBitmap.bitmapData.hitTest(new Point(), 0, new Point(cellX * cellSize, cellY * cellSize))) {
						_stageArray[cellX][cellY] = {type: 0};
						if (Math.floor(Math.random() * 50) == 2) {
							_stageArray[cellX][cellY] = {type: 2};
						}
					} else {
						_stageArray[cellX][cellY] = {type: -1};
					}
				}
			}
			
			initChars();
		}
		
		private var _playerChar:Object;
		private function initChars():void {
			_playerChar = {};
			_playerChar.posArray = [[Math.floor(Math.random() * _cellXMax),Math.floor(Math.random() * _cellYMax)]];
			while (!stageShapeBitmap.bitmapData.hitTest(new Point(), 0, new Point(_playerChar.posArray[0][0]* _cellSize, _playerChar.posArray[0][1]* _cellSize))) {
				_playerChar.posArray = [[Math.floor(Math.random() * _cellXMax),Math.floor(Math.random() * _cellYMax)]];
			}
			_stageArray[_playerChar.posArray[0][0]][_playerChar.posArray[0][1]].type = 100;
			
		}
		
		private var _moveTimer:Timer;
		public function setAnimationParams(params:Object):void {
			_stage = params.stage;
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
			_moveTimer = new Timer(250);
			_moveTimer.addEventListener(TimerEvent.TIMER, moveTimerHandler);
			_cellShake = params.cellShake;
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
		
		private function keyHandler(e:KeyboardEvent):void {
			if (e.keyCode==37 && _playerChar.moveSpeedX!=1) {
				_playerChar.moveSpeedX = -1;
				_playerChar.moveSpeedY = 0;
			} else if (e.keyCode==38 && _playerChar.moveSpeedY!=1) {
				_playerChar.moveSpeedX = 0;
				_playerChar.moveSpeedY = -1;
			} else if (e.keyCode==39 && _playerChar.moveSpeedX!=-1) {
				_playerChar.moveSpeedX = 1;
				_playerChar.moveSpeedY = 0;
			} else if (e.keyCode==40 && _playerChar.moveSpeedY!=-1) {
				_playerChar.moveSpeedX = 0;
				_playerChar.moveSpeedY = 1;
			}
			_stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
			_moveTimer.start();
		}
		
		private function moveTimerHandler(e:TimerEvent):void {
			var playerX:uint = _playerChar.posArray[0][0];
			var playerY:uint = _playerChar.posArray[0][1];
			_stageArray[playerX][playerY].tween.pause();
			this.addChildAt(_stageArray[playerX][playerY].cell, this.numChildren);
			_stageArray[playerX][playerY].cell.x += _playerChar.moveSpeedX*_cellSize;
			_stageArray[playerX][playerY].cell.y += _playerChar.moveSpeedY * _cellSize;
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
		}
	
	}

}