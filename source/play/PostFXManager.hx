package play;

import flixel.FlxG;
import flixel.FlxCamera;
import flixel.addons.display.FlxRuntimeShader;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class PostFXManager {
    public var ps:PlayState;

    // Effect strengths
    public var vignettePower:Float = 0;
    public var bloomPower:Float = 0;
    public var chromaticPower:Float = 0;

    public var grayscale:Bool = false;
    public var invert:Bool = false;
    public var crt:Bool = false;

    // Shaders
    public var vignetteShader:FlxRuntimeShader;
    public var chromaticShader:FlxRuntimeShader;
    public var bloomShader:FlxRuntimeShader;
    public var crtShader:FlxRuntimeShader;
    public var grayShader:FlxRuntimeShader;
    public var invertShader:FlxRuntimeShader;

    public function new(ps:PlayState) {
        this.ps = ps;
        loadShaders();
    }

    // ================================================================
    // LOAD SHADERS
    // ================================================================

    private function loadShaders() {
        vignetteShader  = shader("vignette");
        chromaticShader = shader("chromatic");
        bloomShader     = shader("bloom");
        crtShader       = shader("crt");
        grayShader      = shader("grayscale");
        invertShader    = shader("invert");
    }

    private function shader(name:String):FlxRuntimeShader {
        var pathFrag = "assets/shaders/" + name + ".frag";
        var pathVert = "assets/shaders/" + name + ".vert";

        var frag = "";
        var vert = "";

        if (sys.FileSystem.exists(pathFrag))
            frag = sys.io.File.getContent(pathFrag);

        if (sys.FileSystem.exists(pathVert))
            vert = sys.io.File.getContent(pathVert);

        return new FlxRuntimeShader(vert, frag);
    }

    // ================================================================
    // UPDATE — APPLY EFFECTS TO GAME CAMERA
    // ================================================================

    public function update(elapsed:Float) {
        var cam = ps.cameraManager.camGame;

        // Remove all shaders
        cam.setFilters([]);

        var filters = [];

        if (vignettePower > 0) {
            vignetteShader.setFloat("strength", vignettePower);
            filters.push(vignetteShader);
        }

        if (chromaticPower > 0) {
            chromaticShader.setFloat("offset", chromaticPower);
            filters.push(chromaticShader);
        }

        if (bloomPower > 0) {
            bloomShader.setFloat("strength", bloomPower);
            filters.push(bloomShader);
        }

        if (crt) {
            crtShader.setFloat("time", FlxG.elapsedTotal); 
            filters.push(crtShader);
        }

        if (grayscale)
            filters.push(grayShader);

        if (invert)
            filters.push(invertShader);

        cam.setFilters(filters);
    }

    // ================================================================
    // SCRIPT / EVENT API
    // ================================================================

    public function tweenVignette(value:Float, time:Float) {
        FlxTween.tween(this, { vignettePower: value }, time);
    }

    public function tweenBloom(value:Float, time:Float) {
        FlxTween.tween(this, { bloomPower: value }, time);
    }

    public function tweenChromatic(value:Float, time:Float) {
        FlxTween.tween(this, { chromaticPower: value }, time);
    }

    public function toggleCRT(state:Bool) {
        crt = state;
    }

    public function toggleGrayscale(state:Bool) {
        grayscale = state;
    }

    public function toggleInvert(state:Bool) {
        invert = state;
    }
}
