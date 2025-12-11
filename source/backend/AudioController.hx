package backend;

import flixel.FlxG;
import flixel.system.FlxSound;

class AudioController {
    public static var inst:FlxSound;
    public static var voices:FlxSound;

    public static function load(instPath:String, voxPath:String) {
        inst = FlxG.sound.load(instPath, 1, false, false, true);
        voices = FlxG.sound.load(voxPath, 1, false, false, true);
    }

    public static function play() {
        inst.play();
        voices.play();
    }

    public static function stop() {
        inst.stop();
        voices.stop();
    }
}
