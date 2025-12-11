package play.ui;

import flixel.FlxText;
import flixel.FlxG;

class BotplayText extends FlxText {
    public function new() {
        super(FlxG.width / 2 - 100, FlxG.height * 0.05, 200, "BOTPLAY", 32);

        alpha = 0.8;
        scrollFactor.set();
    }
}
