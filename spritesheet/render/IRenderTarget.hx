package spritesheet.render;

import spritesheet.data.SpritesheetFrame;

interface IRenderTarget {
  function drawFrame(frame : SpritesheetFrame, offsetX : Float, offsetY : Float, smoothing : Bool) : Void;
}