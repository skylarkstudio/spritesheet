package com.eclecticdesignstudio.spritesheet.importers;

import flash.display.Bitmap;
import hxjson2.JSON;

import com.eclecticdesignstudio.spritesheet.data.BehaviorData;
import com.eclecticdesignstudio.spritesheet.data.SpriteSheetFrame;
import com.eclecticdesignstudio.spritesheet.SpriteSheet;
import flash.geom.Point;
import nme.Assets;

/**
 * This is a class used to parse a json file exported from Zoe into 
 * a SpriteSheet object to be used with Joshua Granick's fantastic
 * sprite sheet library avialable on haxelib.
 *
 * Since zoe data is exported in json format, you will need the JSON 
 * haxelib package hxJson2
 * 
 * Zoe: http://easeljs.com/zoe.html
 * SpriteSheet: http://lib.haxe.org/p/spritesheet
 * hxJson2: http://lib.haxe.org/p/hxJson2
 * Joshua Granick: http://www.joshuagranick.com
 * Dean Nicholls: http://www.deannicholls.co.uk
 * 
 * @author Dean Nicholls
 */
class Zoe {
	
	public static function parse (data:String, assetDirectory:String = "", spriteSheetName:String = ""):SpriteSheet {		
		var json:Dynamic = JSON.parse(data);
		
		var images:Array<Bitmap> = [];
		
		for (i in 0...json.images.length) {
			images.push(new Bitmap(Assets.getBitmapData(assetDirectory + "/" + json.images[i])));
		}
		
		var frames:Array<SpriteSheetFrame> = new Array <SpriteSheetFrame>();
		
		if (Std.is(json.frames, Array) ) {
			for (i in 0...json.frames.length) {
				// json.frames[i][4] contains the image in multi image files
				frames.push(new SpriteSheetFrame(json.frames[i][0], json.frames[i][1], json.frames[i][2], json.frames[i][3], -json.frames[i][5], -json.frames[i][6]));
			}
		} else {
			var columns:Int = Math.floor(images[0].width / json.frames.width);
			var rows:Int = Math.floor(images[0].height / json.frames.height);
			
			for (k in 0...rows) {
				for (i in 0...columns) {
					frames.push(new SpriteSheetFrame(Std.int(i * json.frames.width), Std.int(k * json.frames.height), json.frames.width, json.frames.height, 0, 0));
				}
			}
		}
		
		// Populate the array of behaviors from the frames specified in the states list in the json file
		var behaviors:Hash<BehaviorData> = new Hash<BehaviorData>();
		for (key in Reflect.fields(json.animations)) {
			var state = Reflect.field(json.animations, key);
			var behaviorFrames:Array<Int> = new Array<Int>();
			var frames = Reflect.field(state, "frames");
						
			if (frames == null) {
				//there must be a more elegant way of doing this...
				var list_frames:Array<Int> = Reflect.field(json.animations, key);
				for (i in list_frames[0]...list_frames[1]) {
					behaviorFrames.push(i);
				}
			} else {
				behaviorFrames = Reflect.field(state, "frames");
			}
			
			//var origin = new Point(frames[state.start].x, frames[state.start].y);
			//var behavior = new BehaviorData(key, behaviorFrames, true, 30, origin.x, origin.y);
			var behavior = new BehaviorData(key, behaviorFrames, true, 30, 0, 0);
			behaviors.set(behavior.name, behavior);
		}
		
		// Create the spriteSheet object
		if (spriteSheetName == "") {
			var spriteSheetName = json.images[0].split(".")[0];
			if (spriteSheetName == "") {
				spriteSheetName = "undefined";
			}
		}
		var spriteSheet:SpriteSheet = new SpriteSheet (frames, behaviors);
		spriteSheet.name = spriteSheetName;
		spriteSheet.setImage(Assets.getBitmapData(assetDirectory + "/" + json.images[0]));
		
		return spriteSheet;
	}
}