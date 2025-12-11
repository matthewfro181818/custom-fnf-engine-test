package ui;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import backend.ModLoader;

class StoryMenuState extends FlxState {
    var weeks:Array<Dynamic> = [];

    override public function create() {
        super.create();

        add(new FlxText(0, 40, FlxG.width, "STORY MODE", 36).setFormat(null,36,0xFFFFFF,"center"));

        // Load all weeks from mod metadata
        for (mod in ModLoader.mods) {
            var meta = ModLoader.loadMetadata(mod);

            if (meta.weeks != null) 
                for (w in meta.weeks)
                    weeks.push({ name: w.name, mod: mod, songs: w.songs });
        }

        var y = 150;
        for (w in weeks) {
            var b = new FlxButton(FlxG.width/2 - 150, y, w.name, function(){
                FlxG.switchState(new WeekPlayState(w));
            });
            add(b);
            y += 70;
        }
    }
}
