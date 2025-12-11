package rendering;

import haxe.zip.Reader;
import sys.FileSystem;
import sys.io.File;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.display.BitmapData;

class AnimateLoader {
    public static function load(path:String):FlxAtlasFrames {
        var isZip = path.endsWith(".zip");

        var data:Dynamic;
        var lib:Dynamic;

        if (isZip) {
            var zip = new Reader(File.read(path, true));
            data = haxe.Json.parse(zip.unzip("data.json"));
            lib  = haxe.Json.parse(zip.unzip("library.json"));
        } else {
            data = haxe.Json.parse(File.getContent(path + "/data.json"));
            lib  = haxe.Json.parse(File.getContent(path + "/library.json"));
        }

        return AnimateConverter.toAtlas(data, lib, path, isZip);
    }
}
