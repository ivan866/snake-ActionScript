package {
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * snatrix game - classic Snake with The Matrix flavour
	 * @author ivan866
	 */
	public class Main extends Sprite {
		
		private var board:Board;
		private var player:Player;
		
		private var moveTimer:Timer;
		public function Main() {
			board = new Board({xMax: 24, yMax: 16, size: 32, delay: 2500});
			board.drawBoard();
			
			board.x = stage.stageWidth / 2 - board.width / 2;
			board.y = stage.stageHeight / 2 - board.height / 2;
			stage.addChild(board);
			
			stage.color = 0x000000;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
			
			player = new Player(board);
			
			moveTimer = new Timer(100);
		}
		
		
		private function newBoard():void {
			board.generateBoard();

			board.drawBoard(true);

			player.generatePlayer();

			moveTimer.reset();
		}
		
		
		private function keyHandler(e:KeyboardEvent):void {
			var speed:Object = player.getLastSpeed();
			if (e.keyCode == 37 && speed.x != 1) {
				player.setSpeed(-1,0);
			} else if (e.keyCode == 38 && speed.y != 1) {
				player.setSpeed(0,-1);
			} else if (e.keyCode == 39 && speed.x != -1) {
				player.setSpeed(1,0);
			} else if (e.keyCode == 40 && speed.y != -1) {
				player.setSpeed(0,1);
			}
			
			if (!moveTimer.currentCount) {
				moveTimer.addEventListener(TimerEvent.TIMER, moveTimerHandler);
				moveTimer.start();
			}
		}
		
		
		private function moveTimerHandler(e:TimerEvent):void {
			moveTimer.stop();
			
			player.move();
			
			if (player.winner) {
				player.win();
				newBoard();
			} else if (player.looser) {
				player.lose()
				newBoard();
			} else {
				moveTimer.start();
			}
		}
	
	
	
	}

}