package com.eclecticdesignstudio.spritesheet.data;


import flash.geom.Point;


/**
 * ...
 * @author Joshua Granick
 */

class BehaviorData {
	
	
	public var frameData:Array <Dynamic>;
	public var frameRate:Int;
	public var frames:Array <Int>;
	public var loop:Bool;
	public var name:String;
	public var originX:Float;
	public var originY:Float;
	
	
	public function new (name:String, frames:Array <Int>, loop:Bool = false, frameRate:Int = 30, originX:Float = 0, originY:Float = 0) {
		
		this.name = name;
		this.frames = frames;
		this.loop = loop;
		this.frameRate = frameRate;
		this.originX = originX;
		this.originY = originY;
		
		frameData = new Array <Dynamic> ();
		
		for (i in 0...this.frames.length) {
			
			frameData.push (null);
			
		}
		
	}
	
	
}