package tools;

import sys.FileSystem;
import sys.io.File;

class ModTemplateGenerator {
    public static function generate(name:String) {
        var base = "mods/" + name + "/";
        FileSystem.createDirectory(base);
        FileSystem.createDirectory(base + "characters/");
        FileSystem.createDirectory(base + "images/");
        FileSystem.createDirectory(base + "scripts/");
        FileSystem.createDirectory(base + "stages/");
        FileSystem.createDirectory(base + "data/");

        File.saveContent(base + "metadata.json", 
            '{ "name":"'+name+'", "version":"1.0" }'
        );
    }
}
