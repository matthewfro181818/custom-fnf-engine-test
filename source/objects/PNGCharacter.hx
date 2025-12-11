package objects;

import rendering.SpriteLoader;

class PNGCharacter extends Character {
    public var anims:Dynamic;

    public function new(json:Dynamic) {
        super();

        frames = SpriteLoader.load(json.image);

        for (a in json.animations) {
            animation.add(a.anim, a.frames, a.fps, a.loop);
        }

        playAnim(json.defaultAnim);
    }

    override function playAnim(name:String) {
        animation.play(name, true);
    }
}
