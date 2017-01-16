package {
	import com.greensock.TweenMax;
	import com.greensock.easing.Elastic;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	/**
	 * snatrix game - classic Snake with The Matrix flavour
	 * @author ivan866
	 */
	public class Main extends Sprite {
		
		private var gameStage:GameStage;
		private var playerChar:PlayerChar;
		private var moveTimer:Timer;
		public function Main() {
			stage.color = 0x400080;
			
			gameStage = new GameStage({cellXMax: 32, cellYMax: 24, cellSize: 16, cellShake: 5});
			gameStage.drawStage(new GameGraphicsStyle(5, 1, 0x400080, 0x00FF40));
			gameStage.x = stage.stageWidth / 2 - gameStage.width / 2;
			gameStage.y = stage.stageHeight / 2 - gameStage.height / 2;
			stage.addChild(gameStage);

			playerChar = new PlayerChar(gameStage);
			moveTimer = new Timer(100);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
		}
		
		
		private function keyHandler(e:KeyboardEvent):void {
			var speed:Object = playerChar.getLastSpeed();
			if (e.keyCode == 37 && speed.x != 1) {
				playerChar.setSpeed(-1,0);
			} else if (e.keyCode == 38 && speed.y != 1) {
				playerChar.setSpeed(0,-1);
			} else if (e.keyCode == 39 && speed.x != -1) {
				playerChar.setSpeed(1,0);
			} else if (e.keyCode == 40 && speed.y != -1) {
				playerChar.setSpeed(0,1);
			}
			
			if (!moveTimer.currentCount) {
				moveTimer.addEventListener(TimerEvent.TIMER, moveTimerHandler);
				moveTimer.start();
			}
		}
		
		
		private function moveTimerHandler(e:TimerEvent):void {
			moveTimer.stop();
			
			playerChar.move(moveCompleteHandler);
			
			function moveCompleteHandler():void {
				playerChar.setTremor();
				
				if (!gameStage.hasPrize()) {
					playerChar.win();
				} else {				
					moveTimer.start();
				}
			}
		}
	
	
	
	}

}