package play.script;

class ScriptBase {
    public function new() {}

    // Called when script loads
    public function onCreate() {}

    // Called after stage and characters load
    public function onCreatePost() {}

    // Per-frame
    public function onUpdate(elapsed:Float) {}

    // Beat/Step callbacks
    public function onBeatHit(curBeat:Int) {}
    public function onStepHit(curStep:Int) {}

    // Note callbacks
    public function onNoteHit(lane:Int, noteType:String, isSustain:Bool) {}
    public function onNoteMiss(lane:Int, noteType:String) {}

    // Events
    public function onEvent(name:String, params:Array<String>):Bool return false;
}
