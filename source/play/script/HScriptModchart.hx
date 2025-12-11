package play.script;

import hscript.Interp;
import hscript.Parser;
import play.PlayState;

class HScriptModchart extends ScriptBase {
    public var ps:PlayState;
    var interp:Interp;

    public function new(ps:PlayState, path:String) {
        super();
        this.ps = ps;

        interp = new Interp();
        ScriptAPI.bindHScript(interp, ps);

        var parser = new Parser();
        var code = sys.io.File.getContent(path);
        var expr = parser.parseString(code);

        interp.execute(expr);
    }

    function call(name:String, args:Array<Dynamic>=[]) {
        if (interp.variables.exists(name)) {
            var fn = interp.variables.get(name);
            Reflect.callMethod(interp, fn, args);
        }
    }

    override public function onCreate()         call("onCreate");
    override public function onCreatePost()     call("onCreatePost");
    override public function onUpdate(e)        call("onUpdate", [e]);
    override public function onBeatHit(b)       call("onBeatHit", [b]);
    override public function onStepHit(s)       call("onStepHit", [s]);
    override public function onNoteHit(a,b,c)   call("onNoteHit", [a,b,c]);
    override public function onNoteMiss(a,b)    call("onNoteMiss", [a,b]);

    override public function onEvent(name:String, p:Array<String>):Bool {
        if (interp.variables.exists("onEvent"))
            call("onEvent", [name, p]);
        return interp.variables.exists("overrideEvent_" + name);
    }
}
