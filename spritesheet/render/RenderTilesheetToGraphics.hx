package spritesheet.render;

import openfl.display.Tilesheet;
import spritesheet.data.SpritesheetFrame;
import flash.display.Sprite;
import spritesheet.AnimatedSprite;

 class RenderTilesheetToGraphics implements IRenderTarget {
	private var sprite : Sprite;
	private var tilesheet : Tilesheet;
	private var flags : Int = 0;
	 
  // We store the tile data here because we do not want to recreate it every frame and run into garbage collector problems
	// But since it is refilled every time a frame is drawn, it can be static 
  static private var tileDataWithColorTransform : Array<Float> = [0.0,0.0,0.0,0.0,0.0,0.0];
	static private var tileDataWithoutColorTransform : Array<Float> = [0.0,0.0,0.0];
	 
	public function new(o : Sprite, tilesheet : Tilesheet) {
		this.sprite = o;
		this.tilesheet = tilesheet;
	}	
    public function drawFrame(frame : SpritesheetFrame, offsetX : Float , offsetY : Float, smoothing : Bool) {
	    sprite.graphics.clear();
      var tileData : Array<Float> = null;// First data = offset
      var usedFlags = flags;
      if (sprite.transform.colorTransform == null) {
				tileData = tileDataWithoutColorTransform;
				tileData[0] = offsetX + frame.offsetX;
				tileData[1] = offsetY + frame.offsetY;
				tileData[2] = frame.tilesheetIndex;
			} else {
				tileData = tileDataWithColorTransform;
				tileData[0] = offsetX + frame.offsetX;
				tileData[1] = offsetY + frame.offsetY;
				tileData[2] = frame.tilesheetIndex;
				tileData[3] = sprite.transform.colorTransform.redMultiplier;
				tileData[4] = sprite.transform.colorTransform.greenMultiplier;
				tileData[5] = sprite.transform.colorTransform.blueMultiplier;
        usedFlags |= Tilesheet.TILE_RGB;
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