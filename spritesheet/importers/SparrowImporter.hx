package spritesheet.importers;


import flash.geom.Point;
import haxe.xml.Fast;
import openfl.Assets;
import spritesheet.data.BehaviorData;
import spritesheet.data.SpritesheetFrame;
import spritesheet.Spritesheet;


/**
* ...
* @author fermmm
*/
class SparrowImporter {
	
	
	/**
	* IMPORTANT: If the xml is made using Flash CS6 you need to change the codification to ANSI or UTF-8 Otherwise will throw a parsing related error. 
	* Open it with notepad++ and go to codification > convert to ANSI"
	* Use the first frame name of the xml when calling the behavior:
	*
	* sparrowAnimation.showBehavior ("Shape instance 10000");
	* 
	* @param	data
	* @param	assetDirectory
	* @return
	*/
	public static function parse (data:String, assetDirectory:String = ""):Spritesheet {
		
		var frames = new Array ();
		var behaviors = new Map <String, BehaviorData> ();
		var frameIndex = new Map <String, Int> ();
		
		var xml = Xml.parse (data);
		var spriteSheetNode = xml.firstElement();
		var behaviorFrames = new Array ();
		
		var firstFrameName = "";
		
		var i = 0;
		for (behaviorNode in spriteSheetNode.elements()) {
			
			var behaviorNodeFast = new Fast(behaviorNode);
			var frame = new SpritesheetFrame (
				Std.parseInt (behaviorNodeFast.att.x), 
				Std.parseInt (behaviorNodeFast.att.y), 
				Std.parseInt (behaviorNodeFast.att.width), 
				Std.parseInt (behaviorNodeFast.att.height)
			);

			if (behaviorNodeFast.has.name)
				frame.name = behaviorNodeFast.att.name;

			if (behaviorNodeFast.has.frameX)
			{
					frame.offsetX = Std.parseInt (behaviorNodeFast.att.frameX) * -1;
					frame.offsetY = Std.parseInt (behaviorNodeFast.att.frameY) * -1;
			}
			
			frameIndex.set (behaviorNodeFast.att.name, i);
			frames.push (frame);
			
			behaviorFrames.push (i);
			if (i == 0) firstFrameName = behaviorNodeFast.att.name;
			
			i++;
		}
		
		var behavior = new BehaviorData (firstFrameName, behaviorFrames);
		behaviors.set (firstFrameName, behavior);
		
		var spriteSheetNodeFast = new Fast (spriteSheetNode);
		var spriteSheet = new Spritesheet (frames, behaviors);

		return spriteSheet;
		
	}
	
	
}