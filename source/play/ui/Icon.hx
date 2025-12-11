package play.ui;

import flixel.FlxSprite;

class Icon extends FlxSprite {
    public var charID:String;

    public function new(id:String) {
        super();
        charID = id;

        loadGraphic('mods/images/icons/$id.png', true, 150, 150);

        animation.add("normal", [0], 0, false);
        animation.add("winning", [1], 0, false);
        animation.add("danger",  [2], 0, false);

        animation.play("normal");
        scrollFactor.set(0, 0);
    }

    public function updateIcon(health:Float) {
        if (health < 0.25)
            animation.play("danger");
        else if (health > 0.75)
            animation.play("winning");
        else
            animation.play("normal");
    }
}
