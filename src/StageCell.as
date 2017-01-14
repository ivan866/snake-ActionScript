package {
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author ivan866
	 */
	public class StageCell extends Sprite {
		
		public function StageCell(type:int, cellSize:uint, gameGraphicsStyle:GameGraphicsStyle) {
			if (type == -1) {
				return;
			}
			this.graphics.lineStyle(gameGraphicsStyle.fgLineWidth, gameGraphicsStyle.fgColor);
			if (type == 1) {
				this.graphics.beginFill(0x404040);
			} else if (type == 0) {
				this.graphics.beginFill(gameGraphicsStyle.bgColor);
			} else if (type == 2) {
				this.graphics.beginFill(0xFFFF00);
			} else if (type == 100) {
				this.graphics.beginFill(0x80FFFF);
			}
			this.graphics.drawRect(0, 0, cellSize, cellSize);
			this.graphics.endFill();
			
			this.cacheAsBitmap = true;
		}
	
	}

}