package play;

class VSliceEventMap {
    public static var map:Map<String, (PlayState, Array<String>)->Void> = [
        "focus"         => focusChar,
        "move camera"   => moveCamera,
        "shake hud"     => shakeHUD,
        "cue"           => cueEvent,
        "scene change"  => sceneChange
    ];

    public static function exists(name:String):Bool
        return map.exists(name);

    public static function run(ps:PlayState, name:String, params:Array<String>)
        map[name](ps, params);

    static function focusChar(ps:PlayState, p:Array<String>) {
        var char = p[0];
        ps.cameraManager.focusCharacter(char);
    }

    static function moveCamera(ps:PlayState, p:Array<String>) {
        var x = Std.parseFloat(p[0]);
        var y = Std.parseFloat(p[1]);
        var time = Std.parseFloat(p[2]);
        ps.cameraManager.moveTo(x, y, time);
    }

    static function shakeHUD(ps:PlayState, p:Array<String>) {
        var amount = Std.parseFloat(p[0]);
        var duration = Std.parseFloat(p[1]);
        ps.uiManager.shake(amount, duration);
    }

    static function cueEvent(ps:PlayState, p:Array<String>) {
        ps.cutsceneManager.play(p[0]);
    }

    static function sceneChange(ps:PlayState, p:Array<String>) {
        ps.stageManager.loadStage(p[0], true);
    }
}
