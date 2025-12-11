package play;

import stages.Stage;
import stages.StageParser;
import flixel.FlxState;

class StageManager {
    public var ps:PlayState;
    public var stage:Stage;

    public function new(ps:PlayState) {
        this.ps = ps;
    }

    public function loadStage(name:String, instant:Bool = false) {
        stage = StageParser.load(name);
        stage.instantiate(ps);
    }

    public function beatHit(curBeat:Int) {
        if (stage != null)
            stage.beatHit(curBeat);
    }

    public function update(elapsed:Float) {
        if (stage != null)
            stage.update(elapsed);
    }
}
