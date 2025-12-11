package objects;

import rendering.AtlasLoader;

class AtlasCharacter extends Character {
    public function new(json:Dynamic) {
        super();

        frames = AtlasLoader.load(json.image);

        for (a in json.animations) {
            animation.addByPrefix(a.anim, a.prefix, a.fps, a.loop);
        }

        playAnim(json.defaultAnim);
    }
}
