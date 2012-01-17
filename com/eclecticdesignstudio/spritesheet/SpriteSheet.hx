package com.eclecticdesignstudio.spritesheet;


import com.eclecticdesignstudio.spritesheet.data.BehaviorData;
import com.eclecticdesignstudio.spritesheet.data.SpriteSheetFrame;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;


/**
 * ...
 * @author Joshua Granick
 */

class SpriteSheet {
	
	
	public var behaviors:Hash <BehaviorData>;
	public var name:String;
	public var totalFrames:Int;
	
	private var frames:Array <SpriteSheetFrame>;
	private var sourceImage:BitmapData;
	private var sourceImageAlpha:BitmapData;
	
	
	public function new (frames:Array <SpriteSheetFrame> = null, behaviors:Hash <BehaviorData> = null) {
		
		if (frames == null) {
			
			this.frames = new Array <SpriteSheetFrame> ();
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
	
	
	public function addFrame (frame:SpriteSheetFrame):Void {
		
		frames.push (frame);
		totalFrames ++;
		
	}
	
	
	public function generateBitmaps ():Void {
		
		for (i in 0...totalFrames) {
			
			generateBitmap (i);
			
		}
		
	}
	
	
	public function generateBitmap (index:Int):Void {
		
		var frame:SpriteSheetFrame = frames[index];
		
		var bitmapData:BitmapData = new BitmapData (frame.width, frame.height, true);
		var sourceRectangle:Rectangle = new Rectangle (frame.x, frame.y, frame.width, frame.height);
		var targetPoint:Point = new Point ();
		
		bitmapData.copyPixels (sourceImage, sourceRectangle, targetPoint);
		
		if (sourceImageAlpha != null) {
			
			bitmapData.copyChannel (sourceImageAlpha, sourceRectangle, targetPoint, 2, 8);
			
		}
		
		frame.bitmapData = bitmapData;
		
	}
	
	
	public function getFrame (index:Int, autoGenerate:Bool = true):SpriteSheetFrame {
		
		var frame:SpriteSheetFrame = frames[index];
		
		if (frame != null && frame.bitmapData == null && autoGenerate) {
			
			generateBitmap (index);
			
		}
		
		return frame;
		
	}
	
	
	public function setImage (image:BitmapData, imageAlpha:BitmapData = null):Void {
		
		sourceImage = image;
		sourceImageAlpha = imageAlpha;
		
	}
	
	
}