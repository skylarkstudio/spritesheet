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
		
		// Create an array of frames based on the table of images created in the zoe exported png
		var image = new Bitmap(Assets.getBitmapData(assetDirectory + "/" + json.src));
		var columnCount:Int = Math.floor(image.width / json.w);
		var rowCount:Int = Math.floor(image.height / json.h);
		var frames:Array<SpriteSheetFrame> = new Array <SpriteSheetFrame>();
		
		for (row in 0...rowCount) {
			for (column in 0...columnCount) {
				frames.push(new SpriteSheetFrame(Math.floor(column * json.w), Math.floor(row * json.h), json.w, json.h, 0, 0));
			}
		}
		
		// Populate the array of behaviors from the frames specified in the states list in the json file
		var behaviors:Hash<BehaviorData> = new Hash<BehaviorData>();
		for (key in Reflect.fields(json.states)) {
			var state = Reflect.field(json.states, key);
			var behaviorFrames:Array<Int> = new Array<Int>();
			
			for (i in state.start...state.end +1) {
				behaviorFrames.push(i);
			}
			
			var origin = new Point(frames[state.start].x, frames[state.start].y);
			//var behavior = new BehaviorData(key, behaviorFrames, true, 30, origin.x, origin.y);
			var behavior = new BehaviorData(key, behaviorFrames, true, 30, 0, 0);
			behaviors.set(behavior.name, behavior);
		}
		
		// Create the spriteSheet object
		if (spriteSheetName == "") {
			var spriteSheetName = json.src.split(".")[0];
			if (spriteSheetName == "") {
				spriteSheetName = "undefined";
			}
		}
		var spriteSheet:SpriteSheet = new SpriteSheet (frames, behaviors);
		spriteSheet.name = spriteSheetName;
		spriteSheet.setImage(Assets.getBitmapData(assetDirectory + "/" + json.src));
		
		return spriteSheet;
	}
}