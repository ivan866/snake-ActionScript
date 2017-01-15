package {
	import flash.display.Sprite;
	
	/**
	 * Cell graphics
	 * @author ivan866
	 */
	public class StageCell extends Sprite {
		
		public function StageCell(type:int, stageParams:Object, gameGraphicsStyle:GameGraphicsStyle) {
			if (type == -1) {
				return;
			}
			graphics.lineStyle(gameGraphicsStyle.fgLineWidth, gameGraphicsStyle.fgColor);
			if (type == 1) {
				graphics.beginFill(0x404040);
			} else if (type == 0) {
				graphics.beginFill(gameGraphicsStyle.bgColor);
			} else if (type == 2) {
				graphics.beginFill(0xFFFF00);
			} else if (type == 100) {
				graphics.beginFill(0x80FFFF);
			}
			graphics.drawRect(0, 0, stageParams.cellSize, stageParams.cellSize);
			graphics.endFill();
			
			cacheAsBitmap = true;
		}
	
	}

}