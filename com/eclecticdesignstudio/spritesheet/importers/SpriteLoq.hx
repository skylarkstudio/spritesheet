package com.eclecticdesignstudio.spritesheet.importers;


import com.eclecticdesignstudio.spritesheet.data.BehaviorData;
import com.eclecticdesignstudio.spritesheet.data.SpriteSheetFrame;
import com.eclecticdesignstudio.spritesheet.SpriteSheet;
import flash.geom.Point;
import haxe.xml.Fast;
import nme.Assets;


/**
 * ...
 * @author Joshua Granick
 */

class SpriteLoq {
	
	
	public static function parse (data:String, assetDirectory:String = ""):SpriteSheet {
		
		var frames:Array <SpriteSheetFrame> = new Array <SpriteSheetFrame> ();
		var behaviors:Hash <BehaviorData> = new Hash <BehaviorData> ();
		var frameIndex:Hash <Int> = new Hash <Int> ();
		
		var xml:Xml = Xml.parse (data);
		var spriteSheetNode:Xml = xml.firstElement ();
		
		for (behaviorNode in spriteSheetNode.elements ()) {
			
			var behaviorNodeFast:Fast = new Fast (behaviorNode);
			var behaviorFrames:Array <Int> = new Array <Int> ();
			
			var allFramesText:String = behaviorNodeFast.innerData;
			var framesText:Array <String> = allFramesText.split (";");
			
			for (frameText in framesText) {
				
				if (!frameIndex.exists (frameText)) {
					
					var components:Array <String> = frameText.split (",");
					var frame:SpriteSheetFrame = new SpriteSheetFrame (Std.parseInt (components[0]), Std.parseInt (components[1]), Std.parseInt (components[2]), Std.parseInt (components[3]), Std.parseInt (components[4]), Std.parseInt (components[5]));
					frameIndex.set (frameText, frames.length);
					frames.push (frame);
					
				}
				
				behaviorFrames.push (frameIndex.get (frameText));
				
			}
			
			var loop:Bool = false;
			
			if (behaviorNodeFast.att.loop == "0") {
				
				loop = true;
				
			}
			
			var referencePoint:Array <String> = behaviorNodeFast.att.referencePoint.split (",");
			
			var behavior:BehaviorData = new BehaviorData (behaviorNodeFast.att.name, behaviorFrames, loop, Std.parseInt (behaviorNodeFast.att.frameRate), Std.parseFloat (referencePoint[0]), Std.parseFloat (referencePoint[1]));
			behaviors.set (behavior.name, behavior);
			
		}
		
		var spriteSheetNodeFast:Fast = new Fast (spriteSheetNode);
		
		var spriteSheet:SpriteSheet = new SpriteSheet (frames, behaviors);
		spriteSheet.name = spriteSheetNodeFast.att.name;
		spriteSheet.setImage (Assets.getBitmapData (assetDirectory + "/" + spriteSheetNodeFast.att.path));
		
		return spriteSheet;
		
	}
	
	
}