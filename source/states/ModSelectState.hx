package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import sys.FileSystem;

class ModSelectState extends FlxState {
    var mods:Array<String> = [];
    var cur:Int = 0;

    override public function create() {
        super.create();

        for (folder in FileSystem.readDirectory("mods/")) {
            if (FileSystem.isDirectory("mods/" + folder))
                mods.push(folder);
        }

        if (mods.length == 0)
            mods.push("No mods found!");

        draw();
    }

    private function draw() {
        for (i in 0...mods.length) {
            var t = new FlxText(0, 200 + i * 40, FlxG.width, mods[i], 32);
            t.alignment = "center";
            t.alpha = (i == cur ? 1 : 0.5);
            add(t);
        }
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.keys.justPressed.UP) cur = (cur + mods.length - 1) % mods.length;
        if (FlxG.keys.justPressed.DOWN) cur = (cur + 1) % mods.length;

        if (FlxG.keys.justPressed.ENTER)
            select();

        if (FlxG.keys.justPressed.ESCAPE)
            FlxG.switchState(new MainMenuState());
    }

    private function select() {
        FlxG.save.data.selectedMod = mods[cur];
        FlxG.switchState(new MainMenuState());
    }
}
