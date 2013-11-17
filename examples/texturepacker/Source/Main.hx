package;

import spritesheet.Spritesheet;
import spritesheet.importers.TexturePackerImporter;
import flash.display.StageScaleMode;
import flash.display.StageAlign;
import flash.ui.Keyboard;
import flash.events.KeyboardEvent;
import flash.Lib;
import flash.events.Event;
import spritesheet.AnimatedSprite;
import flash.display.BitmapData;
import openfl.Assets;
import flash.display.Sprite;

/**
 * TexturePackerImporter
 * @author infinite
 * 
 * Based on Fugo's spritesheet
 * https://github.com/fugogugo/NMEspritesheetExample
 */
class Main extends Sprite
{
    var inited:Bool;
    var lastTime:Int = 0;
    var animated:AnimatedSprite;

    public function new()
    {
        super();

        stage.align = StageAlign.TOP_LEFT;
        stage.scaleMode = StageScaleMode.NO_SCALE;

        setupSpritsheet();
    }

    public function setupSpritsheet():Void
    {
        //Load Spritesheet Source
        var bitmap:BitmapData = Assets.getBitmapData("assets/kitTpArray.png");

        //Parse Spritesheet
        var jsonString:String  = tempJson;
        var tpParser = new TexturePackerImporter();
        tpParser.frameRate = 6;

        var exp:EReg = ~/.+(?=\/)/;
        var sheet:Spritesheet = tpParser.parse( jsonString, bitmap, exp );

        //tweak behaviors
        sheet.behaviors.get("idle").loop = true;

        animated = new AnimatedSprite(sheet, true);
        animated.showBehavior("idle");
        //animated.showBehaviors(["down","jump","hit","punch"]);

        addChild(animated);

        stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
        stage.addEventListener(Event.RESIZE, resize);
        addEventListener(Event.ENTER_FRAME, onEnterFrame);
        centerContent();

        trace("keys:1,2,3,4,5,6,7,8,9,0");
    }

    private function centerContent():Void
    {
        animated.x = stage.stageWidth / 2-animated.width/2;
        animated.y = stage.stageHeight / 2-animated.height/2;
    }

    private function onEnterFrame(e:Event):Void
    {
        var time = Lib.getTimer();
        var delta = time - lastTime;
        animated.update(delta);
        lastTime = time;
    }

    private function resize(e:Event)
    {
        centerContent();
    }

    private function onKeyUp(e:KeyboardEvent):Void
    {
        if (e.keyCode == Keyboard.NUMBER_1) {
            animated.showBehavior("idle");
            trace("idle");
        }
        if (e.keyCode == Keyboard.NUMBER_2) {
            animated.showBehavior("walk");
            trace("walk");
        }
        if (e.keyCode == Keyboard.NUMBER_3) {
            animated.showBehavior("jump");
            trace("jump");
        }
        if (e.keyCode == Keyboard.NUMBER_4) {
            animated.showBehavior("hit");
            trace("hit");
        }
        if (e.keyCode == Keyboard.NUMBER_5) {
            animated.showBehavior("punch");
            trace("punch");
        }
        if (e.keyCode == Keyboard.NUMBER_6) {
            animated.showBehavior("kick");
            trace("kick");
        }
        if (e.keyCode == Keyboard.NUMBER_7) {
            animated.showBehavior("airpunch");
            trace("airpunch");
        }
        if (e.keyCode == Keyboard.NUMBER_8) {
            animated.showBehavior("airkick");
            trace("airkick");
        }
        if (e.keyCode == Keyboard.NUMBER_9) {
            animated.showBehavior("ko");
            trace("ko");
        }
        if (e.keyCode == Keyboard.NUMBER_0) {
            animated.showBehaviors(["walk","jump","hit","punch"]);
            trace("walk,jump,hit,punch");
        }
    }

    inline static var tempJson:String = '{"frames": [
    {
        "filename": "airkick/1.png",
        "frame": {"x":2,"y":404,"w":46,"h":66},
        "rotated": false,
        "trimmed": true,
        "spriteSourceSize": {"x":2,"y":3,"w":46,"h":66},
        "sourceSize": {"w":56,"h":80}
    },
    {
        "filename": "airkick/2.png",
        "frame": {"x":166,"y":132,"w":52,"h":62},
        "rotated": false,
        "trimmed": true,
        "spriteSourceSize": {"x":2,"y":4,"w":52,"h":62},
        "sourceSize": {"w":56,"h":80}
    },
    {
        "filename": "airkick/3.png",
        "frame": {"x":2,"y":72,"w":54,"h":62},
        "rotated": false,
        "trimmed": true,
        "spriteSourceSize": {"x":1,"y":4,"w":54,"h":62},
        "sourceSize": {"w":56,"h":80}
    },
    {
        "filename": "airpunch/1.png",
        "frame": {"x":100,"y":406,"w":40,"h":76},
        "rotated": false,
        "trimmed": true,
        "spriteSourceSize": {"x":7,"y":2,"w":40,"h":76},
        "sourceSize": {"w":56,"h":80}
    },
    {
        "filename": "airpunch/2.png",
        "frame": {"x":212,"y":196,"w":42,"h":72},
        "rotated": false,
        "trimmed": true,
        "spriteSourceSize": {"x":7,"y":2,"w":42,"h":72},
        "sourceSize": {"w":56,"h":80}
    },
    {
        "filename": "airpunch/3.png",
        "frame": {"x":56,"y":142,"w":50,"h":66},
        "rotated": false,
        "trimmed": true,
        "spriteSourceSize": {"x":1,"y":3,"w":50,"h":66},
        "sourceSize": {"w":56,"h":80}
    },
    {
        "filename": "block/1.png",
        "frame": {"x":112,"y":72,"w":52,"h":68},
        "rotated": false,
        "trimmed": true,
        "spriteSourceSize": {"x":3,"y":11,"w":52,"h":68},
        "sourceSize": {"w":56,"h":80}
    },
    {
        "filename": "block/2.png",
        "frame": {"x":2,"y":136,"w":52,"h":68},
        "rotated": false,
        "trimmed": true,
        "spriteSourceSize": {"x":3,"y":11,"w":52,"h":68},
        "sourceSize": {"w":56,"h":80}
    },
    {
        "filename": "block/3.png",
        "frame": {"x":58,"y":72,"w":52,"h":68},
        "rotated": false,
        "trimmed": true,
        "spriteSourceSize": {"x":3,"y":11,"w":52,"h":68},
        "sourceSize": {"w":56,"h":80}
    },
    {
        "filename": "hit/1.png",
        "frame": {"x":52,"y":342,"w":46,"h":66},
        "rotated": false,
        "trimmed": true,
        "spriteSourceSize": {"x":2,"y":10,"w":46,"h":66},
        "sourceSize": {"w":56,"h":80}
    },
    {
        "filename": "hit/2.png",
        "frame": {"x":108,"y":208,"w":48,"h":66},
        "rotated": false,
        "trimmed": true,
        "spriteSourceSize": {"x":2,"y":11,"w":48,"h":66},
        "sourceSize": {"w":56,"h":80}
    },
    {
        "filename": "hit/3.png",
        "frame": {"x":102,"y":338,"w":46,"h":66},
        "rotated": false,
        "trimmed": true,
        "spriteSourceSize": {"x":3,"y":11,"w":46,"h":66},
        "sourceSize": {"w":56,"h":80}
    },
    {
        "filename": "idle/1.png",
        "frame": {"x":2,"y":338,"w":48,"h":64},
        "rotated": false,
        "trimmed": true,
        "spriteSourceSize": {"x":0,"y":15,"w":48,"h":64},
        "sourceSize": {"w":56,"h":80}
    },
    {
        "filename": "idle/2.png",
        "frame": {"x":52,"y":276,"w":48,"h":64},
        "rotated": false,
        "trimmed": true,
        "spriteSourceSize": {"x":0,"y":15,"w":48,"h":64},
        "sourceSize": {"w":56,"h":80}
    },
    {
        "filename": "idle/3.png",
        "frame": {"x":200,"y":350,"w":46,"h":64},
        "rotated": false,
        "trimmed": true,
        "spriteSourceSize": {"x":2,"y":15,"w":46,"h":64},
        "sourceSize": {"w":56,"h":80}
    },
    {
        "filename": "jump/1.png",
        "frame": {"x":152,"y":328,"w":46,"h":72},
        "rotated": false,
        "trimmed": true,
        "spriteSourceSize": {"x":4,"y":6,"w":46,"h":72},
        "sourceSize": {"w":56,"h":80}
    },
    {
        "filename": "jump/2.png",
        "frame": {"x":208,"y":270,"w":46,"h":78},
        "rotated": false,
        "trimmed": true,
        "spriteSourceSize": {"x":1,"y":0,"w":46,"h":78},
        "sourceSize": {"w":56,"h":80}
    },
    {
        "filename": "jump/3.png",
        "frame": {"x":160,"y":196,"w":50,"h":64},
        "rotated": false,
        "trimmed": true,
        "spriteSourceSize": {"x":3,"y":2,"w":50,"h":64},
        "sourceSize": {"w":56,"h":80}
    },
    {
        "filename": "kick/1.png",
        "frame": {"x":2,"y":338,"w":48,"h":64},
        "rotated": false,
        "trimmed": true,
        "spriteSourceSize": {"x":0,"y":15,"w":48,"h":64},
        "sourceSize": {"w":56,"h":80}
    },
    {
        "filename": "kick/2.png",
        "frame": {"x":2,"y":272,"w":48,"h":64},
        "rotated": false,
        "trimmed": true,
        "spriteSourceSize": {"x":1,"y":15,"w":48,"h":64},
        "sourceSize": {"w":56,"h":80}
    },
    {
        "filename": "kick/3.png",
        "frame": {"x":108,"y":142,"w":50,"h":64},
        "rotated": false,
        "trimmed": true,
        "spriteSourceSize": {"x":0,"y":15,"w":50,"h":64},
        "sourceSize": {"w":56,"h":80}
    },
    {
        "filename": "kick/4.png",
        "frame": {"x":170,"y":2,"w":54,"h":64},
        "rotated": false,
        "trimmed": true,
        "spriteSourceSize": {"x":0,"y":15,"w":54,"h":64},
        "sourceSize": {"w":56,"h":80}
    },
    {
        "filename": "ko/1.png",
        "frame": {"x":170,"y":68,"w":54,"h":62},
        "rotated": false,
        "trimmed": true,
        "spriteSourceSize": {"x":1,"y":18,"w":54,"h":62},
        "sourceSize": {"w":56,"h":80}
    },
    {
        "filename": "ko/2.png",
        "frame": {"x":102,"y":276,"w":48,"h":60},
        "rotated": false,
        "trimmed": true,
        "spriteSourceSize": {"x":4,"y":20,"w":48,"h":60},
        "sourceSize": {"w":56,"h":80}
    },
    {
        "filename": "ko/3.png",
        "frame": {"x":150,"y":402,"w":44,"h":60},
        "rotated": false,
        "trimmed": true,
        "spriteSourceSize": {"x":5,"y":20,"w":44,"h":60},
        "sourceSize": {"w":56,"h":80}
    },
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
        "scale": "1"
    }
    }
    ';
}