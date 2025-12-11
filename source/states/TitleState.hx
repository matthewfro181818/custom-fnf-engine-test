package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class TitleState extends FlxState {
    var logo:FlxSprite;
    var press:FlxText;
    var flashed:Bool = false;

    override public function create() {
        super.create();

        // Background
        FlxG.cameras.bgColor = FlxColor.BLACK;

        // Logo
        logo = new FlxSprite().loadGraphic("assets/images/logo.png");
        logo.screenCenter();
        add(logo);

        // Press Enter
        press = new FlxText(0, FlxG.height - 100, FlxG.width, "PRESS ENTER TO BEGIN", 24);
        press.alignment = "center";
        add(press);

        // Flash animation
        FlxTween.tween(press, { alpha: 0 }, 0.6, { type: PINGPONG });

        flashed = true;
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        if (flashed && FlxG.keys.justPressed.ENTER) {
            FlxG.switchState(new MainMenuState());
        }
    }
}
