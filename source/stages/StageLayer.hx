package stages;

import flixel.FlxSprite;
import flixel.FlxG;

class StageLayer {
    public var sprite:FlxSprite;
    public var x:Float = 0;
    public var y:Float = 0;
    public var scrollX:Float = 1;
    public var scrollY:Float = 1;
    public var animated:Bool = false;
    public var animation:String = "";

    public function new() {}

    public function instantiate(ps:PlayState) {
        sprite.scrollFactor.set(scrollX, scrollY);
        sprite.x = x;
        sprite.y = y;
        ps.add(sprite);
    }

    public function update(elapsed:Float) {}

    public function beatHit(curBeat:Int) {
        if (animated && animation != "")
            sprite.animation.play(animation);
    }
}
