package com.eclecticdesignstudio.spritesheet;


import com.eclecticdesignstudio.spritesheet.data.BehaviorData;
import com.eclecticdesignstudio.spritesheet.data.SpriteSheetFrame;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.PixelSnapping;
import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;


/**
 * ...
 * @author Joshua Granick
 */

class AnimatedSprite extends Sprite {
	
	
	public var bitmap:Bitmap;
	public var currentBehavior:BehaviorData;
	public var currentFrameIndex:Int;
	public var smoothing:Bool;
	public var spriteSheet:SpriteSheet;
	
	private var behaviorComplete:Bool;
	private var behaviorQueue:Array <String>;
	private var behavior:BehaviorData;
	private var loopTime:Int;
	private var timeElapsed:Int;
	

	public function new (spriteSheet:SpriteSheet, smoothing:Bool = false) {
		
		super ();
		
		this.smoothing = smoothing;
		this.spriteSheet = spriteSheet;
		
		bitmap = new Bitmap ();
		addChild (bitmap);
		
	}
	
	
	public function getFrameData (index:Int):Dynamic {
		
		if (currentBehavior != null) {
			
			return currentBehavior.frameData[index];
			
		} else {
			
			return null;
			
		}
		
	}
	
	
	public function showBehavior (name:String, allowRestart:Bool = true):Void {
		
		behavior = spriteSheet.behaviors.get (name);
		
		if (behavior != null) {
			
			if (allowRestart || behavior != currentBehavior) {
				
				currentBehavior = behavior;
				timeElapsed = 0;
				behaviorComplete = false;
				
				loopTime = Std.int ((behavior.frames.length / behavior.frameRate) * 1000);
				
			}
			
		} else {
			
			bitmap.bitmapData = null;
			currentBehavior = null;
			currentFrameIndex = -1;
			behaviorComplete = true;
			
		}
		
	}
	
	
	public function showBehaviors (names:Array <String>):Void {
		
		behaviorQueue = names;
		
		if (behaviorQueue != null && behaviorQueue.length > 0) {
			
			showBehavior (behaviorQueue.shift ());
			
		}
		
	}
	
	
	public function update (deltaTime:Int):Void {
		
		if (!behaviorComplete) {
			
			timeElapsed += deltaTime;
			
			var ratio:Float = timeElapsed / loopTime;
			
			if (ratio >= 1) {
				
				if (behavior.loop) {
					
					ratio -= Math.floor (ratio);
					
				} else {
					
					behaviorComplete = true;
					ratio = 1;
					
				}
				
			}
			
			currentFrameIndex = Math.round (ratio * (behavior.frames.length - 1));
			var frame = spriteSheet.getFrame (behavior.frames [currentFrameIndex]);
			
			bitmap.bitmapData = frame.bitmapData;
			bitmap.smoothing = smoothing;
			bitmap.x = frame.offsetX - behavior.originX;
			bitmap.y = frame.offsetY - behavior.originY;
			
			if (behaviorComplete) {
				
				if (behaviorQueue != null && behaviorQueue.length > 0) {
					
					showBehavior (behaviorQueue.shift ());
					
				} else if (hasEventListener (Event.COMPLETE)) {
					
					dispatchEvent (new Event (Event.COMPLETE));
					
				}		
				
			}
			
		}
		
	}
	
	
}