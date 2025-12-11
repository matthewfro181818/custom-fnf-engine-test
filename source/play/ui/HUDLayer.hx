package play.ui;

import flixel.group.FlxSpriteGroup;

class HUDLayer extends FlxSpriteGroup {
    public var depth:Float = 0;

    public function new(d:Float) {
        super();
        depth = d;
    }

    public function updateHUD(elapsed:Float) {}
}
