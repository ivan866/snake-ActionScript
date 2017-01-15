package {
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	
	/**
	 * Cell graphics
	 * @author ivan866
	 */
	public class StageCell extends Sprite {
		
		private var gameStage:GameStage;
		private var gameGraphicsStyle:GameGraphicsStyle;
		private var type:int;
		private var color:uint;
		private var tremor:TweenMax;
		public function StageCell(gameStage:GameStage, type:int, gameGraphicsStyle:GameGraphicsStyle) {
			
			this.gameStage = gameStage;
			this.gameGraphicsStyle = gameGraphicsStyle;

			setType(type);
			
			cacheAsBitmap = true;
		}
		
		public function setXY(x:Number, y:Number):void {
			if (tremor) {
				tremor.pause();
			}
			
			this.x = x;
			this.y = y;
			
			setTremor();
		}
		
		public function changeColor(color:uint):void {
			if (type == -1) {
				return;
			}
			
			var stageParams:Object = gameStage.getStageParams();
			graphics.lineStyle(gameGraphicsStyle.fgLineWidth, gameGraphicsStyle.fgColor);
			graphics.beginFill(color);
			graphics.drawRect(0, 0, stageParams.cellSize, stageParams.cellSize);
			graphics.endFill();
		}
		
		
		public function getType():int {
			return type;
		}
		
		public function setType(type:int):void {
			this.type = type;
			if (type == 1) {
				color=0x404040;
			} else if (type == 0) {
				color=gameGraphicsStyle.bgColor;
			} else if (type == 2) {
				color=0xFFFF00;
			} else if (type == 100) {
				color=0x80FFFF;
			}
			changeColor(color);
		}
		
		public function setTremor():void {
			var stageParams:Object = gameStage.getStageParams();
			tremor = new TweenMax(this, Math.random() * 0.333 + 0.175, {x: x + Math.random() * stageParams.cellShake, y: y + Math.random() * stageParams.cellShake});
			tremor.currentProgress = Math.random();
			tremor.repeat = -1;
			tremor.yoyo = true;
		}
		
	
	}

}