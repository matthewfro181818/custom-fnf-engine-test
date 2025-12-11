package play;

class PsychEventMap {
    public static var map:Map<String, (PlayState, Array<String>)->Void> = [
        "play animation"    => playAnimation,
        "change character"  => changeCharacter,
        "camera flash"      => cameraFlash,
        "camera shake"      => cameraShake,
        "add camera zoom"   => addCameraZoom,
        "show hud"          => showHUD,
        "tween camera"      => tweenCamera
    ];

    public static function exists(name:String):Bool
        return map.exists(name);

    public static function run(ps:PlayState, name:String, params:Array<String>)
        map[name](ps, params);

    // Event Actions
    static function playAnimation(ps:PlayState, p:Array<String>) {
        var charID = p[0];
        var anim = p[1];
        ps.characterManager.playAnimOn(charID, anim);
    }

    static function changeCharacter(ps:PlayState, p:Array<String>) {
        var index = Std.parseInt(p[0]);
        var newChar = p[1];
        ps.characterManager.changeCharacter(index, newChar);
    }

    static function cameraFlash(ps:PlayState, p:Array<String>) {
        var color = Std.parseInt(p[0]);
        var dur = Std.parseFloat(p[1]);
        FlxG.camera.flash(color, dur);
    }

    static function cameraShake(ps:PlayState, p:Array<String>) {
        var strength = Std.parseFloat(p[0]);
        var duration = Std.parseFloat(p[1]);
        FlxG.camera.shake(strength, duration);
    }

    static function addCameraZoom(ps:PlayState, p:Array<String>) {
        ps.cameraManager.addZoom(
            Std.parseFloat(p[0]),
            Std.parseFloat(p[1])
        );
    }

    static function showHUD(ps:PlayState, p:Array<String>) {
        ps.uiManager.setHUDVisible(p[0] == "true");
    }

    static function tweenCamera(ps:PlayState, p:Array<String>) {
        ps.cameraManager.tweenTo(
            Std.parseFloat(p[0]),
            Std.parseFloat(p[1])
        );
    }
}
