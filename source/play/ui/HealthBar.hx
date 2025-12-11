package play.ui;

import flixel.FlxSprite;
import flixel.FlxG;

class HealthBar extends FlxSprite {
    public var health:Float = 0.5;

    public var colorP1:Int = 0xFF00FF00;
    public var colorP2:Int = 0xFFFF0000;

    public function new(ps:PlayState) {
        super(0, FlxG.height * 0.9);

        makeGraphic(400, 20, 0xFF000000);
        scrollFactor.set();
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
    }
}
