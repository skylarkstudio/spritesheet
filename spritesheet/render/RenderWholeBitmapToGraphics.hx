package spritesheet.render;

import flash.display.Sprite;
import flash.display.BlendMode;
import spritesheet.AnimatedSprite;

class RenderWholeBitmapToGraphics implements IRenderTarget {
	private var sprite : Sprite;
	public function new(o : Sprite) {this.sprite = o;}
	public function drawFrame(frame : spritesheet.data.SpritesheetFrame, offsetX : Float, offsetY : Float, smoothing : Bool) {
	    var m = new flash.geom.Matrix();
	    m.translate(offsetX + frame.offsetX, offsetY + frame.offsetY);
	    sprite.graphics.clear();
	    sprite.graphics.beginBitmapFill(frame.bitmapData, m, false, smoothing);
	    sprite.graphics.drawRect(offsetX + frame.offsetX, offsetY + frame.offsetY ,frame.width, frame.height);
	    sprite.graphics.endFill();
	} 
	public function enableFlag(flag : Flag) {
		switch(flag) {
			case BLEND_ADD:
			sprite.blendMode = BlendMode.ADD;
		}
	}
	public function disableFlag(flag : Flag) {
		switch(flag) {
			case BLEND_ADD:
			sprite.blendMode = BlendMode.NORMAL;
		}
	}
}