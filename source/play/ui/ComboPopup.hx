package play.ui;

import flixel.FlxText;
import flixel.tweens.FlxTween;

class ComboPopup extends FlxText {
    public static function spawn(ps:PlayState) {
        var t = new ComboPopup(ps.uiManager.combo);
        ps.add(t);
    }

    public function new(combo:Int) {
        super(800, 400, 0, "Combo " + combo, 32);
        scrollFactor.set();

        FlxTween.tween(this, { y: y - 40, alpha: 0 }, 0.5, {
            onComplete: _ -> kill()
        });
    }
}
