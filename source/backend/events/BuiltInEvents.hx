package backend.events;

import play.PlayState;

class BuiltInEvents {
    public static function registerAll() {
        // Psych-style
        EventRegistry.register("add camera zoom", addCameraZoom);
        EventRegistry.register("camera flash", cameraFlash);
        EventRegistry.register("play animation", playAnimation);

        // V-Slice style
        EventRegistry.register("focus", cameraFocus);
        EventRegistry.register("move camera", moveCamera);
    }

    static function addCameraZoom(ps:PlayState, p:Array<String>) {
        var amt = Std.parseFloat(p[0]);
        var dur = Std.parseFloat(p[1]);
        ps.cameraManager.addZoom(amt, dur);
    }

    static function cameraFlash(ps:PlayState, p:Array<String>) {
        var color = Std.parseInt("0x" + p[0]);
        var dur = Std.parseFloat(p[1]);
        ps.cameraManager.flash(color, dur);
    }

    static function playAnimation(ps:PlayState, p:Array<String>) {
        var char = p[0];
        var anim = p[1];
        ps.characterManager.playAnimOn(char, anim);
    }

    static function cameraFocus(ps:PlayState, p:Array<String>) {
        ps.cameraManager.focusCharacter(p[0]);
    }

    static function moveCamera(ps:PlayState, p:Array<String>) {
        var x = Std.parseFloat(p[0]);
        var y = Std.parseFloat(p[1]);
        var t = p.length > 2 ? Std.parseFloat(p[2]) : 0.3;
        ps.cameraManager.tweenTo(x, y, t);
    }
}
