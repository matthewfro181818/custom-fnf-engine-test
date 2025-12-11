package play;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.addons.display.FlxSpriteAni;
import openfl.display.BitmapData;
import sys.FileSystem;
import sys.io.File;
import haxe.Json;

import util.Paths;
import objects.stage.*;
import objects.stage.layers.*;

class StageManager {
    public var ps:PlayState;
    public var config:Dynamic;
    public var layers:Array<BaseStageLayer> = [];
    public var script:StageScript = null;

    // camera fields
    public var camBounds:Dynamic = null;
    public var defaultZoom:Float = 1.0;
    public var camOffsetX:Float = 0;
    public var camOffsetY:Float = 0;

    public function new(ps:PlayState) {
        this.ps = ps;
    }

    // =================================================================
    // PUBLIC API
    // =================================================================

    public function loadStage(name:String) {
        var json = Paths.stageJson(ps.modName, name);
        if (json == null) {
            trace("[StageManager] No stage JSON found for: " + name);
            return;
        }

        var raw = File.getContent(json);
        config = Json.parse(raw);

        unloadStage(); // remove old layers

        loadCameraSettings();
        loadLayers();
        loadPostFX();

        loadStageScript(config.script);

        if (script != null)
            script.onStageCreate(this);
    }

    public function unloadStage() {
        for (l in layers) {
            ps.remove(l.sprite);
        }
        layers = [];
    }

    public function update(elapsed:Float) {
        for (l in layers) l.update(elapsed);

        if (script != null)
            script.onStageUpdate(elapsed);
    }

    public function beatHit(beat:Int) {
        for (l in layers) l.beatHit(beat);

        if (script != null)
            script.onBeatHit(beat);
    }

    public function stepHit(step:Int) {
        for (l in layers) l.stepHit(step);

        if (script != null)
            script.onStepHit(step);
    }

    // =================================================================
    // LOADERS
    // =================================================================

    private function loadCameraSettings() {
        if (config.camera != null) {
            if (config.camera.default_zoom != null)
                defaultZoom = config.camera.default_zoom;

            if (config.camera.position != null) {
                camOffsetX = config.camera.position[0];
                camOffsetY = config.camera.position[1];
            }

            if (config.camera.bounds != null)
                camBounds = config.camera.bounds;
        }
    }

    private function loadLayers() {
        if (config.layers == null) return;

        for (layerData in config.layers) {
            var layer = createLayer(layerData);

            if (layer != null) {
                layers.push(layer);
                ps.add(layer.sprite);
            }
        }
    }

    private function loadPostFX() {
        if (config.post == null) return;

        ps.postFX.vignettePower = config.post.vignette != null ? config.post.vignette : 0;
        ps.postFX.bloomPower = config.post.bloom != null ? config.post.bloom : 0;
        ps.postFX.chromaticPower = config.post.chromatic != null ? config.post.chromatic : 0;
        ps.postFX.grayscale = config.post.grayscale == true;
        ps.postFX.crt = config.post.crt == true;
    }

    // =================================================================
    // LAYER CREATION
    // =================================================================

    private function createLayer(data:Dynamic):BaseStageLayer {
        var name = data.name != null ? data.name : "layer";

        switch(data.type) {
            case "sprite":
                return new SpriteLayer(name, data, ps.modName);

            case "animated":
                return new AnimatedSpriteLayer(name, data, ps.modName);

            case "atlas":
                return new AtlasSpriteLayer(name, data, ps.modName);

            case "animate":
                return new AnimateLayer(name, data, ps.modName);

            case "model3d":
                return new Model3DLayer(name, data, ps.modName);

            default:
                trace("[StageManager] Unknown layer type: " + data.type);
                return null;
        }
    }

    // =================================================================
    // SCRIPT LOADING
    // =================================================================

    private function loadStageScript(scriptName:String) {
        if (scriptName == null || scriptName == "") return;

        var path = Paths.modOrAsset(ps.modName, "stages/scripts/" + scriptName);
        if (path == null || !FileSystem.exists(path)) {
            trace("[StageManager] Stage script missing: " + scriptName);
            return;
        }

        script = new StageScript(path);
    }
}
