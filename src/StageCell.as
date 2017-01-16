package {
	import com.greensock.TweenMax;
	import com.greensock.easing.Elastic;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	/**
	 * Cell graphics
	 * @author ivan866
	 */
	public class StageCell extends Sprite {
		
		public static var wallColor:uint = 0x404040;
		public static var prizeColor:uint = 0xFFFF00;
		public static var playerCharColor:uint = 0x80FFFF;
		
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
		
		//TODO head glasses
		
		public function setXY(x:Number, y:Number):void {
			if (tremor) {
				tremor.pause();
			}
			
			this.x = x;
			this.y = y;
			
			setTremor();
		}
		
		public function setTremor():void {
			var stageParams:Object = gameStage.getStageParams();
			tremor = new TweenMax(this, Math.random() * 0.333 + 0.175, {x: x + Math.random() * stageParams.cellShake, y: y + Math.random() * stageParams.cellShake});
			tremor.currentProgress = Math.random();
			tremor.repeat = -1;
			tremor.yoyo = true;
		}
		
		
		public function getType():int {
			return type;
		}
		
		public function setType(type:int):void {
			this.type = type;
			changeColor(getColorByType(type));
		}
		
		public function tweenType(type:int,delay:Number,callback:Function):void {
			tweenColor(getColorByType(type), delay,tweenCompleteHandler)
			function tweenCompleteHandler():void {
				setType(type)
				callback();
			}
		}
		
		
		private var borderShape:Shape;
		private var colorShape:Shape;
		private function changeColor(color:uint):void {
			if (type == -1) {
				visible = false;
				return;
			}
			
			var stageParams:Object = gameStage.getStageParams();
			colorShape = new Shape();
			addChild(colorShape);
			colorShape.graphics.beginFill(color);
			colorShape.graphics.drawRect(0, 0, stageParams.cellSize, stageParams.cellSize);
			colorShape.graphics.endFill();
			
			borderShape = new Shape();
			addChild(borderShape);
			borderShape.graphics.lineStyle(gameGraphicsStyle.fgLineWidth, gameGraphicsStyle.fgColor);
			borderShape.graphics.drawRect(0, 0, stageParams.cellSize, stageParams.cellSize);

			visible = true;
		}
		
		private function tweenColor(color:uint,delay:Number,callback:Function):void {
			new TweenMax(colorShape, 0.5, {ease: Elastic.easeInOut, delay:delay,tint: color,onComplete:callback});
		}
		
		private function getColorByType(type:int):uint {
			var color:uint;
			if (type == 0 || type==-1) {
				color=gameGraphicsStyle.bgColor;
			} else if (type == 1) {
				color=wallColor;
			} else if (type == 2) {
				color=prizeColor;
			} else if (type == 100) {
				color=playerCharColor;
			}
			return color;
		}
		
		
	
	}

}