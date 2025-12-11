package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.group.FlxGroup;
import sys.FileSystem;
import play.PlayState;

class FreeplayState extends FlxState {
    var songs:Array<String> = [];
    var cur:Int = 0;
    var items:FlxGroup;

    override public function create() {
        super.create();

        loadSongs();
        renderSongs();
    }

    private function loadSongs() {
        var mods = FileSystem.readDirectory("mods/");

        for (mod in mods) {
            if (!FileSystem.isDirectory("mods/" + mod)) continue;

            var dataFolder = "mods/" + mod + "/data/";
            if (!FileSystem.exists(dataFolder)) continue;

            var songFolders = FileSystem.readDirectory(dataFolder);
            for (song in songFolders) {
                songs.push(mod + "/" + song);
            }
        }
    }

    private function renderSongs() {
        items = new FlxGroup();

        for (i in 0...songs.length) {
            var t = new FlxText(0, 150 + i * 40, FlxG.width, songs[i], 24);
            t.alignment = "center";
            t.alpha = (i == cur ? 1 : 0.5);
            items.add(t);
        }

        add(items);
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.keys.justPressed.UP)    change(-1);
        if (FlxG.keys.justPressed.DOWN)  change(1);
        if (FlxG.keys.justPressed.ENTER) select();
    }

    private function change(v:Int) {
        cur = (cur + v + songs.length) % songs.length;

        var i = 0;
        for (t in items.members) {
            t.alpha = (i == cur ? 1 : 0.5);
            i++;
        }
    }

    private function select() {
        var path = songs[cur].split("/");
        var mod = path[0];
        var song = path[1];

        var ps = new PlayState();
        ps.modName = mod;
        ps.songName = song;
        FlxG.switchState(ps);
    }
}
