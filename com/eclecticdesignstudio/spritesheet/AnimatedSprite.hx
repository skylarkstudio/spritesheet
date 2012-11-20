package com.eclecticdesignstudio.spritesheet;


import com.eclecticdesignstudio.spritesheet.data.BehaviorData;
import flash.display.Bitmap;
import flash.display.BitmapData;
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
	public var spritesheet:Spritesheet;
	
	private var behaviorComplete:Bool;
	private var behaviorQueue:Array <String>;
	private var behavior:BehaviorData;
	private var loopTime:Int;
	private var timeElapsed:Int;
	

	public function new (spritesheet:Spritesheet, smoothing:Bool = false) {
		
		super ();
		
		this.smoothing = smoothing;
		this.spritesheet = spritesheet;
		
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
		
		behaviorQueue = null;
		
		updateBehavior (name, allowRestart);
		
	}
	
	
	public function showBehaviors (names:Array <String>):Void {
		
		behaviorQueue = names;
		
		if (behaviorQueue != null && behaviorQueue.length > 0) {
			
			updateBehavior (behaviorQueue.shift ());
			
		}
		
	}
	
	
	public function update (deltaTime:Int):Void {
		
		if (!behaviorComplete) {
			
			timeElapsed += deltaTime;
			
			var ratio = timeElapsed / loopTime;
			
			if (ratio >= 1) {
				
				if (behavior.loop) {
					
					ratio -= Math.floor (ratio);
					
				} else {
					
					behaviorComplete = true;
					ratio = 1;
					
				}
				
			}
			
			currentFrameIndex = Math.round (ratio * (behavior.frames.length - 1));
			var frame = spritesheet.getFrame (behavior.frames [currentFrameIndex]);
			
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
	
	
	private function updateBehavior (name:String, allowRestart:Bool = true):Void {
		
		behavior = spritesheet.behaviors.get (name);
		
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
	
	
}