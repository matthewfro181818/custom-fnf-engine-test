package backend;

class Conductor {
    public static var bpm:Float = 120;
    public static var crochet:Float = 500; // quarter beat ms
    public static var stepCrochet:Float = 125; // 1/4 step
    public static var songPosition:Float = 0;
    public static var offset:Float = 0;
    public static var safeZoneOffset:Float = 45;

    public static function recalcTimes():Void {
        crochet = (60 / bpm) * 1000;
        stepCrochet = crochet / 4;
    }

    public static function update(elapsed:Float):Void {
        songPosition += elapsed * 1000;
    }
}
