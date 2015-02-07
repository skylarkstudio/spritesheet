package spritesheet.render;

import openfl.display.Tilesheet;
import spritesheet.data.SpritesheetFrame;
import flash.display.Sprite;
import spritesheet.AnimatedSprite;

 class RenderTilesheetToGraphics implements IRenderTarget {
	private var sprite : Sprite;
	private var tilesheet : Tilesheet;
	private var flags : Int = 0;
	public function new(o : Sprite, tilesheet : Tilesheet) {
		this.sprite = o;
		this.tilesheet = tilesheet;
	}	
    public function drawFrame(frame : SpritesheetFrame, offsetX : Float , offsetY : Float, smoothing : Bool) {
	    sprite.graphics.clear();
      var tileData : Array<Float> =  [offsetX + frame.offsetX,offsetY + frame.offsetY, frame.tilesheetIndex]; // First data = offset
      var usedFlags = flags;
      if (sprite.transform.colorTransform != null) {
        tileData.push(sprite.transform.colorTransform.redMultiplier);
        tileData.push(sprite.transform.colorTransform.greenMultiplier);
        tileData.push(sprite.transform.colorTransform.blueMultiplier);
        tileData.push(sprite.transform.colorTransform.alphaMultiplier);
        usedFlags |= Tilesheet.TILE_RGB | Tilesheet.TILE_ALPHA;
      }
      tilesheet.drawTiles(sprite.graphics,tileData, smoothing, usedFlags);
    }
    public function enableFlag(flag : Flag) {
		switch(flag) {
			case BLEND_ADD:
			flags = flags | Tilesheet.TILE_BLEND_ADD;
		}
	}
	public function disableFlag(flag : Flag) {
		switch(flag) {
			case BLEND_ADD:
			flags &= 0xFFFFFFF - Tilesheet.TILE_BLEND_ADD;
		}
	}
}