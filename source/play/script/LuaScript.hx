package play.script;

import llua.Lua;
import llua.State;
import play.PlayState;

class LuaScript extends ScriptBase {
    public var ps:PlayState;
    public var state:State;

    public function new(ps:PlayState, path:String) {
        super();
        this.ps = ps;

        state = LuaL.newstate();
        LuaL.openlibs(state);

        ScriptAPI.bindLua(state, ps);

        LuaL.dofile(state, path);
    }

    inline function call(name:String, args:Array<Dynamic>=[]) {
        if (Lua.getfield(state, Lua.GLOBALSINDEX, name) == Lua.TFUNCTION) {
            for (v in args) Lua.push(valueToLua(state, v));
            Lua.pcall(state, args.length, 0, 0);
        } else Lua.pop(state, 1);
    }

    override public function onCreate() {
        call("onCreate");
    }

    override public function onCreatePost() {
        call("onCreatePost");
    }

    override public function onUpdate(elapsed:Float) {
        call("onUpdate", [elapsed]);
    }

    override public function onBeatHit(curBeat:Int) {
        call("onBeatHit", [curBeat]);
    }

    override public function onStepHit(curStep:Int) {
        call("onStepHit", [curStep]);
    }

    override public function onNoteHit(lane:Int, type:String, sustain:Bool) {
        call("goodNoteHit", [lane, type, sustain]);
    }

    override public function onNoteMiss(lane:Int, type:String) {
        call("noteMiss", [lane, type]);
    }

    override public function onEvent(name:String, params:Array<String>):Bool {
        call("onEvent", [name, params[0], params[1]]);
        return false; // Lua cannot override events by default
    }
}
