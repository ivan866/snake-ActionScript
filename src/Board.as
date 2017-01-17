package {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * Game board with cells
	 * @author ivan866
	 */
	public class Board extends Sprite {
		private var params:Object;
		
		private var boardBorder:Shape;
		private var boardShape:Shape;
		private var boardBorderBitmap:Bitmap;
		private var boardShapeBitmap:Bitmap;
		public function Board(params:Object) {
			this.params = params;
			
			boardBorder = new Shape();
			boardShape = new Shape();
			boardBorderBitmap = new Bitmap(new BitmapData(1,1));
			boardShapeBitmap = new Bitmap(new BitmapData(1,1));
			
			generateBoard();
		}
		
		
		private var typesArray:Array;
		private var prizeNum:uint;
		public function generateBoard():void {
			generateShapes();
			
			boardBorderBitmap.bitmapData.dispose();
			boardBorderBitmap.bitmapData = new BitmapData(boardBorder.width, boardBorder.height, true, 0x000000);
			boardBorderBitmap.bitmapData.draw(boardBorder);
			
			boardShapeBitmap.bitmapData.dispose();
			boardShapeBitmap.bitmapData = new BitmapData(boardShape.width, boardShape.height, true, 0x000000);
			boardShapeBitmap.bitmapData.draw(boardShape);
			
			typesArray = [];
			prizeNum = 0;
			for (var cellX:uint = 0; cellX < params.xMax; cellX++) {
				typesArray[cellX] = [];
				for (var cellY:uint = 0; cellY < params.yMax; cellY++) {
					if (boardBorderBitmap.bitmapData.hitTest(new Point(), 0, new Point(cellX * params.size, cellY * params.size))) {
						typesArray[cellX][cellY] = 2;
					} else if (boardShapeBitmap.bitmapData.hitTest(new Point(), 0, new Point(cellX * params.size, cellY * params.size))) {
						typesArray[cellX][cellY] = 1;
						if (Math.floor(Math.random() * 50) == 3) {
							typesArray[cellX][cellY] = 3;
							prizeNum++;
						}
					} else {
						typesArray[cellX][cellY] = 0;
					}
				}
			}
		}
		
		
		private function generateShapes(shapeCode:int = -1):void {
			if (shapeCode==-1) {
				shapeCode = Math.floor(Math.random() * 3);
			}
			
			boardBorder.graphics.clear();
			boardShape.graphics.clear();
			if (shapeCode == 0) {
				boardBorder.graphics.lineStyle(params.size);
				boardBorder.graphics.drawEllipse(params.size/2,params.size/2,params.xMax*params.size-params.size,params.yMax*params.size-params.size);
			
				boardShape.graphics.beginFill(0xFFFFFF);
				boardShape.graphics.drawEllipse(params.size/2,params.size/2,params.xMax*params.size-params.size,params.yMax*params.size-params.size);
				boardShape.graphics.endFill();
			} else if (shapeCode == 1) {
				boardBorder.graphics.lineStyle(params.size);
				boardBorder.graphics.moveTo(0,(params.yMax-1)*params.size);
				boardBorder.graphics.lineTo(params.xMax / 2 * params.size, 0);
				boardBorder.graphics.lineTo(params.xMax * params.size, (params.yMax-1) * params.size);
				boardBorder.graphics.lineTo(0,(params.yMax-1)*params.size);
			
				boardShape.graphics.beginFill(0xFFFFFF);
				boardShape.graphics.moveTo(0,(params.yMax-1)*params.size);
				boardShape.graphics.lineTo(params.xMax / 2 * params.size, 0);
				boardShape.graphics.lineTo(params.xMax * params.size, (params.yMax-1) * params.size);
				boardShape.graphics.lineTo(0,(params.yMax-1)*params.size);
				boardShape.graphics.endFill();
			} else if (shapeCode == 2) {
				boardBorder.graphics.lineStyle(params.size);
				boardBorder.graphics.drawRect(0,0,(params.xMax-1)*params.size,(params.yMax-1)*params.size);
				boardBorder.graphics.drawRect(params.xMax / 4*params.size, params.yMax / 4*params.size, (params.xMax-1) / 2*params.size, (params.yMax-1) / 2*params.size);
				
				boardShape.graphics.beginFill(0xFFFFFF);
				boardShape.graphics.drawRect(0,0,(params.xMax-1)*params.size,(params.yMax-1)*params.size);
				boardShape.graphics.drawRect(params.xMax / 4*params.size, params.yMax / 4*params.size, (params.xMax-1) / 2*params.size, (params.yMax-1) / 2*params.size);
				boardShape.graphics.endFill();
			}
		}
		
		
		private var cellsArray:Array;
		public function drawBoard(typeOnly:Boolean=false):void {
			if (!typeOnly) {
				cellsArray = [];
			}
			
			for (var cellX:uint = 0; cellX < params.xMax; cellX++) {
				if (!typeOnly) {
					cellsArray[cellX] = [];
				}
				for (var cellY:uint = 0; cellY < params.yMax; cellY++) {
					if (!typeOnly) {
						var cell:Cell = new Cell(this, typesArray[cellX][cellY]);
						setCell(cellX, cellY, cell);
						
						addChild(cell);
					} else {
						var cell:Cell = getCell(cellX, cellY);
						
						cell.setType(typesArray[cellX][cellY]);
					}
					
					cell.setXY(cellX * params.size, cellY * params.size);
				}
			}
		}
		
		
		public function getBoardParams():Object {
			return params;
		}
		
		public function getBoardBorderBitmap():Bitmap {
			return boardBorderBitmap;
		}
		
		public function getBoardShapeBitmap():Bitmap {
			return boardShapeBitmap;
		}

		
		public function getCell(cellX:uint, cellY:uint):Cell {
			return cellsArray[cellX][cellY];
		}
		
		public function setCell(cellX:uint, cellY:uint, cell:Cell):void {
			cellsArray[cellX][cellY] = cell;
		}
		
		public function exchangeCells(cellX:uint, cellY:uint, newCellX:uint, newCellY:uint):Cell {
			var exchange:Cell = getCell(cellX,cellY);
			setCell(cellX, cellY, getCell(newCellX, newCellY));
			getCell(cellX, cellY).setXY(cellX * params.size, cellY * params.size);
			return exchange;
		}
		
		
		public function removePrize():void {
			prizeNum--;
		}
		
		public function hasPrize():Boolean {
			return prizeNum > 0;
		}
		
	
	}

}