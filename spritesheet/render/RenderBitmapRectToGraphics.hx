package spritesheet.render;

import spritesheet.data.SpritesheetFrame;
import flash.display.Sprite;
import flash.display.BlendMode;
import spritesheet.AnimatedSprite;

class RenderBitmapRectToGraphics implements IRenderTarget {
	private var sprite : Sprite;
	public function new(o : Sprite) {this.sprite = o;}
    public function drawFrame(frame : SpritesheetFrame, offsetX : Float, offsetY : Float, smoothing : Bool) {
        var m = new flash.geom.Matrix();
        m.translate(offsetX + frame.offsetX - frame.x, offsetY + frame.offsetY - frame.y);
	    sprite.graphics.clear();
        sprite.graphics.beginBitmapFill(frame.bitmapData, m, false, smoothing);
        sprite.graphics.drawRect(offsetX + frame.offsetX,offsetY + frame.offsetY,frame.width, frame.height);
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