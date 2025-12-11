package play.ui;

import flixel.FlxSprite;
import flixel.tweens.FlxTween;

class RatingPopup extends FlxSprite {
    public static function spawn(ps:PlayState, rating:String) {
        var pop = new RatingPopup(rating);
        ps.add(pop);
    }

    public function new(rating:String) {
        super(800, 300);

        loadGraphic('mods/images/ratings/$rating.png');
        scrollFactor.set();

        FlxTween.tween(this, { alpha: 0 }, 0.5, {
            onComplete: _ -> this.kill()
        });
    }
}
