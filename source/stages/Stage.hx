package stages;

import flixel.group.FlxTypedGroup;
import flixel.FlxSprite;

class Stage {
    public var name:String;
    public var layers:Array<StageLayer> = [];
    public var onBeat:Void->Void = null;

    public function new(name:String) {
        this.name = name;
    }

    public function instantiate(ps:PlayState) {
        for (layer in layers)
            layer.instantiate(ps);
    }

    public function update(elapsed:Float) {
        for (layer in layers)
            layer.update(elapsed);
    }

    public function beatHit(curBeat:Int) {
        for (layer in layers)
            layer.beatHit(curBeat);
    }
}
