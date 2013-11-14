package;

import flash.display.StageScaleMode;
import flash.display.StageAlign;
import flash.ui.Keyboard;
import flash.events.KeyboardEvent;
import flash.Lib;
import flash.events.Event;
import spritesheet.AnimatedSprite;
import spritesheet.data.BehaviorData;
import flash.display.BitmapData;
import openfl.Assets;
import spritesheet.importers.BitmapImporter;
import spritesheet.Spritesheet;
import flash.display.Sprite;

/**
 * Based on Fugo's Example
 * https://github.com/fugogugo/NMEspritesheetExample
 * @author Fugo
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
        var bitmap:BitmapData = Assets.getBitmapData("assets/kit_from_firefox.png");

        //Parse Spritesheet
        var spritesheet:Spritesheet = BitmapImporter.create( bitmap, 3, 9, 56, 80);

        //Setup Behaviors
        spritesheet.addBehavior(new BehaviorData("stand", [0, 1, 2], true, 6));
        spritesheet.addBehavior(new BehaviorData("down", [3, 4, 5], false, 10));
        spritesheet.addBehavior(new BehaviorData("jump", [6, 7, 8], false, 10));
        spritesheet.addBehavior(new BehaviorData("hit", [9, 10, 11], false, 10));
        spritesheet.addBehavior(new BehaviorData("punch", [12, 13, 14], false, 10));
        spritesheet.addBehavior(new BehaviorData("kick", [15, 16, 17], false, 10));
        spritesheet.addBehavior(new BehaviorData("flypunch", [18, 19, 20], false, 10));
        spritesheet.addBehavior(new BehaviorData("flykick", [21, 22, 23], false, 10));
        spritesheet.addBehavior(new BehaviorData("dizzy", [24, 25, 26], true, 6));

        animated = new AnimatedSprite(spritesheet, true);
        animated.showBehavior("stand");
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
            animated.showBehavior("stand");
            trace("stand");
        }
        if (e.keyCode == Keyboard.NUMBER_2) {
            animated.showBehavior("down");
            trace("down");
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
            animated.showBehavior("flypunch");
            trace("flypunch");
        }
        if (e.keyCode == Keyboard.NUMBER_8) {
            animated.showBehavior("flykick");
            trace("flykick");
        }
        if (e.keyCode == Keyboard.NUMBER_9) {
            animated.showBehavior("dizzy");
            trace("dizzy");
        }
        if (e.keyCode == Keyboard.NUMBER_0) {
            animated.showBehaviors(["down","jump","hit","punch"]);
            trace("down,jump,hit,punch");
        }
    }
}