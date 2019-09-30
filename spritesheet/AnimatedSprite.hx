package spritesheet;

import openfl.display.Tile;
import openfl.display.Tilemap;
import flash.display.Sprite;
import flash.events.Event;
import spritesheet.data.BehaviorData;


class AnimatedSprite extends Sprite {
	public var tilemap(default, null):Tilemap;
	public var tile(default, null):Tile;

	public var currentBehavior:BehaviorData;
	public var currentFrameIndex:Int;
	public var smoothing:Bool;
	public var spritesheet:Spritesheet;
	
	private var behaviorComplete:Bool;
	private var behaviorQueue:Array <BehaviorData>;
	private var behavior:BehaviorData;
	private var loopTime:Int;
	private var timeElapsed:Int;
	

	public function new (sheet:Spritesheet, smoothing:Bool = false) {
		
		super ();
		
		this.smoothing = smoothing;
		this.spritesheet = sheet;
		
		behaviorQueue = new Array <BehaviorData> ();

		this.tilemap = new Tilemap(sheet.width, sheet.height, sheet.tileset, smoothing);
		this.tilemap.addTile(this.tile = new Tile());

		addChild (this.tilemap);
		
	}
	
	
	public function getFrameData (index:Int):Dynamic {
		
		if (currentBehavior != null && currentBehavior.frameData.length > index) {
			
			return currentBehavior.frameData[index];
			
		} else {
			
			return null;
			
		}
		
	}
	
	
	public function queueBehavior (behavior:Dynamic):Void {
		
		var behaviorData = resolveBehavior (behavior);
		
		if (currentBehavior == null) {
			
			updateBehavior (behaviorData);
			
		} else {
			
			behaviorQueue.push (behaviorData);
			
		}
		
	}
	
	
	private function resolveBehavior (behavior:Dynamic):BehaviorData {
		
		if (Std.is (behavior, BehaviorData)) {
			
			return cast behavior;
			
		} else if (Std.is (behavior, String)) {
			
			if (spritesheet != null) {
				
				return spritesheet.behaviors.get (cast behavior);
				
			}
			
		}
		
		return null;
		
	}
	
	
	public function showBehavior (behavior:Dynamic, restart:Bool = true):Void {
		
		behaviorQueue = new Array <BehaviorData> ();
		
		updateBehavior (resolveBehavior (behavior), restart);
		
	}
	
	
	public function showBehaviors (behaviors:Array <Dynamic>):Void {
		
		behaviorQueue = new Array <BehaviorData> ();
		
		for (behavior in behaviors) {
			
			behaviorQueue.push (resolveBehavior (behavior));
			
		}
		
		if (behaviorQueue.length > 0) {
			
			updateBehavior (behaviorQueue.shift ());
			
		}
		
	}
	
	
	public function update (deltaTime:Int):Void {
		
		if (!behaviorComplete) {
			
			timeElapsed += deltaTime;
			
			var ratio = timeElapsed / loopTime;
			
			if (ratio >= 1) {
				
				if (currentBehavior.loop && behaviorQueue.length == 0 ) {
					
					ratio -= Math.floor (ratio);
					
				} else {
					
					behaviorComplete = true;
					ratio = 1;
					
				}
				
			}
			
			// Number of frames in the animation
			var frameCount = currentBehavior.frames.length;
			// Duration in ms of a single frame
			var frameDuration:Int = Math.round(loopTime / frameCount);
			// This is the number of ms we have been in this animation
			var timeInAnimation:Int = timeElapsed % loopTime;
			// The raw frame index is the number of frames we have had time to show
			var rawFrameIndex:Int = Math.round(timeInAnimation / frameDuration);
			// Make sure we loop correctly
			currentFrameIndex = rawFrameIndex % frameCount;
			
			var frame = spritesheet.getFrame (currentBehavior.frames [currentFrameIndex]);

			this.tile.id = frame.id;
			this.tile.x = frame.offsetX - currentBehavior.originX;
			this.tile.y = frame.offsetY - currentBehavior.originY;

			if (behaviorComplete) {
				
				if (behaviorQueue.length > 0) {
					
					updateBehavior (behaviorQueue.shift ());
					
				} else if (hasEventListener (Event.COMPLETE)) {
					
					dispatchEvent (new Event (Event.COMPLETE));
					
				}		
				
			}
			
		}
		
	}
	
	
	private function updateBehavior (behavior:BehaviorData, restart:Bool = true):Void {
		
		if (behavior != null) {
			
			if (restart || behavior != currentBehavior) {
				
				currentBehavior = behavior;
				timeElapsed = 0;
				behaviorComplete = false;
				
				loopTime = Std.int ((behavior.frames.length / behavior.frameRate) * 1000);
			}
			
		} else {

			currentBehavior = null;
			currentFrameIndex = -1;
			behaviorComplete = true;
			
		}
		
	}
	
	
}
