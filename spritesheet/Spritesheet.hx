package spritesheet;

import openfl.display.Tileset;
import flash.display.BitmapData;
import spritesheet.data.BehaviorData;
import spritesheet.data.SpritesheetFrame;


class Spritesheet {
	
	
	public var behaviors:Map <String, BehaviorData>;
	public var name:String;
	public var totalFrames:Int;
	
	private var frames:Array <SpritesheetFrame>;

	public var width = 0;
	public var height = 0;

	public var tileset(default, null):Tileset;
	
	public function new (tileset:Tileset = null, frames:Array <SpritesheetFrame> = null, behaviors:Map <String, BehaviorData> = null, imageAlpha:BitmapData = null) {
		this.tileset = tileset;

		if (frames == null) {
			
			this.frames = new Array <SpritesheetFrame> ();
			totalFrames = 0;

			width = 0;
			height = 0;
			
		} else {
			
			this.frames = frames;
			totalFrames = frames.length;

			for (frame in this.frames) {
				if (width == 0 || frame.width > width) {
					width = frame.width;
				}

				if (height == 0 || frame.height > height) {
					height = frame.height;
				}
			}
			
		}
		
		if (behaviors == null) {
			
			this.behaviors = new Map <String, BehaviorData> ();
			
		} else {
			
			this.behaviors = behaviors;
			
		}
		
	}
	
	
	public function addBehavior (behavior:BehaviorData):Void {
		
		behaviors.set (behavior.name, behavior);
		
	}
	
	/**
	 * added for ZoeImporter, loop of the animation is default false 
	 * @param  name 	BehaviorData name set by ZoeImporter
	 */
	public function loopBehavior (name:String):Void {
		
		if(this.behaviors.exists(cast name)){		
			var behavior : BehaviorData = this.behaviors.get (cast name);
			behavior.loop = true;
		}

	}


	public function addFrame (frame:SpritesheetFrame):Void {
		
		frames.push (frame);
		totalFrames ++;

		if (frame.width > width) {
			width = frame.width;
		}

		if (frame.height > height) {
			height = frame.height;
		}
	}
	
	public function getFrame (index:Int, autoGenerate:Bool = true):SpritesheetFrame {
		
		return frames[index];
		
	}
	

	public function getFrameById(frameId:Int, autoGenerate:Bool = true):SpritesheetFrame {

			var frameIndex:Int = 0;
			var frame:SpritesheetFrame = null;

			for (index in 0...totalFrames) {

					if (frames[index].id==frameId) {
							frameIndex = index;
							frame = frames[index];
							break;
					}

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

}