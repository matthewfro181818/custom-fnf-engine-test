package play;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class CameraManager {
    public var ps:PlayState;

    public var camFollow:FlxPoint;
    public var camTarget:FlxPoint;
    public var zoom:Float = 1.0;
    public var baseZoom:Float = 1.0;

    public var camLocked:Bool = false;

    public function new(ps:PlayState) {
        this.ps = ps;

        camFollow = FlxPoint.get();
        camTarget = FlxPoint.get();

        FlxG.camera.follow(camFollow, LOCKON);
    }

    //=======================================================
    // PSYCH EVENT: Add Camera Zoom
    //=======================================================
    public function addZoom(amt:Float, dur:Float) {
        var startZoom = FlxG.camera.zoom;
        var endZoom = startZoom + amt;

        FlxTween.tween(FlxG.camera, { zoom: endZoom }, dur, {
            ease: FlxEase.quadOut
        });
    }

    //=======================================================
    // VS SLICE EVENT: Tween camera to a coordinate
    //=======================================================
    public function tweenTo(x:Float, y:Float, time:Float = 1, ?ease:FlxEase=FlxEase.quadOut) {
        camLocked = true;

        FlxTween.tween(camFollow, { x: x, y: y }, time, {
            ease: ease,
            onComplete: (_) -> camLocked = false
        });
    }

    //=======================================================
    // VS SLICE EVENT: Move camera instantly or smoothly
    //=======================================================
    public function moveTo(x:Float, y:Float, t:Float = 0) {
        if (t <= 0) {
            camFollow.set(x, y);
            return;
        }

        tweenTo(x, y, t);
    }

    //=======================================================
    // PSYCH/V-SLICE EVENT: Focus camera on a character
    //=======================================================
    public function focusCharacter(id:String) {
        if (!ps.characterManager.characters.exists(id)) {
            trace("[Camera] Character '" + id + "' not found.");
            return;
        }

        var char = ps.characterManager.characters[id];

        var cx = char.x + char.width  * 0.5;
        var cy = char.y + char.height * 0.5;

        moveTo(cx, cy, 0.2);
    }

    //=======================================================
    // Called every frame by PlayState.update()
    //=======================================================
    public function update(elapsed:Float) {
        if (!camLocked) {
            // Smooth follow to target (dynamic cam movement)
            camFollow.x += (camTarget.x - camFollow.x) * 0.10;
            camFollow.y += (camTarget.y - camFollow.y) * 0.10;
        }
    }
}
