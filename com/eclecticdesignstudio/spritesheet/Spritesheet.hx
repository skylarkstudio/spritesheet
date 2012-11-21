package com.eclecticdesignstudio.spritesheet;


import com.eclecticdesignstudio.spritesheet.data.BehaviorData;
import com.eclecticdesignstudio.spritesheet.data.SpritesheetFrame;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;


/**
 * ...
 * @author Joshua Granick
 */

class Spritesheet {
	
	
	public var behaviors:Hash <BehaviorData>;
	public var name:String;
	public var totalFrames:Int;
	
	private var frames:Array <SpritesheetFrame>;
	private var sourceImage:BitmapData;
	private var sourceImageAlpha:BitmapData;
	
	
	public function new (image:BitmapData = null, frames:Array <SpritesheetFrame> = null, behaviors:Hash <BehaviorData> = null, imageAlpha:BitmapData = null) {
		
		this.sourceImage = image;
		this.sourceImageAlpha = imageAlpha;
		
		if (frames == null) {
			
			this.frames = new Array <SpritesheetFrame> ();
			totalFrames = 0;
			
		} else {
			
			this.frames = frames;
			totalFrames = frames.length;
			
		}
		
		if (behaviors == null) {
			
			this.behaviors = new Hash <BehaviorData> ();
			
		} else {
			
			this.behaviors = behaviors;
			
		}
		
	}
	
	
	public function addBehavior (behavior:BehaviorData):Void {
		
		behaviors.set (behavior.name, behavior);
		
	}
	
	
	public function addFrame (frame:SpritesheetFrame):Void {
		
		frames.push (frame);
		totalFrames ++;
		
	}
	
	
	public function generateBitmaps ():Void {
		
		for (i in 0...totalFrames) {
			
			generateBitmap (i);
			
		}
		
	}
	
	
	public function generateBitmap (index:Int):Void {
		
		var frame = frames[index];
		
		var bitmapData = new BitmapData (frame.width, frame.height, true);
		var sourceRectangle = new Rectangle (frame.x, frame.y, frame.width, frame.height);
		var targetPoint = new Point ();
		
		bitmapData.copyPixels (sourceImage, sourceRectangle, targetPoint);
		
		if (sourceImageAlpha != null) {
			
			bitmapData.copyChannel (sourceImageAlpha, sourceRectangle, targetPoint, 2, 8);
			
		}
		
		frame.bitmapData = bitmapData;
		
	}
	
	
	public function getFrame (index:Int, autoGenerate:Bool = true):SpritesheetFrame {
		
		var frame = frames[index];
		
		if (frame != null && frame.bitmapData == null && autoGenerate) {
			
			generateBitmap (index);
			
		}
		
		return frame;
		
	}
	
	
	public function getFrameIDs ():Array <Int> {
		
		var ids = [];
		
		for (i in 0...totalFrames) {
			
			ids.push (i);
			
		}
		
		return ids;
		
	}
	
	
	public function getFrames ():Array <SpritesheetFrame> {
		
		return frames.copy ();
		
	}
	
	
	public function merge (spritesheet:Spritesheet):Array <Int> {
		
		var cacheTotalFrames = totalFrames;
		
		for (i in 0...spritesheet.frames.length) {
			
			if (spritesheet.frames[i].bitmapData == null && (spritesheet.sourceImage != sourceImage || spritesheet.sourceImageAlpha != sourceImageAlpha)) {
				
				spritesheet.generateBitmap (i);
				
			}
			
			addFrame (spritesheet.frames[i]);
			
		}
		
		for (behavior in spritesheet.behaviors) {
			
			if (!behaviors.exists (behavior.name)) {
				
				var clone = behavior.clone ();
				clone.name = behavior.name;
				
				for (i in 0...behavior.frames.length) {
					
					behavior.frames[i] += cacheTotalFrames;
					
				}
				
				addBehavior (behavior);
				
			}
			
		}
		
		var ids = [];
		
		for (i in cacheTotalFrames...totalFrames) {
			
			ids.push (i);
			
		}
		
		return ids;
		
	}
	
	
	public function updateImage (image:BitmapData, imageAlpha:BitmapData = null):Void {
		
		sourceImage = image;
		sourceImageAlpha = imageAlpha;
		
		for (frame in frames) {
			
			if (frame.bitmapData != null) {
				
				frame.bitmapData = null;
				
			}
			
		}
		
	}
	
	
}