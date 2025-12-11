package rendering;

import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.Assets;

class AtlasLoader {
    public static function load(name:String):FlxAtlasFrames {
        var png = 'mods/images/$name.png';
        var json = 'mods/images/$name.json';
        return FlxAtlasFrames.fromTexturePackerJson(png, json);
    }
}
