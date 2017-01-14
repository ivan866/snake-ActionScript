package {
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ivan866
	 */
	public class Main extends Sprite {
		
		private var _cellSize:uint;
		private var _cellShake:uint;
		private var _gameStage:GameStage;
		
		public function Main() {
			this._cellSize = 16;
			this._cellShake = 5;
			this.stage.color = 0x400080;
			this._gameStage = new GameStage(32, 24, this._cellSize, new GameGraphicsStyle(5, 1, 0x400080, 0x00FF40));
			this._gameStage.setAnimationParams({stage:this.stage, cellShake: this._cellShake});
			this._gameStage.drawStage();
			
			this._gameStage.x = this.stage.stageWidth / 2 - this._gameStage.width / 2;
			this._gameStage.y = this.stage.stageHeight / 2 - this._gameStage.height / 2;
			this.stage.addChild(this._gameStage);
		}
		
	}
	
}