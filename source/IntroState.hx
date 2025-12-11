package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;

class IntroState extends FlxState {
    override public function create() {
        super.create();

        var text = new FlxText(0, FlxG.height/2 - 20, FlxG.width, "HYBRID ENGINE", 32);
        text.alignment = "center";
        add(text);

        FlxG.sound.playMusic("assets/music/intro.ogg");

        new flixel.util.FlxTimer().start(2.0, function(_) {
            FlxG.switchState(new TitleState());
        });
    }
}
