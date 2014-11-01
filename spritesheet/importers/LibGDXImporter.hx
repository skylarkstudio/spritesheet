package spritesheet.importers;



import flash.display.BitmapData;
import haxe.Json;
import spritesheet.data.BehaviorData;
import spritesheet.data.SpritesheetFrame;
using StringTools;


class LibGDXImporter {
	
	
	public var frameRate:Int = 30;
	
	
	public function new () {
		
		
		
	}
	
	
	private function buildBehaviorMap(frames:Array<GDXFrame>, exp:EReg = null):Map<String, Array<GDXFrame>> {
		
		exp = (exp == null) ? ~// : exp;
		var nameMap = new Map<String, Array<GDXFrame>>();
		
		for (frame in frames) {
			
			exp.match (frame.filename);
			var behaviorName = exp.matched (0);
			
			if (!nameMap.exists (behaviorName)) {
				
				nameMap.set (behaviorName, new Array<GDXFrame> ());
				
			}
			
			var behaviors = nameMap.get (behaviorName);
			behaviors.push (frame);
			
		}
		
		return nameMap;
		
	}
	
	
	private function generateSpriteSheetForBehaviors (bitmapData:BitmapData, behaviorNames:Map<String, Array<GDXFrame>>):Spritesheet {
		
		var allFrames = new Array<SpritesheetFrame>();
		var allBehaviors = new Map <String, BehaviorData>();
		
		for (key in behaviorNames.keys ()) {
			
			var indexes = new Array<Int> ();
			var frames = behaviorNames.get (key);
			
			for (i in 0...frames.length) {
				
				var gdxFrame = frames[i];
				var sFrame = new SpritesheetFrame (gdxFrame.xy.x, gdxFrame.xy.y, gdxFrame.size.w, gdxFrame.size.h, gdxFrame.offset.x, gdxFrame.offset.y);
				sFrame.name = gdxFrame.filename;
				
				indexes.push (allFrames.length);
				allFrames.push (sFrame);
				
			}
			
			if (isIgnoredBehavior (key)) {
				
				continue;
				
			}
			
			allBehaviors.set (key, new BehaviorData (key, indexes, false, frameRate));
			
		}
		
		return new Spritesheet (bitmapData, allFrames, allBehaviors);
		
	}
	
	
	private function isIgnoredBehavior (key):Bool {
		
		return key == "";
		
	}
	
	
	public function parse (data:String, bitmapData:BitmapData, exp:EReg = null):Spritesheet {

		var lines = data.split ("\n");
		var gdxFrames = parseFrames (lines.filter (function (s) { return s.length != 0; }));
		var behaviorNames = buildBehaviorMap (gdxFrames, exp);
		return generateSpriteSheetForBehaviors (bitmapData, behaviorNames);
		
	}
	
	
	public function parseFrame (name:String, os:Array<String>):GDXFrame {
		
		// Make option/value pairs
		var options = new Map<String,String> ();
		
		for (o in os) {
			
			var tmp = o.split (":");
			if (tmp.length != 2) throw "Invalid libGDX file";
			options.set (tmp[0].trim (), tmp[1].trim ());
		  	
		}
		
		var frame = new GDXFrame ();
		frame.filename = name;
		frame.rotate = (options.get ("rotate").toLowerCase () == "true") ? true : false;
		frame.xy = parseGDXPos (options.get ("xy"));
		frame.size = parseGDXSize (options.get ("size"));
		frame.orig = parseGDXSize (options.get ("orig"));
		frame.offset = parseGDXPos (options.get ("offset"));
		frame.index = Std.parseInt (options.get ("index"));
		return frame;
		
	}
	
	
	public function parseFrames (lines:Array<String>):Array<GDXFrame> {
		
		var gdxFrames = new Array<GDXFrame> ();
		
		var frameStartLine = 0;
		var frameStopLine = 0;
		
		// Find first frame
		for (i in 1...lines.length) {
			
			if (lines[i].charAt(0) == " " || lines[i].charAt(0) == "\t" ) {
				
				frameStartLine = i - 1;
				break;
				
			}
			
		}
		
		// Iterate over all frames
		while (frameStartLine < lines.length) {
			
			// Find end line
			frameStopLine = lines.length; // If the loop does not break, this is the wanted value
			
			for (i in (frameStartLine+1)...lines.length) {
				
				if (lines[i].charAt(0) != " " && lines[i].charAt(0) != "\t" ) {
					
					frameStopLine = i;
					break;
					
				}
				
			}
			
			// Are we still valid ...?
			if (frameStopLine > lines.length) {
				
				break;
				
			}
			
			// Parse the frame ...
			var curFrame = parseFrame (lines[frameStartLine], [ for (i in (frameStartLine + 1)...frameStopLine) lines[i].trim () ]);
			gdxFrames.push (curFrame);
			
			// Update start line and continue
			frameStartLine = frameStopLine;
			
		}
		
		return gdxFrames;
		
	}
	
	
	private function parseGDXPos (string:String):GDXPos {
		
		var pos = new GDXPos ();
		var tmp = string.split (",");
		pos.x = Std.parseInt (tmp[0]);
		pos.y = Std.parseInt (tmp[1]);
		return pos;
		
	}
	
	  

	private function parseGDXSize (string:String):GDXSize {
		
		var size = new GDXSize ();
		var tmp = string.split (",");
		size.w = Std.parseInt (tmp[0]);
		size.h = Std.parseInt (tmp[1]);
		return size;
		
	}
	
	
}


private class GDXFrame {
	
	
	public var filename:String;
	public var index:Int;
	public var offset:GDXPos;
	public var orig:GDXSize;
	public var rotate:Bool;
	public var size:GDXSize;
	public var xy:GDXPos;
	
	
	public function new () {
		
		
		
	}
	
	
}


private class GDXPos {
	
	
	public var x:Int;
	public var y:Int;
	
	
	public function new () {
		
		
		
	}
	
	
}


private class GDXSize {
	
	
	public var h:Int;
	public var w:Int;
	
	
	public function new () {
		
		
		
	}
	
	
}
