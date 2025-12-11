package play;

import flixel.FlxG;

class InputManager {
    public static var keyLanes = [
        [FlxG.keys.justPressed.A], // 0
        [FlxG.keys.justPressed.S], // 1
        [FlxG.keys.justPressed.W], // 2
        [FlxG.keys.justPressed.D], // 3
    ];

    public function getActiveLanes():Array<Int> {
        var arr = [];
        for (i in 0...4) {
            if (lanePressed(i))
                arr.push(i);
        }
        return arr;
    }

    inline function lanePressed(i:Int):Bool {
        return keyLanes[i][0];
    }
}
