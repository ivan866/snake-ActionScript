package {
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author ivan866
	 */
	public class Main extends Sprite {
		
		private var _cellXMax:uint;
		private var _cellYMax:uint;
		private var _cellSize:uint;
		private var _cellShake:uint;
		private var _gameStage:GameStage;
		private var _moveTimer:Timer;
		
		public function Main() {
			_cellXMax  = 32;
			_cellYMax = 24;
			_cellSize = 16;
			_cellShake = 5;
			stage.color = 0x400080;
			_gameStage = new GameStage(_cellXMax, _cellYMax, _cellSize, new GameGraphicsStyle(5, 1, 0x400080, 0x00FF40));
			initChars({stageShapeBitmap:_gameStage.getStageShapeBitmap()});
			_gameStage.setAnimationParams({cellShake: this._cellShake});
			_gameStage.drawStage();
			
			
			_gameStage.x = stage.stageWidth / 2 - _gameStage.width / 2;
			_gameStage.y = stage.stageHeight / 2 - _gameStage.height / 2;
			stage.addChild(this._gameStage);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
			_moveTimer = new Timer(250);
			_moveTimer.addEventListener(TimerEvent.TIMER, moveTimerHandler);
		}
		
		private var _playerChar:Object;
		private function initChars(params:Object):void {
			_playerChar = {};
			_playerChar.posArray = [[Math.floor(Math.random() * _cellXMax),Math.floor(Math.random() * _cellYMax)]];
			while (!params.stageShapeBitmap.bitmapData.hitTest(new Point(), 0, new Point(_playerChar.posArray[0][0]* _cellSize, _playerChar.posArray[0][1]* _cellSize))) {
				_playerChar.posArray = [[Math.floor(Math.random() * _cellXMax),Math.floor(Math.random() * _cellYMax)]];
			}
			var stageArray:Array = _gameStage.getStageArray();
			stageArray[_playerChar.posArray[0][0]][_playerChar.posArray[0][1]].type = 100;
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
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
			_moveTimer.start();
		}
		
		private function moveTimerHandler(e:TimerEvent):void {
			for (var i:int = 0; i < ; i++) {
				
			}
			var playerX:uint = _playerChar.posArray[0][0];
			var playerY:uint = _playerChar.posArray[0][1];
			var stageArray:Array = _gameStage.getStageArray();
			stageArray[playerX][playerY].tween.pause();
			_gameStage.addChildAt(stageArray[playerX][playerY].cell, _gameStage.numChildren);
			stageArray[playerX][playerY].cell.x += _playerChar.moveSpeedX * _cellSize;
			stageArray[playerX][playerY].cell.y += _playerChar.moveSpeedY * _cellSize;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
		}
		
			
		
	}
	
}