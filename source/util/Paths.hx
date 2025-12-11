package util;

import openfl.utils.Assets;
import sys.FileSystem;
import sys.io.File;

class Paths {
    // ============================================================
    // BASE LOOKUP FUNCTIONS
    // ============================================================

    public static inline var MODS:String = "mods/";
    public static inline var ASSETS:String = "assets/";

    public static function exists(path:String):Bool {
        return FileSystem.exists(path);
    }

    public static function getFile(path:String):String {
        if (exists(path)) return path;
        return null;
    }

    // ============================================================
    //  MOD PRIORITY LOOKUP
    // ============================================================
    public static function modOrAsset(mod:String, subPath:String):String {
        // Check mod
        var modPath = MODS + mod + "/" + subPath;
        if (exists(modPath)) return modPath;

        // Global mods folder (non-mod-specific fallback)
        var globalModPath = MODS + subPath;
        if (exists(globalModPath)) return globalModPath;

        // Base assets
        var assetPath = ASSETS + subPath;
        if (exists(assetPath)) return assetPath;

        // Nothing found
        return null;
    }

    // ============================================================
    //  CHARACTER JSON v2
    // ============================================================
    public static function characterJson(mod:String, name:String):String {
        return modOrAsset(mod, "characters/" + name + ".json");
    }

    // Required for Animate ZIP/folder:
    public static function characterFolder(mod:String, name:String):String {
        return modOrAsset(mod, "characters/" + name + "/");
    }

    // ============================================================
    //  STAGES (Stage JSON v2)
    // ============================================================
    public static function stageJson(mod:String, name:String):String {
        return modOrAsset(mod, "stages/" + name + ".json");
    }

    // ============================================================
    //  CHARTS & SONG DATA
    // ============================================================
    public static function chartJson(mod:String, song:String):String {
        return modOrAsset(mod, "data/" + song + "/chart.json");
    }

    public static function songJson(mod:String, song:String):String {
        return modOrAsset(mod, "data/" + song + "/" + song + ".json");
    }

    // Psych-style variants:
    public static function eventsJson(mod:String, song:String):String {
        return modOrAsset(mod, "data/" + song + "/events.json");
    }

    // ============================================================
    //  MUSIC: Inst / Voices / OST
    // ============================================================
    public static function inst(mod:String, song:String):String {
        return modOrAsset(mod, "songs/" + song + "/Inst.ogg");
    }

    public static function voices(mod:String, song:String):String {
        return modOrAsset(mod, "songs/" + song + "/Voices.ogg");
    }

    public static function music(name:String):String {
        return ASSETS + "music/" + name;
    }

    public static function sound(name:String):String {
        return ASSETS + "sounds/" + name;
    }

    // ============================================================
    //  GRAPHICS: PNG / XML / ATLAS / 3D
    // ============================================================

    // Basic image
    public static function image(mod:String, name:String):String {
        return modOrAsset(mod, "images/" + name + ".png");
    }

    // XML spritesheets
    public static function xml(mod:String, name:String):String {
        return modOrAsset(mod, "images/" + name + ".xml");
    }

    // Atlas JSON (Starling / Sparrow)
    public static function atlasJson(mod:String, name:String):String {
        return modOrAsset(mod, "images/" + name + ".json");
    }

    // Adobe Animate ZIP or folder
    public static function animateLibrary(mod:String, char:String):String {
        return modOrAsset(mod, "characters/" + char + "/library.json");
    }

    public static function animateData(mod:String, char:String):String {
        return modOrAsset(mod, "characters/" + char + "/data.json");
    }

    public static function animateSymbols(mod:String, char:String):String {
        return modOrAsset(mod, "characters/" + char + "/symbols/");
    }

    // Spine skeleton
    public static function spineJson(mod:String, char:String):String {
        return modOrAsset(mod, "characters/" + char + ".json");
    }

    public static function spineAtlas(mod:String, char:String):String {
        return modOrAsset(mod, "characters/" + char + ".atlas");
    }

    // 3D models
    public static function modelOBJ(mod:String, name:String):String {
        return modOrAsset(mod, "models/" + name + ".obj");
    }

    public static function modelMTL(mod:String, name:String):String {
        return modOrAsset(mod, "models/" + name + ".mtl");
    }

    public static function modelTexture(mod:String, name:String):String {
        return modOrAsset(mod, "models/" + name + ".png");
    }

    // ============================================================
    //  UI / HUD / Icons
    // ============================================================
    public static function icon(name:String):String {
        var p = modOrAsset("", "icons/" + name + ".png");
        if (p != null) return p;
        return ASSETS + "icons/icon.png"; // fallback default
    }

    public static function hudGraphics(name:String):String {
        return ASSETS + "ui/" + name + ".png";
    }

    // ============================================================
    //  FONT / SHADER / MISC
    // ============================================================
    public static function font(name:String):String {
        return ASSETS + "fonts/" + name;
    }

    public static function shader(name:String):String {
        var p = modOrAsset("", "shaders/" + name + ".frag");
        if (p != null) return p;
        return ASSETS + "shaders/" + name + ".frag";
    }

    // ============================================================
    //  SAFE FETCH UTILITY
    // ============================================================
    public static function readText(path:String):String {
        if (path == null) return "";
        return File.getContent(path);
    }
}
