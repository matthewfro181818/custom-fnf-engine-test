package objects;

import rendering.AnimateLoader;

class AnimateCharacter extends Character {
    public function new(json:Dynamic) {
        super();

        frames = AnimateLoader.load(json.source);

        for (a in json.animations) {
            animation.add(a.anim, a.frames, a.fps, a.loop);
        }

        playAnim(json.defaultAnim);
    }
}
