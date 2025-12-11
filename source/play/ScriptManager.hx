package play;

import haxe.ds.StringMap;
import haxe.Json;
import sys.FileSystem;
import sys.io.File;

import util.Paths;

#if LUA
import llua.Lua;
import llua.LuaL;
#end

import hscript.Parser;
import hscript.Interp;

class ScriptManager {
    public var ps:PlayState;

    var luaScripts:Array<LuaScript> = [];
    var hxsScripts:Array<HScript> = [];

    public function new(ps:PlayState) {
        this.ps = ps;
    }

    // =======================================================================
    //  LOAD SCRIPTS
    // =======================================================================

    public function loadScripts() {
        loadSongScripts();
        loadStageScripts();
        loadModScripts();
        loadCharacterScripts();
    }

    // SONG MODCHART SCRIPTS
    private function loadSongScripts() {
        var name = ps.songName;
        var mod  = ps.modName;

        var luaPath = Paths.modOrAsset(mod, "data/" + name + "/" + name + ".lua");
        var hxPath  = Paths.modOrAsset(mod, "data/" + name + "/" + name + ".hx");

        if (luaPath != null) loadLua(luaPath);
        if (hxPath  != null) loadHScript(hxPath);
    }

    // STAGE-SPECIFIC SCRIPT (loaded via StageManager)
    private function loadStageScripts() {
        if (ps.stageManager.script != null) {
            addHScript(ps.stageManager.script);
        }
    }

    // GLOBAL MOD SCRIPTS
    private function loadModScripts() {
        var folder:String = "mods/" + ps.modName + "/scripts/";

        if (!FileSystem.exists(folder)) return;

        var list = FileSystem.readDirectory(folder);
        for (file in list) {
            if (file.endsWith(".lua")) loadLua(folder + file);
            if (file.endsWith(".hx"))  loadHScript(folder + file);
        }
    }

    // CHARACTER-SPECIFIC SCRIPTS
    private function loadCharacterScripts() {
        for (char in ps.characterManager.characters) {
            if (char.scriptPath != null) {
                loadHScript(char.scriptPath);
            }
        }
    }

    // =======================================================================
    // LUA LOADER
    // =======================================================================

    private function loadLua(path:String) {
        #if LUA
        var lua = new LuaScript(path, ps);
        luaScripts.push(lua);
        #else
        trace("[ScriptManager] LUA disabled, skipping: " + path);
        #end
    }

    // =======================================================================
    // HSCRIPT LOADER
    // =======================================================================

    private function loadHScript(path:String) {
        try {
            var parser = new Parser();
            var code = File.getContent(path);

            var expr = parser.parseString(code);
            var interp = new Interp();

            injectHScriptAPI(interp);

            interp.execute(expr);
            hxsScripts.push(new HScript(interp));
        } catch(e:Dynamic) {
            trace("[ScriptManager] HScript error in: " + path + "\n" + e);
        }
    }

    private function addHScript(script:StageScript) {
        var interp = script.interp;
        injectHScriptAPI(interp);
        hxsScripts.push(new HScript(interp));
    }

    // =======================================================================
    // UPDATE CALLBACKS
    // =======================================================================

    public function update(elapsed:Float) {
        callAll("onUpdate", [elapsed]);
        callAll("onUpdatePost", [elapsed]);
    }

    public function beatHit(beat:Int) {
        callAll("onBeatHit", [beat]);
    }

    public function stepHit(step:Int) {
        callAll("onStepHit", [step]);
    }

    public function noteHit(id:Int, dir:Int, sus:Bool) {
        callAll("onNoteHit", [id, dir, sus]);
    }

    public function noteMiss(id:Int, dir:Int, sus:Bool) {
        callAll("onNoteMiss", [id, dir, sus]);
    }

    public function callEvent(name:String, params:Array<String>) {
        callAll("onEvent", [name, params]);
    }

    public function callCreate() {
        callAll("onCreate", []);
    }

    public function callCreatePost() {
        callAll("onCreatePost", []);
    }

    // =======================================================================
    // SCRIPT EXECUTION WRAPPER
    // =======================================================================

    private function callAll(func:String, args:Array<Dynamic>) {
        #if LUA
        for (lua in luaScripts) lua.call(func, args);
        #end

        for (hx in hxsScripts) hx.call(func, args);
    }

    // =======================================================================
    // INJECT API FOR HSCRIPT
    // =======================================================================

    private function injectHScriptAPI(i:Interp) {
        // Core references
        i.variables.set("ps", ps);

        // Camera
        i.variables.set("cam", ps.cameraManager);

        // UI
        i.variables.set("ui", ps.uiManager);

        // Stage
        i.variables.set("stage", ps.stageManager);

        // Characters
        i.variables.set("chars", ps.characterManager.characters);

        // Notes
        i.variables.set("notes", ps.noteManager);

        // Audio
        i.variables.set("audio", ps.audioManager);

        // Events
        i.variables.set("events", ps.eventManager);

        // Helpers
        i.variables.set("debug", function(x) trace("[HScript] " + x));
    }
}
