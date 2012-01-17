package com.eclecticdesignstudio.spritesheet.data;


import flash.display.BitmapData;


/**
 * ...
 * @author Joshua Granick
 */

class SpriteSheetFrame {
	
	
	public var bitmapData:BitmapData;
	public var height:Int;
	public var offsetX:Int;
	public var offsetY:Int;
	public var width:Int;
	public var x:Int;
	public var y:Int;
	
	
	public function new (x:Int, y:Int, width:Int, height:Int, offsetX:Int, offsetY:Int) {
		
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
		this.offsetX = offsetX;
		this.offsetY = offsetY;
		
	}
	
	
}