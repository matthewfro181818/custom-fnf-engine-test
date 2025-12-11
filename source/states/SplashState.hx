package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class SplashState extends FlxState {
    var logo:FlxSprite;
    var title:FlxText;
    var version:FlxText;

    override public function create() {
        super.create();

        FlxG.cameras.bgColor = FlxColor.BLACK;

        // Logo (optional, replace with your own)
        logo = new FlxSprite().loadGraphic("assets/images/splashLogo.png");
        logo.screenCenter();
        logo.alpha = 0;
        add(logo);

        // Engine Name
        title = new FlxText(0, FlxG.height * 0.65, FlxG.width,
            "HYBRID FNF ENGINE", 24);
        title.alignment = "center";
        title.alpha = 0;
        add(title);

        // Version
        version = new FlxText(0, FlxG.height - 50, FlxG.width,
            "v1.0.0", 16);
        version.alignment = "center";
        version.alpha = 0;
        add(version);

        // Fade in
        FlxTween.tween(logo, { alpha: 1 }, 0.7);
        FlxTween.tween(title, { alpha: 1 }, 1.0);
        FlxTween.tween(version, { alpha: 1 }, 1.3);

        // Schedule exit
        FlxTween.delayedCall(2.5, fadeOut);
    }

    function fadeOut(_) {
        FlxTween.tween(logo, { alpha: 0 }, 0.7);
        FlxTween.tween(title, { alpha: 0 }, 0.7);
        FlxTween.tween(version, { alpha: 0 }, 0.7, {
            onComplete: (_) -> FlxG.switchState(new TitleState())
        });
    }
}
