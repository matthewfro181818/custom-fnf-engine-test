package play;

import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import util.Paths;
import sys.FileSystem;
import sys.io.File;
import haxe.Json;

import objects.character.*;
import objects.character.formats.*;

class CharacterManager {
    public var ps:PlayState;
    public var characters:Map<String, BaseCharacter> = new Map();

    public function new(ps:PlayState) {
        this.ps = ps;
    }

    // -------------------------------------------------------------
    // PUBLIC API
    // -------------------------------------------------------------
    public function loadCharacter(id:String, jsonPath:String) {
        if (jsonPath == null || !FileSystem.exists(jsonPath)) {
            trace("[CharacterManager] Missing character JSON: " + jsonPath);
            return;
        }

        var raw = File.getContent(jsonPath);
        var data:Dynamic = Json.parse(raw);

        var char = loadFromData(id, data);

        if (char != null) {
            characters.set(id, char);
            ps.add(char);
            char.onAdded(ps);
        }
    }

    public function get(id:String):BaseCharacter {
        return characters.get(id);
    }

    public function update(elapsed:Float) {
        for (char in characters) char.updateChar(elapsed);
    }

    public function beatHit(beat:Int) {
        for (char in characters) char.beatHit(beat);
    }

    public function stepHit(step:Int) {
        for (char in characters) char.stepHit(step);
    }

    public function playAnimOn(id:String, anim:String, forced:Bool=false) {
        var c = characters.get(id);
        if (c != null) c.playAnim(anim, forced);
    }

    // -------------------------------------------------------------
    // INTERNAL LOADING LOGIC (auto-detect)
    // -------------------------------------------------------------
    private function loadFromData(id:String, data:Dynamic):BaseCharacter {
        var mod = ps.modName;
        var charType:String = Reflect.field(data, "type");

        // handle "auto" type
        if (charType == null || charType == "auto") {
            charType = detectType(mod, data.name);
        }

        switch (charType) {
            case "png":
                return loadPNGCharacter(id, data);

            case "atlas":
                return loadAtlasCharacter(id, data);

            case "animate":
                return loadAnimateCharacter(id, data);

            case "spine":
                return loadSpineCharacter(id, data);

            case "model3d":
                return loadModelCharacter(id, data);

            default:
                trace("[CharacterManager] Unknown type: " + charType);
                return null;
        }
    }

    // -------------------------------------------------------------
    // AUTO-DETECTION ORDER
    // -------------------------------------------------------------
    private function detectType(mod:String, name:String):String {
        var base = "characters/" + name;

        if (Paths.animateLibrary(mod, name) != null) return "animate";
        if (Paths.spineJson(mod, name) != null) return "spine";
        if (Paths.atlasJson(mod, name) != null) return "atlas";
        if (Paths.image(mod, name) != null) return "png";
        if (Paths.modelOBJ(mod, name) != null) return "model3d";

        return "png";
    }

    // -------------------------------------------------------------
    // LOADERS
    // -------------------------------------------------------------
    private function loadPNGCharacter(id:String, data:Dynamic):BaseCharacter {
        var char = new PNGCharacter(id, data, ps.modName);
        return char;
    }

    private function loadAtlasCharacter(id:String, data:Dynamic):BaseCharacter {
        var char = new AtlasCharacter(id, data, ps.modName);
        return char;
    }

    private function loadAnimateCharacter(id:String, data:Dynamic):BaseCharacter {
        var char = new AnimateCharacter(id, data, ps.modName);
        return char;
    }

    private function loadSpineCharacter(id:String, data:Dynamic):BaseCharacter {
        var char = new SpineCharacter(id, data, ps.modName);
        return char;
    }

    private function loadModelCharacter(id:String, data:Dynamic):BaseCharacter {
        var char = new ModelCharacter(id, data, ps.modName);
        return char;
    }
}
