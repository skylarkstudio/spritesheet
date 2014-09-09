package spritesheet.render;

import flash.display.Graphics;

class RenderWholeBitmapToGraphics implements IRenderTarget {
	private var graphics : Graphics;
	public function new(graphics : Graphics) {this.graphics = graphics;}
	public function drawFrame(frame : spritesheet.data.SpritesheetFrame, offsetX : Float, offsetY : Float, smoothing : Bool) {
	    var m = new flash.geom.Matrix();
	    m.translate(offsetX + frame.offsetX, offsetY + frame.offsetY);
	    graphics.beginBitmapFill(frame.bitmapData, m, false, smoothing);
	    graphics.drawRect(offsetX + frame.offsetX, offsetY + frame.offsetY ,frame.width, frame.height);
	    graphics.endFill();
	}
}