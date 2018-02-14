package spritesheet.importers;


import openfl.display.Tileset;
import flash.display.BitmapData;
import flash.geom.Rectangle;
import spritesheet.data.SpritesheetFrame;
import spritesheet.Spritesheet;


class BitmapImporter {
	
	
	public static function create (bitmapData:BitmapData, columns:Int, rows:Int, tileWidth:Int, tileHeight:Int, adjustLength:Int = 0):Spritesheet {
		
		var frames = [];
		var rects = new Array<Rectangle>();
		var totalLength = rows * columns + adjustLength;
		
		for (row in 0...rows) {
			
			for (column in 0...columns) {
				
				if (frames.length < totalLength) {
					
					var x = tileWidth * column;
					var y = tileHeight * row;
					var frame = new SpritesheetFrame (x, y, tileWidth, tileHeight, 0, 0);
					frame.id = column + row;

					frames.push (frame);
					rects.push(new Rectangle(x, y, tileWidth, tileHeight));
					
				}
				
			}
			
		}
		
		while (frames.length < totalLength) {
			
			frames.push (new SpritesheetFrame ());
			
		}
		
		return new Spritesheet (new Tileset(bitmapData, rects), frames);
		
	}
	
	
}