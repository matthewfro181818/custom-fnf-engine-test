package play;

import flixel.FlxG;
import flixel.FlxCamera;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;

class CameraManager {
    public var ps:PlayState;

    public var camGame:FlxCamera;
    public var camHUD:FlxCamera;
    public var camOther:FlxCamera;

    public var followX:Float = 0;
    public var followY:Float = 0;

    public var followOffsetX:Float = 0;
    public var followOffsetY:Float = 0;

    public var zoom:Float = 1.0;

    // Stage camera boundaries
    public var bounds:Dynamic = null;

    // Whether camera should auto-follow characters
    public var autoFollow:Bool = true;

    public function new(ps:PlayState) {
        this.ps = ps;

        camGame = FlxG.camera;
        camHUD = new FlxCamera();
        camOther = new FlxCamera();

        FlxG.cameras.reset(camGame);
        FlxG.cameras.add(camHUD);
        FlxG.cameras.add(camOther);

        camHUD.bgColor = 0x00000000;
        camOther.bgColor = 0x00000000;

        zoom = camGame.zoom = 1.0;
    }

    // =====================================================================
    // UPDATE
    // =====================================================================

    public function update(elapsed:Float) {
        if (autoFollow)
            updateFollow();

        applyBounds();
    }

    private function updateFollow() {
        camGame.scroll.set(followX - camGame.width / 2, followY - camGame.height / 2);
    }

    // =====================================================================
    // CAMERA FOLLOW TARGETS
    // =====================================================================

    public function focusCharacter(id:String) {
        var char = ps.characterManager.get(id);
        if (char == null) return;

        var cx = char.getMidpoint().x + char.cameraOffsetX + followOffsetX;
        var cy = char.getMidpoint().y + char.cameraOffsetY + followOffsetY;

        setFollow(cx, cy);
    }

    public function setFollow(x:Float, y:Float) {
        followX = x;
        followY = y;
    }

    public function tweenTo(x:Float, y:Float, time:Float = 0.5, ease:Dynamic = FlxEase.quadOut) {
        autoFollow = false;

        FlxTween.tween(this, {
            followX: x,
            followY: y
        }, time, {
            ease: ease,
            onComplete: function(_) {
                autoFollow = true;
            }
        });
    }

    // =====================================================================
    // ZOOM FUNCTIONS
    // =====================================================================

    public function setZoom(value:Float) {
        zoom = value;
        camGame.zoom = value;
    }

    public function addZoom(amount:Float, duration:Float = 0.15) {
        var start = camGame.zoom;
        var target = start + amount;

        FlxTween.tween(camGame, { zoom: target }, duration, {
            ease: FlxEase.sineOut,
            onComplete: function(_) {
                // Return to normal
                FlxTween.tween(camGame, { zoom: start }, duration, { ease: FlxEase.sineIn });
            }
        });
    }

    // =====================================================================
    // CAMERA EFFECTS
    // =====================================================================

    public function flash(color:Int = FlxColor.WHITE, duration:Float = 1) {
        camGame.flash(color, duration);
    }

    public function shake(amount:Float = 0.01, duration:Float = 0.2) {
        camGame.shake(amount, duration);
    }

    // =====================================================================
    // STAGE BOUNDS
    // =====================================================================

    public function setBounds(b:Dynamic) {
        bounds = b;
    }

    private function applyBounds() {
        if (bounds == null) return;

        var minX:Float = bounds[0];
        var minY:Float = bounds[1];
        var maxX:Float = bounds[2];
        var maxY:Float = bounds[3];

        followX = Math.min(Math.max(followX, minX), maxX);
        followY = Math.min(Math.max(followY, minY), maxY);
    }

    // =====================================================================
    // SMALL UTILITY FUNCTIONS FOR SCRIPTING
    // =====================================================================

    public function offset(x:Float, y:Float) {
        followOffsetX = x;
        followOffsetY = y;
    }

    public function resetOffset() {
        followOffsetX = followOffsetY = 0;
    }
}
