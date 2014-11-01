package spritesheet.data;


import flash.display.BitmapData;


class SpritesheetFrame {
	
	
	public var name:String;
	public var tilesheetIndex:Int;//Used when drawing this frame from a tilesheet
	public var bitmapData:BitmapData;
	public var height:Int;
	public var offsetX:Int;
	public var offsetY:Int;
	public var width:Int;
	public var x:Int;
	public var y:Int;
	
	
	public function new (x:Int = 0, y:Int = 0, width:Int = 0, height:Int = 0, offsetX:Int = 0, offsetY:Int = 0) {
		
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
		this.offsetX = offsetX;
		this.offsetY = offsetY;
		
	}
	
	
}