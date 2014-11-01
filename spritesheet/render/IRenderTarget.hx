package spritesheet.render;

import spritesheet.data.SpritesheetFrame;
import spritesheet.AnimatedSprite;

interface IRenderTarget {
  function drawFrame(frame : SpritesheetFrame, offsetX : Float, offsetY : Float, smoothing : Bool) : Void;
  function enableFlag(flag : Flag) : Void;
  function disableFlag(flag : Flag) : Void;
}