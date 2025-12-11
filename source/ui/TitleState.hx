package ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;

class TitleState extends FlxState {
    var logo:FlxSprite;
    var pressStart:FlxText;
    var started:Bool = false;

    override public function create() {
        super.create();

        FlxG.sound.playMusic("assets/music/titleTheme.ogg", 1.0);

        // Animated FNF style logo
        logo = new FlxSprite(0, 0, "assets/images/ui/title_logo.png");
        logo.screenCenter();
        add(logo);

        // Pulsing "Press Enter"
        pressStart = new FlxText(0, FlxG.height - 120, FlxG.width, "PRESS ENTER", 32);
        pressStart.alignment = "center";
        pressStart.alpha = 0;
        add(pressStart);

        FlxTween.tween(pressStart, { alpha: 1 }, 1.2, { type: FlxTween.PINGPONG });
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        // Quit instantly
        if (FlxG.keys.justPressed.ESCAPE)
            FlxG.game.close();

        // Start game
        if (!started && (FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE)) {
            started = true;
            FlxG.sound.play("assets/sounds/confirmMenu.ogg");
            FlxG.switchState(new MainMenuState());
        }
    }
}
