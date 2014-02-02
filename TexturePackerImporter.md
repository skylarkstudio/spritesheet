# TexturePacker Importer for Spritesheet

The TexturePacker Importer supports the popular [TexturePacker](http://www.codeandweb.com/texturepacker) program but has no affiliation Code'n'Web.

## Usage

The TexturePacker importer is designed to import a json files with the `JSON (Array)` format, a bitmap, and a optional Regex Expression to automate the creation of Spritesheet Behaviors.

### TexturePacker TextureSettings

* Data Format should be `JSON (Array)`
* `Trim mode: Trim` IS supported and cells are correctly offset.
* `Allow Rotation` is NOT supported, make sure it is off (unchecked).

Export your JSON and PNG to your Assets folder.

> Hint: You can save room in your repo if you don't check-in the final atlas and just check in the .TPS files and cells

###  TextureSettings

Load your Spritesheet Source
```as3
var bitmapData = Assets.getBitmapData("some_sprite_sheet.png");
```

New a TexturePackerImporter and set the frameRate if you do not want the DEFAULT of 30 fps.
```as3
var tpParser = new TexturePackerImporter();
tpParser.frameRate = 12; //optional
```

Now create a REGEX matcher that will automatically convert your naming scheme into a behavior.  In my this example I have
a folder structure like this: animationName/frame#.png.  Thus my REGEX is set to grab the string before the first "/".  For
every REGEX match the importer will create a behavior and add all of the frames in order.

```as3
var exp:EReg = ~/.+(?=\/)/;
var sheet:Spritesheet = tpParser.parse( jsonString, bitmap, exp );
```

That's it!  You now have a sprite sheet with frames AND behaviors!

### Tweaking a behaviors

If you want to alter a behaviors frameRate or Looping you can access it via the Spritesheet.

```as3
sheet.behaviors.get("idle").loop = true;
```

###  No Behavior Parsing Option

If no REGEX is provided the Importer will not create any Behaviors yet all of the frames will be added and you can manually add the
behaviors to the Spritesheet.  The frame indexes should be in the same order of your json file.

```as3
var sheet:Spritesheet = tpParser.parse( jsonString, bitmap );
sheet.addBehavior( new BehaviorData("idle", [3, 4, 5], false, 15) );
```
