# Spritesheet

Spritesheet is a animation library for animating bitmap sequences in a Haxe projects.  Provides support for common sprite sheet importers.

## Installation

To install a release build:
	
	haxelib install spritesheet
	
If you prefer to use development builds:
	
	git clone https://github.com/jgranick/spritesheet
	haxelib dev spritesheet spritesheet

To include Spritesheet in an OpenFL project, add `<haxelib name="spritesheet" />` to your project.xml.

## Usage

It's simple to get started!  To see your sprite animating you will need a bitmap, a Spritesheet, and a AnimatedSprite.

Get the BitmapData for your animation
```as3
var bitmapData = Assets.getBitmapData("some_sprite_sheet.png");
```

Spritesheet includes some basic factory methods for common bitmap sprite sheets. This will seed the frames into the Spritesheet.
```as3
var spritesheet:Spritesheet = BitmapImporter.create( bitmapData, 3, 9, 56, 80);
```

Behavior consisting of a name and the cells that should animate
```as3
spritesheet.addBehavior( new BehaviorData("idle", [3, 4, 5], false, 15) );
```

AnimatedSprite sheet will be your view and is added to the stage
```as3
var animated:AnimatedSprite = new AnimatedSprite(spritesheet, true)
addChild( animated );
```

Tell the sprite what behavior to play
```as3
animated.showBehavior("stand");
```
Finally, tell the sprite when to animate and the delta since the last update, in this case we'll be updating via Event.ENTER_FRAME.
```as3
private function onEnterFrame(e:Event):Void
{
 var time = Lib.getTimer();
 var delta = time - lastTime;
 animated.update(delta);
 lastTime = time;
}
```