package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

class OptionsState extends FlxState {
    var options = ["Downscroll", "Volume +", "Volume -"];
    var cur:Int = 0;

    override public function create() {
        super.create();
        drawOptions();
    }

    private function drawOptions() {
        for (i in 0...options.length) {
            var t = new FlxText(0, 200 + i * 40, FlxG.width, options[i], 32);
            t.alignment = "center";
            t.alpha = (i == cur ? 1 : 0.5);
            add(t);
        }
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.keys.justPressed.UP) cur = (cur + 2) % 3;
        if (FlxG.keys.justPressed.DOWN) cur = (cur + 1) % 3;

        if (FlxG.keys.justPressed.ENTER)
            applyOption();

        if (FlxG.keys.justPressed.ESCAPE)
            FlxG.switchState(new MainMenuState());
    }

    private function applyOption() {
        switch (cur) {
            case 0:
                FlxG.save.data.downscroll = !FlxG.save.data.downscroll;

            case 1:
                FlxG.sound.volume += 0.1;

            case 2:
                FlxG.sound.volume -= 0.1;
        }
    }
}
