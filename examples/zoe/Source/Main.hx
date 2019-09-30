package;

import spritesheet.Spritesheet;
import spritesheet.importers.ZoeImporter;
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
 * ZoeImporter
 * @author Matthijs Kamstra aka [mck]
 * 
 * Based on Infinite's code
 * https://github.com/jgranick/spritesheet/tree/master/examples/texturepacker
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
		centerContent();
	}

	public function setupSpritsheet():Void
	{
		// Load Spritesheet Source (json file)
		var json = Assets.getText("assets/kit.json");

		var spritesheet:Spritesheet = ZoeImporter.parse(json, 'assets');

		// default the behaviour don't loop
		spritesheet.loopBehavior('walk');
		spritesheet.loopBehavior('idle');

		animated = new AnimatedSprite(spritesheet, true);
		addChild( animated );

		animated.showBehavior("walk");

		addEventListener(Event.ENTER_FRAME, onEnterFrame);
		stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);

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
			animated.showBehaviors(["walk","jump","hit","punch","idle"]);
			trace("walk,jump,hit,punch,idle");
		}
	}

}