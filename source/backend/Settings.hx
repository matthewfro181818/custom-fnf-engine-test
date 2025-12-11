package backend;

import haxe.Json;
import sys.io.File;
import sys.FileSystem;

class Settings {
    public static var data:Dynamic = {
        volume: 1.0,
        downscroll: false,
        vsync: true,
        botplay: false
    };

    static var path = "save/settings.json";

    public static function load() {
        if (!FileSystem.exists(path)) save();
        data = Json.parse(File.getContent(path));
    }

    public static function save() {
        var json = Json.stringify(data, "\t");
        File.saveContent(path, json);
    }
}
