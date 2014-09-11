package spritesheet.importers;

import spritesheet.data.BehaviorData;
import haxe.ds.StringMap;
import spritesheet.data.SpritesheetFrame;
import flash.display.BitmapData;
import haxe.Json;
using StringTools;

class LibgdxImporter {

    public var frameRate:Int = 30;

    public function new() {}

    public function parse(data:String, bitmapData:BitmapData, exp:EReg = null):Spritesheet {

        var lines = data.split("\n");
        var gdxFrames:Array<GdxFrame> = parseFrames(lines.filter(function(s) {return s.length != 0;}));
        var behaviorNames = buildBehaviorMap(gdxFrames, exp);
        return generateSpriteSheetForBehaviors(bitmapData, behaviorNames);

    }

    public function parseFrames(lines:Array<String>):Array<GdxFrame> {
      var gdxFrames:Array<GdxFrame> = new Array<GdxFrame>();

      var frameStartLine : Int = 0;
      var frameStopLine : Int = 0;
      // FInd first frame ...
      for (i in 1...lines.length) {
        if (lines[i].charAt(0) == " " || lines[i].charAt(0) == "\t" ) {
          frameStartLine = i-1;
          break;
        }
      }
      // Iterate over all frames ...
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
        var curFrame:GdxFrame = parseFrame(lines[frameStartLine], [for (i in (frameStartLine+1)...frameStopLine) lines[i].trim()]);
        gdxFrames.push(curFrame);

        // Update start line and continue
        frameStartLine = frameStopLine;
      }
      return gdxFrames;
    }

      public function parseFrame(name:String, os:Array<String>):GdxFrame {
        // Make option/value pairs
        var options = new Map<String,String>();
        for (o in os) {
          var tmp = o.split(":");
          if (tmp.length != 2) throw "Invalid libgdx file";
          options.set(tmp[0].trim(),tmp[1].trim());
        }

        var frame:GdxFrame = new GdxFrame();
        frame.filename = name;
        frame.rotate = (options.get("rotate").toLowerCase() == "true")?true:false;
        frame.xy = parseGdxPos(options.get("xy"));
        frame.size = parseGdxSize(options.get("size"));
        frame.orig = parseGdxSize(options.get("orig"));
        frame.offset = parseGdxPos(options.get("offset"));
        frame.index = Std.parseInt(options.get("index"));
        return frame;
    }

    private function parseGdxSize(string:String):GdxSize {
        var size:GdxSize = new GdxSize();
        var tmp = string.split(",");
        size.w = Std.parseInt(tmp[0]);
        size.h = Std.parseInt(tmp[1]);
        return size;
    }
    private function parseGdxPos(string:String):GdxPos {
        var pos:GdxPos = new GdxPos();
        var tmp = string.split(",");
        pos.x = Std.parseInt(tmp[0]);
        pos.y = Std.parseInt(tmp[1]);
        return pos;
    }

    private function buildBehaviorMap(frames:Array<GdxFrame>, exp:EReg = null):StringMap<Array<GdxFrame>> {

        exp = (exp == null) ? ~// : exp;
        var nameMap = new StringMap<Array<GdxFrame>>();

        for (frame in frames) {

            exp.match(frame.filename);
            var behaviorName:String = exp.matched(0);
            if (!nameMap.exists(behaviorName)) {

                nameMap.set(behaviorName, new Array<GdxFrame>());

            }

            var behaviors:Array<GdxFrame> = nameMap.get(behaviorName);
            behaviors.push(frame);
        }

        return nameMap;
    }

    private function generateSpriteSheetForBehaviors( bitmapData:BitmapData, behaviorNames:StringMap<Array<GdxFrame>> ):Spritesheet
    {
        var allFrames = new Array<SpritesheetFrame>();
        var allBehaviors = new Map <String, BehaviorData>();

        for (key in behaviorNames.keys()) {

            var indexes = new Array<Int>();
            var frames = behaviorNames.get(key);

            for (i in 0...frames.length) {
                var gdxFrame:GdxFrame = frames[i];
                var sFrame = new SpritesheetFrame ( gdxFrame.xy.x, gdxFrame.xy.y, gdxFrame.size.w, gdxFrame.size.h, gdxFrame.offset.x, gdxFrame.offset.y);
                sFrame.name = gdxFrame.filename;

                indexes.push(allFrames.length);
                allFrames.push(sFrame);
            }

            if( isIgnoredBehavior(key) )
            {
                continue;
            }

            allBehaviors.set(key, new BehaviorData( key, indexes, false, frameRate ));

        }

        return new Spritesheet( bitmapData, allFrames, allBehaviors);

    }

    private function isIgnoredBehavior( key ):Bool
    {
        return key == "";
    }

}

private class GdxFrame {
    public function new():Void {}

    public var filename:String;
    public var xy:GdxPos;
    public var rotate:Bool;
    public var size:GdxSize;
    public var orig:GdxSize;
    public var offset:GdxPos;
    public var index:Int;
}

private class GdxPos {
    public function new():Void {}
    public var x : Int;
    public var y : Int;
}

private class GdxSize {

    public function new():Void {}
    public var w : Int;
    public var h : Int;
}
