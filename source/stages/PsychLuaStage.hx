package stages;

class PsychLuaStage extends Stage {
    public var lua:Dynamic;

    public function new(name:String) {
        super(name);
        var path = 'mods/stages/' + name + ".lua";
        lua = ScriptAPI.loadLua(path);
    }

    override public function instantiate(ps:PlayState) {
        lua.call("onCreate");
        lua.call("onCreatePost");
    }

    override public function update(elapsed:Float) {
        lua.call("onUpdate", elapsed);
    }

    override public function beatHit(curBeat:Int) {
        lua.call("onBeatHit", curBeat);
    }
}
