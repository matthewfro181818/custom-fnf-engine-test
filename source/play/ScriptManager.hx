package play;

import play.script.ScriptBase;
import play.script.LuaScript;
import play.script.HScriptModchart;

class ScriptManager {
    public var ps:PlayState;
    public var scripts:Array<ScriptBase> = [];

    public function new(ps:PlayState) {
        this.ps = ps;
    }

    public function loadScripts() {
        loadFolder("mods/" + ps.modName + "/scripts/");
        loadFolder("mods/" + ps.modName + "/data/" + ps.songName + "/");
        loadFolder("mods/" + ps.modName + "/stages/");
    }

    function loadFolder(path:String) {
        if (!sys.FileSystem.exists(path))
            return;

        for (file in sys.FileSystem.readDirectory(path)) {
            if (file.endsWith(".lua"))
                scripts.push(new LuaScript(ps, path + file));

            if (file.endsWith(".hx") || file.endsWith(".hscript"))
                scripts.push(new HScriptModchart(ps, path + file));
        }
    }

    // Script lifecycle ---------------------------------------------------

    public function callCreate() {
        for (s in scripts) s.onCreate();
        for (s in scripts) s.onCreatePost();
    }

    public function update(elapsed:Float) {
        for (s in scripts) s.onUpdate(elapsed);
    }

    public function beatHit(curBeat:Int) {
        for (s in scripts) s.onBeatHit(curBeat);
    }

    public function stepHit(curStep:Int) {
        for (s in scripts) s.onStepHit(curStep);
    }

    public function noteHit(lane:Int, type:String, sustain:Bool) {
        for (s in scripts) s.onNoteHit(lane, type, sustain);
    }

    public function noteMiss(lane:Int, type:String) {
        for (s in scripts) s.onNoteMiss(lane, type);
    }

    // Event override -----------------------------------------------------

    public function runEvent(name:String, params:Array<String>):Bool {
        var handled = false;
        for (s in scripts) {
            if (s.onEvent(name, params))
                handled = true;
        }
        return handled;
    }
}
