package com.eclecticdesignstudio.spritesheet.importers;


import com.eclecticdesignstudio.spritesheet.data.SpritesheetFrame;
import com.eclecticdesignstudio.spritesheet.Spritesheet;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;


class BitmapImporter {
	
	
	public static function create (bitmapData:BitmapData, columns:Int, rows:Int, tileWidth:Int, tileHeight:Int, adjustLength:Int = 0, scale:Float = 1):Spritesheet {
		
		var frames = [];
		var totalLength = rows * columns + adjustLength;
		
		for (row in 0...rows) {
			
			for (column in 0...columns) {
				
				if (frames.length < totalLength) {
					
					var x = tileWidth * column;
					var y = tileHeight * row;
					var frame = new SpritesheetFrame (x, y, tileWidth, tileHeight, 0, 0);
					
					if (scale != 1) {
						
						var sourceBitmapData = new BitmapData (tileWidth, tileHeight, true, 0x00000000);
						sourceBitmapData.copyPixels (bitmapData, new Rectangle (x, y, tileWidth, tileHeight), new Point ());
						
						var bitmap = new Bitmap (sourceBitmapData);
						bitmap.smoothing = true;
						
						var matrix = new Matrix ();
						matrix.scale (scale, scale);
						
						var bitmapData = new BitmapData (Math.round (tileWidth * scale), Math.round (tileHeight * scale), true, 0x0);
						bitmapData.draw (bitmap, matrix);
						frame.bitmapData = bitmapData;
						
					}
					
					frames.push (frame);
					
				}
				
			}
			
		}
		
		while (frames.length < totalLength) {
			
			frames.push (new SpritesheetFrame ());
			
		}
		
		return new Spritesheet (bitmapData, frames);
		
	}
	
	
}