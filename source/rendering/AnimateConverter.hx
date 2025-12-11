package rendering;

import flixel.graphics.frames.FlxAtlasFrames;

class AnimateConverter {
    public static function toAtlas(data:Dynamic, lib:Dynamic, base:String, isZip:Bool):FlxAtlasFrames {
        var frames = new FlxAtlasFrames(null, []);

        for (symbol in lib.symbols) {
            for (frameObj in symbol.frames) {
                frames.addSpriteFrame(
                    AnimateFrameExtractor.extractFrame(symbol, frameObj, base, isZip)
                );
            }
        }

        return frames;
    }
}
