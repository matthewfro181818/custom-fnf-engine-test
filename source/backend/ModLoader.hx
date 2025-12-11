package backend;

import sys.FileSystem;
import haxe.Json;

class ModLoader {
    public static var mods:Array<String> = [];

    public static function scanMods() {
        mods = [];
        for (folder in FileSystem.readDirectory("mods")) {
            var path = "mods/" + folder + "/metadata.json";
            if (FileSystem.exists(path)) {
                mods.push(folder);
            }
        }
    }

    public static function loadMetadata(mod:String):Dynamic {
        var path = "mods/" + mod + "/metadata.json";
        var raw = sys.io.File.getContent(path);
        return Json.parse(raw);
    }
}
