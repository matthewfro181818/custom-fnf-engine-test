package ui;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

import backend.ModLoader;
import backend.ChartLoader;

class FreeplayState extends FlxState {
    var songs:Array<String> = [];

    override public function create() {
        super.create();

        add(new FlxText(0, 40, FlxG.width, "FREEPLAY", 36).setFormat(null,36,0xFFFFFF,"center"));

        loadSongs();

        var y = 140;
        for (song in songs) {
            var b = new FlxButton(FlxG.width/2 - 100, y, song, function(){
                FlxG.sound.play("assets/sounds/confirmMenu.ogg");
                FlxG.switchState(new PlayState({ songName: song, modName: findMod(song) }));
            });
            add(b);
            y += 60;
        }
    }

    function loadSongs() {
        for (mod in ModLoader.mods) {
            var path = "mods/" + mod + "/data/";
            var dirs = sys.FileSystem.readDirectory(path);

            for (d in dirs)
                if (sys.FileSystem.exists(path + d + "/" + d + ".json"))
                    songs.push(d);
        }
    }

    function findMod(song:String):String {
        for (mod in ModLoader.mods) {
            if (sys.FileSystem.exists("mods/" + mod + "/data/" + song))
                return mod;
        }
        return "exampleMod";
    }
}
