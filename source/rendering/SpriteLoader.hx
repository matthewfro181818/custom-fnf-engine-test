package rendering;

import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.Assets;

class SpriteLoader {
    public static function load(name:String):FlxAtlasFrames {
        var png = 'mods/images/$name.png';
        var xml = 'mods/images/$name.xml';

        return FlxAtlasFrames.fromSparrow(png, xml);
    }
}
