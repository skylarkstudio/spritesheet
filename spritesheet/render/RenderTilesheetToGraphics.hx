package spritesheet.render;

import openfl.display.Tilesheet;
import spritesheet.data.SpritesheetFrame;
import flash.display.Graphics;

class RenderTilesheetToGraphics implements IRenderTarget {
	private var graphics : flash.display.Graphics;
	private var tilesheet : Tilesheet;
	public function new(g : flash.display.Graphics, tilesheet : Tilesheet) {
		this.graphics = g;
		this.tilesheet = tilesheet;
	}	
    public function drawFrame(frame : SpritesheetFrame, offsetX : Float , offsetY : Float, smoothing : Bool) {
        tilesheet.drawTiles(graphics, [offsetX + frame.offsetX,offsetY + frame.offsetY, frame.tilesheetIndex], smoothing);
    }
}