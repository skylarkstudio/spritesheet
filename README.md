Spritesheet
===========

A useful and flexible sprite sheet library compatible with OpenFL which provides support for common sprite sheet importers.


Installation
------------

To install a release build:

    haxelib install spritesheet

To include Spritesheet in an OpenFL project, add `<haxelib name="spritesheet" />` to your project.xml.


Installing Samples
------------------
Spritesheet includes a number of samples which are located in a seperate _spritesheet-samples_ Haxelib which needs to be installed.

    haxelib install spritesheet-samples


Listing Samples
---------------
To list all the Spritesheet samples use the following command:

    lime create spritesheet


Creating Samples
----------------
If you find a sample you would like to create, you can create it using the "create" command:

    lime create spritesheet:Basics

This will create a copy of the sample within the current directory, using the same name as the sample. If you prefer, you can also specify a custom target directory:

    lime create spritesheet:Basics SpritesheetTest


Usage
-----

It's simple to get started!  To see your sprite animating you will need a bitmap, a Spritesheet, and a AnimatedSprite.

Get the BitmapData for your animation

    var bitmapData = Assets.getBitmapData("some_sprite_sheet.png");

Spritesheet includes some basic factory methods for common bitmap sprite sheets. This will seed the frames into the Spritesheet.

    var spritesheet:Spritesheet = BitmapImporter.create( bitmapData, 3, 9, 56, 80);

Behavior consisting of a name and the cells that should animate

    spritesheet.addBehavior( new BehaviorData("idle", [3, 4, 5], false, 15) );

AnimatedSprite sheet will be your view and is added to the stage

    var animated:AnimatedSprite = new AnimatedSprite(spritesheet, true)
    addChild( animated );
    
Tell the sprite what behavior to play

    animated.showBehavior("stand");

Finally, tell the sprite when to animate and the delta since the last update, in this case we'll be updating via Event.ENTER_FRAME.

    private function onEnterFrame(e:Event):Void
    {
		var time = Lib.getTimer();
		var delta = time - lastTime;
		animated.update(delta);
		lastTime = time;
    }


License
------------

Spritesheet is free, open-source software under the [MIT license](LICENSE.md).

Development Builds
------------

Clone the Spritesheet repository:

    git clone https://github.com/jgranick/spritesheet

Tell haxelib where your development copy of Spritesheet is installed:

    haxelib dev spritesheet spritesheet

To return to release builds:

    haxelib dev spritesheet
