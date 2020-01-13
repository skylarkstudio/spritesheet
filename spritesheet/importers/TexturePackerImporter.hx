package spritesheet.importers;

import openfl.display.Tileset;
import openfl.geom.Rectangle;
import spritesheet.data.BehaviorData;
import haxe.ds.StringMap;
import spritesheet.data.SpritesheetFrame;
import flash.display.BitmapData;
import haxe.Json;

class TexturePackerImporter {

    public var frameRate:Int = 30;

    public function new() {}

    public function parse(path:String, bitmapData:BitmapData, exp:EReg = null):Spritesheet {

        var json = Json.parse(path);
        if (!Std.is(json.frames, Array))
        {
            trace("Converting json frames map to array...");
            json = convertFramesToArray(json);
        }

        var tpFrames:Array<TPFrame> = parseJsonFrames(json);
        var behaviorNames = buildBehaviorMap(tpFrames, exp);
        return generateSpriteSheetForBehaviors(bitmapData, behaviorNames);
    }

    private function convertFramesToArray(json:Dynamic):Dynamic
    {
        var newJson:Dynamic = {
            frames: [],
            meta: json.meta
        };

        for (field in Reflect.fields(json.frames))
        {
            var frame:Dynamic = Reflect.field(json.frames, field);
            frame.filename = field;
            newJson.frames.push(frame);
        }

        return newJson;
    }

    public function parseJsonFrames(json:Dynamic):Array<TPFrame> {

        var tpFrames:Array<TPFrame> = new Array<TPFrame>();

        for (frame in cast (json.frames, Array <Dynamic>)) {
            var curFrame:TPFrame = parseJsonFrame(frame);
            tpFrames.push(curFrame);
        }

        return tpFrames;
    }

    public function parseJsonFrame(json:Dynamic):TPFrame {

        var frame:TPFrame = new TPFrame();
        frame.filename = json.filename;
        frame.rotated = json.rotated;
        frame.trimmed = json.trimmed;
        frame.frame = parseJsonRect(json.frame);
        frame.spriteSourceSize = parseJsonRect(json.spriteSourceSize);
        frame.sourceSize = parseJsonSize(json.sourceSize);
        return frame;

    }

    private function parseJsonRect(json:Dynamic):TPRect {

        var rect:TPRect = new TPRect();
        rect.x = json.x;
        rect.y = json.y;
        rect.w = json.w;
        rect.h = json.h;
        return rect;

    }

    private function parseJsonSize(json:Dynamic):TPSize {

        var size:TPSize = new TPSize();
        size.w = json.w;
        size.h = json.h;
        return size;
    }

    private function buildBehaviorMap(frames:Array<TPFrame>, exp:EReg = null):StringMap<Array<TPFrame>> {

        exp = (exp == null) ? ~// : exp;
        var nameMap = new StringMap<Array<TPFrame>>();

        var count:Int = 0;

        for (frame in frames) {

            exp.match(frame.filename);
            var behaviorName:String = exp.matched(0);
            if (!nameMap.exists(behaviorName)) {

                nameMap.set(behaviorName, new Array<TPFrame>());
                count++;
            }

            var behaviors:Array<TPFrame> = nameMap.get(behaviorName);
            behaviors.push(frame);
        }

        if (count == 1)
        {
            var behaviorName:String = "default";
            nameMap.set(behaviorName, new Array<TPFrame>());

            for (frame in frames) {
                nameMap.get(behaviorName).push(frame);
            }
        }

        return nameMap;
    }

    private function generateSpriteSheetForBehaviors( bitmapData:BitmapData, behaviorNames:StringMap<Array<TPFrame>> ):Spritesheet
    {
        var allFrames = new Array<SpritesheetFrame>();
        var allBehaviors = new Map <String, BehaviorData>();
        var allRects = new Array<Rectangle>();

        for (key in behaviorNames.keys()) {

            var indexes = new Array<Int>();
            var frames = behaviorNames.get(key);

            for (i in 0...frames.length) {

                var tpFrame:TPFrame = frames[i];

                var w:Int = tpFrame.rotated ? tpFrame.frame.h : tpFrame.frame.w;
                var h:Int = tpFrame.rotated ? tpFrame.frame.w : tpFrame.frame.h;

                var sFrame = new SpritesheetFrame ( tpFrame.frame.x, tpFrame.frame.y, w, h );
                sFrame.id = i;

                if( tpFrame.trimmed )
                {

                    sFrame.offsetX = tpFrame.spriteSourceSize.x;
                    sFrame.offsetY = tpFrame.spriteSourceSize.y;

                }

                indexes.push(allFrames.length);
                allFrames.push(sFrame);
                allRects.push(new Rectangle(tpFrame.frame.x, tpFrame.frame.y, w, h));
            }

            if( isIgnoredBehavior(key) )
            {
                continue;
            }

            allBehaviors.set(key, new BehaviorData( key, indexes, false, frameRate ));

        }

        return new Spritesheet( new Tileset(bitmapData, allRects), allFrames, allBehaviors );

    }

    private function isIgnoredBehavior( key ):Bool
    {
        return key == "";
    }

}

class TPFrame {

    public function new():Void {}

    public var filename:String;
    public var frame:TPRect;
    public var rotated:Bool;
    public var trimmed:Bool;
    public var spriteSourceSize:TPRect;
    public var sourceSize:TPSize;

}

class TPRect {

    public function new():Void {}

    public var x:Int;
    public var y:Int;
    public var w:Int;
    public var h:Int;

}

class TPSize {

    public function new():Void {}

    public var w:Int;
    public var h:Int;

}