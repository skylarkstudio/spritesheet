package spritesheet.importers;


import flash.geom.Point;
import haxe.xml.Fast;
import openfl.Assets;
import spritesheet.data.BehaviorData;
import spritesheet.data.SpritesheetFrame;
import spritesheet.Spritesheet;


class AnimoImporter {
	
	
	public static function parse (data:String, assetDirectory:String = ""):Spritesheet {
		
		var frames = new Array <SpritesheetFrame> ();
		var behaviors = new Map <String, BehaviorData> ();
		var frameIndex = new Map <String, Int> ();
		
		var xml = Xml.parse (data);
		var spriteSheetNode = xml.firstElement ();
		
		for (behaviorNode in spriteSheetNode.elements ()) {
			
			var behaviorNodeFast = new Fast (behaviorNode);
			var behaviorFrames = new Array <Int> ();
			
			var allFramesText = behaviorNodeFast.innerData;
			var framesText = allFramesText.split (";");
			
			for (frameText in framesText) {
				
				if (!frameIndex.exists (frameText)) {
					
					var components = frameText.split (",");
					var frame = new SpritesheetFrame (Std.parseInt (components[0]), Std.parseInt (components[1]), Std.parseInt (components[2]), Std.parseInt (components[3]), Std.parseInt (components[4]), Std.parseInt (components[5]));
					frameIndex.set (frameText, frames.length);
					frames.push (frame);
					
				}
				
				behaviorFrames.push (frameIndex.get (frameText));
				
			}
			
			var loop = false;
			
			if (behaviorNodeFast.att.loop == "0") {
				
				loop = true;
				
			}
			
			var referencePoint = behaviorNodeFast.att.referencePoint.split (",");
			
			var behavior = new BehaviorData (behaviorNodeFast.att.name, behaviorFrames, loop, Std.parseInt (behaviorNodeFast.att.frameRate), Std.parseFloat (referencePoint[0]), Std.parseFloat (referencePoint[1]));
			behaviors.set (behavior.name, behavior);
			
		}
		
		var spriteSheetNodeFast = new Fast (spriteSheetNode);
		
		var spriteSheet = new Spritesheet (Assets.getBitmapData (assetDirectory + "/" + spriteSheetNodeFast.att.path), frames, behaviors);
		spriteSheet.name = spriteSheetNodeFast.att.name;
		
		return spriteSheet;
		
	}
	
	
}