package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxState;
import flixel.group.FlxGroup;

class MainMenuState extends FlxState {
    var options = ["FREEPLAY", "OPTIONS", "MODS"];
    var cur:Int = 0;
    var menu:FlxGroup;

    override public function create() {
        super.create();

        menu = new FlxGroup();

        for (i in 0...options.length) {
            var t = new FlxText(0, 200 + i * 60, FlxG.width, options[i], 32);
            t.alignment = "center";
            t.alpha = (i == cur ? 1 : 0.5);
            menu.add(t);
        }

        add(menu);
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.keys.justPressed.UP)    change(-1);
        if (FlxG.keys.justPressed.DOWN)  change(1);

        if (FlxG.keys.justPressed.ENTER)
            select();
    }

    private function change(v:Int) {
        cur = (cur + v + options.length) % options.length;
        var i = 0;
        for (t in menu.members) {
            t.alpha = (i == cur ? 1 : 0.5);
            i++;
        }
    }

    private function select() {
        switch (options[cur]) {
            case "FREEPLAY": FlxG.switchState(new FreeplayState());
            case "OPTIONS":  FlxG.switchState(new OptionsState());
            case "MODS":     FlxG.switchState(new ModSelectState());
        }
    }
}
