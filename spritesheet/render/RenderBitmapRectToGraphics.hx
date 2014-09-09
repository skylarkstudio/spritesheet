package spritesheet.render;

import spritesheet.data.SpritesheetFrame;
import flash.display.Graphics;

class RenderBitmapRectToGraphics implements IRenderTarget {
	private var graphics : flash.display.Graphics;
	public function new(g : flash.display.Graphics) {
		this.graphics = g;
	}	
    public function drawFrame(frame : SpritesheetFrame, offsetX : Float, offsetY : Float, smoothing : Bool) {
        var m = new flash.geom.Matrix();
        m.translate(offsetX + frame.offsetX - frame.x, offsetY + frame.offsetY - frame.y);
        graphics.beginBitmapFill(frame.bitmapData, m, false, smoothing);
        graphics.drawRect(offsetX + frame.offsetX,offsetY + frame.offsetY,frame.width, frame.height);
        graphics.endFill();
    }
}