package com.eclecticdesignstudio.spritesheet.importers;


import com.eclecticdesignstudio.spritesheet.data.BehaviorData;
import com.eclecticdesignstudio.spritesheet.data.SpritesheetFrame;
import com.eclecticdesignstudio.spritesheet.Spritesheet;
import flash.display.Bitmap;
import flash.geom.Point;
import haxe.Json;
import nme.Assets;


/**
 * This is a class used to parse a json file exported from Zoe into 
 * a Spritesheet object to be used with Joshua Granick's fantastic
 * sprite sheet library avialable on haxelib.
 * 
 * Zoe: http://easeljs.com/zoe.html
 * Spritesheet: http://lib.haxe.org/p/spritesheet
 * Joshua Granick: http://www.joshuagranick.com
 * Dean Nicholls: http://www.deannicholls.co.uk
 * 
 * @author Dean Nicholls
 */
class ZoeImporter {
	
	public static function parse (data:String, assetDirectory:String = "", spritesheetName:String = ""):Spritesheet {
		
		var json = Json.parse (data);
		var images = [];
		
		for (image in cast (json.images, Array <Dynamic>)) {
			
			images.push (new Bitmap (Assets.getBitmapData (assetDirectory + "/" + images)));
			
		}
		
		var frames = new Array <SpritesheetFrame> ();
		
		if (Std.is(json.frames, Array)) {
			
			for (frame in cast (json.frames, Array <Dynamic>)) {
				
				// json.frames[i][4] contains the image in multi image files
				
				frames.push (new SpritesheetFrame (frame[0], frame[1], frame[2], frame[3], Std.int (-frame[5]), Std.int (-frame[6])));
				
			}
			
		} else {
			
			var columns = Math.floor (images[0].width / json.frames.width);
			var rows = Math.floor (images[0].height / json.frames.height);
			
			for (k in 0...rows) {
				
				for (i in 0...columns) {
					
					frames.push (new SpritesheetFrame (Std.int (i * json.frames.width), Std.int (k * json.frames.height), json.frames.width, json.frames.height, 0, 0));
					
				}
				
			}
			
		}
		
		// Populate the array of behaviors from the frames specified in the states list in the json file
		
		var behaviors = new Hash<BehaviorData> ();
		
		for (key in Reflect.fields (json.animations)) {
			
			var state = Reflect.field (json.animations, key);
			var behaviorFrames = new Array <Int> ();
			var frames = Reflect.field (state, "frames");
			
			if (frames == null) {
				
				//there must be a more elegant way of doing this...
				
				var list_frames:Array<Int> = Reflect.field (json.animations, key);
				
				for (i in list_frames[0]...list_frames[1]) {
					
					behaviorFrames.push(i);
					
				}
				
			} else {
				
				behaviorFrames = Reflect.field(state, "frames");
				
			}
			
			//var origin = new Point (frames[state.start].x, frames[state.start].y);
			//var behavior = new BehaviorData (key, behaviorFrames, true, 30, origin.x, origin.y);
			var behavior = new BehaviorData (key, behaviorFrames, true, 30, 0, 0);
			behaviors.set (behavior.name, behavior);
			
		}
		
		// Create the spritesheet object
		
		if (spritesheetName == "") {
			
			var spritesheetName = json.images[0].split(".")[0];
			
			if (spritesheetName == "") {
				
				spritesheetName = "undefined";
				
			}
		}
		
		var spritesheet = new Spritesheet (Assets.getBitmapData(assetDirectory + "/" + json.images[0]), frames, behaviors);
		spritesheet.name = spritesheetName;
		
		return spritesheet;
		
	}
	
}