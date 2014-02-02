package spritesheet.importers;

import spritesheet.data.BehaviorData;
import flash.display.BitmapData;
import spritesheet.importers.TexturePackerImporter.TPFrame;
import haxe.Json;
import openfl.Assets;
import spritesheet.Spritesheet;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

/**
* Auto generated ExampleTest for MassiveUnit.
* This is an example test class can be used as a template for writing normal and async tests
* Refer to munit command line tool for more information (haxelib run munit)
*/
class TexturePackerImporterTest {

    inline static var testImageUrl:String = "assets/kitTpArray.png";

    private var _spritesheet:Spritesheet;
    private var _instance:TexturePackerImporter;
    private var _bitmap:BitmapData;

    @Before
    public function setup():Void {
        _bitmap = new BitmapData (256, 512, true, 0x00000000);
        _instance = new TexturePackerImporter();
    }

    @After
    public function tearDown():Void {
        _instance = null;
        _spritesheet = null;
    }

    @Test
    public function testParseShouldReturnSpriteSheet():Void {
        var returned:Dynamic = _instance.parse(_rawJsonSingleFrame, _bitmap);
        Assert.isTrue(Std.is(returned, spritesheet.Spritesheet));
    }

    @Test
    public function testParseShouldHaveExpectedBehaviorsAndFrames():Void {
        var exp:EReg = ~/.+(?=\/)/;
        _spritesheet = _instance.parse(_rawJson, _bitmap, exp);

        Assert.isTrue(_spritesheet.behaviors.exists("walk"));
        Assert.isTrue(_spritesheet.behaviors.exists("punch"));
        Assert.isFalse(_spritesheet.behaviors.exists("foo"));

        Assert.areEqual(6, _spritesheet.totalFrames);
    }

    @Test
    public function testParseShouldHaveNoBehaviorsButAllFrameWhenNoRegexIsUsed():Void {
        _spritesheet = _instance.parse(_rawJson, _bitmap );

        Assert.areEqual( 0, Lambda.count( _spritesheet.behaviors ) );
        Assert.isFalse(_spritesheet.behaviors.exists("walk"));
        Assert.isFalse(_spritesheet.behaviors.exists("punch"));
        Assert.isFalse(_spritesheet.behaviors.exists("foo"));

        Assert.areEqual(6, _spritesheet.totalFrames);
    }

    @Test
    public function testParseShouldHaveCorrectNumberOfFramesForBehavior():Void {
        var exp:EReg = ~/.+(?=\/)/;
        _spritesheet = _instance.parse(_rawJson, _bitmap, exp);

        Assert.isTrue(_spritesheet.behaviors.exists("punch"));

        var behavior:BehaviorData = _spritesheet.behaviors.get("punch");
        var frames:Array<Int> = behavior.frames;
        Assert.areEqual( 3, frames.length );
    }

    @Test
    public function testParseShouldHaveExpectedBehaviorsData():Void {
        var exp:EReg = ~/.+(?=\/)/;
        _spritesheet = _instance.parse(_rawJson, _bitmap, exp);

        var bd:BehaviorData = _spritesheet.behaviors.get("walk");
        Assert.isNotNull( bd );
    }

    @Test
    public function testParseShouldSetTrimmedDataAsOffset():Void {
        var json = Json.parse(_rawJsonSingleFrame);
        _spritesheet = _instance.parse( _rawJsonSingleFrame, _bitmap );

        var spriteFrame = _spritesheet.getFrame(0, false);
        Assert.isNotNull( spriteFrame );

        var blob = json.frames[0];
        Assert.areEqual( blob.frame.x, spriteFrame.x );
        Assert.areEqual( blob.frame.y, spriteFrame.y );
        Assert.areEqual( blob.frame.w, spriteFrame.width );
        Assert.areEqual( blob.frame.h, spriteFrame.height );
        Assert.areEqual( blob.spriteSourceSize.x, spriteFrame.offsetX );
        Assert.areEqual( blob.spriteSourceSize.y, spriteFrame.offsetY );
    }

    @Test
    public function testParseShouldSetNonTrimmedDataAsNotOffset():Void {
        var json = Json.parse(_rawJsonSingleFrameNonTrimmed);
        _spritesheet = _instance.parse( _rawJsonSingleFrameNonTrimmed, _bitmap );

        var spriteFrame = _spritesheet.getFrame(0, false);
        Assert.isNotNull( spriteFrame );

        var blob = json.frames[0];
        Assert.areEqual( blob.frame.x, spriteFrame.x );
        Assert.areEqual( blob.frame.y, spriteFrame.y );
        Assert.areEqual( blob.frame.w, spriteFrame.width );
        Assert.areEqual( blob.frame.h, spriteFrame.height );
        Assert.areEqual( 0, spriteFrame.offsetX );
        Assert.areEqual( 0, spriteFrame.offsetY );
    }

    @Test
    public function testParseJsonFrameShouldParseJsonCorrectly():Void {
        var json:Dynamic = Json.parse('{
            "filename": "punch/1.png",
            "frame": {"x":54,"y":210,"w":48,"h":64},
            "rotated": false,
            "trimmed": true,
            "spriteSourceSize": {"x":0,"y":15,"w":48,"h":64},
            "sourceSize": {"w":56,"h":80}
            }');
        var tpFrame:TPFrame = _instance.parseJsonFrame(json);
        Assert.areEqual(json.filename, tpFrame.filename);
        Assert.areEqual(json.rotated, tpFrame.rotated);
        Assert.areEqual(json.trimmed, tpFrame.trimmed);
        Assert.isTrue(rectsMatch(json.frame, tpFrame.frame));
        Assert.isTrue(rectsMatch(json.spriteSourceSize, tpFrame.spriteSourceSize));
        Assert.isTrue(sizeMatch(json.sourceSize, tpFrame.sourceSize));
    }

    private function rectsMatch(json:Dynamic, rect:Dynamic):Bool {
        return json.x == rect.x && json.y == rect.y && json.w == rect.w && json.h == rect.h;
    }

    private function sizeMatch(json:Dynamic, size:Dynamic):Bool {
        return json.w == size.w && json.h == size.h;
    }

    private function getFrameList(jsonString:String = null):Array<TPFrame> {
        jsonString = ( jsonString == null ) ? _rawJson : jsonString;
        var json = Json.parse(jsonString);
        return _instance.parseJsonFrames(json);
    }

    inline static var _rawJsonSingleFrame:String = '{"frames": [
    {
        "filename": "walk/1.png",
        "frame": {"x":114,"y":2,"w":54,"h":68},
        "rotated": false,
        "trimmed": true,
        "spriteSourceSize": {"x":0,"y":11,"w":54,"h":68},
        "sourceSize": {"w":56,"h":80}
    }]
    }';

    inline static var _rawJsonSingleFrameNonTrimmed:String = '{"frames": [
    {
        "filename": "walk/1.png",
        "frame": {"x":114,"y":2,"w":54,"h":68},
        "rotated": false,
        "trimmed": false,
        "spriteSourceSize": {"x":1,"y":11,"w":54,"h":68},
        "sourceSize": {"w":56,"h":80}
    }]
    }';

    inline static var _rawJson:String = '{"frames": [
    {
        "filename": "punch/1.png",
        "frame": {"x":54,"y":210,"w":48,"h":64},
        "rotated": false,
        "trimmed": true,
        "spriteSourceSize": {"x":0,"y":15,"w":48,"h":64},
        "sourceSize": {"w":56,"h":80}
    },
    {
        "filename": "punch/2.png",
        "frame": {"x":158,"y":262,"w":48,"h":64},
        "rotated": false,
        "trimmed": true,
        "spriteSourceSize": {"x":1,"y":15,"w":48,"h":64},
        "sourceSize": {"w":56,"h":80}
    },
    {
        "filename": "punch/3.png",
        "frame": {"x":2,"y":206,"w":50,"h":64},
        "rotated": false,
        "trimmed": true,
        "spriteSourceSize": {"x":1,"y":15,"w":50,"h":64},
        "sourceSize": {"w":56,"h":80}
    },
    {
        "filename": "walk/1.png",
        "frame": {"x":114,"y":2,"w":54,"h":68},
        "rotated": false,
        "trimmed": true,
        "spriteSourceSize": {"x":0,"y":11,"w":54,"h":68},
        "sourceSize": {"w":56,"h":80}
    },
    {
        "filename": "walk/2.png",
        "frame": {"x":58,"y":2,"w":54,"h":68},
        "rotated": false,
        "trimmed": true,
        "spriteSourceSize": {"x":0,"y":11,"w":54,"h":68},
        "sourceSize": {"w":56,"h":80}
    },
    {
        "filename": "walk/3.png",
        "frame": {"x":2,"y":2,"w":54,"h":68},
        "rotated": false,
        "trimmed": true,
        "spriteSourceSize": {"x":0,"y":11,"w":54,"h":68},
        "sourceSize": {"w":56,"h":80}
    }],
    "meta": {
        "app": "http://www.codeandweb.com/texturepacker ",
        "version": "1.0",
        "image": "kitTpArray.png",
        "format": "RGBA8888",
        "size": {"w":256,"h":512},
        "scale": "1"}
    }';

}